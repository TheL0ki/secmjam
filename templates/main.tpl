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
                            {if $voteStatus == '1'}
                                {include 'voteBlock.tpl'}
                            {else}
                                <form>
                                    <div class="radio">
                                        <label for="noodles">
                                            <input type="radio" value="1" onclick="getVote(this.value)">
                                            Noodles
                                        </label>
                                    </div>
                                    <div class="radio">
                                        <label for="pizza">
                                            <input type="radio" value="2" onclick="getVote(this.value)">
                                            Pizza
                                        </label>
                                    </div>
                                    <div class="radio">
                                        <label for="kebap">
                                            <input type="radio" value="3" onclick="getVote(this.value)">
                                            Kebap
                                        </label>
                                    </div>
                                    <div class="radio">
                                        <label for="schnitzel">
                                            <input type="radio" value="4" onclick="getVote(this.value)">
                                            Schnitzel
                                        </label>
                                    </div>
                                    <div class="radio">
                                        <label for="schnitzel">
                                            <input type="radio" value="5" onclick="getVote(this.value)">
                                            Grill
                                        </label>
                                    </div>
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