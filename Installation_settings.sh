#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────────────────────────
# Declaring Variables
# ─────────────────────────────────────────────────────────────────────────────

# ──────────────────────
# Colors
# ──────────────────────

RED='\033[0;31m'

GREEN='\033[0;32m'

YELLOW='\033[0;33m'

ORANGE='\033[1;33m'    # Orange approach

MAGENTA='\033[1;35m'

BLUE='\033[0;34m'

GRAY='\033[1;30m'

RESET='\033[0m'

# ─────────────────────────────────────────────────────────────────────────────
# Function to validate if the script is running as root
# ─────────────────────────────────────────────────────────────────────────────

    check_root_user() {
        if [ "$(id -u)" != 0 ]; then
           echo -e "${RED}Please run the script as root!${RESET}"
           echo -e "${RED}We need to run to do administrative tasks${RESET}"
           exit 1
        fi
    }

# ─────────────────────────────────────────────────────────────────────────────
# Functions of update
# ─────────────────────────────────────────────────────────────────────────────    

    dist_upgrade() {
       apt update && apt upgrade -y && apt dist-upgrade -y
    }

    repo_update() {
       apt update
    }

    system_update() {
       apt update && apt upgrade -y
    }

    snap_update() {
        snap refresh
    }

    flatpak_update(){
        flatpak update
    }

# ─────────────────────────────────────────────────────────────────────────────
# Disabling ADS in the Ubuntu Pro Terminal
# ─────────────────────────────────────────────────────────────────────────────

    disable_terminal_ads() {
        sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
        pro config set apt_news=false
    }

# ─────────────────────────────────────────────────────────────────────────────
# Cleanup function
# ─────────────────────────────────────────────────────────────────────────────

    cleanup() {
        apt autoremove -y
    }

# ─────────────────────────────────────────────────────────────────────────────
# Configuring flathub to install flatpak packages
# ─────────────────────────────────────────────────────────────────────────────

    setup_flathub() {
         apt install flatpak -y
         flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
         apt install --install-suggests gnome-software -y
    }

# ─────────────────────────────────────────────────────────────────────────────
# Unlock options on startup manager
# ─────────────────────────────────────────────────────────────────────────────

    startup_manager() {
         sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
    }

# ─────────────────────────────────────────────────────────────────────────────
# Adding third party repositories
# ─────────────────────────────────────────────────────────────────────────────

    
   repo_it_tools() {
        
        # Anydesk
        wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /etc/apt/keyrings/anydesk.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/anydesk.gpg] http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list > /dev/null
        
        # Virtualbox
        echo -e "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian jammy contrib"|sudo tee /etc/apt/sources.list.d/virtualbox.list
        wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
    }

    repo_programming_applications() {
        
        # DBeaver-ce
        curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/dbeaver.gpg
        echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
        
       # VSCode
       wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg > /dev/null
       echo "deb [signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
        }
    
    repo_brave_browser() {
        wget -qO - https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | sudo tee /etc/apt/keyrings/brave-browser-archive-keyring.gpg
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    }
    
    repo_opera_browser() {
        wget -qO- https://deb.opera.com/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/opera-browser.gpg
        echo "deb [signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free" | sudo tee /etc/apt/sources.list.d/opera.list

    }
    
    repo_edge_browser() {
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
    }
    
    repo_for_gamers() {
        # retroarch
        sudo add-apt-repository ppa:libretro/stable
    }
     repo_for_steam() {
        # Repo for steam (architecture i386)
         sudo add-apt-repository universe multiverse 
    }

# ─────────────────────────────────────────────────────────────────────────────
# Installing applications and tools
# ─────────────────────────────────────────────────────────────────────────────
    install_repo_tools() {
       apt install curl apt-transport-https software-properties-common -y
    }
    install_essentials_tools() {
        apt install aptitude htop net-tools snapd gparted cpu-x gdebi git tesseract-ocr poppler-utils whois vim binutils preload default-jdk ubuntu-restricted-extras stow traceroute ssh dnsutils mtr iperf3 nload gnupg2 ca-certificates f3 tree gnome-calendar setserial cu -y
        sudo flatpak install https://dl.flathub.org/repo/appstream/org.gnome.Snapshot.flatpakref -y
        sudo systemctl start ssh && sudo systemctl enable ssh
        
        # Microsoft Fonts
        wget --max-redirect 100 http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8_all.deb
        dpkg -i ttf-mscorefonts-installer_3.8_all.deb
        apt --fix-broken install
        rm -fr ttf-mscorefonts-installer_3.8_all.deb
    }
  
    install_advanced_tools() {
       apt install nmap alacritty tmux dnsenum lynis nethogs rkhunter -y
    }
    
    install_basic_applications() {
        apt install libreoffice audacity youtubedl-gui qbittorrent vlc winff handbrake thunderbird gnome-shell-extensions arandr -y
        wget --max-redirect 100 https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb
        sudo dpkg -i freedownloadmanager.deb
        apt --fix-broken install
        rm -fr freedownloadmanager.deb
        sudo snap install foliate
        sudo snap install spider-solitaire
        sudo snap install kmahjongg
        sudo snap install space-cadet-pinball
        sudo snap install gnome-mines
    }

    install_google_chrome_browser() {
        wget --max-redirect 100 https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
        sudo dpkg -i google-chrome*
        apt --fix-broken install
        rm -fr google-chrome*
    }
    
    install_brave_browser() {
        apt install brave-browser -y
    }
    install_opera_browser() {
        apt install opera-stable -y
    }
    install_edge_browser() {
        apt install microsoft-edge-stable -y
    }
      
    install_design_applications() {
        apt install gimp inkscape blender -y
    }
    
    install_it_tools() {
        sudo apt install dia rpi-imager anydesk wireshark remmina putty* -y
        sudo aptitude install virtualbox -y
        sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y
        wget --max-redirect 100 https://github.com/balena-io/etcher/releases/download/v1.19.25/balena-etcher_1.19.25_amd64.deb
        sudo dpkg -i balena-etcher_*
        apt --fix-broken install
        rm -fr balena-etcher_*
        sudo snap install core
        sudo snap install drawio
    }
    install_cd_dvd_burn() {
        aptitude install brasero k3b -y
    }
       
    install_programming_applications() {
         apt install arduino arduino-* dbeaver-ce ca-certificates code android-tools-adb -y
         sudo snap install notepad-plus-plus
     }
     setup_architecture_i386() {
          sudo dpkg  --add-architecture i386
     }
     install_steam() {
          aptitude install steam-installer steam-devices -y
     }
     install_lutris() {
          aptitude install lutris -y
     }
     install_retroarch() {
          sudo snap install retroarch
     }
     install_moonlight() {
          sudo snap install moonlight
     }
     install_video_editor_live() {
          aptitude install obs-studio kdenlive -y
     }
     install_all_extra_packages() {
          msg 'Configuring repositories...'
          repo_it_tools
          repo_programming_applications
          repo_for_gamers
          system_update
          msg 'Installing all extra packages...'
          msg 'Installing design applications...'
          install_design_applications
          msg 'Installing programming applications...'
          install_programming_applications
          msg 'Installing IT tools...'
          install_it_tools
          msg 'Installing gamers applications...'
          install_for_gamers
          msg 'Installing video editor and live stream applications...'
          install_video_editor_live
     }
     choose_browser_options() {
         echo
         echo -e "${YELLOW}Choose a browser to install: ${RESET}"
         echo
         echo '1 - Google Chrome'
         echo '2 - Brave'
         echo '3 - Opera'
         echo '4 - Microsoft Edge'
         echo '5 - Install all browsers'
         echo 'q - Skip or quit'
         echo
         while true; do
            read -p "Enter your choices (separate with spaces, e.g., '2 3 5'): " browser

             for choice in $browser; do
                 case "$choice" in
                1)
                    msg 'Installing Google Chrome...'
                    install_google_chrome_browser
                    msg 'Google Chrome installed successfully!'
                    ;;
                2)
                    msg 'Installing Brave Browser...'
                    repo_brave_browser
                    repo_update
                    install_brave_browser
                    msg 'Brave Browser installed successfully!'
                    ;;
                3)
                    msg 'Installing Opera Browser...'
                    repo_opera_browser
                    repo_update
                    install_opera_browser
                    msg 'Opera Browser installed successfully!'
                    ;;
                4)
                    msg 'Installing Microsoft Edge...'
                    repo_edge_browser
                    repo_update
                    install_edge_browser
                    msg 'Microsoft Edge installed successfully!'
                    ;;
                5)
                    msg 'Setting up repositories...'
                    repo_brave_browser
                    repo_opera_browser
                    repo_edge_browser
                    repo_update
                    msg 'Installing browsers...'
                    install_google_chrome_browser
                    install_brave_browser
                    install_opera_browser
                    install_edge_browser
                    msg 'All browsers installed successfully!'
                    ;;
                q)
                   msg 'Skipping browser installation.'
                   break
                   ;;
                *)
                   error_msg 'Invalid option. Please choose a valid number or "q" to quit.'
                   ;;
             esac
          done
             msg 'Installation process finished. Exiting...'
             break 
         done
       }
       cd_dvd_burn_option() {
               echo
               echo -e "${YELLOW}Do you have a CD/DVD burner? (y/n) ${RESET}"
               echo
               while true; do
                  read choice
                  if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
                      msg 'Installing CD/DVD burn applications...'
                      install_cd_dvd_burn
                       msg 'CD/DVD burn applications installed successfully!'
                       break
                  fi
                  if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                       break
                  fi
             done
     }
     gpu_install_opt() {
        echo
         echo -e "${YELLOW}Choose the vendor of your GPU Card: ${RESET}"
         echo
         echo '1 - AMD'
         echo '2 - NVIDIA/Geforce'
         echo '3 - Intel'
         echo 'q - Skip or quit'
         echo
         while true; do
            read -p "Enter your choice: " gpu_vendor

             for choice in $gpu_vendor; do
                 case "$choice" in
                1)
                    msg 'Installing AMD GPU Drivers...'
                    wget https://repo.radeon.com/amdgpu-install/6.4.1/ubuntu/noble/amdgpu-install_6.4.60401-1_all.deb
                    sudo dpkg -i amdgpu-install_6.4.60401-1_all.deb
                    sudo rm -fr amdgpu-install*
                    msg 'GPU Drivers installed successfully!'
                    ;;
                2)
                    msg 'Installing NVIDIA GPU Drivers...'
                    sudo ubuntu-drivers autoinstal
                    msg 'GPU Drivers installed successfully!'
                    ;;
                3)
                   msg 'Installing Intel HD Grapics Drivers...'
                   sudo mkdir /etc/X11/xorg.conf.d/
                   sudo echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
                   msg 'GPU Drivers installed successfully!'
                   ;;
                q)
                   msg 'Skipping games installation.'
                   break
                   ;;
                *)
                   error_msg 'Invalid option. Please choose a valid number or "q" to quit.'
                   ;;
             esac
          done
             msg 'Installation process finished. Exiting...'
             break 
         done    
     }
     gpu_install_opt2() {
        echo
         echo -e "${YELLOW}Choose the vendor of your GPU Card: ${RESET}"
         echo
         echo '1 - AMD'
         echo '2 - NVIDIA/Geforce'
         echo '3 - Intel'
         echo 'q - Skip or quit'
         echo
         while true; do
            read -p "Enter your choice: " gpu_vendor

             for choice in $gpu_vendor; do
                 case "$choice" in
                1)
                    msg 'Installing AMD GPU Drivers...'
                    wget https://github.com/kevindexter22/GPU_Driver_Ubuntu/blob/main/amdgpu-install.deb
                    sudo dpkg -i amdgpu-install.deb
                    sudo rm -fr amdgpu-install.deb 
                    msg 'GPU Drivers installed successfully!'
                    ask_reboot
                    ;;
                2)
                    msg 'Installing NVIDIA GPU Drivers...'
                    sudo ubuntu-drivers autoinstal
                    msg 'GPU Drivers installed successfully!'
                    ask_reboot
                    ;;
                3)
                   msg 'Installing Intel HD Grapics Drivers...'
                   sudo mkdir /etc/X11/xorg.conf.d/
                   sudo echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
                   msg 'GPU Drivers installed successfully!'
                   ask_reboot
                   ;;
                q)
                    msg 'Skipping games installation.'
                   break
                   ;;
                *)
                   error_msg 'Invalid option. Please choose a valid number or "q" to quit.'
                   ;;
             esac
          done
             msg 'Installation process finished. Exiting...'
             break 
         done    
     }              
     install_for_gamers() {
         echo
         echo -e "${YELLOW}Choose what do you wanna install: ${RESET}"
         echo
         echo '1 - Steam'
         echo '2 - Lutris'
         echo '3 - Retroarch (for retro games)'
         echo '4 - Moonlight'
         echo '5 - Install all'
         echo 'q - Skip or quit'
         echo
         while true; do
            read -p "Enter your choices (separate with spaces, e.g., '2 3 5'): " game

             for choice in $game; do
                 case "$choice" in
                1)
                    msg 'Installing Steam...'
                    repo_for_steam
                    setup_architecture_i386
                    repo_update
                    install_steam
                    msg 'Steam installed successfully!'
                    ;;
                2)
                    msg 'Installing Lutris...'
                    install_lutris
                    msg 'Lutris installed successfully!'
                    ;;
                3)
                   msg 'Installing Retroarch...'
                   repo_for_gamers
                   repo_update
                   install_retroarch
                   msg 'Retroarch installed successfully!'
                   ;;    
                4)
                    msg 'Installing Moonlight...'
                    install_moonlight
                    msg ' Moonlight installed successfully!'
                    ;;
                5)
                    msg 'Installing all options...'
                    repo_for_gamers
                    repo_for_steam
                    setup_architecture_i386
                    repo_update
                    install_steam
                    install_lutris
                    install_retroarch
                    install_moonlight
                    msg 'All options installed successfully!'
                    ;;
                q)
                   msg 'Skipping games installation.'
                   break
                   ;;
                *)
                   error_msg 'Invalid option. Please choose a valid number or "q" to quit.'
                   ;;
             esac
          done
             msg 'Installation process finished. Exiting...'
             break 
         done
       }
       install_extra_packages_options() {
         echo
         echo -e "${YELLOW}Choose what packages do you want install: ${RESET}"
         echo
         echo '1  - Install all extra packages'
         echo '2  - Install basic design applications'
         echo '3  - Install basic IT tools'
         echo '4  - Install programming applications'
         echo '5  - Install gamers apps'
         echo '6  - Install video editor and live stream applications'
         echo '7 - Install flathub and gnome software'
         echo 'q - Skip or quit'
         echo
         while true; do
            read -p "Enter your choices (separate with spaces, e.g., '2 3 5'): " extra_pack

             for choice in $extra_pack; do
                 case "$choice" in
                     1)
                         install_all_extra_packages
                         msg 'All packages installed successfully!'
                         ;;
                     2)
                         msg 'Installing design applications...'
                         repo_update
                         install_design_applications
                         msg 'Design applications installed successfully!'
                         ;;
                     3)
                         msg 'Installing IT tools...'
                         repo_it_tools
                         repo_update
                         install_it_tools
                         msg 'IT tools installed successfully!'
                         ;;
                     4)
                         msg 'Installing programming applications...'
                         repo_programming_applications
                         repo_update
                         install_programming_applications
                         msg 'Programming applications installed successfully!'
                         ;;
                     5)
                         repo_update
                         install_for_gamers
                         msg 'Gamers apps installed successfully!'
                         ;;
                     6)
                         msg 'Installing video editor and live stream applications...'
                         repo_update
                         install_video_editor_live
                         msg 'Video editor and live stream applications installed successfully!'
                         ;;
                     7)
                         msg 'Setting flathub and gnome store...'
                         system_update
                         setup_flathub
                         msg 'Successfully configured!'
                         ;;
                     q)
                         msg 'Skipping installation.'
                         break
                         ;;
                     *)
                         msg 'Invalid choice: $choice'
                         ;;
                 esac
             done
	     
             msg 'Installation process finished. Exiting...'
             break 
         done
     }
	 choose_extra_packages() {
          echo
          echo -e "${YELLOW}Do you wish install extra application packages? ${RESET}"
          echo
          while true; do
             read -p 'Enter your option (y/n): ' ext_choice
             if [[ "$ext_choice" == 'y' || "$ext_choice" == 'Y' ]]; then
                   install_extra_packages_options
                   break
             fi
             if [[ "$ext_choice" == 'n' || "$ext_choice" == 'N' ]]; then
                   break
             fi
         done
       }

       ubuntu_pro_activate() {
               echo
               echo -e "${YELLOW}Do you wanna activate the Ubuntu Pro version? (y/n) ${RESET}"
               echo
               while true; do
                  read choice
                  if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
                       read -p 'Insert the token: ' ubuntu_pro_token
                       sudo pro attach $ubuntu_pro_token
                       dist_upgrade
                       msg 'Ubuntu Pro active successfully!'
                       break
                  fi
                  if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                       break
                  fi
             done
     }
     
     ubuntu_pro_activate_opt() {
               echo
               echo -e "${YELLOW}Do you wanna activate the Ubuntu Pro version? (y/n) ${RESET}"
               echo
               while true; do
                  read choice
                  if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
                       read -p 'Insert the token: ' ubuntu_pro_token
                       sudo pro attach $ubuntu_pro_token
                       dist_upgrade
                       msg 'Ubuntu Pro active successfully!'
                       msg 'Restart your computer to complete activation.'
                       ask_reboot
                       break
                  fi
                  if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                       break
                  fi
             done
     }
       
# ─────────────────────────────────────────────────────────────────────────────
# Download and Configuration folders and github repositories
# ─────────────────────────────────────────────────────────────────────────────
     dotfiles_repository_begginer_common() {
        echo
        echo -e "${YELLOW}Whats your user? ${RESET}"
        echo
        read -p 'Enter the username that you choose on system installation: ' user_common
        # Check if the user exists
        if id "$user_common" &>/dev/null; then
        sudo -u "$user_common" bash <<EOF
        msg 'Configuring the dotfiles...'
	git clone https://github.com/kevindexter22/dotfiles.git /home/$user_common/dotfiles
        git clone https://github.com/kevindexter22/.fonts.git /home/$user_common/.fonts
        git clone https://github.com/kevindexter22/.icon.git /home/$user_common/.icon
        cd /home/$user_common/dotfiles/
        mv /home/$user_common/.bashrc /home/$user_common/.ori.bashrc
        stow bash
        source /home/$user_common/.bashrc
        sudo fc-cache -fv
        msg 'creating folders to files organization...'
        msg  'Creating folders to Downloads...'
        mkdir /home/$user_common/Downloads/Torrent
        mkdir /home/$user_common/Downloads/Youtube
        mkdir /home/$user_common/Downloads/Apps
        mkdir /home/$user_common/Downloads/ISOs
        mkdir /home/$user_common/Downloads/Images
        mkdir /home/$user_common/Downloads/Work
        mkdir /home/$user_common/Downloads/Others
        mkdir /home/$user_common/Downloads/Music
        msg  'Creating folders to Documents...'
        mkdir /home/$user_common/Documents/VM\ Shared
        mkdir /home/$user_common/Documents/Scripts
        mkdir /home/$user_common/Documents/Scripts/PDF
        mkdir /home/$user_common/Documents/Scripts/PDF/Optimized
        mkdir /home/$user_common/Documents/Scripts/whois
	touch /home/$user_common/Documents/Scripts/whois/search_whois.txt
        msg 'Creating folders to Pictures...'
        mkdir /home/$user_common/Pictures/Google\ Photos
        mkdir /home/$user_common/Pictures/Personal\ Pictures
        mkdir /home/$user_common/Pictures/Internet\ Images
        mkdir /home/$user_common/.Wallpapers
        msg 'Configuration applied successfully!'
EOF
	else
        echo -e "${RED}User $user_common does not exist. ${RESET}"
        echo    
    fi
    }
    scripts_repository_common_begginer() {
        cd /
        cd /opt
        git clone https://github.com/kevindexter22/automation.git
        cd /opt/automation/
        rm -fr /opt/automation/scripts/scripts_pt-br
        stow scripts
        sudo chmod +x /opt/scripts/*.sh
        msg 'You can found scripts in /opt/scripts.'
        msg 'Configuration applied successfully!'
    }
    desktop_repository_common_begginer() {
        cd /
        cd /usr/share
        git clone https://github.com/kevindexter22/script_desktop.git
        cp -R /usr/share/script_desktop/* /usr/share/applications/
        cd /
        msg 'You can found scripts.desktop in applications menu.'
        msg 'Configuration applied successfully!'
    }
    dotfiles_repository_advanced_all() {
        echo
        echo -e "${YELLOW}Whats your user? ${RESET}"
        echo
        read -p 'Enter the username that you choose on system installation: ' user_common
        # Check if the user exists
        if id "$user_common" &>/dev/null; then
        sudo -u "$user_common" bash <<EOF
        msg 'Configuring the dotfiles...'
	git clone https://github.com/kevindexter22/dotfiles.git /home/$user_common/dotfiles
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        git clone https://github.com/kevindexter22/.fonts.git /home/$user_common/.fonts
        git clone https://github.com/kevindexter22/.icon.git /home/$user_common/.icon
	cd /home/$user_common/dotfiles/
        mv /home/$user_common/.bashrc /home/$user_common/.ori.bashrc
        stow bash
        stow alacritty
        stow tmux
        source /home/$user_common/.bashrc
        source /home/$user_common/.tmux.conf
        source /home/$user_common/.conf/alacritty/alacritty.toml
        sudo fc-cache -fv
        msg 'creating folders to files organization...'
        msg  'Creating folders to Downloads...'
        mkdir /home/$user_common/Downloads/Torrent
        mkdir /home/$user_common/Downloads/Youtube
        mkdir /home/$user_common/Downloads/Apps
        mkdir /home/$user_common/Downloads/ISOs
        mkdir /home/$user_common/Downloads/Images
        mkdir /home/$user_common/Downloads/Work
        mkdir /home/$user_common/Downloads/Others
        mkdir /home/$user_common/Downloads/Music
        msg  'Creating folders to Documents...'
        mkdir /home/$user_common/Documents/VM\ Shared
        mkdir /home/$user_common/Documents/Scripts
        mkdir /home/$user_common/Documents/Scripts/PDF
        mkdir /home/$user_common/Documents/Scripts/PDF/Optimized
        mkdir /home/$user_common/Documents/Scripts/whois
	touch /home/$user_common/Documents/Scripts/whois/search_whois.txt
        msg 'Creating folders to Pictures...'
        mkdir /home/$user_common/Pictures/Google\ Photos
        mkdir /home/$user_common/Pictures/Personal\ Pictures
        mkdir /home/$user_common/Pictures/Internet\ Images
        mkdir /home/$user_common/.Wallpapers
        msg 'Configuration applied successfully!'
EOF
	else
        echo "User $user_common does not exist."
        echo
    fi
    }
    scripts_repository_advanced_all() {
        cd /
        cd /opt
        git clone https://github.com/kevindexter22/automation.git
        cd /opt/automation/
        rm -fr /opt/automation/scripts/scripts_pt-br
        stow scripts
        sudo chmod +x /opt/scripts/*.sh
        msg 'You can found scripts in /opt/scripts.'
        msg 'Configuration applied successfully!'    
    }
    desktop_repository_advanced_all() {
        echo
        echo -e "${YELLOW}Do you wanna create script.desktop on applications menu? (y/n) ${RESET}"
        echo
          while true; do
          read desktop_choice
            if [[ "$desktop_choice" == 'y' || "$desktop_choice" == 'Y' ]]; then
                cd /
                cd /usr/share
                git clone https://github.com/kevindexter22/script_desktop.git
                cp -R /usr/share/script_desktop/* /usr/share/applications/
                cd /
                msg 'You can found scripts.desktop in applications menu.'
                msg 'Configuration applied successfully!'
                break
             fi
             if [[ "$desktop_choice" == 'n' || "$desktop_choice" == 'N' ]]; then
                break
            fi
          done
    }
 
# ─────────────────────────────────────────────────────────────────────────────
# Customized Configuration
# ─────────────────────────────────────────────────────────────────────────────
    ssh_port_configuration() {
        echo
        echo -e "${YELLOW}Choose a new SSH port access for security ${RESET}" 
        echo
        read -p 'Enter the port number to change or leave blank to default: ' ssh_port
        if [[ -n "$ssh_port" && "$ssh_port" =~ ^[0-9]+$ ]]; then
             echo "Configuring SSH to use port $ssh_port..."
        
             # Backup of configuration file
             sudo cp /etc/ssh/ssh_config /etc/ssh/sshd_config.bak
        
             # Change the ssh port on file.conf
             sudo sed -i "/^#Port 22/c\Port $ssh_port" /etc/ssh/sshd_config
	     sudo echo Port $ssh_port >> /etc/ssh/sshd_config

             # Restart service to apply change
             sudo systemctl restart ssh
             msg "SSH port updated to $ssh_port successfully!"
        else
             msg "No changes made to SSH configuration."
             msg "The ssh access will use port 22."
        fi
   }

# ─────────────────────────────────────────────────────────────────────────────
# Disable suspend
# ─────────────────────────────────────────────────────────────────────────────

   disable_suspend_configuration_systemd() {
             msg 'Disabling suspend and hibernation via systemd'
             sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
             
             # Backup of configuration file
             sudo cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak
        
             # Change the settings on file.conf
	     sudo echo HandleLidSwitch=ignore >> /etc/systemd/logind.conf
             sudo echo HandleLidSwitchDocked=ignore >> /etc/systemd/logind.conf
             
             msg 'Settings applyed successfully!'
   }
   
# ─────────────────────────────────────────────────────────────────────────────
# Restart function
# ─────────────────────────────────────────────────────────────────────────────

    ask_reboot() {
      echo
      echo -e "${YELLOW}Want to restart now? ${RESET}"
      echo
      while true; do
         read -p 'Enter your option (y/n): ' choice
         if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
                   reboot
                   exit 0
         fi
         if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                   break
         fi
     done
    }

# ─────────────────────────────────────────────────────────────────────────────
# Message function
# ─────────────────────────────────────────────────────────────────────────────

    msg() {
        tput setaf 2
        echo "[*] $1"
        tput sgr0
    }

    error_msg() {
       tput setaf 1
       echo "[!] $1"
       tput sgr0
    }

# ─────────────────────────────────────────────────────────────────────────────
# Show banner and menu
# ─────────────────────────────────────────────────────────────────────────────

    print_banner() {
        echo -e "${GREEN}
        
 ╔════════════════════════════════════════════════════════════════════════╗
 ║                  Post Installation Setup                               ║
 ║                                                                        ║
 ║                                                                        ║
 ║ By: Kevin Oliveira                                                     ║
 ║ Script version: 3.0                                                    ║
 ╚════════════════════════════════════════════════════════════════════════╝
    
        ${RESET}"
    }

    show_menu() {
        echo -e "${ORANGE}Choose what to do: ${RESET}"
        echo
        echo -e "${ORANGE}Configuration profiles: ${RESET}"
        echo '1  - Apply all settings' 
        echo '2  - Setup for common users'
        echo '3  - Setup for advanced users'
        echo '4  - Setup for begginer users'
        echo -e "${ORANGE}Customization options: ${RESET}"
        echo '5  - Disable terminal ads (LTS versions)'
        echo '6  - Unlock more options on startup manager'
        echo -e "${ORANGE}Application packages: ${RESET}"
        echo '7  - Install extra application packages'
        echo -e "${ORANGE}Optional settings: ${RESET}"
        echo '8  - Activate ubuntu pro version'
        echo '9  - Disable suspend and hibernation via systemd (for older computers)'
        echo '10 - Install GPU Drivers'
        echo 'q  - Exit'
        echo
    }

# ─────────────────────────────────────────────────────────────────────────────
# Functions of the script task execution
# ─────────────────────────────────────────────────────────────────────────────

    main() {
       check_root_user
       while true; do
         print_banner
         show_menu
         read -p 'Enter your choice: ' choice
         case $choice in
         1)
             auto
             msg 'Settings applied successfully!'
             ask_reboot
             ;;
         2)
             common_user
             msg 'Settings applied successfully!'
             ask_reboot
             ;;
         3)
             advanced_user
             msg 'Settings applied successfully!'
             ask_reboot
             ;;
         4)
             begginer_user
             msg 'Settings applied successfully!'
             ask_reboot
             ;;
         5)
             msg 'Disabling Terminal ADS...'
             disable_terminal_ads
             msg 'ADS disabled successfully!'
             ;;
         6)
             msg 'Unlocking options on startup manager...'
             startup_manager
             msg 'Unlocked options successfully!'
             ;;
         7)
             install_extra_packages_options
             ;;             
         8)
             ubuntu_pro_activate_opt
             ;;
         9)
             disable_suspend_configuration_systemd
             ask_reboot
             ;;
         10)
             gpu_install_opt2
             ;;
         q)
             msg 'See you soon!'
             exit 0
             ;;
         *)
             error_msg 'Invalid option. Please choose a valid number or "q" to quit.'
         esac
       done

    }
        
    auto() {
	msg 'Update repository...'
        repo_update
        msg 'Installing tools to add repositories...'
        install_repo_tools
        msg 'setting up repositories...'
        repo_it_tools
	repo_programming_applications
	repo_for_gamers
	repo_for_steam
	setup_architecture_i386
        msg 'Update repository...'
        repo_update
        msg 'Setting up flathub'
        setup_flathub
        msg 'Updating applications...'
        system_update
        msg 'Upgrading system...'
        dist_upgrade
        msg 'Removing terminal ads (if they are enable)...'
        disable_terminal_ads
        msg 'Installing additional drivers...'
        gpu_install_opt
	msg 'Installing essentials tools...'
        install_essentials_tools
	msg 'Installing advanced tools...'
        install_advanced_tools
        msg 'Installing basic applications...'
        install_basic_applications
        choose_browser_options
        cd_dvd_burn_option
	msg 'Installing design applications...'
        install_design_applications
        msg 'Installing IT applications...'
        install_it_tools
        msg 'Installing programming applications...'
        install_programming_applications
        msg 'Installing video applications...'
        install_video_editor_live
        msg 'Installing games store and emulators...'
        install_for_gamers
        msg 'Ubuntu pro activate...'
        ubuntu_pro_activate
	msg 'Updating applications...'
        system_update
        msg 'Updating snap packages...'
        snap_update
        msg 'Updating flatpak packages...'
        flatpak_update
        msg 'Unlocking more options on startup manager...'
        startup_manager
        msg 'SSH configuration...'
        ssh_port_configuration
        msg 'configuring the system...'
        dotfiles_repository_advanced_all
        msg 'Downloading automation scripts...'
        scripts_repository_advanced_all
        msg 'Downloading scripts.desktop...'
        desktop_repository_advanced_all
        msg 'Cleaning up...'
        cleanup
    }

    common_user() {
        msg 'Updating repositories...'
        repo_update
        msg 'Installing tools to add repositories...'
        install_repo_tools
        msg 'Setting up flathub...'
        setup_flathub
        msg 'Removing terminal ads (if they are enable)...'
        disable_terminal_ads
        msg 'Installing additional drivers...'
        gpu_install_opt
        msg 'Installing essentials tools...'
        install_essentials_tools
        msg 'Installing basic applications...'
        install_basic_applications
        choose_browser_options
        cd_dvd_burn_option
        msg 'Updating applications...'
        system_update
        msg 'Updating snap packages...'
        snap_update
        msg 'Updating flatpak packages...'
        flatpak_update
        msg 'Unlocking more options on startup manager...'
        startup_manager
        msg 'SSH configuration...'
        ssh_port_configuration
        choose_extra_packages
        msg 'configuring the system...'
        dotfiles_repository_begginer_common
        msg 'Downloading automation scripts...'
        scripts_repository_common_begginer
        msg 'Downloading scripts.desktop...'
        desktop_repository_common_begginer
        msg 'Cleaning up...'
        cleanup
    }
    advanced_user() {
        msg 'Updating repositories...'
        repo_update
        msg 'Installing tools to add repositories...'
        install_repo_tools
        msg 'Setting up flathub...'
        setup_flathub
        msg 'Removing terminal ads (if they are enable)...'
        disable_terminal_ads
        msg 'Installing additional drivers...'
        gpu_install_opt
        msg 'Installing essentials tools...'
        install_essentials_tools
	msg 'Installing advanced tools...'
        install_advanced_tools
        msg 'Installing basic applications...'
        install_basic_applications
        choose_browser_options
        cd_dvd_burn_option
        msg 'Updating applications...'
        system_update
        msg 'Updating snap packages...'
        snap_update
        msg 'Updating flatpak packages...'
        flatpak_update
        msg 'Unlocking more options on startup manager...'
        startup_manager
        msg 'SSH configuration...'
        ssh_port_configuration
        choose_extra_packages
        msg 'configuring the system...'
        dotfiles_repository_advanced_all
        msg 'Downloading automation scripts...'
        scripts_repository_advanced_all
        msg 'Downloading scripts.desktop...'
        desktop_repository_advanced_all
        msg 'Cleaning up...'
        cleanup
    }
    begginer_user() {
        msg 'Updating repositories...'
        repo_update
        msg 'Installing tools to add repositories...'
        install_repo_tools
        msg 'Setting up flathub...'
        setup_flathub
        msg 'Removing terminal ads (if they are enable)...'
        disable_terminal_ads
        msg 'Installing additional drivers...'
        gpu_install_opt
        msg 'Installing essentials tools...'
        install_essentials_tools
        msg 'Installing basic applications...'
        install_basic_applications
        choose_browser_options
        cd_dvd_burn_option
        msg 'Updating applications...'
        system_update
        msg 'Updating snap packages...'
        snap_update
        msg 'Updating flatpak packages...'
        flatpak_update
        msg 'Unlocking more options on startup manager...'
        startup_manager
        msg 'SSH configuration...'
        ssh_port_configuration
        choose_extra_packages
        msg 'configuring the system...'
        dotfiles_repository_begginer_common
        msg 'Downloading automation scripts...'
        scripts_repository_common_begginer
        msg 'Downloading scripts.desktop...'
        desktop_repository_common_begginer
        msg 'Cleaning up...'
        cleanup
    }
    
    (return 2> /dev/null) || main
