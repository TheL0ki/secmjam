{extends file="layout.tpl"}

{block name="title"}Home - SEC-Mjam{/block}

{block name="content"}
    <div class="row">
        <div class="col-md-6">
            <div class="well well-sm">
                <span style="font-size: 18px;">Übersicht</span>
                <p style="padding-left:25px; padding-right: 25px;">
                    {*Guthaben: € 0,00*}
                    Punktestand: {$points}
                </p>
            </div>
        </div>
        {nocache}
        <div class="col-md-6">
            <div class="well well-sm">
                <span style="font-size: 18px;">Todays Lunch?</span>
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
        {/nocache}
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="well" style="overflow-y:scroll; max-height: 45vh;">
                {include 'partials/changelog.tpl'}
            </div>
        </div>
    </div>
{/block}