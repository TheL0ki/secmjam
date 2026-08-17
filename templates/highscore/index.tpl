{extends 'layout.tpl'}

{block name=title}SEC-Mjam - Highscore{/block}

{block name=content}
    <style>
        .first {
            background: #f0e68c;
            background: -webkit-linear-gradient(left, #f0e68c, #ffffff);
            background: -moz-linear-gradient(left, #f0e68c, #ffffff);
            background: -ms-linear-gradient(left, #f0e68c, #ffffff);
            background: -o-linear-gradient(left, #f0e68c, #ffffff);
            background: linear-gradient(to right, #f0e68c, #ffffff);
        }

        .second {
            background: #c0c0c0;
            background:-webkit-linear-gradient(left, #c0c0c0, #ffffff);
            background: -moz-linear-gradient(left, #c0c0c0, #ffffff);
            background: -ms-linear-gradient(left, #c0c0c0, #ffffff);
            background: -o-linear-gradient(left, #c0c0c0, #ffffff);
            background: linear-gradient(to right, #c0c0c0, #ffffff);
        }

        .third {
            background: #d7995b;
            background:-webkit-linear-gradient(left, #d7995b, #ffffff);
            background: -moz-linear-gradient(left, #d7995b, #ffffff);
            background: -ms-linear-gradient(left, #d7995b, #ffffff);
            background: -o-linear-gradient(left, #d7995b, #ffffff);
            background: linear-gradient(to right, #d7995b, #ffffff);
        }
    </style>
    {nocache}
    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive">
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
