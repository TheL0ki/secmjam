<?php

chdir(dirname(__DIR__));

require 'App/init.php';
require 'config/functions.php';

session_start();

require 'App/router.php';
