<p class="text-muted mb-2">{$lunchTotal} {if $lunchTotal == 1}Stimme{else}Stimmen{/if} heute</p>
{foreach $lunchChoices as $slug => $label}
    <div class="mb-2">
        <div class="d-flex justify-content-between">
            <span>{$label}</span>
            <span class="text-muted">{$lunchCounts[$slug]} ({$lunchPercent[$slug]}%)</span>
        </div>
        <div class="progress">
            <div class="progress-bar" role="progressbar" aria-valuenow="{$lunchPercent[$slug]}" aria-valuemin="0" aria-valuemax="100" style="width: {$lunchPercent[$slug]}%; min-width: 2em;">
                {$lunchPercent[$slug]}%
            </div>
        </div>
    </div>
{/foreach}
