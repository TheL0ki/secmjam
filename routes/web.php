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
        '/orders/show/{order_uuid:uuid}' => [OrderController::class, 'show'],
        '/user/settings' => [UserController::class, 'userSettings'],
    ],
    'POST' => [
        '/login'  => [UserController::class, 'authenticate'],
        '/user/settings' => [UserController::class, 'updateUserSettings'],
        '/orders' => [OrderController::class, 'createOrder'],
        '/orders/add' => [OrderController::class, 'addToOrder'],

    ],
];