<?php

namespace App\Controllers;

use Respect\Validation\ValidatorBuilder as v;
use Respect\Validation\Exceptions\ValidationException;

class AdminController
{
    public function __construct(
        private mixed $smarty,
        private mixed $capsule
    ) {}

    public function index() : void
    {
        $this->smarty->display('admin/index.tpl');
    }

    public function users() : void
    {
        $users = $this->capsule->table('users')->where('active', true)->get();
        $this->smarty->assign('users', $users);
        $this->smarty->display('admin/users.tpl');
    }

    public function categories() : void
    {
        $categories = $this->capsule->table('categories')->where('active', true)->get();

        $this->smarty->assign('categories', $categories);
        $this->smarty->display('admin/categories.tpl');
    }

    public function menu() : void
    {
        $this->smarty->display('admin/menu.tpl');
    }

    public function extras() : void
    {
        $this->smarty->display('admin/extras.tpl');
    }

    public function createUser() : void
    {
        $this->smarty->display('admin/createUser.tpl');
    }

    public function storeUser() : void
    {
        try {
            v::key('username', v::not(v::falsy())->stringType())
                ->key('firstname', v::not(v::falsy())->stringType())
                ->key('lastname', v::not(v::falsy())->stringType())
                ->key('email', v::not(v::falsy())->email())
                ->key('role', v::not(v::falsy())->in(['user', 'manager', 'admin']))
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $this->capsule->table('users')->insert([
            'user' => $_POST['username'],
            'firstname' => $_POST['firstname'],
            'lastname' => $_POST['lastname'],
            'email' => $_POST['email'],
            'role' => $_POST['role'],
            'password' => password_hash(bin2hex(random_bytes(16)), PASSWORD_DEFAULT),
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        header('Location: /admin/users');
        exit;
    }

    public function createCategory() : void
    {
        $this->smarty->display('admin/createCategory.tpl');
    }

    public function storeCategory() : void
    {
        $data = $_POST;
        $data['points'] = (int) ($data['points'] ?? 0);
        $data['multiple_extras'] = isset($data['multiple_extras']) ? 1 : 0;
        if (empty($data['slug']) && !empty($data['name'])) {
            $data['slug'] = $this->slugify($data['name']);
        }

        try {
            v::key('name', v::not(v::falsy())->stringType())
                ->key('slug', v::not(v::falsy())->stringType())
                ->key('points', v::intType())
                ->key('multiple_extras', v::in([0, 1]))
                ->assert($data);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $this->capsule->table('categories')->insert([
            'name' => $data['name'],
            'slug' => $data['slug'],
            'points' => $data['points'],
            'multiple_extras' => $data['multiple_extras'],
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        header('Location: /admin/categories');
        exit;
    }

    public function deleteCategory() : void
    {
        $category_id = (int) $_POST['category_id'] ?? null;

        try {
            v::not(v::falsy())->intType()->assert($category_id);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }

        $this->capsule->table('categories')->where('id', $category_id)->update([
            'active' => false,
            'updated_at' => date('Y-m-d H:i:s'),
        ]);
        header('Location: /admin/categories');
        exit;
    }

    public function editUser(string $user_uuid) : void
    {
        $user = $this->capsule->table('users')->where('uuid', $user_uuid)->first();
        if (!$user) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }
        $this->smarty->assign('user', $user);
        $this->smarty->display('admin/editUser.tpl');
    }

    public function updateUser(string $user_uuid) : void
    {   
        try {
        v::key('username', v::not(v::falsy())->stringType())
            ->key('firstname', v::not(v::falsy())->stringType())
            ->key('lastname', v::not(v::falsy())->stringType())
            ->key('email', v::not(v::falsy())->email())
            ->key('role', v::not(v::falsy())->stringType())
            ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $user = $this->capsule->table('users')->where('uuid', $user_uuid)->first();
        if (!$user) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }

        $this->capsule->table('users')->where('uuid', $user_uuid)->update([
            'user' => $_POST['username'],
            'firstname' => $_POST['firstname'],
            'lastname' => $_POST['lastname'],
            'email' => $_POST['email'],
            'role' => $_POST['role'],
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        header('Location: /admin/users');
    }

    public function deleteUser(string $user_uuid) : void
    {
        $user = $this->capsule->table('users')->where('uuid', $user_uuid)->first();
        if (!$user) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }
        $this->capsule->table('users')->where('uuid', $user_uuid)->update([
            'active' => false,
            'updated_at' => date('Y-m-d H:i:s'),
        ]);
        header('Location: /admin/users');
    }

    public function editCategory(int $category_id) : void
    {
        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }
        $this->smarty->assign('category', $category);
        $this->smarty->display('admin/editCategory.tpl');
    }

    public function updateCategory(int $category_id) : void
    {
        $data = $_POST;
        $data['points'] = (int) $data['points'];
        $data['multiple_extras'] = isset($data['multiple_extras']) ? 1 : 0;

        try {
            v::key('name', v::not(v::falsy())->stringType())
                ->key('points', v::not(v::falsy())->intType())
                ->key('multiple_extras', v::in([0, 1]))
                ->assert($data);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }

        $this->capsule->table('categories')->where('id', $category_id)->update([
            'name' => $data['name'],
            'points' => $data['points'],
            'multiple_extras' => $data['multiple_extras'],
            'updated_at' => date('Y-m-d H:i:s'),
        ]);
        header('Location: /admin/categories');
    }

    public function editMenu(int $category_id) : void
    {
        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }
        $menu = $this->capsule->table('menu')->where('category_id', $category_id)->where('active', true)->get();
        $this->smarty->assign([
            'menu' => $menu,
            'category_id' => $category_id
        ]);
        $this->smarty->display('admin/editMenu.tpl');
    }

    public function createMenuItem(int $category_id) : void
    {
        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }
        $this->smarty->assign('category', $category);
        $this->smarty->display('admin/createMenuItem.tpl');
    }

    public function storeMenuItem(int $category_id) : void
    {
        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }

        $data = $_POST;
        $data['price'] = (float) ($data['price'] ?? 0);

        try {
            v::key('sub_category', v::stringType())
                ->key('item', v::not(v::falsy())->stringType())
                ->key('size', v::not(v::falsy())->stringType())
                ->key('price', v::numericVal())
                ->assert($data);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $this->capsule->table('menu')->insert([
            'category_id' => $category_id,
            'sub_category' => $data['sub_category'],
            'item' => $data['item'],
            'size' => $data['size'],
            'price' => $data['price'],
        ]);

        header('Location: /admin/categories/edit/' . $category_id . '/menu');
        exit;
    }

    public function updateMenu(int $category_id) : void
    {
        try {
            v::key('items', v::not(v::falsy())->arrayType()
                ->keyOptional('*', v::not(v::falsy())->arrayType()
                    ->key('sub_category', v::not(v::falsy())->stringType())
                    ->key('item', v::not(v::falsy())->stringType())
                    ->key('size', v::not(v::falsy())->stringType())
                    ->key('price', v::not(v::falsy())->floatType())
                ))
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        foreach ($_POST['items'] as $key => $item) {
            $this->capsule->table('menu')->where('id', $key)->update([
                'sub_category' => $item['sub_category'],
                'item' => $item['item'],
                'size' => $item['size'],
                'price' => $item['price']
            ]);
        }
        header('Location: /admin/categories/edit/' . $category_id . '/menu');
        exit;
    }

    public function deleteMenuItem(int $category_id, int $item_id) : void
    {
        $item = $this->capsule->table('menu')
            ->where('id', $item_id)
            ->where('category_id', $category_id)
            ->first();
        if (!$item) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }

        $this->capsule->table('menu')
            ->where('id', $item_id)
            ->where('category_id', $category_id)
            ->update(['active' => false]);

        header('Location: /admin/categories/edit/' . $category_id . '/menu');
        exit;
    }

    public function editCategoryExtras(int $category_id) : void
    {
        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }
        $extras = $this->capsule->table('extras')->where('category_id', $category_id)->where('active', true)->get();
        $this->smarty->assign([
            'extras' => $extras,
            'category' => $category,
            'category_id' => $category_id,
        ]);
        $this->smarty->display('admin/editExtras.tpl');
    }

    public function updateExtras(int $category_id) : void
    {
        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }

        if (empty($_POST['extras'])) {
            header('Location: /admin/categories/edit/' . $category_id . '/extras');
            exit;
        }

        try {
            v::key('extras', v::arrayType()
                ->keyOptional('*', v::arrayType()
                    ->key('name', v::not(v::falsy())->stringType())
                    ->key('slug', v::not(v::falsy())->stringType())
                ))
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        foreach ($_POST['extras'] as $key => $extra) {
            $this->capsule->table('extras')
                ->where('id', $key)
                ->where('category_id', $category_id)
                ->update([
                    'name' => $extra['name'],
                    'slug' => $extra['slug'],
                    'active' => isset($extra['active']) ? 1 : 0,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
        }
        header('Location: /admin/categories/edit/' . $category_id . '/extras');
        exit;
    }

    public function deleteExtra(int $category_id, int $extra_id) : void
    {
        $extra = $this->capsule->table('extras')
            ->where('id', $extra_id)
            ->where('category_id', $category_id)
            ->first();
        if (!$extra) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }

        $this->capsule->table('extras')
            ->where('id', $extra_id)
            ->where('category_id', $category_id)
            ->update([
                'active' => false,
                'updated_at' => date('Y-m-d H:i:s'),
            ]);

        header('Location: /admin/categories/edit/' . $category_id . '/extras');
        exit;
    }

    public function createExtra(int $category_id) : void
    {
        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }
        $this->smarty->assign('category', $category);
        $this->smarty->display('admin/createExtra.tpl');
    }

    public function storeExtra(int $category_id) : void
    {
        $category = $this->capsule->table('categories')->where('id', $category_id)->first();
        if (!$category) {
            http_response_code(404);
            $this->smarty->display('error/404.tpl');
            exit;
        }

        $data = $_POST;
        $data['active'] = isset($data['active']) ? 1 : 0;
        if (empty($data['slug']) && !empty($data['name'])) {
            $data['slug'] = $this->slugify($data['name']);
        }

        try {
            v::key('name', v::not(v::falsy())->stringType())
                ->key('slug', v::not(v::falsy())->stringType())
                ->key('active', v::in([0, 1]))
                ->assert($data);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        $this->capsule->table('extras')->insert([
            'category_id' => $category_id,
            'name' => $data['name'],
            'slug' => $data['slug'],
            'active' => $data['active'],
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        header('Location: /admin/categories/edit/' . $category_id . '/extras');
        exit;
    }

    private function slugify(string $value): string
    {
        $slug = strtolower(trim($value));
        $slug = preg_replace('/[^a-z0-9]+/i', '-', $slug) ?? '';
        $slug = trim($slug, '-');

        return $slug !== '' ? $slug : 'item';
    }
}