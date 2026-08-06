{extends file="layout.tpl"}

{block name="title"}Menu - SEC-Mjam{/block}

{block name="content"}
    {if $page == 'save' AND $success == TRUE}
        <div class="row">
            <div class="col-md-12">
                <div class="alert alert-success">
                    <b>Bestellung erfolgreich gespeichert</b>, du wirst weitergeleitet.
                    <meta http-equiv="refresh" content="2; url=overview.php?dn={$dn}" />
                </div>
            </div>
        </div>
    {elseif $page == 'save' AND $error == TRUE}
        <div class="row">
            <div class="col-md-12">
                <div class="alert alert-error">
                    <b>Etwas ist schief gelaufen</b>, bitte versuche es <a href="menu.php">nocheinmal</a>.
                </div>
            </div>
        </div>
    {else}
        {if $orders == NULL}
            <div class="row">
                <div class="col-xs-12">
                    Keine offenen Bestellungen<br>
                    <br>
                    <a href="create_order.php" class="btn btn-primary">Neue Bestellung anlegen</a>
                </div>
            </div>
        {else}
            <div class="row">
                <div class="col-xs-12">
                    <form action="menu.php?page=menu" method="post">
                        <div class="row">
                            <div class="col-md-4 col-xs-12">
                                <select class="form-control" name="dn" onchange="this.form.submit()">
                                    <option></option>
                                {foreach item=order from=$orders}
                                    {if $order.locked != 1}
                                        <option value="{$order.dn}">{$order.date_output} - {$order.category|capitalize} - {$order.ownerFullname}</option>
                                    {/if}
                                {/foreach}
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        {/if}
        {if $page == "menu"}
            <div class="row">
                <div class="col-xs-12" style="margin-top: 20px;">
                    <form action="menu.php?page=save" method="post">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    {if $category != 'grill'}
                                        <th>Sub Cat</th>
                                    {/if}
                                    <th>Item</th>
                                    <th>Size</th>
                                    <th>Extras</th>
                                    <th>Price</th>
                                    <th>Amount</th>
                                    <th>Check</th>
                                </tr>
                                </thead>
                                <tbody>
                                {foreach item=item from=$menu}
                                    {if $item.sub_category != 'Beilage'}
                                        <tr>
                                            {if $category != 'grill'}
                                                <td>{$item.sub_category}</td>
                                            {/if}
                                            <td>{$item.item}</td>
                                            <td>{$item.size}</td>
                                            <td>
                                                {if $category == 'noodles'}
                                                    <select size="1" name="sauce[{$item.id}][]">
                                                        <option value="false"></option>
                                                        <option value="Ohne">Ohne</option>
                                                        <option value="Soja">Soja</option>
                                                        <option value="Süß-Sauer">Süß-Sauer</option>
                                                        <option value="Teriyaki">Teriyaki</option>
                                                        <option value="Scharf">Scharf</option>
                                                    </select>
                                                {elseif $category == 'schnitzel' AND $item.sub_category != 'Beilage'}
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="ketchup">Ketchup<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="mayo">Mayo<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="senf">Senf<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="salat">Salat<br>
                                                {elseif $category == 'kebap'}
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="salat">Ohne Salat<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="zwiebel">Ohne Zwiebel<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="tomate">Ohne Tomate<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="sauce">Ohne Sauce<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="scharf">Ohne Scharf<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="rotkraut">Ohne Rotkraut<br>
                                                {else}
                                                    <input type="hidden" value="-" name="sauce[{$item.id}][]"> -
                                                {/if}
                                            </td>
                                            <td>€ {$item.price|number_format:2:',':'.'}</td>
                                            <td><input type="number" name="amount[{$item.id}]" min="1" max="5" value="1"></td>
                                            <td><input type="checkbox" value="{$item.id}" name="foodid[]"></td>
                                        </tr>
                                    {/if}
                                {/foreach}
                                {foreach item=item from=$menu}
                                    {if $item.sub_category == 'Beilage'}
                                        <tr>
                                            <td>{$item.sub_category}</td>
                                            <td>{$item.item}</td>
                                            <td>{$item.size}</td>
                                            <td>
                                                {if $category == 'noodles'}
                                                    <select size="1" name="sauce[{$item.id}][]">
                                                        <option value="false"></option>
                                                        <option value="Ohne">Ohne</option>
                                                        <option value="Soja">Soja</option>
                                                        <option value="Süß-Sauer">Süß-Sauer</option>
                                                        <option value="Teriyaki">Teriyaki</option>
                                                        <option value="Scharf">Scharf</option>
                                                    </select>
                                                {elseif $category == 'schnitzel' AND $item.sub_category != 'Beilage'}
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="ketchup">Ketchup<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="mayo">Mayo<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="senf">Senf<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="salat">Salat<br>
                                                {elseif $category == 'kebap'}
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="salat">Ohne Salat<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="zwiebel">Ohne Zwiebel<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="tomate">Ohne Tomate<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="sauce">Ohne Sauce<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="scharf">Ohne Scharf<br>
                                                    <input type="checkbox" name="sauce[{$item.id}][]" value="rotkraut">Ohne Rotkraut<br>
                                                {else}
                                                    <input type="hidden" value="-" name="sauce[{$item.id}][]"> -
                                                {/if}
                                            </td>
                                            <td>€ {$item.price|number_format:2:',':'.'}</td>
                                            <td><input type="number" name="amount[{$item.id}]" min="1" max="5" value="1"></td>
                                            <td><input type="checkbox" value="{$item.id}" name="foodid[]"></td>
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
        {/if}
    {/if}
{/block}