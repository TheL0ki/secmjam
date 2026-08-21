{extends file="layout.tpl"}

{block name="title"}Bestellungen - SEC-Mjam{/block}

{block name="content"}
    <div class="row mt-3">
        <div class="col">
            <div class="card">
                <div class="card-header">
                    <span>Laufende Bestellungen</span>
                </div>
                <div class="card-body">
                    {if $open_orders == NULL}
                        Keine offenen Bestellungen
                    {else}
                        {foreach $open_orders as $order}
                            {if $order->locked == 1}
                                <span class="glyphicon glyphicon-lock"></span>
                            {/if}
                            <a href='/orders/show/{$order->uuid}'>{$order->created_at} - {$order->categoryName|capitalize}</a><br>
                        {/foreach}
                    {/if}
                </div>
                <div class="card-footer">
                    <a href="/orders/new" class="btn btn-primary">Neue Bestellung anlegen</a>
                </div>
            </div>
        </div>
    </div>
{/block}