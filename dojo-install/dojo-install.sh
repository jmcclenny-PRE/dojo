VPN_AUTH_GROUP=###CHANGEME###
VPN_AUTH_CONNECT=###CHANGEME###

# install homebrew #
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install apps from homebrew #
brew install blueutil openconnect tmux watch tree jq 
brew install minio/stable/mc
brew install cloudfoundry/tap/credhub-cli
brew install cloudfoundry/tap/bosh-cli
brew install cloudfoundry/tap/cf-cli
brew install homebrew/cask/powershell
brew install homebrew/cask-versions/slack-beta
brew cask install microsoft-remote-desktop-beta
brew cask install iterm2
brew install zsh
gem install cf-uaac

# install zoom #
cd ~/Downloads
curl -L --remote-name https://zoom.us/client/latest/zoomusInstaller.pkg
sudo installer -pkg zoomusInstaller.pkg -target /

#om-darwin
cd ~/Downloads
om_type=darwin
curl -L --remote-name $(curl -s https://api.github.com/repos/pivotal-cf/om/releases/latest | jq -r ".assets[] | select(.name | test(\"${om_type}\")) | .browser_download_url")
chmod +x om-darwin
mv om-darwin /usr/local/bin/om

# due to great reluctance, I'm allowing concourse to be installed #
cd ~/Downloads
concourse_type=concourse_darwin_amd64$
curl -L --remote-name $(curl -s https://api.github.com/repos/concourse/concourse/releases/latest | jq -r ".assets[] | select(.name | test(\"${concourse_type}\")) | .browser_download_url")
chmod +x concourse_darwin_amd64
mv concourse_darwin_amd64 /usr/local/bin/concourse

# install chrome #
cd ~/Downloads
curl https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg -o googlechrome.dmg
open ~/Downloads/googlechrome.dmg
sudo cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/

# install fly-cli #
cd ~/Downloads
fly_type=fly_darwin_amd64$
curl -L --remote-name $(curl -s https://api.github.com/repos/concourse/concourse/releases/latest | jq -r ".assets[] | select(.name | test(\"${fly_type}\")) | .browser_download_url")
chmod +x fly_darwin_amd64
mv fly_darwin_amd64 /usr/local/bin/fly

# install vscode #
cd ~/Downloads
curl -o VSCode-darwin-stable.zip -L --remote-name https://go.microsoft.com/fwlink/?LinkID=620882
cd /Applications
unzip ~/Downloads/VSCode-darwin-stable.zip

##### Create VPN connect script #####
cd ~/
echo "sudo openconnect --authgroup $VPN_AUTH_GROUP --script=~/vpnc-script-split-traffic.sh   $VPN_AUTH_CONNECT  --servercert sha256:cca84f3585f647d4507276d3b714fb3868ed1bd27e33b6535652fd915818d34c" > connect-ceif.sh
chmod +x connect-ceif.sh

##### Create VPN tunnel script #####
echo '# Add one IP to the list of split tunnel
add_ip ()
{
    export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_ADDR=$1
    export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASK=$2
    export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASKLEN=$3
    export CISCO_SPLIT_INC=$(($CISCO_SPLIT_INC + 1))
}

# Initialize empty split tunnel list
export CISCO_SPLIT_INC=0

# Delete DNS info provided by VPN server to use internet DNS
# Comment following line to use DNS beyond VPN tunnel
#unset INTERNAL_IP4_DNS

# List of IPs beyond VPN tunnel
add_ip 10.5.15.0	 255.255.255.0 24   #MGMT1
add_ip 10.5.16.0 255.255.255.0 24       #MGMT2
add_ip 192.168.0.0 255.255.0.0 16		#Platform

# Execute default script
. /usr/local/etc/vpnc-script

# End of script' > vpnc-script-split-traffic.sh
chmod +x vpnc-script-split-traffic.sh

# install oh-my-zsh (drops you into zsh and you must exit)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"