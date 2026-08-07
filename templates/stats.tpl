{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Stats{/block}

{block name=content}
    {nocache}
    <div class="row">
        <div class="col-md-6">
            <table class="table table-striped table-bordered">
                <tr>
                    <th colspan="2" align="center"><b>Top 5 Bestellungen</b></th>
                </tr>
                {assign var='counter' value=2}
                {foreach item=item from=$count_arr}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td align="center" style="width: 10%;">{$item.count}x</td><td>{$item.item}</td>
                    </tr>
                    {assign var='counter' value=$counter+1}
                {/foreach}
            </table>
        </div>
        <div class="col-md-6">
            <table class="table table-striped table-bordered">
                <tr>
                    <th colspan="2" align="center"><b>Persönliche Top 5 Bestellungen</b></th>
                </tr>
                {assign var='counter' value=2}
                {foreach item=item from=$count_arr_pers}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td align="center" style="width: 10%;">{$item.count}x</td><td>{$item.item}</td>
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
                {foreach item=cat from=$cat_arr}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td align="center" style="width: 10%;">{$cat.count}x</td>
                    <td>{$cat.category|ucfirst}</td>
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
                {foreach item=cat from=$cat_arr_pers}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td align="center" style="width: 10%;">{$cat.count}x</td>
                    <td>{$cat.category|ucfirst}</td>
                    </tr>
                    {assign var='counter' value=$counter+1}
                {/foreach}
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-striped table-bordered">
                <tr>
                    <th colspan="3">Top 3 Bestellungen in einem einzigen Monat</th>
                </tr>
                {assign var='counter' value=2}
                {foreach item=orderer from=$orderer_arr}
                    {if $counter % 2 == 0}
                        <tr class='one'>
                            {else}
                        <tr class='two'>
                    {/if}
                    <td align="center" style="width: 10%;">{$orderer.count}x</td>
                    <td>{$orderer.firstname} {$orderer.lastname}</td>
                    <td>{$orderer.output_date}</td>
                    </tr>
                    {assign var='counter' value=$counter+1}
                {/foreach}
            </table>
        </div>
    </div>
    {/nocache}
{/block}
