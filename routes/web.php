<?php

use App\Controllers\MainController;
use App\Controllers\UserController;
use App\Controllers\OrderController;

return [
    'GET' => [
        '/'       => [MainController::class, 'index'],
        '/login'  => [UserController::class, 'login'],
        '/logout' => [UserController::class, 'logout'],
        '/orders'   => [OrderController::class, 'index'],
        '/orders/new' => [OrderController::class, 'chooseCategory'],
        '/orders/menu/{category_id:int}' => [OrderController::class, 'showMenu'],
        '/user/settings' => [UserController::class, 'userSettings'],
    ],
    'POST' => [
        '/login'  => [UserController::class, 'authenticate'],
        '/orders' => [OrderController::class, 'createOrder'],
        '/user/settings' => [UserController::class, 'updateUserSettings'],

    ],
];