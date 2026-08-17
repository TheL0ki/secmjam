<?php

namespace App\Controllers;

class HighscoreController
{
    public function __construct(
        private mixed $smarty,
        private mixed $capsule
    ) {}

    public function index()
    {
        $highscore = $this->getHighscoreArray();
        $this->smarty->assign('highscore', $highscore);
        $this->smarty->display('highscore/index.tpl');
    }

    private function getHighscoreArray() : array
    {
        $userArray = $this->capsule->table('users')->get();
        $highscore = [];
        foreach ($userArray as $user) { 
            $highscore[$user->uuid]['order_points'] = $this->calcOrderPoints($user->uuid);
            $highscore[$user->uuid]['helper_points'] = $this->calcHelperPoints($user->uuid);
            $highscore[$user->uuid]['total_points'] = $highscore[$user->uuid]['order_points'] + $highscore[$user->uuid]['helper_points'];
            $highscore[$user->uuid]['user'] = $user;

            $orderCount = $this->capsule->table('orders')
                ->where('owner_uuid', $user->uuid)
                ->count();
            $helperCount = $this->capsule->table('helper')
                ->where('user_uuid', $user->uuid)
                ->count();
            $totalOrders = $this->capsule->table('order_items')
                ->where('item_owner_uuid', $user->uuid)
                ->distinct('order_uuid')
                ->count();
            $totalCount = $orderCount + $helperCount;
            $highscore[$user->uuid]['quote'] = round(($totalCount/$totalOrders)*100,2) . '%';
            $highscore[$user->uuid]['totalOrders'] = $totalOrders;
        }

        usort($highscore, function($a, $b) {
            return $b['total_points'] - $a['total_points'];
        });

        return $highscore;
    }

    private function calcOrderPoints(string $user_uuid) : int
    {
        $orderArray = $this->capsule->table('orders')
            ->where('owner_uuid', $user_uuid)
            ->leftJoin('categories', 'orders.category_id', '=', 'categories.id')
            ->select('orders.*', 'categories.points as category_points')
            ->get();
        $orderPoints = (int) 0;
        foreach ($orderArray as $order) {
            $orderPoints += (int) $order->category_points;
        }
        return (int) $orderPoints;
    }

    private function calcHelperPoints(string $user_uuid) : int
    {
        $helperArray = $this->capsule->table('helper')
            ->where('user_uuid', $user_uuid)
            ->leftJoin('orders', 'helper.order_uuid', '=', 'orders.uuid')
            ->leftJoin('categories', 'orders.category_id', '=', 'categories.id')
            ->select('helper.*', 'categories.points as category_points')
            ->get();
        $helperPoints = (int) 0;
        foreach ($helperArray as $helper) {
            $helperPoints += (int) $helper->category_points;
        }
        return (int) $helperPoints;
    }
}