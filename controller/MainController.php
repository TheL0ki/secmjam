<?php

namespace App\Controllers;

class MainController
{
    public function __construct(
        private $smarty,
        private $capsule
    ) {}

    public function index()
    {   
        $this->smarty->assign('points', $this->getPoints());
        $this->smarty->display('main.tpl');
    }

    public function getPoints()
    {
        $orderPoints = $this->capsule->table('orders')
            ->join('categories', 'orders.category_id', '=', 'categories.id')
            ->leftJoin('order_items', 'orders.uuid', '=', 'order_items.order_uuid')
            ->where('owner_uuid', $_SESSION['user']->uuid)
            ->selectRaw('COALESCE(SUM(categories.points * order_items.amount), 0) as order_points')
            ->groupBy('orders.owner_uuid')
            ->first();

        $helperPoints = $this->capsule->table('helper')
            ->join('orders', 'helper.order_uuid', '=', 'orders.uuid')
            ->join('categories', 'orders.category_id', '=', 'categories.id')
            ->leftJoin('order_items', 'orders.uuid', '=', 'order_items.order_uuid')
            ->where('user_uuid', $_SESSION['user']->uuid)
            ->selectRaw('ROUND(COALESCE(SUM(categories.points * order_items.amount), 0) / 2, 0) as helper_points')
            ->first();
        
        return $orderPoints->order_points + $helperPoints->helper_points;
    }
}