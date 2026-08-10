<?php

namespace App\Controllers;

class UserController
{
    public function __construct(
        private $smarty,
        private $capsule
    ) {}

    public function login()
    {
        $this->smarty->display('user/login.tpl');
    }

    public function authenticate()
    {
        $user = $this->capsule->table('users')
            ->where('user', $_POST['user'])
            ->first();

        if ($user && password_verify($_POST['password'], $user->password)) {
            session_regenerate_id(true);
            $_SESSION['user'] = $user;
            header('Location: /');
            exit;
        }

        header('Location: /login');
        exit;
    }

    public function logout()
    {
        session_destroy();
        header('Location: /');
        exit;
    }

    public function userSettings()
    {
        $user = $this->capsule->table('users')->where('uuid', $_SESSION['user']->uuid)->first();
        $this->smarty->assign('user', $user);
        $this->smarty->display('user/settings.tpl');
    }

    public function updateUserSettings()
    {
        $this->capsule->table('users')->where('uuid', $_SESSION['user']->uuid)->update([
            'email' => $_POST['email'],
            'notify' => $_POST['notify'] ? 1 : 0,
            'active' => $_POST['active'] ? 1 : 0,
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        header('Location: /user/settings');
        exit;
    }

    public function changePassword()
    {
        $this->smarty->display('user/changePassword.tpl');
    }

    public function showRegisterForm()
    {
        $this->smarty->display('user/register.tpl');
    }

    public function register()
    {
        
    }

    public function forgotPassword()
    {
        $this->smarty->display('user/forgotPassword.tpl');
    }
}