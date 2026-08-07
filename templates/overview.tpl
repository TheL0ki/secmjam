{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Übersicht{/block}

{block name=content}
    {nocache}
    {if $openOrders != NULL}
        {foreach item=order from=$openOrders}
            <a href="overview.php?dn={$order.dn}">
                {if $order.locked == 1}
                    <span class="glyphicon glyphicon-lock"></span>
                {/if}
                {$order.date_output} - {$order.category|ucfirst} - {$order.ownerFullname}
            </a><br>
        {/foreach}
    {/if}
    <br>
    <a href="create_order.php" class="btn btn-primary">Neue Bestellung anlegen</a>
    <br>
    <br>
    Meine letzten 10 Abgeschlossenen Bestellungen:<br><br>
    {foreach item=order from=$orders}
        <a href='overview.php?dn={$order.dn}'>{$order.date} - {$order.category|ucfirst}</a><br>
    {/foreach}
    {/nocache}
{/block}
