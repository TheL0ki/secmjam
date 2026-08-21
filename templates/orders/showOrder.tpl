{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Bestellung{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col">
            <span class="fs-4">
                {if $order->locked == 1}
                    <span class="bi bi-lock-fill"></span>
                {/if}
                Bestellungen vom {$order->created_at|date_format:"%d.%m.%Y %H:%M"}
            </span>
            <br>
            Owner: {$order->ownerUser|capitalize}<br>
        </div>        
        <div class="col">
            {if $order->locked == 0}
                <a href="/orders/{$order->uuid}/menu" class="btn btn-primary">Artikel hinzufügen</a>
            {/if}
        </div>
    </div>
    <div class="row mt-3">
        <div class="col">
            <div class="table-responsive-md">
                <table class="table table-striped table-bordered align-middle">
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
                                <td>{$orderItem->user|capitalize}</td>
                                <td>{$orderItem->sub_category} {$orderItem->item}</td>
                                <td>{$orderItem->amount}</td>
                                <td>{$orderItem->size}</td>
                                <td>
                                    {foreach item=extra from=$orderExtras[$orderItem->id]}
                                        {$extra|capitalize}
                                    {/foreach}
                                </td>
                                <td>€ {$orderItem->price|number_format:2:",":"."}</td>
                                <td>
                                    {if $order->open == 1
                                        && $order->locked == 0 
                                        && $orderItem->item_owner_uuid == $sessionUser 
                                        && $order->owner_uuid != $sessionUser
                                    }
                                        <form action="/orders/cancel-item" method="post">
                                            <input type="hidden" name="order_item_id" value="{$orderItem->id}">
                                            <input type="submit" class="btn btn-danger" value="Stornieren">
                                        </form>
                                    {/if}
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="row mt-3">
        <div class="col">
            <div class="card">
                <div class="card-header">
                    <span>Zusammenfassung</span>
                </div>
                <div class="card-body">
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
        </div>
        <div class="col">
            <table class="table table-striped table-bordered align-middle">
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
                        <strong>Summe:</strong>
                    </td>
                    <td>
                        <strong>€ {$totalSum|number_format:2:",":"."}</strong>
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
                        <a href="/orders/unlock/{$order->uuid}" class="btn btn-primary">Bestellung entsperren</a>
                    {else}
                        <a href="/orders/lock/{$order->uuid}" class="btn btn-primary">Bestellung sperren</a>
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
