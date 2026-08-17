{extends file='layout.tpl'}

{block name='title'}
    SEC-Mjam - Übersicht
{/block}

{block name='content'}
    <h1>Bestellübersicht</h1>
    <div class="row">
        <div class="col-md-6">
            <p>Meine letzten 10 Bestellungen:</p>
            {foreach $last_orders as $order}
                <a href='/orders/show/{$order->order_uuid}'>{$order->created_at} - {$order->categoryName|capitalize}</a><br>
            {/foreach}
        </div>
        <div class="col-md-6">
            <p>Meine letzten 10 gestarteten Bestellungen:</p>
            {foreach $last_orders_owner as $order}
                <a href='/orders/show/{$order->uuid}'>{$order->created_at} - {$order->categoryName|capitalize}</a><br>
            {/foreach}
        </div>
    </div>
{/block}