<?php

return [
    'GET' => [
        '/' => 'controller/main.php',
        '/login' => 'controller/user/login.php',
        '/logout' => 'controller/user/logout.ph p',
        '/menu' => 'controller/menu/menu.php'
    ],
    'POST' => [
        '/login' => 'controller/user/authenticate.php',
    ],
];