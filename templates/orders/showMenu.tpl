{extends file="layout.tpl"}

{block name=title}SEC-Mjam - Menü{/block}

{block name="content"}
    <div class="row">
        <div class="col-xs-12" style="margin-top: 20px;">
            <form action="/orders" method="post">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Sub Cat</th>
                                <th>Item</th>
                                <th>Size</th>
                                <th>Extras</th>
                                <th>Price</th>
                                <th>Amount</th>
                                <th>Check</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $menu as $item}
                                <tr>
                                    <td>{$item->sub_category}</td>
                                    <td>{$item->item}</td>
                                    <td>{$item->size}</td>
                                    <td>
                                        {if $item->multiple_extras == 0}
                                            <select size="1" name="item[{$item->id}][extras][]">
                                                <option value="false"></option>
                                                {foreach $extras as $extra}
                                                    <option value="{$extra->id}">{$extra->name}</option>
                                                {/foreach}
                                            </select>
                                        {else}
                                            {foreach $extras as $extra}
                                                <input type="checkbox" name="item[{$item->id}][extras][]" value="{$extra->id}">{$extra->name}<br>
                                            {/foreach}
                                        {/if}
                                    </td>
                                    <td>€ {$item->price|number_format:2:',':'.'}</td>
                                    <td><input type="number" name="item[{$item->id}][amount]" min="1" max="5" value="1"></td>
                                    <td><input type="checkbox" value="{$item->id}" name="item[{$item->id}][checked]"></td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                <input type="hidden" value="{$category_id}" name="category_id">
                <input type="hidden" value="{$order->uuid|default:''}" name="order_uuid">
                <input class="btn btn-primary" type="submit" value="Bestellen">
            </form>
        </div>
    </div>
{/block}