<?php

use App\Controllers\MainController;
use App\Controllers\UserController;
use App\Controllers\OrderController;
use App\Controllers\OverviewController;
use App\Controllers\HighscoreController;
use App\Controllers\StatsController;
use App\Controllers\AdminController;

return [
    'GET' => [
        '/'       => [MainController::class, 'index'],
        '/login'  => [UserController::class, 'login'],
        '/register' => [UserController::class, 'showRegisterForm'],
        '/altcha' => [UserController::class, 'altchaChallenge'],
        '/forgot-password' => [UserController::class, 'forgotPassword'],
        '/reset-password/{token}' => [UserController::class, 'showResetPassword'],
        '/logout' => [UserController::class, 'logout'],
        '/orders'   => [OrderController::class, 'index'],
        '/orders/new' => [OrderController::class, 'chooseCategory'],
        '/orders/{order_uuid:uuid}/menu' => [OrderController::class, 'showMenu'],
        '/orders/show/{order_uuid:uuid}' => [OrderController::class, 'show'],
        '/orders/lock/{order_uuid:uuid}' => [OrderController::class, 'lockOrder'],
        '/orders/unlock/{order_uuid:uuid}' => [OrderController::class, 'unlockOrder'],
        '/overview' => [OverviewController::class, 'index'],
        '/user/settings' => [UserController::class, 'userSettings'],
        '/user/changepwd' => [UserController::class, 'changePassword'],
        '/highscore' => [HighscoreController::class, 'index'],
        '/stats' => [StatsController::class, 'index'],
        '/admin' => [AdminController::class, 'index'],
        '/admin/users' => [AdminController::class, 'users'],
        '/admin/categories' => [AdminController::class, 'categories'],
        '/admin/extras' => [AdminController::class, 'extras'],
        '/admin/menu' => [AdminController::class, 'menu'],
    ],
    'POST' => [
        '/login'  => [UserController::class, 'authenticate'],
        '/register' => [UserController::class, 'registerUser'],
        '/forgot-password' => [UserController::class, 'sendPasswordReset'],
        '/reset-password/{token}' => [UserController::class, 'resetPassword'],
        '/user/settings' => [UserController::class, 'updateUserSettings'],
        '/orders/new' => [OrderController::class, 'createOrder'],
        '/orders' => [OrderController::class, 'addItems'],
        '/orders/close' => [OrderController::class, 'closeOrder'],
        '/orders/cancel-item' => [OrderController::class, 'cancelOrderItem'],
        '/user/changepwd' => [UserController::class, 'updatePassword'],
    ],
];