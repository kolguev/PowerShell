# Получаем логин пользователя
$UserName = $env:username
$PathAppdata = $env:appdata

# Далее ищем Имя и Фамилию пользователя в AD по логину
$Filter = "(&(objectCategory=User)(samAccountName=$UserName))"
$Searcher = New-Object System.DirectoryServices.DirectorySearcher
$Searcher.Filter = $Filter
$ADUserPath = $Searcher.FindOne()
$ADUser = $ADUserPath.GetDirectoryEntry()
$ADDisplayName = $ADUser.DisplayName

####################

#Копируем папки профайла

if (-Not (Test-Path "D:\post\$UserName\"))
{
Copy-Item -Path "$PathAppdata\Thunderbird\Profiles\" -Destination "D:\post\$UserName\Profiles" -Recurse
}
else {
Write-Host "Folder exist! Continue."
}

# Copy-Item -Path "$env:appdata\Thunderbird\Profiles\" -Destination "D:\post\$UserName\Profiles" -Recurse

# Находим имя папки профайла
$NeedProfileFolder = Get-ChildItem "$PathAppdata\Thunderbird\Profiles\" | Where-Object {$_.Name -like "*.default-release"}
$NameOfProfileFolder = $NeedProfileFolder.Name

# Изменяем profiles.ini
$ProfilesINI = Get-Content $PathAppdata\Thunderbird\Profiles.ini

for ($i=0; $i -le $ProfilesINI.Length; $i++)
{
if ($ProfilesINI[$i] -like "IsRelative=1")
{
$ProfilesINI[$i] = $ProfilesINI[$i] -replace "IsRelative=1","IsRelative=0"
}
elseif ($ProfilesINI[$i] -like "*Profiles/*")
{
$ProfilesINI[$i] = $ProfilesINI[$i] -replace "Profiles/","D:\Post\$UserName\Profiles\"
}
}
$ProfilesINI | Out-File -Encoding utf8 $env:appdata\Thunderbird\Profiles.ini

# $String1 = $ProfilesINI[1]
# $String2 = $ProfilesINI[6]
# $String3 = $ProfilesINI[7]
# $String4 = $ProfilesINI[12]
# $String5 = $ProfilesINI[13]
# $PathForReplace = "D:\Post\$env:username\Profiles\"
# $NeedString = $String1 -replace 'Profiles/',$PathForReplace
# $ProfilesINI[1] = $NeedString
# $NeedString = $String2 -replace 'IsRelative=1','IsRelative=0'
# $ProfilesINI[6] = $NeedString
# $NeedString = $String3 -replace 'Profiles/',$PathForReplace
# $ProfilesINI[7] = $NeedString
# $NeedString = $String4 -replace 'IsRelative=1','IsRelative=0'
# $ProfilesINI[12] = $NeedString
# $NeedString = $String5 -replace 'Profiles/',$PathForReplace
# $ProfilesINI[13] = $NeedString
# $ProfilesINI | Out-File -Encoding utf8 $env:appdata\Thunderbird\Profiles.ini

####################

# Получаем имя ящика пользователя по логину
$UserNameToEmail = @{WindowsUserName="EmailName";}
$EmailName = $UserNameToEmail[$UserName]

####################

if ($UserName -eq "MyEmailName")
{$domain="MyEmailDomain.ru"} #Почтовый домен
else {$domain="ecofarmplus.ru"} #Почтовый домен


$imap="imap.mail.ru" #imap сервер
$dc="dcsrv.office.company.ru" #Контролер домена
$dcIP="10.10.100.21"
$bdn="OU=CompanyUsers,DC=office,DC=Company,DC=ru" #Base DN
$AddressBaseDN="OU=Contacts,OU=CompanyUsers,DC=office,DC=Company,DC=ru"
$login = $UserName+"@office.Company.ru"

$file="D:\post\$UserName\Profiles\$NameOfProfileFolder\prefs.js"
# $file = 'C:\Users\Администратор\Desktop\Thunderbird.cfg'

echo 'user_pref("ldap_2.autoComplete.directoryServer", "ldap_2.servers.company");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("ldap_2.autoComplete.useDirectory", true);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("ldap_2.servers.company.auth.dn", "'$login'");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("ldap_2.servers.company.auth.saslmech", "");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("ldap_2.servers.company.description", "Company");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("ldap_2.servers.company.filename", "ldap.mab");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("ldap_2.servers.company.maxHits", 100);' | out-file $file -encoding UTF8 -Append
$id1 = echo 'user_pref("ldap_2.servers.company.uri", "ldap://'
$id2 = echo $dcIP/$AddressBaseDN'??sub?(objectclass=*)");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.ab_remote_content.migrated", 1);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.account.account1.identities", "id1");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.account.account1.server", "server1");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.account.account2.server", "server2");' | out-file $file -encoding UTF8 -Append

if ($UserName -eq "AnyUserName")
{
echo 'user_pref("mail.account.account3.identities", "id3");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.account.account3.server", "server3");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.account.lastKey", 3);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.accountmanager.accounts", "account1,account2,account3");' | out-file $file -encoding UTF8 -Append

# Server3 Email@Company.ru
echo 'user_pref("mail.server.server3.type", "imap");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.hostname", "mail.Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.realhostname", "mail.Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.port", 993);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.socketType", 3);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.name", "Email@Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.userName", "Email@Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.realuserName", "Email@Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.login_at_startup", true);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp2.hostname", "mail.Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp2.port", 465);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp2.try_ssl", 3);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp2.auth_method", 2);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp2.username", "Email@Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.sign_mail", false);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.smtpServer", "smtp2");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.fullName", "Email");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.useremail", "Email@Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.reply_to", "Email@Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.valid", true);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.smtpServer", "smtp2");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.organization", "Барион");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.draft_folder", "imap://Email%40Company.ru@mail.Company.ru/Drafts");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.drafts_folder_picker_mode", "0");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.fcc_folder", "imap://Email%40Company.ru@mail.Company.ru/Sent");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.fcc_folder_picker_mode", "0");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.stationery_folder", "imap://Email%40Company.ru@mail.Company.ru/Templates");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id3.tmpl_folder_picker_mode", "0");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.directory", "D:\\post\\'$UserName'\\Profiles\\'$NameOfProfileFolder'\\ImapMail\\Email.Company.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server3.directory-rel", "[ProfD]ImapMail/Email.Company.ru");' | out-file $file -encoding UTF8 -Append
}
else
{
echo 'user_pref("mail.account.lastKey", 2);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.accountmanager.accounts", "account1,account2");' | out-file $file -encoding UTF8 -Append
}

#echo 'user_pref("mail.account.lastKey", 2);' | out-file $file -encoding UTF8 -Append
#echo 'user_pref("mail.accountmanager.accounts", "account1,account2");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.accountmanager.defaultaccount", "account1");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.accountmanager.localfoldersserver", "server2");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.append_preconfig_smtpservers.version", 2);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.attachment.store.version", 1);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.default_charsets.migrated", 1);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.folder.views.version", 1);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.font.windows.version", 2);' | out-file $file -encoding UTF8 -Append

echo 'user_pref("app.update.enabled", false);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("extensions.update.enabled", false);' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.identity.id1.draft_folder", "imap://' 
$id2 = echo $EmailName%40$domain@$imap/Drafts'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.identity.id1.attach_signature", true);' | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.identity.id1.drafts_folder_picker_mode", "0");' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.identity.id1.fcc_folder", "imap://'
$id2 = echo $EmailName%40$domain@$imap/Sent'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.identity.id1.fcc_folder_picker_mode", "0");' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.identity.id1.fullName", "'
$id2 = echo $ADDisplayName'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.identity.id1.htmlSigFormat", true);'  | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id1.reply_on_top", 1);'  | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.identity.id1.sig_file", "D:\\post\\'
$id2 = echo $UserName\\Profiles\\$NameOfProfileFolder\\signature.htm'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.identity.id1.sig_file-rel", "[ProfD]signature.htm");' | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.identity.id1.sign_mail", false);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.identity.id1.smtpServer", "smtp1");' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.identity.id1.stationery_folder", "imap://'
$id2 = echo $EmailName%40$domain@$imap/Templates'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.identity.id1.tmpl_folder_picker_mode", "0");' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.identity.id1.useremail", "'
$id2 = echo $EmailName@$domain'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.identity.id1.valid", true);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.openMessageBehavior.version", 1);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.rights.version", 1);' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.root.imap", "D:\\post\\'
$id2 = echo $UserName\\Profiles\\$NameOfProfileFoldere\\ImapMail'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.root.imap-rel", "[ProfD]ImapMail");' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.root.none", "D:\\post\\'
$id2 = echo $UserName\\Profiles\\$NameOfProfileFolder\\Mail'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.root.none-rel", "[ProfD]Mail");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server1.cacheCapa.acl", false);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server1.cacheCapa.quota", false);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server1.canChangeStoreType", true);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server1.check_new_mail", true);' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.server.server1.directory", "D:\\post\\'
$id2 = echo $UserName\\Profiles\\$NameOfProfileFolder\\ImapMail\\$imap'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.server.server1.directory-rel", "[ProfD]ImapMail/'
$id2 = echo $imap'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.server.server1.hostname", "'
$id2 = echo $imap'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.server.server1.login_at_startup", true);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server1.max_cached_connections", 5);' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.server.server1.name", "'
$id2 = echo $EmailName@$domain'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.server.server1.port", 993);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server1.socketType", 3);' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.server.server1.spamActionTargetAccount", "imap://'
$id2 = echo $EmailName%40$domain@$imap'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.server.server1.storeContractID", "@mozilla.org/msgstore/berkeleystore;1");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server1.type", "imap");' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.server.server1.userName", "'
$id2 = echo $EmailName@$domain'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.server.server2.directory", "D:\\post\\'
$id2 = echo $UserName\\Profiles\\$NameOfProfileFolder\\ImapMail\\Mail\\Local Folders'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.server.server2.directory-rel", "[ProfD]Mail/Local Folders");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server2.hostname", "Local Folders");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server2.name", "Локальные папки");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server2.storeContractID", "@mozilla.org/msgstore/berkeleystore;1");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server2.type", "none");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.server.server2.userName", "nobody");' | out-file $file -encoding UTF8 -Append

echo 'user_pref("mail.smtpserver.smtp1.authMethod", 3);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp1.description", "mail.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp1.hostname", "smtp.mail.ru");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp1.port", 465);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.smtpserver.smtp1.try_ssl", 3);' | out-file $file -encoding UTF8 -Append

$id1 = echo 'user_pref("mail.smtpserver.smtp1.username", "'
$id2 = echo $EmailName@$domain'");'
echo $id1$id2 | out-file $file -encoding UTF8 -Append

if ($UserName -eq "AnyUserName")
{
echo 'user_pref("mail.smtpservers", "smtp1,smtp2");' | out-file $file -encoding UTF8 -Append
}
else
{
echo 'user_pref("mail.smtpservers", "smtp1");' | out-file $file -encoding UTF8 -Append
}

echo 'user_pref("mail.spam.version", 1);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.taskbar.lastgroupid", "8216C80C92C4E828");' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.ui-rdf.version", 15);' | out-file $file -encoding UTF8 -Append
echo 'user_pref("mail.winsearch.firstRunDone", true);' | out-file $file -encoding UTF8 -Append
