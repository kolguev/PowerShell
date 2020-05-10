function global:ChangeMonth
{
param([string]$inString)
$Change_Month = @{
[string]'января' = "01"
[string]'февраля' = "02"
[string]'марта' = "03"
[string]'апреля' = "04"
[string]'мая' = "05"
[string]'июня' = "06"
[string]'июля' = "07"
[string]'августа' = "08"
[string]'сентября' = "09"
[string]'октября' = "10"
[string]'ноября' = "11"
[string]'декабря' = "12"
}
$outStrings=""
foreach ($c in $Change_Month.Keys = $inString)
{
if ($Change_Month[$c] -cne $Null )
{$outStrings = $Change_Month[$c]}
}
Write-Output $outStrings
}

$text = "мая"
$log = ChangeMonth $text
$log
