$BackupFolders = Get-ChildItem -Path "E:\Backup\BackupFarma\"
for ($i=0; $i -lt $BackupFolders.Length; $i++)
{
$ElementOfArray = $BackupFolders[$i].ToString()
$ArrayOfFiles = Get-ChildItem -Path "E:\Backup\BackupFarma\$ElementOfArray" *.7z | Where-Object -FilterScript {($_.LastWriteTime -lt '2020-03-07')} # > "E:\Backup\!\$ElementOfArray.txt"
$ArrayOfFiles | foreach {$_.Delete()}
}