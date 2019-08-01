## Download the Chef Client
$clientURL = "https://packages.chef.io/files/stable/chef/15.1.36/windows/2016/chef-client-15.1.36-1-x64.msi"
$clientDestination = "C:\chef-client.msi"
Invoke-WebRequest $clientURL -OutFile $clientDestination

## Install the Chef Client
Start-Process msiexec.exe -ArgumentList @('/qn', '/lv C:\Windows\Temp\chef-log.txt', '/i C:\chef-client.msi', 'ADDLOCAL="ChefClientFeature,ChefSchTaskFeature,ChefPSModuleFeature"') -Wait

## At this point, the chef-client is installed and ready for use.  

## Once the client is installed, you would do more stuff here, like setting up first-boot.json and client.rb...  then execute the initial chef-client run.
## See the example here:  https://docs.chef.io/install_bootstrap.html#powershell-user-data
