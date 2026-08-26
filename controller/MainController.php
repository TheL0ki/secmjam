<?php

namespace App\Controllers;

use Illuminate\Database\QueryException;
use Respect\Validation\Exceptions\ValidationException;
use Respect\Validation\ValidatorBuilder as v;

class MainController
{
    public function __construct(
        private $smarty,
        private $capsule
    ) {}

    public function index()
    {
        $this->smarty->assign('points', $this->getPoints());
        $this->assignLunchPoll();
        $this->smarty->display('main.tpl');
    }

    public function vote()
    {
        $choices = $this->lunchChoices();

        try {
            v::key('choice', v::not(v::falsy())->stringType()->in(array_keys($choices)))
                ->assert($_POST);
        } catch (ValidationException $e) {
            echo 'Error: ' . $e->getMessage();
            die;
        }

        try {
            $this->capsule->table('lunch_votes')->insert([
                'user_uuid' => $_SESSION['user']->uuid,
                'choice' => $_POST['choice'],
                'vote_date' => $this->today(),
            ]);
        } catch (QueryException $e) {
            if ((int) ($e->errorInfo[1] ?? 0) !== 1062) {
                throw $e;
            }
        }

        header('Location: /');
        exit;
    }

    public function getPoints()
    {
        $totalPoints = 0;
        $orderPoints = $this->capsule->table('orders')
            ->join('categories', 'orders.category_id', '=', 'categories.id')
            ->leftJoin('order_items', 'orders.uuid', '=', 'order_items.order_uuid')
            ->where('owner_uuid', $_SESSION['user']->uuid)
            ->where('orders.open', '=', 0)
            ->selectRaw('COALESCE(SUM(categories.points * order_items.amount), 0) as order_points')
            ->groupBy('orders.owner_uuid')
            ->first();

        $helperPoints = $this->capsule->table('helper')
            ->join('orders', 'helper.order_uuid', '=', 'orders.uuid')
            ->join('categories', 'orders.category_id', '=', 'categories.id')
            ->leftJoin('order_items', 'orders.uuid', '=', 'order_items.order_uuid')
            ->where('user_uuid', $_SESSION['user']->uuid)
            ->where('orders.open', '=', 0)
            ->selectRaw('ROUND(COALESCE(SUM(categories.points * order_items.amount), 0) / 2, 0) as helper_points')
            ->first();

        if($orderPoints == null) {
            $totalPoints += 0;
        } else {
            $totalPoints += $orderPoints->order_points;
        }
        if($helperPoints == null) {
            $totalPoints += 0;
        } else {
            $totalPoints += $helperPoints->helper_points;
        }

        return $totalPoints;
    }

    private function assignLunchPoll(): void
    {
        $today = $this->today();
        $userUuid = $_SESSION['user']->uuid;
        $choices = $this->lunchChoices();

        $existing = $this->capsule->table('lunch_votes')
            ->where('user_uuid', $userUuid)
            ->where('vote_date', $today)
            ->first();

        $rows = $this->capsule->table('lunch_votes')
            ->select('choice')
            ->selectRaw('COUNT(*) as votes')
            ->where('vote_date', $today)
            ->groupBy('choice')
            ->get();

        $counts = array_fill_keys(array_keys($choices), 0);
        foreach ($rows as $row) {
            if (array_key_exists($row->choice, $counts)) {
                $counts[$row->choice] = (int) $row->votes;
            }
        }

        $total = array_sum($counts);
        $percent = [];
        foreach ($counts as $slug => $count) {
            $percent[$slug] = $total > 0 ? (int) round($count * 100 / $total) : 0;
        }

        $this->smarty->assign([
            'hasVoted' => $existing !== null,
            'lunchChoices' => $choices,
            'lunchCounts' => $counts,
            'lunchPercent' => $percent,
            'lunchTotal' => $total,
        ]);
    }

    private function lunchChoices(): array
    {
        return $this->capsule->table('categories')
            ->where('active', 1)
            ->orderBy('name')
            ->pluck('name', 'slug')
            ->all();
    }

    private function today(): string
    {
        return (new \DateTimeImmutable('now', $this->timezone()))->format('Y-m-d');
    }

    private function timezone(): \DateTimeZone
    {
        $name = $_ENV['APP_TIMEZONE'] ?? '';
        if ($name === '') {
            throw new \RuntimeException('APP_TIMEZONE is not set in the environment.');
        }

        return new \DateTimeZone($name);
    }
}
