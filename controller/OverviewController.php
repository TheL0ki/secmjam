<?php

namespace App\Controllers;

class OverviewController
{
    public function __construct(
        private mixed $smarty,
        private mixed $capsule
    ) {}

    public function index()
    {
        $last_orders = $this->capsule->table('orders')
            ->where('owner_uuid', $_SESSION['user']->uuid)
            ->where('open', 0)
            ->leftJoin('categories', 'orders.category_id', '=', 'categories.id')
            ->select('orders.*', 'categories.name as categoryName')
            ->orderBy('orders.created_at', 'desc')
            ->limit(10)
            ->get();
        $last_orders_owner = $this->capsule->table('orders')
            ->where('owner_uuid', $_SESSION['user']->uuid)
            ->where('open', 0)
            ->leftJoin('categories', 'orders.category_id', '=', 'categories.id')
            ->select('orders.*', 'categories.name as categoryName')
            ->orderBy('orders.created_at', 'desc')
            ->limit(10)
            ->get();
        $this->smarty->assign([
            'last_orders' => $last_orders->toArray(),
            'last_orders_owner' => $last_orders_owner->toArray()
        ]);
        $this->smarty->display('overview/index.tpl');
    }
}