{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Neue Bestellung{/block}
    
{block name=content}
    {if $page == 'save'}
        <div class="row">
            <div class="col-xs-12">
                <div class="alert alert-success">
                    <b>Bestellung erfolgreich gespeichert</b>, du wirst weitergeleitet.
                </div>
            </div>
        </div>
    {else}
        <div class="row">
            <div class="col-md-4 col-xs-12">
                <form action="/menu/showMenu" method="get">
                    <select class="form-control" name="category" onchange="this.form.submit()">
                        <option></option>
                        {foreach item=category from=$categories}
                            <option value="{$category->id}">{$category->name}</option>
                        {/foreach}
                    </select>
                </form>
            </div>
        </div>
        {if $page == "menu"}
            <form action="create_order.php?page=save" method="post">
                <div class="row" style="margin-top: 20px;">
                    <div class="col-xs-12">
                        <input type="checkbox" name="check" value="1">
                        Bestellung möglich bis: <input name="autolock" type="time" step="900" value="00:00">
                    </div>
                    <div class="col-xs-12" style="margin-top: 5px;">
                        <input type="checkbox" name="mail_check" value="1" checked>
                        Infomail aussenden?
                    </div>
                </div>
                {*<div class="row">
                    <div class='col-xs-12'>
                        Dein Guthaben € {$userBalance|number_format:2:',':'.'}
                    </div>
                </div>*}
                <div class="row" style="margin-top: 20px;">
                    <div class="col-xs-12">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        {if $category != 'grill'}
                                            <th>Sub Cat</th>
                                        {/if}
                                        <th>Item</th>
                                        {if $category != 'grill' AND $category != 'schnitzel' AND $category != 'kebap'}
                                            <th>Size</th>
                                        {/if}
                                        {if $category != 'grill'}
                                            <th>Extras</th>
                                        {/if}
                                        <th>Price</th>
                                        <th>Amount</th>
                                        <th>Check</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach item=item from=$menu}
                                        <tr>
                                            {if $category != 'grill'}
                                                <td>{$item.sub_category}</td>
                                            {/if}
                                            <td>{$item.item}</td>
                                            {if $category != 'grill' AND $category != 'schnitzel' AND $category != 'kebap'}
                                                <td>{$item.size}</td>
                                            {/if}
                                            {if $category != 'grill'}
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
                                                {elseif $category == 'schnitzel'}
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
                                            {/if}
                                            <td>€ {$item.price|number_format:2:',':'.'}</td>
                                            <td><input type="number" name="amount[{$item.id}]" min="1" max="5" value="1"></td>
                                            <td><input type="checkbox" value="{$item.id}" name="foodid[]"></td>
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <input type="hidden" value="{$owner}" name="userid">
                <input type="hidden" value="{$dn}" name="dn">
                <input type="hidden" value="{$owner}" name="owner">
                <input type="hidden" value="{$category}" name="category">
                <input type="hidden" value="1" name="new">
                <input class="btn btn-primary" type="submit" value="Bestellen">
            </form>
        {/if}
    {/if}
{/block}