{extends 'layout.tpl'}

{block name=title}Highscore - SEC-Mjam{/block}

{block name=content}
    <style>
        /* Bootstrap 5 applies table backgrounds on cells (--bs-table-bg / box-shadow), not the <tr>. */
        .table tbody tr.first,
        .table tbody tr.second,
        .table tbody tr.third {
            --bs-table-bg: transparent;
            --bs-table-bg-type: transparent;
            --bs-table-accent-bg: transparent;
        }

        .table tbody tr.first > *,
        .table tbody tr.second > *,
        .table tbody tr.third > * {
            background-color: transparent;
            box-shadow: none;
        }

        .table tbody tr.first {
            background: linear-gradient(to right, #f0e68c, #ffffff);
        }

        .table tbody tr.second {
            background: linear-gradient(to right, #c0c0c0, #ffffff);
        }

        .table tbody tr.third {
            background: linear-gradient(to right, #d7995b, #ffffff);
        }
    </style>
    {nocache}
    <div class="row mt-3">
        <div class="col">
            <div class="table-responsive" style="max-height: 85vh; overflow-y: scroll;">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Platz</th>
                            <th>User</th>
                            <th>Punkte</th>
                            <th>Bestellungen</th>
                            <th>Quote</th>
                        </tr>
                    </thead>
                    <tbody>
                        {assign var=i value=1}
                        {foreach item=user from=$highscore}
                            <tr class="{if $i == '1'}
                                    first
                                {elseif $i == '2'}
                                    second
                                {elseif $i == '3'}
                                    third
                                {/if}">
                                <td>#{$i}</td>
                                <td>{$user.user->firstname} {$user.user->lastname}</td>
                                <td>{$user.total_points}</td>
                                <td>{$user.totalOrders}</td>
                                <td>{$user.quote}</td>
                            </tr>
                            {assign var=i value=$i+1}
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    {/nocache}
{/block}
