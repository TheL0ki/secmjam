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
        '/admin/users/create' => [AdminController::class, 'createUser'],
        '/admin/users/edit/{user_uuid:string}' => [AdminController::class, 'editUser'],
        '/admin/categories' => [AdminController::class, 'categories'],
        '/admin/categories/create' => [AdminController::class, 'createCategory'],
        '/admin/categories/edit/{category_id:int}' => [AdminController::class, 'editCategory'],
        '/admin/categories/edit/{category_id:int}/menu' => [AdminController::class, 'editMenu'],
        '/admin/categories/edit/{category_id:int}/menu/create' => [AdminController::class, 'createMenuItem'],
        '/admin/categories/edit/{category_id:int}/extras' => [AdminController::class, 'editCategoryExtras'],
        '/admin/categories/edit/{category_id:int}/extras/create' => [AdminController::class, 'createExtra'],
        '/admin/extras' => [AdminController::class, 'extras'],
        '/admin/menu' => [AdminController::class, 'menu'],
    ],
    'POST' => [
        '/vote' => [MainController::class, 'vote'],
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
        '/admin/users/create' => [AdminController::class, 'storeUser'],
        '/admin/users/edit/{user_uuid:string}' => [AdminController::class, 'updateUser'],
        '/admin/users/delete/{user_uuid:string}' => [AdminController::class, 'deleteUser'],
        '/admin/categories/create' => [AdminController::class, 'storeCategory'],
        '/admin/categories/delete' => [AdminController::class, 'deleteCategory'],
        '/admin/categories/edit/{category_id:int}' => [AdminController::class, 'updateCategory'],
        '/admin/categories/edit/{category_id:int}/menu' => [AdminController::class, 'updateMenu'],
        '/admin/categories/edit/{category_id:int}/menu/create' => [AdminController::class, 'storeMenuItem'],
        '/admin/categories/edit/{category_id:int}/menu/delete/{item_id:int}' => [AdminController::class, 'deleteMenuItem'],
        '/admin/categories/edit/{category_id:int}/extras' => [AdminController::class, 'updateExtras'],
        '/admin/categories/edit/{category_id:int}/extras/create' => [AdminController::class, 'storeExtra'],
        '/admin/categories/edit/{category_id:int}/extras/delete/{extra_id:int}' => [AdminController::class, 'deleteExtra'],
    ],
];