<?php

namespace App\Controllers;

class AdminController
{
    public function __construct(
        private mixed $smarty,
        private mixed $capsule
    ) {}

    public function index() : void
    {
        $this->smarty->display('admin/index.tpl');
    }

    public function users() : void
    {
        $users = $this->capsule->table('users')->get();
        $this->smarty->assign('users', $users);
        $this->smarty->display('admin/users.tpl');
    }

    public function categories() : void
    {
        $categories = $this->capsule->table('categories')->get();
        $this->smarty->assign('categories', $categories);
        $this->smarty->display('admin/categories.tpl');
    }

    public function menu() : void
    {
        $this->smarty->display('admin/menu.tpl');
    }

    public function extras() : void
    {
        $this->smarty->display('admin/extras.tpl');
    }
}