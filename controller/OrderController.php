<?php

namespace App\Controllers;

use Ramsey\Uuid\Uuid;
use Respect\Validation\ValidatorBuilder as v;
use Respect\Validation\Exceptions\ValidationException;

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
        $categories = $this->capsule->table('categories')->get();
        $this->smarty->assign('categories', $categories);
        $this->smarty->display('orders/chooseCategory.tpl');
    }

    public function showMenu(int $category_id)
    {
        $menu = $this->capsule
            ->table('menu')
            ->where('category_id', $category_id)
            ->leftJoin('categories', 'menu.category_id', '=', 'categories.id')
            ->select('menu.*', 'categories.id as category_id', 'categories.multiple_extras as multiple_extras')
            ->get();
        $extras = $this->capsule->table('extras')->where('category_id', $category_id)->get();
        $this->smarty->assign([
            'menu' => $menu->toArray(),
            'extras' => $extras->toArray(),
            'category_id' => $category_id
        ]);
        $this->smarty->display('orders/showMenu.tpl');
    }

    public function createOrder()
    {
        try {
            v::key('order_uuid', v::undefOr(v::uuid()))
                ->key('category_id', v::intVal()->greaterThanOrEqual(1))
                ->key('item', v::arrayType()->each(
                    v::arrayType()
                        ->key('amount', v::intVal()->between(1, 5))
                        ->keyOptional('extras', v::arrayType()->each(v::undefOr(v::intVal())))
                        ->keyOptional('checked', v::not(v::blank()))
                ))
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $order_uuid = $_POST['order_uuid'] ?? NULL;
        $items = array_filter($_POST['item'] ?? [], fn($row) => isset($row['checked']));

        $attrs = [
            'uuid' => $order_uuid,
            'owner_uuid' => $_SESSION['user']->uuid,
            'category_id' => $_POST['category_id'],
        ];
        $order = $this->capsule->table('orders')->where($attrs)->first();
        if (!$order) {
            $order_uuid = Uuid::uuid4();
            $this->capsule->table('orders')->insert([
                'uuid' => $order_uuid,
                'owner_uuid' => $_SESSION['user']->uuid,
                'category_id' => $_POST['category_id'],
                'open' => 1
            ]);
        }
        foreach ($items as $item_id => $item) {
            $orderItemId = $this->capsule->table('order_items')->insertGetId([
                'order_uuid' => $order_uuid,
                'item_id' => $item_id,
                'item_owner_uuid' => $_SESSION['user']->uuid,
                'amount' => $item['amount'],
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s')
            ]);
            
            $extraIds = array_filter($item['extras'] ?? [], fn($id) => $id !== '' && $id !== null);
            foreach ($extraIds as $extraId) {
                $this->capsule->table('order_item_extras')->insert([
                    'order_item_id' => $orderItemId,
                    'extra_id' => (int) $extraId,
                ]);
            }
        }
        header('Location: /orders');
    }

    public function addToOrder()
    {
        try {
            v::key('order_uuid', v::uuid())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }
        $order = $this->capsule->table('orders')->where('uuid', $_POST['order_uuid'])->first();
        $menu = $this->capsule
            ->table('menu')
            ->where('category_id', $order->category_id)
            ->leftJoin('categories', 'menu.category_id', '=', 'categories.id')
            ->select('menu.*', 'categories.id as category_id', 'categories.multiple_extras as multiple_extras')
            ->get();
        $extras = $this->capsule->table('extras')->where('category_id', $order->category_id)->get();
        $this->smarty->assign([
            'menu' => $menu->toArray(),
            'extras' => $extras->toArray(),
            'category_id' => $order->category_id,
            'order' => $order
        ]);
        $this->smarty->display('orders/showMenu.tpl');
    }

    public function show(string $order_uuid)
    {
        $order = $this->capsule->table('orders')
            ->where('orders.uuid', $order_uuid)
            ->leftJoin('users', 'orders.owner_uuid', '=', 'users.uuid')
            ->select('orders.*', 'users.user as ownerUser')
            ->first();
        $orderItems = $this->capsule->table('order_items')
            ->where('order_uuid', $order_uuid)
            ->leftJoin('menu', 'order_items.item_id', '=', 'menu.id')
            ->select('order_items.*', 'menu.sub_category as sub_category', 'menu.item as item', 'menu.size as size', 'menu.price as price')
            ->get();
        $extras = $this->capsule->table('order_item_extras')
            ->whereIn('order_item_id', $orderItems->pluck('id'))
            ->leftJoin('extras', 'order_item_extras.extra_id', '=', 'extras.id')
            ->select('order_item_extras.*', 'extras.name as extraName')
            ->get();

        $total = $this->total($order_uuid);
        $totalSum = array_sum(array_column($total, 'total'));

        $this->smarty->assign([
            'order' => $order,
            'orderItems' => $orderItems,
            'extras' => $extras,
            'totalItems' => $this->totalItems($order_uuid),
            'total' => $total,
            'totalSum' => $totalSum,
            'helperArray' => $this->getHelper($order_uuid),
            'sessionUser' => $_SESSION['user']->uuid
        ]);
        $this->smarty->display('orders/showOrder.tpl');
    }

    public function lockOrder(string $order_uuid)
    {
        try {
            v::key('order_uuid', v::uuid())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }
        $this->capsule->table('orders')->where('uuid', $order_uuid)->update(['locked' => 1]);
        header('Location: /orders');
    }

    public function unlockOrder(string $order_uuid)
    {
        try {
            v::key('order_uuid', v::uuid())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }
        $this->capsule->table('orders')->where('uuid', $order_uuid)->update(['locked' => 0]);
        header('Location: /orders');
    }

    public function closeOrder(string $order_uuid)
    {
        try {
            v::key('order_uuid', v::uuid())
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }
        $this->capsule->table('orders')->where('uuid', $order_uuid)->update(['open' => 0]);
        header('Location: /orders');
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
            $totalItems[$orderItem->item_id]['item'] = $orderItem->sub_category . ' ' . $orderItem->item . ' (' . $orderItem->size . ')';
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
            $total[$orderItem->ownerUser]['total'] = 0;
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
    
}