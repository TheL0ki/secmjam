<?php

use App\Controllers\MainController;
use App\Controllers\UserController;
use App\Controllers\OrderController;
use App\Controllers\OverviewController;
use App\Controllers\HighscoreController;
use App\Controllers\StatsController;

return [
    'GET' => [
        '/'       => [MainController::class, 'index'],
        '/login'  => [UserController::class, 'login'],
        '/logout' => [UserController::class, 'logout'],
        '/orders'   => [OrderController::class, 'index'],        
        '/orders/new' => [OrderController::class, 'chooseCategory'],
        '/orders/{order_uuid:uuid}/menu' => [OrderController::class, 'showMenu'],
        '/orders/show/{order_uuid:uuid}' => [OrderController::class, 'show'],
        '/orders/lock/{order_uuid:uuid}' => [OrderController::class, 'lockOrder'],
        '/orders/unlock/{order_uuid:uuid}' => [OrderController::class, 'unlockOrder'],
        '/overview' => [OverviewController::class, 'index'],
        '/user/settings' => [UserController::class, 'userSettings'],
        '/highscore' => [HighscoreController::class, 'index'],
        '/stats' => [StatsController::class, 'index'],
    ],
    'POST' => [
        '/login'  => [UserController::class, 'authenticate'],
        '/user/settings' => [UserController::class, 'updateUserSettings'],
        '/orders/new' => [OrderController::class, 'createOrder'],
        '/orders' => [OrderController::class, 'addItems'],
        '/orders/close' => [OrderController::class, 'closeOrder'],
    ],
];