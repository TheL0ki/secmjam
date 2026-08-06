<?php

$user = $capsule->table('users')->where('user', $_POST['user'])->first();

if($user) {
    if(password_verify($_POST['password'], $user->password)) {
        echo 'Login successful';
        $_SESSION['user'] = $user;
        header('Location: /');
        exit;
    } else {
        echo 'Login failed';
        header('Location: /login');
        exit;
    }
} else {
    echo 'Login failed';
    header('Location: /login');
    exit;
}