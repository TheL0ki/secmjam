<?php

chdir(dirname(__DIR__));

require 'vendor/autoload.php';

use Smarty\Smarty;
use Symfony\Component\Dotenv\Dotenv;
use Illuminate\Database\Capsule\Manager as Capsule;

if (is_readable('.env')) {
    (new Dotenv())->loadEnv('.env');
}

$capsule = new Capsule;
$capsule->addConnection([
    'driver'    => 'mysql',
    'host'      => $_ENV['DB_HOSTNAME'],
    'database'  => $_ENV['DB_DATABASE'],
    'username'  => $_ENV['DB_USER'],
    'password'  => $_ENV['DB_PASSWORD'],
    'charset'   => 'utf8',
    'collation' => 'utf8_unicode_ci',
    'prefix'    => '',
]);

$capsule->setAsGlobal();
$capsule->bootEloquent();

$smarty = new Smarty();

$smarty->setTemplateDir('templates');
$smarty->setCompileDir('templates_c');
$smarty->setConfigDir('configs');
$smarty->setCacheDir('cache');