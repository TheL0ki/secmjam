{extends file="layout.tpl"}

{block name=title}SEC-Mjam - Menü{/block}

{block name="content"}
    <div class="row">
        <div class="col-xs-12" style="margin-top: 20px;">
            <form action="/orders/new" method="post">
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
                                {if $item->sub_category != 'Beilage'}
                                    <tr>
                                        <td>{$item->sub_category}</td>
                                        <td>{$item->item}</td>
                                        <td>{$item->size}</td>
                                        <td>
                                            {if $item->multiple_extras == 0}
                                                <select size="1" name="sauce[{$item->id}][]">
                                                    <option value="false"></option>
                                                    {foreach $extras as $extra}
                                                        <option value="{$extra->id}">{$extra->name}</option>
                                                    {/foreach}
                                                </select>
                                            {else}
                                                {foreach $extras as $extra}
                                                    <input type="checkbox" name="sauce[{$item->id}][]" value="{$extra->id}">{$extra->name}<br>
                                                {/foreach}
                                            {/if}
                                        </td>
                                        <td>€ {$item->price|number_format:2:',':'.'}</td>
                                        <td><input type="number" name="amount[{$item->id}]" min="1" max="5" value="1"></td>
                                        <td><input type="checkbox" value="{$item->id}" name="foodid[]"></td>
                                    </tr>
                                {/if}
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                <input type="hidden" value="{$sessionUserID}" name="userid">
                <input type="hidden" value="{$singleOrder.delivery_number}" name="dn">
                <input type="hidden" value="{$singleOrder.owner}" name="owner">
                <input type="hidden" value="{$category}" name="category">
                <input class="btn btn-primary" type="submit" value="Bestellen">
            </form>
        </div>
    </div>
    {if $category == "kebap" OR $category == "schnitzel"}
        <script type="text/javascript">
            $(document).ready(function () {
                $('td:nth-child(3),th:nth-child(3)').hide();
            })
        </script>
    {/if}
{/block}