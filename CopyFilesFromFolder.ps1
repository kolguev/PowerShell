set-location C:\users\
$a = Get-ChildItem
foreach ($folder in $a)
{
if ("C:\Users\$folder\Desktop"){
set-location C:\Users\$folder\
Copy-Item -Path .\Desktop\ -Destination "D:\BackupUsersDesktop\$folder\" -Recurse
}
}