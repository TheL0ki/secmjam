{extends file="layout.tpl"}

{block name="title"}Home - SEC-Mjam{/block}

{block name="content"}


        <div class="row mt-3">
            <div class="col">
                <div class="card">
                    <div class="card-header">
                        <span>Übersicht</span>
                    </div>
                    <div class="card-body">
                        <p style="padding-left:25px; padding-right: 25px;">
                            Punktestand: {$points}
                        </p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-header">
                        <span>Todays Lunch?</span>
                    </div>
                    <div class="card-body">
                        <div id="poll" style="padding-left: 25px; padding-right: 25px;">
                            {if $hasVoted}
                                {include 'partials/voteBlock.tpl'}
                            {elseif !$lunchChoices}
                                <p class="mb-0 text-muted">Keine Kategorien vorhanden.</p>
                            {else}
                                <form action="/vote" method="post">
                                    {foreach $lunchChoices as $slug => $label}
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="choice" id="lunch-{$slug}" value="{$slug}" required onchange="this.form.submit()">
                                            <label class="form-check-label" for="lunch-{$slug}">{$label}</label>
                                        </div>
                                    {/foreach}
                                    <noscript>
                                        <button type="submit" class="btn btn-sm btn-primary mt-2">Abstimmen</button>
                                    </noscript>
                                </form>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-3">
            <div class="col">
                <div class="card" style="overflow-y:scroll; max-height: 50vh;">
                    <div class="card-header sticky-top bg-light">
                        <span>Changelog</span>
                    </div>
                    <div class="card-body">
                        {include 'partials/changelog.tpl'}
                    </div>
                </div>
            </div>
        </div>
    
{/block}
