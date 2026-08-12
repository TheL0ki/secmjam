{extends file="layout.tpl"}

{block name="title"}Bestellungen - SEC-Mjam{/block}

{block name="content"}
    <div class="row">
        <div class="col-xs-6">
            {if $open_orders == NULL}
                Keine offenen Bestellungen<br>
                <br>
            {else}
                <p>Laufende Bestellungen:</p>
                {foreach $open_orders as $order}
                    {if $order->locked == 1}
                        <span class="glyphicon glyphicon-lock"></span>
                    {/if}
                    <a href='/orders/show/{$order->uuid}'>{$order->created_at} - {$order->categoryName|capitalize}</a><br>
                {/foreach}
            {/if}
        </div>
        <div class="col-xs-6">
            <a href="/orders/new" class="btn btn-primary">Neue Bestellung anlegen</a>
        </div>
    </div>
{/block}