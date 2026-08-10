{extends file="layout.tpl"}

{block name="title"}Bestellungen - SEC-Mjam{/block}

{block name="content"}
    <div class="row">
        <div class="col-xs-12">
            {if $open_orders == NULL}
                Keine offenen Bestellungen<br>
                <br>                
            {else}
                <form action="/orders/add" method="post">
                    <div class="row">
                        <div class="col-md-4 col-xs-12">
                            <select class="form-control" name="order_uuid" onchange="this.form.submit()">
                                <option></option>
                                {foreach $open_orders as $order}
                                    <option value="{$order->uuid}">{$order->created_at} - {$order->categoryName} - {$order->ownerUser|capitalize}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </form>
            {/if}                
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <a href="/orders/new" class="btn btn-primary">Neue Bestellung anlegen</a>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12">
            Meine letzten 10 Abgeschlossenen Bestellungen:<br><br>
            {foreach item=order from=$last_orders}
                <a href='/orders/show/{$order->uuid}'>{$order->created_at} - {$order->categoryName|capitalize}</a><br>
            {/foreach}
        </div>
    </div>
{/block}