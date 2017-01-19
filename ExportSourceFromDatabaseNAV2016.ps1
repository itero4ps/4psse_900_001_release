$PowerShellPath = 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\'
$NavClientFolder = 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client'
$NavIde = (Join-Path $NavClientFolder '\finsql.exe')



#C:\WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell.exe  -NoExit -ExecutionPolicy RemoteSigned " & ' C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\NavModelTools.ps1 ' "
#C:\WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell.exe  -NoExit -ExecutionPolicy RemoteSigned " & ' C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1 ' "
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass -Force
#Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\NavModelTools.ps1'
#Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1'
$NavIdeFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Ide.psm1')
Import-Module $NavIdeFile -DisableNameChecking

$NavToolFile = (Join-Path $NavClientFolder 'Microsoft.Dynamics.Nav.Model.Tools.psd1')
Import-Module $NavToolFile -DisableNameChecking

$NavIde = (Join-Path $NavClientFolder '\finsql.exe')
$MyWorkFile = 'AllObjects'

$BaseAppFolder = (Join-Path $MyWorkFolder 'BaseApp')
$LanguageFolder = (Join-Path $MyWorkFolder 'Language')
$DevAppFolder = (Join-Path $MyWorkFolder 'DevApp')
$HelpFolder = (Join-Path $MyWorkFolder 'Help')

$DevAppsFolder = (Join-Path $MyWorkFolder 'DevApps')


#Export all objects from DB
if (!(test-path $MyWorkFolder)) {  New-Item -path $MyWorkFolder -ItemType directory}
#Create-FolderIfNotExist $MyWorkFolder
$MyAllObjectsFile = (Join-Path $MyWorkFolder $MyWorkFile) + '.txt'
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path $MyAllObjectsFile -ExportTxtSkipUnlicensed -Filter $MyObjectFilter -Force


$FobFolder = (Join-Path $MyWorkFolder 'Fobs')
if (!(test-path $FobFolder)) {  New-Item -path $FobFolder -ItemType directory}
Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllTables.fob') -Filter ($MyObjectFilter+';Type=table') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllTables.zip') -Path (Join-Path $FobFolder 'AllTables.fob') -Force

Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllPages.fob') -Filter ($MyObjectFilter+';Type=page') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllPages.zip') -Path (Join-Path $FobFolder 'AllPages.fob') -Force

Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'Allcodeunit.fob') -Filter ($MyObjectFilter+';Type=codeunit') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'Allcodeunit.zip') -Path (Join-Path $FobFolder 'Allcodeunit.fob') -Force

Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllQuery.fob') -Filter ($MyObjectFilter+';Type=Query') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllQuery.zip') -Path (Join-Path $FobFolder 'AllQuery.fob') -Force

Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllXMLport.fob') -Filter ($MyObjectFilter+';Type=XMLport') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllXMLport.zip') -Path (Join-Path $FobFolder 'AllXMLport.fob') -Force

Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllMenusuite.fob') -Filter ($MyObjectFilter+';Type=menusuite') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllMenusuite.zip') -Path (Join-Path $FobFolder 'AllMenusuite.fob') -Force

Export-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Path (Join-Path $FobFolder 'AllReports.fob') -Filter ($MyObjectFilter+';Type=report') -Force
Compress-Archive -DestinationPath (Join-Path $FobFolder 'AllReports.zip') -Path (Join-Path $FobFolder 'AllReports.fob') -Force

#BaseApp
#Split all NAV objects into individual files
if (!(test-path $BaseAppFolder)) {  New-Item -path $BaseAppFolder -ItemType directory}
#Create-FolderIfNotExists $BaseAppFolder
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $BaseAppFolder -PassThru -Force -PreserveFormatting

#DevApp
#Split all NAV objects into individual files
if (!(test-path $DevAppFolder)) {  New-Item -path $DevAppFolder -ItemType directory}
#Create-FolderIfNotExists $DevAppFolder
Split-NAVApplicationObjectFile -Source $MyAllObjectsFile -Destination $DevAppFolder -PassThru -Force -PreserveFormatting
Remove-NAVApplicationObjectLanguage -Source $DevAppFolder -Destination $DevAppFolder -Force
#Remove app properties
Set-NAVApplicationObjectProperty -TargetPath $DevAppFolder -ModifiedProperty No -DateTimeProperty '' # -VersionListProperty '' 

if (!(test-path $DevAppsFolder)) {  New-Item -path $DevAppsFolder -ItemType directory}
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Codeunit.txt -Source $DevAppFolder\COD*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\MenuSuite.txt -Source $DevAppFolder\MEN*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Page.txt -Source $DevAppFolder\PAG*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Query.txt -Source $DevAppFolder\QUE*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Tables.txt -Source $DevAppFolder\TAB*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\XMLPorts.txt -Source $DevAppFolder\XML*.TXT  -Force

Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports1101.txt -Source $DevAppFolder\REP1101*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports11XX.txt -Source $DevAppFolder\REP11[2-9][2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports1X.txt -Source $DevAppFolder\REP1[2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports2X.txt -Source $DevAppFolder\REP2[2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports3X.txt -Source $DevAppFolder\REP3[2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports4X.txt -Source $DevAppFolder\REP4[2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports5X.txt -Source $DevAppFolder\REP5[2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports6X.txt -Source $DevAppFolder\REP6[2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports7X.txt -Source $DevAppFolder\REP7[2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports8X.txt -Source $DevAppFolder\REP8[2-9]*.TXT  -Force
Join-NAVApplicationObjectFile -Destination $DevAppsFolder\Reports9X.txt -Source $DevAppFolder\REP9[2-9]*.TXT  -Force


#Languages
if (!(test-path $LanguageFolder)) {  New-Item -path $LanguageFolder -ItemType directory}
#Create-FolderIfNotExists $LanguageFolder
#Export-NAVApplicationLanguageByFile2Folder -MyAllObjectsFile $MyAllObjectsFile -CurrentLanguage ENU -LanguageFolder $LanguageFolder
Export-NAVApplicationObjectLanguage -source $MyAllObjectsFile -DevelopmentLanguageId ENU -destination $LanguageFolder -Force

#Help
#if (!(test-path $HelpFolder)) {  New-Item -path $HelpFolder -ItemType directory}
#Create-FolderIfNotExists $HelpFolder

