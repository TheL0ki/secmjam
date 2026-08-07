<?php

namespace App\Controllers;

class OrderController
{
    public function __construct(
        private mixed $smarty,
        private mixed $capsule
    ) {}

    public function index()
    {
        $this->smarty->display('orders/orders.tpl');
    }

    public function chooseCategory()
    {
        $categories = $this->capsule->table('categories')->get();
        $this->smarty->assign('categories', $categories);
        $this->smarty->display('orders/chooseCategory.tpl');
    }

    public function showMenu(int $category)
    {
        $menu = $this->capsule
            ->table('menu')
            ->where('category_id', $category)
            ->leftJoin('categories', 'menu.category_id', '=', 'categories.id')
            ->get();
        
        $extras = $this->capsule->table('extras')->where('category_id', $category)->get();
        $this->smarty->assign([
            'menu' => $menu->toArray(),
            'extras' => $extras->toArray()
        ]);
        $this->smarty->display('orders/showMenu.tpl');
    }

    public function createOrder()
    {
        
    }

    public function addToOrder()
    {
        
    }
}