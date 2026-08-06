<?php

chdir(dirname(__DIR__));

require 'includes/init.php';
require 'config/functions.php';
session_start();

$path = $_GET['path'] ?? parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = '/' . trim($path, '/');

$routes = require 'routes/web.php';

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$handler = $routes[$method][$path] ?? null;

if ($handler === null) {
    http_response_code(404);
    require 'controller/error/404.php';
    exit;
}

$publicRoutes = [
    'GET'  => ['/login'],
    'POST' => ['/login'],
];

$isPublic = in_array($path, $publicRoutes[$method] ?? [], true);

if (!$isPublic && !isset($_SESSION['user'])) {
    header('Location: /login');
    exit;
}

require $handler;