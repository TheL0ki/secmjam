<?php

namespace App\Controllers;

use Ramsey\Uuid\Uuid;

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

    public function showMenu(int $category_id)
    {
        $menu = $this->capsule
            ->table('menu')
            ->where('category_id', $category_id)
            ->leftJoin('categories', 'menu.category_id', '=', 'categories.id')
            ->get();
        $extras = $this->capsule->table('extras')->where('category_id', $category_id)->get();
        $this->smarty->assign([
            'menu' => $menu->toArray(),
            'extras' => $extras->toArray(),
            'category_id' => $category_id
        ]);
        $this->smarty->display('orders/showMenu.tpl');
    }

    public function createOrder()
    {
        dd($_REQUEST);
        $this->capsule->table('orders')->insert([
            'uuid' => Uuid::uuid4(),
            'user_uuid' => $_SESSION['user']->uuid,
            'category_id' => $_POST['category_id'],
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s')
        ]);
    }

    public function addToOrder()
    {
        
    }
}