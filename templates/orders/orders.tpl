{extends file="layout.tpl"}

{block name="title"}Bestellungen - SEC-Mjam{/block}

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
                    <a href="/orders/new" class="btn btn-primary">Neue Bestellung anlegen</a>
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
    {/if}
{/block}