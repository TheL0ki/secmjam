<?php

namespace App\Controllers;

class HighscoreController
{
    public function __construct(
        private mixed $smarty,
        private mixed $capsule
    ) {}

    public function index() : void
    {
        $highscore = $this->getHighscoreArray();
        $this->smarty->assign('highscore', $highscore);
        $this->smarty->display('highscore/index.tpl');
    }

    private function getHighscoreArray() : array
    {
        $orderStats = $this->capsule->table('orders')
            ->join('categories', 'orders.category_id', '=', 'categories.id')
            ->leftJoin('order_items', 'orders.uuid', '=', 'order_items.order_uuid')
            ->select('orders.owner_uuid as uuid')
            ->selectRaw('COALESCE(SUM(categories.points * order_items.amount), 0) as order_points')
            ->selectRaw('COUNT(DISTINCT orders.uuid) as owner_count')
            ->groupBy('orders.owner_uuid')
            ->get()
            ->keyBy('uuid');

        $helperStats = $this->capsule->table('helper')
            ->join('orders', 'helper.order_uuid', '=', 'orders.uuid')
            ->join('categories', 'orders.category_id', '=', 'categories.id')
            ->leftJoin('order_items', 'orders.uuid', '=', 'order_items.order_uuid')
            ->select('helper.user_uuid as uuid')
            ->selectRaw('ROUND(COALESCE(SUM(categories.points * order_items.amount), 0) / 2, 0) as helper_points')
            ->selectRaw('COUNT(DISTINCT helper.order_uuid) as helper_count')
            ->groupBy('helper.user_uuid')
            ->get()
            ->keyBy('uuid');

        $participation = $this->capsule->table('order_items')
            ->select('item_owner_uuid as uuid')
            ->selectRaw('COUNT(DISTINCT order_uuid) as total_orders')
            ->groupBy('item_owner_uuid')
            ->get()
            ->keyBy('uuid');

        $uuids = array_unique(array_merge(
            $orderStats->keys()->all(),
            $helperStats->keys()->all(),
            $participation->keys()->all()
        ));

        if ($uuids === []) {
            return [];
        }

        $users = $this->capsule->table('users')
            ->whereIn('uuid', $uuids)
            ->get()
            ->keyBy('uuid');

        $highscore = [];
        foreach ($uuids as $uuid) {
            $user = $users->get($uuid);
            if ($user === null) {
                continue;
            }

            $orderRow = $orderStats->get($uuid);
            $helperRow = $helperStats->get($uuid);
            $participationRow = $participation->get($uuid);

            $orderPoints = (int) ($orderRow->order_points ?? 0);
            $helperPoints = (int) ($helperRow->helper_points ?? 0);
            $ownerCount = (int) ($orderRow->owner_count ?? 0);
            $helperCount = (int) ($helperRow->helper_count ?? 0);
            $totalOrders = (int) ($participationRow->total_orders ?? 0);
            $totalCount = $ownerCount + $helperCount;

            $highscore[$uuid] = [
                'order_points' => $orderPoints,
                'helper_points' => $helperPoints,
                'total_points' => $orderPoints + $helperPoints,
                'user' => $user,
                'totalOrders' => $totalOrders,
                'quote' => $totalOrders === 0
                    ? '0%'
                    : round(($totalCount / $totalOrders) * 100, 2) . '%',
            ];
        }

        usort($highscore, function ($a, $b) {
            return $b['total_points'] - $a['total_points'];
        });

        return $highscore;
    }
}
