param([Parameter(ValueFromRemainingArguments=$true)][string[]]$SourceIds)
foreach ($sourceId in $SourceIds) {
  $sourcePath = Join-Path 'data/raw' ('jail_followup_' + $sourceId + '_2026-09-26.html')
  $pageHtml = Get-Content -LiteralPath $sourcePath -Raw
  $pageText = [regex]::Replace($pageHtml, '(?is)<(script|style)\b[^>]*>.*?</\1>', '')
  $pageText = [regex]::Replace($pageText, '(?is)</(p|div|h[1-6]|li|section)>|<br\s*/?>', "`n")
  $pageText = [System.Net.WebUtility]::HtmlDecode([regex]::Replace($pageText, '(?s)<[^>]+>', ' '))
  $pageLines = $pageText -split "`n" | ForEach-Object { [regex]::Replace($_, '\s+', ' ').Trim() } | Where-Object { $_ }
  Write-Output $sourceId
  $pageLines | Where-Object { $_ -match 'museum|jail|village|board|historical|society|hours|open|managed' } | Select-Object -First 60
  [regex]::Matches($pageHtml, '(?is)<a\b[^>]*href=["''](?<url>[^"'']+)["''][^>]*>(?<text>.*?)</a>') | ForEach-Object {
    $linkText = [regex]::Replace($_.Groups['text'].Value, '<[^>]+>', ' ')
    $linkUrl = $_.Groups['url'].Value
    if (($linkText + ' ' + $linkUrl) -match 'lorettotel|museum|jail|board|officer|village') { Write-Output ($linkText + ' : ' + $linkUrl) }
  } | Select-Object -First 50
}
