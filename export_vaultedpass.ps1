$newcsv = {} | Select-Object 'Org_id','Orgname','Pass_ID','Pass_name','Username','Password','passcategryid','passcategryname','resource_id','resourcetypename','resourcename','restricted','archived','Personal','vault_id','CreatedAt','MyGluePass' | Export-Csv -NoTypeInformation passwords.csv
$csvfile = Import-Csv passwords.csv
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$totalpage = 1
$headers.Add("Content-Type", "application/vnd.api+json")
 
$headers.Add("x-api-key", "Paste your API key")
$response = Invoke-RestMethod 'https://api.itglue.com/passwords?page[size]=1000&page[number]=$totalpage' -Method 'GET' -Headers $headers

$totalpage = $response.meta.'total-pages'

for($i=1; $i -le $totalpage; $i++){

$response = Invoke-RestMethod "https://api.itglue.com/passwords?page[size]=1000&page[number]=$i" -Method 'GET' -Headers $headers


ForEach ($item in $response.data){

if($item.attributes.'vault-id' -ne $null){

$getpassid = $item.id

$getorg_id = $item.attributes.'organization-id'

$getorgname = $item.attributes.'organization-name'

$getname = $item.attributes.name

$getusername = $item.attributes.username

$getpassword = $item.attributes.password

$getresource_id = $item.attributes.'resource-id'

$getresourcetypename = $item.attributes.'cached-resource-type-name'

$getresourcename = $item.attributes.'cached-resource-name'

$getpasscategryid = $item.attributes.'password-category-id'

$getpasscategryname = $item.attributes.'password-category-name'

$getcreateat = $item.attributes.'created-at'

$vault_id = $item.attributes.'vault-id'

$restricted = $item.attributes.'restricted'

$archived = $item.attributes.'archived'

$Personal = $item.attributes.'personal'
 
$getmyglueinfo = $item.attributes.'my-glue'

$otp_enabled = $item.attributes.'otp-enabled'


Write-Host $getpassid" "$getorg_id" "$getorgname" "$getname" "$getusername" "$getmyglueinfo" "$getpassword" "$getpasscategryid" "$getpasscategryname" "$getresource_id" "$getresourcetypename" "$getresourcename" "$getcreateat" "$restricted" "$archived" "$Personal" "$vault_id" "$getmyglueinfo

$csvfile | select @{Name="Pass_ID"; Expression={$getpassid}
},
@{Name="Org_id"; Expression={$getorg_id}}, @{Name="Orgname"; Expression={$getorgname}
}, @{
    Name="Pass_name"; Expression={$getname}
}, @{
    Name="Username"; Expression={$getusername}
}, @{
    Name="Password"; Expression={$getpassword}
}, @{
    Name="passcategryid"; Expression={$getpasscategryid}
}, @{
    Name="passcategryname"; Expression={$getpasscategryname}
}, @{
    Name="resource_id"; Expression={$getresource_id}
}, @{
    Name="resourcetypename"; Expression={$getresourcetypename}
}, @{
    Name="resourcename"; Expression={$getresourcename}
}, @{
    Name="restricted"; Expression={$restricted}
}, @{
    Name="archived"; Expression={$archived}
}, @{
    Name="Personal"; Expression={$Personal}
}, @{
    Name="vault_id"; Expression={$vault_id}
}, @{
    Name="CreatedAt"; Expression={$getcreateat}
}, @{
    Name="MyGluePass"; Expression={$getmyglueinfo}
} | export-CSV passwords.csv -Append -NoTypeInformation

}

}

}
