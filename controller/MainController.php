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
        $this->smarty->display('main.tpl');
    }
}