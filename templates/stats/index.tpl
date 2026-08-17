{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Stats{/block}

{block name=content}
    <div class="row">
        <div class="col-md-6">
            <table class="table table-striped table-bordered">
                <tr>
                    <th colspan="2"><b>Top 5 Bestellungen</b></th>
                </tr>
                {assign var='counter' value=2}
                {foreach item=item from=$topFiveItems}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td style="width: 10%;">{$item->item_count}x</td><td> {$item->sub_category|capitalize} {$item->item} {$item->size|capitalize}</td>
                    </tr>
                    {assign var='counter' value=$counter+1}
                {/foreach}
            </table>
        </div>
        <div class="col-md-6">
            <table class="table table-striped table-bordered">
                <tr>
                    <th colspan="2"><b>Persönliche Top 5 Bestellungen</b></th>
                </tr>
                {assign var='counter' value=2}
                {foreach item=item from=$topFiveItemsByUser}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td style="width: 10%;">{$item->item_count}x</td><td> {$item->sub_category|capitalize} {$item->item} {$item->size|capitalize}</td>
                    </tr>
                    {assign var='counter' value=$counter+1}
                {/foreach}
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <table class="table table-striped table-bordered">
                <tr>
                    <th colspan="2">Top Kategorien</th>
                </tr>
                {assign var='counter' value=2}
                {foreach item=cat from=$topCategories}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td style="width: 10%;">{$cat->item_count}x</td>
                    <td>{$cat->name|capitalize}</td>
                    </tr>
                    {assign var='counter' value=$counter+1}
                {/foreach}
            </table>
        </div>
        <div class="col-md-6">
            <table class="table table-striped table-bordered">
                <tr>
                    <th colspan="2">Persönliche Top Kategorien</th>
                </tr>
                {assign var='counter' value=2}
                {foreach item=cat from=$topCategoriesByUser}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td style="width: 10%;">{$cat->item_count}x</td>
                    <td>{$cat->name|capitalize}</td>
                    </tr>
                    {assign var='counter' value=$counter+1}
                {/foreach}
            </table>
        </div>
    </div>
{/block}
