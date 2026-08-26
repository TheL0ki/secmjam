<?php

namespace App\Controllers;

use AltchaOrg\Altcha\Altcha;
use AltchaOrg\Altcha\Algorithm\Pbkdf2;
use AltchaOrg\Altcha\CreateChallengeOptions;
use AltchaOrg\Altcha\VerifySolutionOptions;
use PHPMailer\PHPMailer\Exception as PHPMailerException;
use PHPMailer\PHPMailer\PHPMailer;
use Respect\Validation\ValidatorBuilder as v;
use Respect\Validation\Exceptions\ValidationException;

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
        try {
            v::key('username', v::not(v::falsy())->stringType())
                ->key('password', v::not(v::falsy())->stringType())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $user = $this->capsule->table('users')
            ->where('user', $_POST['username'])
            ->where('active', 1)
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
        $this->smarty->display('user/changepwd.tpl');
    }

    public function updatePassword()
    {
        try {
            v::key('oldpwd', v::not(v::falsy())->stringType())
                ->key('pwd', v::not(v::falsy())->stringType())
                ->key('pwd2', v::not(v::falsy())->stringType())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $user = $this->capsule->table('users')->where('uuid', $_SESSION['user']->uuid)->first();

        if (!password_verify($_POST['oldpwd'], $user->password)) {
            echo 'Error: Invalid old password';
            die;
        }

        if ($_POST['pwd'] !== $_POST['pwd2']) {
            echo 'Error: Passwords do not match';
            die;
        }

        $this->capsule->table('users')->where('uuid', $_SESSION['user']->uuid)->update([
            'password' => password_hash($_POST['pwd'], PASSWORD_DEFAULT),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        header('Location: /user/settings');
        exit;
    }

    public function showRegisterForm()
    {
        $this->smarty->display('user/register.tpl');
    }

    public function altchaChallenge()
    {
        $challenge = $this->altcha()->createChallenge(new CreateChallengeOptions(
            algorithm: new Pbkdf2(),
            cost: 5000,
            expiresAt: time() + 600,
        ));

        header('Content-Type: application/json');
        echo $challenge->toJson();
        exit;
    }

    public function registerUser()
    {
        try {
            v::key('username', v::not(v::falsy())->stringType())
                ->key('email', v::not(v::falsy())->email())
                ->key('password', v::not(v::falsy())->stringType())
                ->key('pwd2', v::not(v::falsy())->stringType())
                ->key('altcha', v::not(v::falsy())->stringType())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        try {
            $result = $this->altcha()->verifySolution(new VerifySolutionOptions(
                payload: $_POST['altcha'],
                algorithm: new Pbkdf2(),
            ));
        } catch (\InvalidArgumentException) {
            echo 'Error: Invalid captcha';
            die;
        }

        if (!$result->verified) {
            echo 'Error: Invalid captcha';
            die;
        }

        $this->capsule->table('users')->insert([
            'user' => $_POST['username'],
            'email' => $_POST['email'],
            'password' => password_hash($_POST['password'], PASSWORD_DEFAULT),
            'firstname' => $_POST['firstname'],
            'lastname' => $_POST['lastname']
        ]);

        header('Location: /login');
        exit;
    }

    private function altcha(): Altcha
    {
        return new Altcha(
            hmacSignatureSecret: $_ENV['ALTCHA_HMAC_SECRET'],
        );
    }

    public function forgotPassword()
    {
        $this->smarty->assign('sent', false);
        $this->smarty->display('user/pwd_forget.tpl');
    }

    public function sendPasswordReset()
    {
        try {
            v::key('email', v::not(v::falsy())->email())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $user = $this->capsule->table('users')
            ->where('email', $_POST['email'])
            ->where('active', 1)
            ->first();

        if ($user) {
            $this->capsule->table('password_resets')
                ->where('user_uuid', $user->uuid)
                ->delete();

            $token = bin2hex(random_bytes(32));
            $this->capsule->table('password_resets')->insert([
                'user_uuid' => $user->uuid,
                'token_hash' => hash('sha256', $token),
                'expires_at' => date('Y-m-d H:i:s', time() + 3600),
            ]);

            $this->sendPasswordResetMail($user, $token);
        }

        $this->smarty->assign('sent', true);
        $this->smarty->display('user/pwd_forget.tpl');
    }

    public function showResetPassword(string $token)
    {
        $this->smarty->assign('token', $token);
        $this->smarty->assign('error', '');
        $this->smarty->assign('invalid', $this->findValidReset($token) === null);
        $this->smarty->display('user/pwd_reset.tpl');
    }

    public function resetPassword(string $token)
    {
        try {
            v::key('pwd', v::not(v::falsy())->stringType())
                ->key('pwd2', v::not(v::falsy())->stringType())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $reset = $this->findValidReset($token);
        if ($reset === null) {
            $this->smarty->assign('token', $token);
            $this->smarty->assign('error', '');
            $this->smarty->assign('invalid', true);
            $this->smarty->display('user/pwd_reset.tpl');
            return;
        }

        if ($_POST['pwd'] !== $_POST['pwd2']) {
            $this->smarty->assign('token', $token);
            $this->smarty->assign('error', 'Passwörter stimmen nicht überein.');
            $this->smarty->assign('invalid', false);
            $this->smarty->display('user/pwd_reset.tpl');
            return;
        }

        $this->capsule->table('users')->where('uuid', $reset->user_uuid)->update([
            'password' => password_hash($_POST['pwd'], PASSWORD_DEFAULT),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        $this->capsule->table('password_resets')
            ->where('user_uuid', $reset->user_uuid)
            ->delete();

        header('Location: /login');
        exit;
    }

    private function findValidReset(string $token): ?object
    {
        return $this->capsule->table('password_resets')
            ->where('token_hash', hash('sha256', $token))
            ->where('expires_at', '>', date('Y-m-d H:i:s'))
            ->first();
    }

    private function sendPasswordResetMail(object $user, string $token): void
    {
        $name = trim(($user->firstname ?? '') . ' ' . ($user->lastname ?? ''));
        if ($name === '') {
            $name = $user->user ?? '';
        }

        $text = file_get_contents('mailTemplates/mailPasswordReset.html');
        $text = str_replace('[name]', $name, $text);
        $text = str_replace('[address]', rtrim($_ENV['APP_ADDRESS'] ?? '', '/') . '/reset-password/' . $token, $text);

        $mail = new PHPMailer(true);
        try {
            $mail->isSMTP();
            $mail->Host = $_ENV['EMAIL_SMTP'];
            $mail->Port = (int) $_ENV['EMAIL_PORT'];
            $mail->CharSet = PHPMailer::CHARSET_UTF8;

            $username = $_ENV['EMAIL_USER'] ?? '';
            $password = $_ENV['EMAIL_PASSWORD'] ?? '';
            if ($username !== '' && $password !== '') {
                $mail->SMTPAuth = true;
                $mail->Username = $username;
                $mail->Password = $password;
                $mail->SMTPSecure = $mail->Port === 465
                    ? PHPMailer::ENCRYPTION_SMTPS
                    : PHPMailer::ENCRYPTION_STARTTLS;
            } else {
                $mail->SMTPAuth = false;
                $mail->SMTPAutoTLS = false;
            }

            $mail->setFrom($_ENV['EMAIL_FROM'], $_ENV['EMAIL_FROM_NAME'] ?? '');
            $mail->addAddress($user->email);
            $mail->isHTML(true);
            $mail->Subject = 'SEC-Mjam Passwort zurücksetzen';
            $mail->Body = $text;
            $mail->send();
            error_log('Password reset mail sent to ' . $user->email);
        } catch (PHPMailerException $e) {
            error_log('Password reset mail failed: ' . $mail->ErrorInfo);
        }
    }
}