# Source: https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.4

echo '###########################################'
echo '#   Entering Install-LinuxPowerShell.sh   #'
echo '###########################################'

echo '1. Update the list of packages'
sudo apt-get update

echo '2. Install pre-requisite packages'
sudo apt-get install -y wget apt-transport-https software-properties-common

echo '3. Get the version of Ubuntu'
# source /etc/os-release
# echo "Found version $VERSION_ID" - empty
VERSION_ID='22.04'

echo '4. Determine URL'
url=https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
echo "   Found URL [$url]"

echo '5. Download the Microsoft repository GPG keys'
wget -q $url

echo '6. Register the Microsoft repository GPG keys'
sudo dpkg -i packages-microsoft-prod.deb

echo '7. Delete the Microsoft repository keys file'
rm packages-microsoft-prod.deb

echo '8. Update the list of products'
sudo apt-get update

echo '9. Enable the "universe" repositories'
sudo add-apt-repository universe -y

echo '10. Install PowerShell'
sudo apt-get install -y powershell

echo '##########################################'
echo '#   Exiting Install-LinuxPowerShell.sh   #'
echo '##########################################'

exit 0
