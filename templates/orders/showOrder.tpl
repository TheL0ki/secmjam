{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Bestellung{/block}

{block name=content}
    <div class="row" style="margin-bottom: 20px;">
        <div class="col-md-12">
            <span style="font-size: 24px;">
                {if $deliveries.0.locked == 1}
                    <span class="glyphicon glyphicon-lock"></span>
                {/if}
                Bestellungen für den {$order->created_at}
            </span>
            <br>
            Owner: {$order->owner_uuid}<br>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive">
                <table id="item" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Bestellung</th>
                            <th>Größe</th>
                            <th>Extras</th>
                            <th>Preis</th>
                            <th>Optionen</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach item=orderItem from=$orderItems}
                            <tr>
                                <td>{$orderItem->item_name}</td>
                                <td>{$orderItem->amount}</td>
                                <td>{$orderItem->size}</td>
                                <td>
                                    {foreach item=extra from=$extras}
                                        {$extra->extraName}
                                    {/foreach}
                                </td>
                                <td>€ {$orderItem->price|number_format:2:",":"."}</td>
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
                            {$item.count}x {$item.item}
                            {assign var=totalItemsCount value=$totalItemsCount+$item.count}
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
                {foreach item=row from=$total}
                    <tr>
                        <td>
                            {$row.fullname}
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
    {if $ownerID == $sessionUser}
        {if $deliveries.0.status != 1}
            <div class="row">
                <div class="col-xs-12">
                    {if $deliveries.0.status != 1}
                        {if $deliveries.0.locked == 1}
                            <a href="overview.php?dn={$dn}&do=unlock" class="btn btn-primary">Bestellung entsperren</a>
                        {else}
                            <a href="overview.php?dn={$dn}&do=lock" class="btn btn-primary">Bestellung sperren</a>
                        {/if}
                    {/if}
                </div>
            </div>
            <br>
            <form action="overview.php?dn={$dn}&do=close" method="post">
                <div class="row">
                    <div class="col-md-12">
                        {for $i=0 to 9}
                            <div class="row">
                                {for $c=0 to $to}
                                    {assign var="add" value=$c|cat:"0"}
                                    {assign var="key" value=$i+$add}
                                    {if array_key_exists($key, $helperArray)}
                                        <div class="col-md-{$col} col-xs-12">
                                            <div class="checkbox" style="margin-top: 3px; margin-bottom: 3px;">
                                                <label>
                                                    <input type="checkbox" name="helper[]" value="{$helperArray.$key.id}" {if $helperArray.$key.id == $ownerID}disabled{/if}>
                                                    {$helperArray.$key.firstname} {$helperArray.$key.lastname}
                                                </label>
                                            </div>
                                        </div>
                                    {else}
                                        <div class="col-md-{$col} col-xs-12"></div>
                                    {/if}
                                {/for}
                            </div>
                        {/for}
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-xs-12">
                        <input type="hidden" name="category" value="{$category}">
                        <input type="submit" class="btn btn-danger" value="Bestellung abschließen">
                    </div>
                </div>
            </form>
        {/if}
    {/if}
{/block}
