<?php

namespace App\Controllers;

class StatsController
{
    public function __construct(
        private mixed $smarty,
        private mixed $capsule
    ) {}

    public function index()
    {
        $this->smarty->assign([
            'topFiveItems' => $this->topFiveItems(),
            'topFiveItemsByUser' => $this->topFiveItemsByUser(),
            'topCategories' => $this->topCategories(),
            'topCategoriesByUser' => $this->topCategoriesByUser(),
        ]);
        $this->smarty->display('stats/index.tpl');
    }

    public function topFiveItems()
    {
        $countArr = $this->capsule->table('order_items')
            ->leftJoin('menu', 'order_items.item_id', '=', 'menu.id')
            ->selectRaw('SUM(order_items.amount) as item_count')
            ->selectRaw('menu.sub_category as sub_category')
            ->selectRaw('menu.item as item')
            ->selectRaw('menu.size as size')
            ->groupBy('menu.sub_category', 'menu.item', 'menu.size')
            ->orderBy('item_count', 'desc')
            ->limit(5)
            ->get();
        return $countArr;
    }

    public function topFiveItemsByUser()
    {
        $countArr = $this->capsule->table('order_items')
            ->where('order_items.item_owner_uuid', $_SESSION['user']->uuid)
            ->leftJoin('menu', 'order_items.item_id', '=', 'menu.id')
            ->selectRaw('SUM(order_items.amount) as item_count')
            ->selectRaw('menu.sub_category as sub_category')
            ->selectRaw('menu.item as item')
            ->selectRaw('menu.size as size')
            ->groupBy('menu.sub_category', 'menu.item', 'menu.size')
            ->orderBy('item_count', 'desc')
            ->limit(5)
            ->get();

        return $countArr;
    }

    public function topCategories()
    {
        $countArr = $this->capsule->table('order_items')
            ->leftJoin('menu', 'order_items.item_id', '=', 'menu.id')
            ->leftJoin('categories', 'menu.category_id', '=', 'categories.id')
            ->selectRaw('SUM(order_items.amount) as item_count')
            ->selectRaw('categories.name as name')
            ->groupBy('categories.name')
            ->orderBy('item_count', 'desc')
            ->limit(5)
            ->get();

        return $countArr;
    }

    public function topCategoriesByUser()
    {
        $countArr = $this->capsule->table('order_items')
            ->where('order_items.item_owner_uuid', $_SESSION['user']->uuid)
            ->leftJoin('menu', 'order_items.item_id', '=', 'menu.id')
            ->leftJoin('categories', 'menu.category_id', '=', 'categories.id')
            ->selectRaw('SUM(order_items.amount) as item_count')
            ->selectRaw('categories.name as name')
            ->groupBy('categories.name')
            ->orderBy('item_count', 'desc')
            ->limit(5)
            ->get();
        return $countArr;
    }
}