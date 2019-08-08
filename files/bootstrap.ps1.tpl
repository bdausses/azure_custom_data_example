## Download the Chef Client
$clientURL = "https://packages.chef.io/files/stable/chef/15.1.36/windows/2016/chef-client-15.1.36-1-x64.msi"
$clientDestination = "C:\chef-client.msi"
Invoke-WebRequest $clientURL -OutFile $clientDestination

## Install the Chef Client
Start-Process msiexec.exe -ArgumentList @('/qn', '/lv C:\Windows\Temp\chef-log.txt', '/i C:\chef-client.msi', 'ADDLOCAL="ChefClientFeature,ChefSchTaskFeature,ChefPSModuleFeature"') -Wait

## Create first-boot.json
$firstboot = @{
   "run_list" = @("${run_list}");
   "chef_client" = @{
     "interval" = 300
   }
}
Set-Content -Path c:\chef\first-boot.json -Value ($firstboot | ConvertTo-Json -Depth 10)

# Create client.rb
$nodeName = "lab-win-{0}" -f (-join ((65..90) + (97..122) | Get-Random -Count 4 | % {[char]$_}))

$clientrb = @"
chef_server_url        '${chef_server_url}'
validation_client_name '${validation_client_name}'
validation_key         'C:\chef\validator.pem'
node_name              '{0}'
"@ -f $nodeName

Set-Content -Path c:\chef\client.rb -Value $clientrb

# Write the validator.pem file
$key_value = '${validator_key}'
$key_value | Set-Content 'C:\chef\validator.pem'

# Fetch SSL Certificate from Chef server
C:\opscode\chef\bin\knife ssl fetch -c c:\chef\client.rb

## Run Chef
C:\opscode\chef\bin\chef-client.bat --chef-license accept-silent -j C:\chef\first-boot.json

# Remove the validator.pem file
Remove-Item c:\chef\validator.pem

# Remove the AzureData directory and it's contents
Remove-Item -Recurse -Force c:\AzureData
