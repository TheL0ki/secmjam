{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Bestellung{/block}

{block name=content}
    <div class="row" style="margin-bottom: 20px;">
        <div class="col-md-6">
            <span style="font-size: 24px;">
                {if $order->locked == 1}
                    <span class="glyphicon glyphicon-lock"></span>
                {/if}
                Bestellungen vom {$order->created_at|date_format:"%d.%m.%Y %H:%M"}
            </span>
            <br>
            Owner: {$order->ownerUser|capitalize}<br>
        </div>        
        <div class="col-md-6">
            {if $order->locked == 0}
                <a href="/orders/{$order->uuid}/menu" class="btn btn-primary">Artikel hinzufügen</a>
            {/if}
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive">
                <table id="item" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Owner</th>
                            <th>Name</th>
                            <th>Menge</th>
                            <th>Größe</th>
                            <th>Extras</th>
                            <th>Preis</th>
                            <th>Optionen</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach item=orderItem from=$orderItems}
                            <tr>
                                <td>{$order->ownerUser|capitalize}</td>
                                <td>{$orderItem->sub_category} {$orderItem->item}</td>
                                <td>{$orderItem->amount}</td>
                                <td>{$orderItem->size}</td>
                                <td>
                                    {foreach item=extra from=$extras}
                                        {$extra->extraName}
                                    {/foreach}
                                </td>
                                <td>€ {$orderItem->price|number_format:2:",":"."}</td>
                                <td>Löschen</td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6" style="margin-top: 15px;">
            <div style="border: 3px solid darkred; border-radius: 15px; padding-left: 15px; padding-right: 15px;">
                <div class="row">
                    <div class="col-xs-12" style="text-align: center;">
                        <span style="font-size: 18px;">Zusammenfassung</span>
                    </div>
                </div>
                {assign var=totalItemsCount value=0}
                {foreach item=item from=$totalItems}
                    <div class="row">
                        <div class="col-xs-12">
                            {$item.amount}x {$item.item}
                            {assign var=totalItemsCount value=$totalItemsCount+$item.amount}
                        </div>
                    </div>
                {/foreach}
                    <div class="row" style="border-top: 3px double black">
                        <div class="col-sm-6">
                            Summe aller Bestellungen: {$totalItemsCount}
                        </div>
                        <div class="col-sm-6">
                            Punktewert: {$points}
                        </div>
                    </div>
            </div>
        </div>
        <div class="col-md-6" style="margin-top: 15px;">
            <table class="table table-striped">
                {foreach key=key item=row from=$total}
                    <tr>
                        <td>
                            {$key|capitalize}
                        </td>
                        <td>
                            € {$row.total|number_format:2:",":"."}
                        </td>
                    </tr>
                {/foreach}
                <tr style="border-top: 3px double black;">
                    <td>
                        Summe:
                    </td>
                    <td>
                        € {$totalSum|number_format:2:",":"."}
                    </td>
                </tr>
            </table>
        </div>
    </div>
    {if $order->owner_uuid == $sessionUser}
        {if $order->open == 1}
            <div class="row">
                <div class="col-xs-12">
                    {if $order->locked == 1}
                        <a href="/order/unlock/{$order->uuid}" class="btn btn-primary">Bestellung entsperren</a>
                    {else}
                        <a href="/order/lock/{$order->uuid}" class="btn btn-primary">Bestellung sperren</a>
                    {/if}
                </div>
            </div>
            <br>
            <form action="/orders/close" method="post">
                <div class="row">
                    <div class="col-md-12">
                        <p>Bitte Helfer auswählen:</p>
                        {foreach item=helper from=$helperArray}
                        <div class="checkbox" style="margin-top: 3px; margin-bottom: 3px;">
                            <label>
                                <input type="checkbox" name="helper[]" value="{$helper->uuid}" {if $helper->uuid == $order->owner_uuid}disabled{/if}>
                                {$helper->user|capitalize}
                            </label>
                        </div>
                        {/foreach}
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-xs-12">
                        <input type="hidden" name="order_uuid" value="{$order->uuid}">
                        <input type="submit" class="btn btn-danger" value="Bestellung abschließen">
                    </div>
                </div>
            </form>
        {/if}
    {/if}
{/block}
