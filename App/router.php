<?php

chdir(dirname(__DIR__));

$path = $_GET['path'] ?? parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = '/' . trim($path, '/');

$routes = require 'routes/web.php';

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

$publicRoutes = [
    'GET'  => ['/login', '/register', '/forgot-password', '/altcha', '/reset-password'],
    'POST' => ['/login', '/register', '/forgot-password', '/reset-password'],
];

$isPublic = false;
foreach ($publicRoutes[$method] ?? [] as $publicPath) {
    if ($path === $publicPath || str_starts_with($path, $publicPath . '/')) {
        $isPublic = true;
        break;
    }
}

if (!$isPublic && !isset($_SESSION['user'])) {
    header('Location: /login');
    exit;
}

$isAdminRoute = $path === '/admin' || str_starts_with($path, '/admin/');
if ($isAdminRoute && ($_SESSION['user']->role ?? null) !== 'admin') {
    http_response_code(403);
    $smarty->display('error/403.tpl');
    exit;
}

function matchRoute(string $path, array $routes): ?array
{
    foreach ($routes as $pattern => $handler) {
        $regex = preg_replace_callback(
            '/\{([a-zA-Z_]+)(?::([a-z]+))?\}/',
            function (array $m): string {
                $name = $m[1];
                $type = $m[2] ?? 'string';
                $part = match ($type) {
                    'int' => '\d+',
                    default => '[^/]+',
                };

                return '(?P<' . $name . '>' . $part . ')';
            },
            $pattern
        );

        if (preg_match('#^' . $regex . '$#', $path, $matches)) {
            $params = array_filter($matches, 'is_string', ARRAY_FILTER_USE_KEY);

            return [$handler, $params];
        }
    }

    return null;
}

$result = matchRoute($path, $routes[$method] ?? []);

if ($result === null) {
    http_response_code(404);
    $smarty->display('error/404.tpl');
    exit;
}

[[$class, $action], $params] = $result;

if (!class_exists($class) || !method_exists($class, $action)) {
    http_response_code(404);
    $smarty->display('error/404.tpl');
    exit;
}

$controller = new $class($smarty, $capsule);
$controller->$action(...$params);
