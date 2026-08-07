<?php

chdir(dirname(__DIR__));

$path = $_GET['path'] ?? parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = '/' . trim($path, '/');

$routes = require 'routes/web.php';

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

$publicRoutes = [
    'GET'  => ['/login'],
    'POST' => ['/login'],
];

$isPublic = in_array($path, $publicRoutes[$method] ?? [], true);

if (!$isPublic && !isset($_SESSION['user'])) {
    header('Location: /login');
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
    require 'controller/error/404.php';
    exit;
}

$controller = new $class($smarty, $capsule);
$controller->$action(...$params);
