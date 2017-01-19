$MyObjectFilter = 'ID=..49999|78700..78899|89100..89199|100000..'
$MyWorkBaseFolder = 'c:\source\NAVWorkFolder' 

$DatabaseServer = 'sql04'
$DatabaseName = '4psse_900_001_release'
$MyWorkFolder = (Join-Path $MyWorkBaseFolder $DatabaseServer-$DatabaseName)
$CommitDate = Get-Date -format o

Import-Module posh-git
c:
cd $MyWorkFolder

#git remote add origin https://github.com/itero4ps/4psse_900_001_release
git fetch origin  #get all from remote repo
git reset --hard origin/master  #reset local status to same as remote repo
#git clean -f -d  #delete all files/folders not in remote repo

#invoke-expression, get new objects from Database
& 'C:\Source\NAVWorkFolder\powershell\ExportSourceFromDatabaseNAV2016.ps1'

cd $MyWorkFolder
git add .\DevApp\*.TXT
#git commit -m "auto commit DevApp"
git add .\DevApps\*.txt
#git commit -m "auto commit DevApps"
git add .\Language\*.TXT
#git commit -m "auto commit Language"
git add .\Fobs\*.zip
#git commit -m "auto commit FOB objects"
git commit -m "auto commit $DatabaseName $CommitDate"

git push origin master
