{extends file='layout.tpl'}

{block name='title'}
    Übersicht - SEC-Mjam
{/block}

{block name='content'}
    <div class="row mt-3">
        <div class="col">
            <div class="card">
                <div class="card-header">
                    <span>Meine letzten 10 Bestellungen</span>
                </div>
                <div class="card-body">
                    {foreach $last_orders as $order}
                        <a href='/orders/show/{$order->order_uuid}'>{$order->created_at} - {$order->categoryName|capitalize}</a><br>
                    {/foreach}
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card">
                <div class="card-header">
                    <span>Meine letzten 10 gestarteten Bestellungen</span>
                </div>
                <div class="card-body">
                    {foreach $last_orders_owner as $order}
                        <a href='/orders/show/{$order->order_uuid}'>{$order->created_at} - {$order->categoryName|capitalize}</a><br>
                    {/foreach}
                </div>
            </div>
        </div>
    </div>
{/block}