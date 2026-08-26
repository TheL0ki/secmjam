<?php

namespace App\Controllers;

use Ramsey\Uuid\Uuid;
use Respect\Validation\ValidatorBuilder as v;
use Respect\Validation\Exceptions\ValidationException;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception as PHPMailerException;

class OrderController
{
    public function __construct(
        private mixed $smarty,
        private mixed $capsule
    ) {}

    public function index()
    {
        $open_orders = $this->capsule->table('orders')
            ->where('open', 1)
            ->leftJoin('users', 'orders.owner_uuid', '=', 'users.uuid')
            ->leftJoin('categories', 'orders.category_id', '=', 'categories.id')
            ->select('orders.*', 'categories.name as categoryName', 'users.user as ownerUser')
            ->get();
        $last_orders = $this->capsule->table('orders')
            ->where('owner_uuid', $_SESSION['user']->uuid)
            ->where('open', 0)
            ->leftJoin('categories', 'orders.category_id', '=', 'categories.id')
            ->select('orders.*', 'categories.name as categoryName')
            ->orderBy('orders.created_at', 'desc')
            ->limit(10)
            ->get();
        $this->smarty->assign([
            'open_orders' => $open_orders->toArray(),
            'last_orders' => $last_orders->toArray()
        ]);
        $this->smarty->display('orders/orders.tpl');
    }

    public function chooseCategory()
    {
        $orderCheck = $this->capsule->table('orders')->where('owner_uuid', $_SESSION['user']->uuid)->where('open', 1)->first();
        if ($orderCheck) {
            header('Location: /orders/show/' . $orderCheck->uuid);
            exit;
        }

        $categories = $this->capsule->table('categories')->get();
        $this->smarty->assign('categories', $categories);
        $this->smarty->display('orders/chooseCategory.tpl');
    }

    public function createOrder()
    {
        try {
            v::key('category_id', v::intVal()->greaterThanOrEqual(1))
                ->keyOptional('autolock', v::stringType())
                ->keyOptional('infomail', v::equals('1'))
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
            
        }

        $autolock = null;
        if (!empty($_POST['autolock'])) {
            $parsed = \DateTime::createFromFormat('Y-m-d\TH:i', $_POST['autolock'])
                ?: \DateTime::createFromFormat('Y-m-d\TH:i:s', $_POST['autolock']);
            if (!$parsed) {
                echo 'Error: Invalid autolock datetime';
                die;
            }
            $autolock = $parsed->format('Y-m-d H:i:s');
        }

        $order_uuid = Uuid::uuid4()->toString();
        $category_id = (int) $_POST['category_id'];

        $this->capsule->table('orders')->insert([
            'uuid' => $order_uuid,
            'owner_uuid' => $_SESSION['user']->uuid,
            'category_id' => $category_id,
            'open' => 1,
            'locked' => 0,
            'autolock' => $autolock,
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        if (!empty($_POST['infomail'])) {
            $category = $this->capsule->table('categories')->where('id', $category_id)->first();
            $this->sendInfoMail(
                $_SESSION['user'],
                $category->name ?? '',
                $autolock !== null,
                $autolock ? date('d.m.Y H:i', strtotime($autolock)) : '00:00',
                $order_uuid
            );
        }

        header('Location: /orders/' . $order_uuid . '/menu');
        exit;
    }

    public function showMenu(string $order_uuid)
    {
        $order = $this->capsule->table('orders')->where('uuid', $order_uuid)->first();
        if (!$order) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            return;
        }

        $menu = $this->capsule
            ->table('menu')
            ->where('menu.category_id', $order->category_id)
            ->where('menu.active', true)
            ->leftJoin('categories', 'menu.category_id', '=', 'categories.id')
            ->select('menu.*', 'categories.id as category_id', 'categories.multiple_extras as multiple_extras')
            ->get();
        $extras = $this->capsule->table('extras')->where('category_id', $order->category_id)->where('active', true)->get();
        $this->smarty->assign([
            'menu' => $menu->toArray(),
            'extras' => $extras->toArray(),
            'category_id' => $order->category_id,
            'order' => $order,
        ]);
        $this->smarty->display('orders/showMenu.tpl');
    }

    public function addItems()
    {
        $_POST['item'] = array_filter($_POST['item'] ?? [], fn($row) => isset($row['checked']));

        try {
            v::key('order_uuid', v::uuid())
                ->key('category_id', v::intVal()->greaterThanOrEqual(1))
                ->key('item', v::arrayType()->each(
                    v::arrayType()
                        ->keyOptional('extras', v::arrayType()->each(v::undefOr(v::intVal())))
                        ->key('amount', v::intVal()->between(1, 5))
                        ->keyOptional('checked', v::not(v::blank()))
                ))
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            dd($_POST);
            die;
        }

        $order_uuid = $_POST['order_uuid'];
        $order = $this->capsule->table('orders')->where([
            'uuid' => $order_uuid,
            'category_id' => $_POST['category_id'],
        ])->first();

        if (!$order) {
            echo 'Error: Order not found';
            die;
        }

        foreach ($_POST['item'] as $item_id => $item) {
            $orderItemId = $this->capsule->table('order_items')->insertGetId([
                'order_uuid' => $order_uuid,
                'item_id' => $item_id,
                'item_owner_uuid' => $_SESSION['user']->uuid,
                'amount' => $item['amount'],
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
            ]);

            $extraIds = array_filter($item['extras'] ?? [], fn($id) => $id !== '' && $id !== null && $id !== 'false');
            foreach ($extraIds as $extraId) {
                $this->capsule->table('order_item_extras')->insert([
                    'order_item_id' => $orderItemId,
                    'extra_id' => (int) $extraId,
                ]);
            }
        }
        header('Location: /orders/show/' . $order_uuid);
        exit;
    }

    public function show(string $order_uuid)
    {
        $order = $this->capsule->table('orders')
            ->where('orders.uuid', $order_uuid)
            ->leftJoin('users', 'orders.owner_uuid', '=', 'users.uuid')
            ->select('orders.*', 'users.user as ownerUser')
            ->first();
        $orderItems = $this->capsule->table('order_items')
            ->where('order_items.order_uuid', $order_uuid)
            ->where('order_items.active', 1)
            ->leftJoin('menu', 'order_items.item_id', '=', 'menu.id')
            ->leftJoin('users', 'order_items.item_owner_uuid', '=', 'users.uuid')
            ->select('order_items.*', 'menu.sub_category as sub_category', 'menu.item as item', 'menu.size as size', 'menu.price as price', 'users.*')
            ->get();
        $extras = $this->capsule->table('order_item_extras')
            ->whereIn('order_item_id', $orderItems->pluck('id'))
            ->leftJoin('extras', 'order_item_extras.extra_id', '=', 'extras.id')
            ->select('order_item_extras.*', 'extras.name as extraName')
            ->get();
        
        $orderExtras = [];
        foreach ($extras as $orderExtra) {
            $orderExtras[$orderExtra->order_item_id][] = $orderExtra->extraName;
        }        

        $total = $this->total($order_uuid);
        $totalSum = array_sum(array_column($total, 'total'));

        $catPoints = $this->capsule->table('categories')
            ->where('id', $order->category_id)
            ->pluck('points')
            ->first();

        $this->smarty->assign([
            'order' => $order,
            'orderItems' => $orderItems,
            'orderExtras' => $orderExtras,
            'totalItems' => $this->totalItems($order_uuid),
            'total' => $total,
            'totalSum' => $totalSum,
            'helperArray' => $this->getHelper($order_uuid),
            'sessionUser' => $_SESSION['user']->uuid,
            'points' => ($orderItems->sum('amount') * $catPoints) ?? 0
        ]);

        $this->smarty->display('orders/showOrder.tpl');
    }

    public function lockOrder(string $order_uuid)
    {
        try {
            v::uuid()->assert($order_uuid);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }
        $order = $this->capsule->table('orders')->where('uuid', $order_uuid)->first();
        if (!$order) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            return;
        }
        if ($order->locked == 1) {
            echo 'Error: Order already locked';
            die;
        }
        if ($order->owner_uuid != $_SESSION['user']->uuid) {
            echo 'Error: You are not the owner of this order';
            die;
        }

        $this->capsule->table('orders')->where('uuid', $order_uuid)->update(['locked' => 1]);
        header('Location: /orders');
    }

    public function unlockOrder(string $order_uuid)
    {
        try {
            v::uuid()->assert($order_uuid);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }
        $order = $this->capsule->table('orders')->where('uuid', $order_uuid)->first();
        if (!$order) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            return;
        }
        if ($order->locked == 0) {
            echo 'Error: Order already unlocked';
            die;
        }
        if ($order->owner_uuid != $_SESSION['user']->uuid) {
            echo 'Error: You are not the owner of this order';
            die;
        }

        $this->capsule->table('orders')->where('uuid', $order_uuid)->update(['locked' => 0]);
        header('Location: /orders');
    }

    public function closeOrder()
    {
        try {
            v::key('order_uuid', v::uuid())
                ->keyOptional('helper', v::arrayType()->each(v::uuid()))
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }
        $order = $this->capsule->table('orders')->where('uuid', $_POST['order_uuid'])->first();
        if (!$order) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            return;
        }
        if ($order->open == 0) {
            echo 'Error: Order already closed';
            die;
        }
        if ($order->owner_uuid != $_SESSION['user']->uuid) {
            echo 'Error: You are not the owner of this order';
            die;
        }

        $this->capsule->table('orders')->where('uuid', $_POST['order_uuid'])->update(['open' => 0, 'locked' => 1]);
        if (!empty($_POST['helper'])) {
            foreach ($_POST['helper'] as $helper) {
                $this->capsule->table('helper')->insert([
                    'user_uuid' => $helper,
                    'order_uuid' => $_POST['order_uuid'],
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            }
        }
        header('Location: /orders/show/' . $_POST['order_uuid']);
    }

    public function totalItems(string $order_uuid)
    {
        $orderItems = $this->capsule->table('order_items')
            ->where('order_uuid', $order_uuid)
            ->leftJoin('menu', 'order_items.item_id', '=', 'menu.id')
            ->select('order_items.*', 'menu.sub_category as sub_category', 'menu.item as item', 'menu.size as size', 'menu.price as price')
            ->get();
        
        $totalItems = [];
        foreach ($orderItems as $orderItem) {
            if($orderItem->size === '') {
                $size = '';
            } else {
                $size = ' (' . $orderItem->size . ')';
            }
            $totalItems[$orderItem->item_id]['item'] = $orderItem->sub_category . ' ' . $orderItem->item . $size;
            $amount = $this->capsule->table('order_items')
                ->where('item_id', $orderItem->item_id)
                ->where('order_uuid', $order_uuid)
                ->sum('amount');
            $totalItems[$orderItem->item_id]['amount'] = $amount ?? 0;
        }

        return $totalItems;

    }

    public function total(string $order_uuid)
    {
        $orderItems = $this->capsule->table('order_items')
            ->where('order_uuid', $order_uuid)
            ->leftJoin('menu', 'order_items.item_id', '=', 'menu.id')
            ->leftJoin('users', 'order_items.item_owner_uuid', '=', 'users.uuid')
            ->select('order_items.*', 'menu.sub_category as sub_category', 'menu.item as item', 'menu.size as size', 'menu.price as price', 'users.user as ownerUser')
            ->get();
        $total = [];
        foreach ($orderItems as $orderItem) {
            if (!isset($total[$orderItem->ownerUser])) {
                $total[$orderItem->ownerUser] = [
                    'total' => 0
                ];
            }
            $total[$orderItem->ownerUser]['total'] += $orderItem->price * $orderItem->amount;
        }
        return $total;
    }

    public function getHelper(string $order_uuid)
    {
        $helpers = $this->capsule->table('order_items')
            ->where('order_uuid', $order_uuid)
            ->select('item_owner_uuid')
            ->distinct()
            ->leftJoin('users', 'order_items.item_owner_uuid', '=', 'users.uuid')
            ->select('users.uuid as uuid', 'users.user as user')
            ->get();
        return $helpers->toArray();
    }

    public function cancelOrderItem()
    {
        try {
            v::intVal()->greaterThanOrEqual(1)->assert($_POST['order_item_id']);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $orderItem = $this->capsule->table('order_items')
            ->where('id', $_POST['order_item_id'])
            ->leftJoin('orders', 'order_items.order_uuid', '=', 'orders.uuid')
            ->select('order_items.*', 'orders.owner_uuid as order_owner_uuid', 'orders.open as order_open', 'orders.locked as order_locked')
            ->first();

        if (!$orderItem) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            return;
        }

        if ($orderItem->item_owner_uuid != $_SESSION['user']->uuid) {
            echo 'Error: You are not the owner of this item';
            die;
        }
        
        if ($orderItem->active == 0) {
            echo 'Error: Item already cancelled';
            die;
        }

        if ($orderItem->order_open == 0 || $orderItem->order_locked == 1) {
            echo 'Error: Order is already closed or locked';
            die;
        }

        $this->capsule->table('order_items')
            ->where('id', $_POST['order_item_id'])
            ->update([
                'active' => 0,
                'updated_at' => date('Y-m-d H:i:s')
        ]);
        header('Location: /orders/show/' . $orderItem->order_uuid);
        exit;
    }

    private function sendInfoMail(object $owner, string $category, bool $hasAutolock = false, string $time = '00:00', string $order_uuid = '') : void
    {
        $receivers = $this->capsule->table('users')
            ->where('notify', 1)
            ->where('active', 1)
            ->pluck('email');

        $ownerFullName = trim(($owner->firstname ?? '') . ' ' . ($owner->lastname ?? ''));
        if ($ownerFullName === '') {
            $ownerFullName = $owner->user ?? '';
        }

        $template = $hasAutolock ? 'mailTemplates/mailTime.html' : 'mailTemplates/mailNoTime.html';
        $text = file_get_contents($template);
        $text = str_replace('[time]', $time, $text);
        $text = str_replace('[name]', $ownerFullName, $text);
        $text = str_replace('[mail_food]', ucfirst($category), $text);
        $text = str_replace('[address]', $_ENV['APP_ADDRESS'] . '/orders/show/' . $order_uuid ?? '', $text);

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
            $mail->isHTML(true);
            $mail->Subject = 'Neue SEC-Mjam Bestellung';
            $mail->Body = $text;

            foreach ($receivers as $receiver) {
                $mail->clearAddresses();
                $mail->addAddress($receiver);
                $mail->send();
            }
        } catch (PHPMailerException $e) {
            error_log('Info mail failed: ' . $mail->ErrorInfo);
        }
    }
}