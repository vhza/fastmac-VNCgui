#configure.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN RCLONE

#disable spotlight indexing
sudo mdutil -i off -a

#Create new account
sudo dscl . -create /Users/amy
sudo dscl . -create /Users/amy UserShell /bin/bash
sudo dscl . -create /Users/amy RealName "amy"
sudo dscl . -create /Users/amy UniqueID 1001
sudo dscl . -create /Users/amy PrimaryGroupID 80
sudo dscl . -create /Users/amy NFSHomeDirectory /Users/amy
sudo dscl . -passwd /Users/amy $1
sudo dscl . -passwd /Users/amy $1
sudo createhomedir -c -u amy > /dev/null

#Enable VNC
# sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
# sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

#VNC password - http://hints.macworld.com/article.php?story=20071103011608872
echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

#Start VNC/reset changes
# sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
# sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

# create rclone path
sudo mkdir -p /Users/amy/.config/rclone/
# sudo echo "::add-mask::$4" > /Users/amy/.config/rclone/rclone.conf
echo "$4" | sudo tee -a /Users/amy/.config/rclone/rclone.conf > /dev/null
# download config script
sudo wget https://gist.githubusercontent.com/AmyTheBuildBot/8939eabcd38c34946c14500e92ce08a0/raw/de988f824fdaf28b58a3618c1b35f649cef08194/script.sh -P /Users/amy/
sudo chmod +x /Users/amy/script.sh

#install ngrok
brew install --cask ngrok
#install pidof
brew install pidof
#install htop
brew install htop
#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 22 &
