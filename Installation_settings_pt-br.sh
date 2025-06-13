#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────────────────────────
# Declarando Variáveis
# ─────────────────────────────────────────────────────────────────────────────

# ──────────────────────
# Cores
# ──────────────────────

RED='\033[0;31m'

GREEN='\033[0;32m'

YELLOW='\033[0;33m'

ORANGE='\033[1;33m'    # Cor próxima ao laranja

MAGENTA='\033[1;35m'

BLUE='\033[0;34m'

GRAY='\033[1;30m'

RESET='\033[0m' 

# ─────────────────────────────────────────────────────────────────────────────
# Função para validar se o script está rodando como root
# ─────────────────────────────────────────────────────────────────────────────

    check_root_user() {
        if [ "$(id -u)" != 0 ]; then
           echo -e "${RED}Por favor, rode esse script como root root!${RESET}"
           echo -e "${RED}Precisaremos executar alguns como administrador${RESET}"
           exit 1
        fi
    }

# ─────────────────────────────────────────────────────────────────────────────
# Funções de atualização
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
# Desabilitando ADS no terminal Ubuntu Pro
# ─────────────────────────────────────────────────────────────────────────────

    disable_terminal_ads() {
        sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
        pro config set apt_news=false
    }

# ─────────────────────────────────────────────────────────────────────────────
# Função de limpeza
# ─────────────────────────────────────────────────────────────────────────────

    cleanup() {
        apt autoremove -y
    }

# ─────────────────────────────────────────────────────────────────────────────
# Configurando flathub para instalar pacotes flatpak
# ─────────────────────────────────────────────────────────────────────────────

    setup_flathub() {
         apt install flatpak -y
         flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
         apt install --install-suggests gnome-software -y
    }

# ─────────────────────────────────────────────────────────────────────────────
# Desbloqueando opções no gerenciador de inicialização
# ─────────────────────────────────────────────────────────────────────────────

    startup_manager() {
         sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop
    }

# ─────────────────────────────────────────────────────────────────────────────
# Adicionando repositórios de terceiros
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
# Instalando aplicativos e ferramentas
# ─────────────────────────────────────────────────────────────────────────────
    install_repo_tools() {
       apt install curl apt-transport-https software-properties-common -y
    }
    install_essentials_tools() {
        apt install aptitude htop net-tools snapd gparted cpu-x gdebi git tesseract-ocr poppler-utils whois vim binutils preload default-jdk ubuntu-restricted-extras stow traceroute ssh dnsutils mtr iperf3 f3 nload gnupg2 ca-certificates tree gnome-calendar setserial cu -y
        flatpak install https://dl.flathub.org/repo/appstream/org.gnome.Snapshot.flatpakref -y
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
          msg 'Configurando repositórios...'
          repo_it_tools
          repo_programming_applications
          repo_for_gamers
          system_update
          msg 'Instalando todos os pacotes extras...'
          msg 'Instalando aplicativos de design...'
          install_design_applications
          msg 'Instalando aplicativos de programação...'
          install_programming_applications
          msg 'Instalando ferramentas de TI...'
          install_it_tools
          msg 'Instalando aplicativos para gamers...'
          install_for_gamers
          msg 'Instalando aplicativos de edição de vídeo e streaming...'
          install_video_editor_live
     }
     choose_browser_options() {
         echo
         echo -e "${YELLOW}Escolha um navegador para instalar: ${RESET}"
         echo
         echo '1 - Google Chrome'
         echo '2 - Brave'
         echo '3 - Opera'
         echo '4 - Microsoft Edge'
         echo '5 - Instalar todos os navegadores'
         echo 's - pular ou sair'
         echo
         while true; do
            read -p "Digite suas escolhas (separadas com espaço, ex: 2 3 5): " browser

             for choice in $browser; do
                 case "$choice" in
                1)
                    msg 'Instalando Google Chrome...'
                    install_google_chrome_browser
                    msg 'Google Chrome instalado com sucesso!'
                    ;;
                2)
                    msg 'Instalando navegador Brave...'
                    repo_brave_browser
                    repo_update
                    install_brave_browser
                    msg 'Brave instalado com sucesso!'
                    ;;
                3)
                    msg 'Instalando o navegador Opera...'
                    repo_opera_browser
                    repo_update
                    install_opera_browser
                    msg 'Opera instalado com successo!'
                    ;;
                4)
                    msg 'Instalando o Microsoft Edge...'
                    repo_edge_browser
                    repo_update
                    install_edge_browser
                    msg 'Microsoft Edge instalado com sucesso!'
                    ;;
                5)
                    msg 'Configurando os repositórios...'
                    repo_brave_browser
                    repo_opera_browser
                    repo_edge_browser
                    repo_update
                    msg 'Instalando os navegadores...'
                    install_google_chrome_browser
                    install_brave_browser
                    install_opera_browser
                    install_edge_browser
                    msg 'Navegadores instalados com sucesso!'
                    ;;
                s)
                   msg 'Pulando a instalação dos navegadores.'
                   break
                   ;;
                *)
                   error_msg 'Opção inválida. Escolha um dos números ou "s" para sair.'
                   ;;
             esac
          done
               msg 'Processo de instalação finalizado. Saindo...'
             break 
         done
       }
       cd_dvd_burn_option() {
               echo
               echo -e "${YELLOW}Você tem gravador de CD/DVD? (s/n) ${RESET}"
               echo
               while true; do
                  read choice
                  if [[ "$choice" == 's' || "$choice" == 'S' ]]; then
                      msg 'Instalando gravadores de CD/DVD...'
                      install_cd_dvd_burn
                       msg 'Gravadores de CD/DVD instalados com sucesso!'
                       break
                  fi
                  if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                       break
                  fi
             done
     }
     gpu_install_opt() {
        echo
         echo -e "${YELLOW}Escolha o fabricante da sua Placa Grágica (GPU): ${RESET}"
         echo
         echo '1 - AMD'
         echo '2 - NVIDIA/Geforce'
         echo '3 - Intel'
         echo 's - Pular ou sair'
         echo
         while true; do
            read -p "Digite sua opção: " gpu_vendor

             for choice in $gpu_vendor; do
                 case "$choice" in
                1)
                    msg 'Instalando drivers da AMD...'
                    wget https://repo.radeon.com/amdgpu-install/6.4.1/ubuntu/noble/amdgpu-install_6.4.60401-1_all.deb
                    sudo dpkg -i amdgpu-install_6.4.60401-1_all.deb
                    sudo rm -fr amdgpu-install* 
                    msg 'Drivers instalados com sucesso!'
                    ;;
                2)
                    msg 'Instalando drivers da NVIDIA/Geforce...'
                    sudo ubuntu-drivers autoinstal
                    msg 'Drivers instalados com sucesso!'
                    ;;
                3)
                   msg 'Installing Intel HD Grapics Drivers...'
                   sudo mkdir /etc/X11/xorg.conf.d/
                   sudo echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
                   msg 'GPU Drivers installed successfully!'
                   ;;
                s)
                   msg 'Pulando a instalação.'
                   break
                   ;;
                *)
                   error_msg 'Opção inválida. Por favor, digite um número válido ou "s" para sair.'
                   ;;
             esac
          done
             msg 'Processo de instalação finalizado. Saindo...'
             break 
         done    
     }
     gpu_install_opt2() {
        echo
         echo -e "${YELLOW}Escolha o fabricante do GPU: ${RESET}"
         echo
         echo '1 - AMD'
         echo '2 - NVIDIA/Geforce'
         echo '3 - Intel'
         echo 's - Pular ou sair'
         echo
         while true; do
            read -p "Digite sua opção: " gpu_vendor

             for choice in $gpu_vendor; do
                 case "$choice" in
                1)
                    msg 'Instalando drivers da AMD...'
                    wget https://github.com/kevindexter22/GPU_Driver_Ubuntu/blob/main/amdgpu-install.deb
                    sudo dpkg -i amdgpu-install.deb
                    sudo rm -fr amdgpu-install.deb 
                    msg 'Drivers instalados com sucesso!'
                    ask_reboot
                    ;;
                2)
                    msg 'Instalando drivers da NVIDIA/Geforce...'
                    sudo ubuntu-drivers autoinstal
                    msg 'Drivers instalados com sucesso!'
                    ask_reboot
                    ;;
                3)
                   msg 'Installing Intel HD Grapics Drivers...'
                   sudo mkdir /etc/X11/xorg.conf.d/
                   sudo echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
                   msg 'GPU Drivers installed successfully!'
                   ask_reboot
                   ;;
                s)
                   msg 'Pulando a instalação.'
                   break
                   ;;
                *)
                   error_msg 'Opção inválida. Por favor, digite um número válido ou "s" para sair.'
                   ;;
             esac
          done
             msg 'Processo de instalação finalizado. Saindo...'
             break 
         done    
     }
     install_for_gamers() {
         echo
         echo -e "${YELLOW}Escolha o que gostaria de instalar: ${RESET}"
         echo
         echo '1 - Steam'
         echo '2 - Lutris'
         echo '3 - Retroarch (para retro games)'
         echo '4 - Moonlight'
         echo '5 - Instalar tudo'
         echo 's - pular ou sair'
         echo
          while true; do
            read -p "Digite suas escolhas (separadas com espaço, ex: 2 3 5): " game

             for choice in $game; do
                 case "$choice" in
                1)
                    msg 'Instalando Steam...'
                    repo_for_steam
                    setup_architecture_i386
                    repo_update
                    install_steam
                    msg 'Steam instalada com sucesso!'
                    ;;
                2)
                    msg 'Instalando Lutris...'
                    install_lutris
                    msg 'Lutris instalado com sucesso!'
                    ;;
                3)
                   msg 'Instalando Retroarch...'
                   repo_for_gamers
                   repo_update
                   install_retroarch
                   msg 'Retroarch instalado com sucesso!'
                   ;;    
                4)
                    msg 'Instalando Moonlight...'
                    install_moonlight
                    msg ' Moonlight instalado com sucesso!'
                    ;;
                5)
                    msg 'Instalando todas as opções...'
                    repo_for_gamers
                    repo_for_steam
                    setup_architecture_i386
                    repo_update
                    install_steam
                    install_lutris
                    install_retroarch
                    install_moonlight
                    msg 'Todas as opções foram instaladas com sucesso!'
                    ;;
                s)
                   msg 'Pulando a instalação dos aplicativos de jogos.'
                   break
                   ;;
                *)
                   error_msg 'Opção inválida. Selecione um número ou "s" para sair.'
                   ;;
             esac
          done
               msg 'Processo de instalação finalizado. Saindo...'
             break 
         done
       }
       install_extra_packages_options() {
         echo
         echo -e "${YELLOW}Escolha os pacotes adicionais que deseja instalar: ${RESET}"
         echo
         echo '1 - Instalar todos os pacotes'
         echo '2 - Instalar pacote básico de design'
         echo '3 - Instalar ferramentas básicas de TI'
         echo '4 - Instalar aplicativos de programação'
         echo '5 - Instalar aplicativos para gamers'
         echo '6 - Instalar editores de video e ferramentas de stream'
         echo '7 - Instalar flathub and gnome software'
         echo 's - Pular ou sair'
         echo
         while true; do
            read -p "Digite suas escolhas (separadas com espaço, ex: 2 3 5): " extra_pack

             for choice in $extra_pack; do
                 case "$choice" in
                     1)
                         install_all_extra_packages
                         msg 'Todos os pacotes foram instalados com sucesso!'
                         ;;
                     2)
                         msg 'Installing design applications...'
                         repo_update
                         install_design_applications
                         msg 'Aplicativos básicos de design instalados com sucesso!'
                         ;;
                     3)
                         msg 'Instalando ferramentas de TI...'
                         repo_it_tools
                         repo_update
                         install_it_tools
                         msg 'Ferramentas de TI instaladas com sucesso!'
                         ;;
                     4)
                         msg 'Instalando aplicativos de programação...'
                         repo_programming_applications
                         repo_update
                         install_programming_applications
                         msg 'Aplicativos de programação instalados com sucesso!'
                         ;;
                     5)
                         repo_update
                         install_for_gamers
                         msg 'Aplicativos gamers instalados com sucesso!'
                         ;;
                     6)
                         msg 'Instalando aplicativos de edição de vídeo e streaming...'
                         repo_update
                         install_video_editor_live
                         msg 'Aplicativos instalados com sucesso!'
                         ;;
                     7)
                         msg 'Configurando flathub and gnome store...'
                         system_update
                         setup_flathub
                         msg 'Configurados com sucesso!'
                         ;;
                     s)
                         msg 'Pulando a instalação...'
                         break
                         ;;
                     *)
                         msg 'Escolha inválida: $choice'
                         ;;
                 esac
             done
	     
             msg 'Processo de instalação finalizado. Saindo...'
             break 
         done
     }
	 choose_extra_packages() {
          echo
          echo -e "${YELLOW}Você deseja instalar pacotes de aplicativos adicionais? ${RESET}"
          echo
          while true; do
             read -p 'Digite sua escolha (s/n): ' ext_choice
             if [[ "$ext_choice" == 's' || "$ext_choice" == 'S' ]]; then
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
               echo -e "${YELLOW}Você quer ativar a versão Pro do Ubuntu? (s/n) ${RESET}"
               echo
               while true; do
                  read choice
                  if [[ "$choice" == 's' || "$choice" == 'S' ]]; then
                       read -p 'Insira o token: ' ubuntu_pro_token
                       sudo pro attach $ubuntu_pro_token
                       dist_upgrade
                       msg 'Ubuntu Pro ativado com sucesso!'
                       break
                  fi
                  if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                       break
                  fi
             done
     }
     ubuntu_pro_activate_opt() {
               echo
               echo -e "${YELLOW}Você quer ativar a versão Pro do Ubuntu? (s/n) ${RESET}"
               echo
               while true; do
                  read choice
                  if [[ "$choice" == 's' || "$choice" == 'S' ]]; then
                       read -p 'Insira o token: ' ubuntu_pro_token
                       sudo pro attach $ubuntu_pro_token
                       dist_upgrade
                       msg 'Ubuntu Pro ativado com sucesso!'
                       msg 'Reinicie seu computador para concluir a ativação.'
                       ask_reboot
                       break
                  fi
                  if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                       break
                  fi
             done
     }
       
# ─────────────────────────────────────────────────────────────────────────────
# Download e configuração de pastas e repositórios
# ─────────────────────────────────────────────────────────────────────────────
     dotfiles_repository_begginer_common() {
        echo
        echo -e "${YELLOW}Qual é o seu usuário? ${RESET}"
        echo
        read -p 'Digite o nome de usuário configurado na instalação do sistema: ' user_common
        # Check if the user exists
        if id "$user_common" &>/dev/null; then
        sudo -u "$user_common" bash <<EOF
        msg 'Configurando os dotfiles...'
	git clone https://github.com/kevindexter22/dotfiles.git /home/$user_common/dotfiles
        git clone https://github.com/kevindexter22/.fonts.git /home/$user_common/.fonts
        git clone https://github.com/kevindexter22/.icon.git /home/$user_common/.icon
        cd /home/$user_common/dotfiles/
        mv /home/$user_common/.bashrc /home/$user_common/.ori.bashrc
        stow bash
        source /home/$user_common/.bashrc
        sudo fc-cache -fv
        msg 'criando pastas para organização dos seus arquivos...'
        msg  'Criando pastas em Downloads...'
        mkdir /home/$user_common/Downloads/Torrent
        mkdir /home/$user_common/Downloads/Youtube
        mkdir /home/$user_common/Downloads/Aplicativos
        mkdir /home/$user_common/Downloads/ISOs
        mkdir /home/$user_common/Downloads/Imagens
        mkdir /home/$user_common/Downloads/Trabalho
        mkdir /home/$user_common/Downloads/Outros
        mkdir /home/$user_common/Downloads/Música
        msg  'Criando pastas em Documentos...'
        mkdir /home/$user_common/Documentos/VM\ Shared
        mkdir /home/$user_common/Documentos/Scripts
        mkdir /home/$user_common/Documentos/Scripts/PDF
        mkdir /home/$user_common/Documentos/Scripts/PDF/Otimizados
        mkdir /home/$user_common/Documentos/Scripts/whois
	touch /home/$user_common/Documentos/Scripts/whois/search_whois.txt
        msg 'Criando pastas para Imagens...'
        mkdir /home/$user_common/Imagens/Google\ Photos
        mkdir /home/$user_common/Imagens/Fotos
        mkdir /home/$user_common/Imagens/Imagens\ da\ Internet
        mkdir /home/$user_common/.Wallpapers
        msg 'Configurações aplicadas com sucesso!'
EOF
	else
        echo -e "${RED}O usuário $user_common não existe. ${RESET}"
        echo    
    fi
    }
    scripts_repository_common_begginer() {
        cd /
        cd /opt
        git clone https://github.com/kevindexter22/automation.git
        cd /opt/automation/
        rm -fr /opt/automation/scripts/scripts
        mv /opt/automation/scripts/scripts_pt-br /opt/automation/scripts/scripts
        stow scripts
        sudo chmod +x /opt/scripts/*.sh
        msg 'Você irá encontrar os scripts na pasta /opt/scripts.'
        msg 'Configuração aplicada com sucesso!'
    }
    desktop_repository_common_begginer() {
        cd /
        cd /usr/share
        git clone https://github.com/kevindexter22/script_desktop.git
        cp -R /usr/share/script_desktop/* /usr/share/applications/
        cd /
        msg 'Você irá encontrar o atalho dos scripts no menu de aplicativos.'
        msg 'Configuração aplicada com sucesso!'
    }
    dotfiles_repository_advanced_all() {
        echo
        echo -e "${YELLOW}Qual é o seu usuário? ${RESET}"
        echo
        read -p 'Digite o nome de usuário configurado na instalação do sistema: ' user_common
        # Check if the user exists
        if id "$user_common" &>/dev/null; then
        sudo -u "$user_common" bash <<EOF
        msg 'Configurando os dotfiles...'
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
        msg 'criando pastas para organização dos seus arquivos...'
        msg  'Criando pastas em Downloads...'
        mkdir /home/$user_common/Downloads/Torrent
        mkdir /home/$user_common/Downloads/Youtube
        mkdir /home/$user_common/Downloads/Aplicativos
        mkdir /home/$user_common/Downloads/ISOs
        mkdir /home/$user_common/Downloads/Imagens
        mkdir /home/$user_common/Downloads/Trabalho
        mkdir /home/$user_common/Downloads/Outros
        mkdir /home/$user_common/Downloads/Música
        msg  'Criando pastas em Documentos...'
        mkdir /home/$user_common/Documentos/VM\ Shared
        mkdir /home/$user_common/Documentos/Scripts
        mkdir /home/$user_common/Documentos/Scripts/PDF
        mkdir /home/$user_common/Documentos/Scripts/PDF/Otimizados
        mkdir /home/$user_common/Documentos/Scripts/whois
	touch /home/$user_common/Documentos/Scripts/whois/search_whois.txt
        msg 'Criando pastas para Imagens...'
        mkdir /home/$user_common/Imagens/Google\ Photos
        mkdir /home/$user_common/Imagens/Fotos
        mkdir /home/$user_common/Imagens/Imagens\ da\ Internet
        mkdir /home/$user_common/.Wallpapers
        msg 'Configurações aplicadas com sucesso!'
EOF
	else
        echo "O usuário $user_common não existe."
        echo
    fi
    }
    scripts_repository_advanced_all() {
        cd /
        cd /opt
        git clone https://github.com/kevindexter22/automation.git
        cd /opt/automation/
        rm -fr /opt/automation/scripts/scripts
        mv /opt/automation/scripts/scripts_pt-br /opt/automation/scripts/scripts
        stow scripts
        sudo chmod +x /opt/scripts/*.sh
        msg 'Você irá encontrar os scripts na pasta /opt/scripts.'
        msg 'Configuração aplicada com sucesso!'    
    }
    desktop_repository_advanced_all() {
        echo
        echo -e "${YELLOW}Gostaria de criar os atalhos dos scripts no menu de aplicativos? (s/n) ${RESET}"
        echo
          while true; do
          read desktop_choice
            if [[ "$desktop_choice" == 's' || "$desktop_choice" == 'S' ]]; then
                cd /
                cd /usr/share
                git clone https://github.com/kevindexter22/script_desktop.git
                cp -R /usr/share/script_desktop/* /usr/share/applications/
                cd /
                msg 'Você irá encontrar o atalho dos scripts no menu de aplicativos.'
                msg 'Configuração aplicada com sucesso!'
                break
             fi
             if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                break
            fi
          done
    }
 
# ─────────────────────────────────────────────────────────────────────────────
# Configurações personalizadas
# ─────────────────────────────────────────────────────────────────────────────
    ssh_port_configuration() {
        echo
        echo -e "${YELLOW}Escolha uma nova porta para acesso SSH por segurança! ${RESET}" 
        echo
        read -p 'Digite a porta para mudar ou deixe em branco para manter a padrão: ' ssh_port
        if [[ -n "$ssh_port" && "$ssh_port" =~ ^[0-9]+$ ]]; then
             echo "Configurando o SSH para usar a porta $ssh_port..."
        
             # Backup of configuration file
             sudo cp /etc/ssh/ssh_config /etc/ssh/sshd_config.bak
        
             # Change the ssh port on file.conf
             sudo sed -i "/^#Port 22/c\Port $ssh_port" /etc/ssh/sshd_config
			 sudo echo Port $ssh_port >> /etc/ssh/sshd_config

             # Restart service to apply change
             sudo systemctl restart ssh
             msg "Porta do SSH alterada para $ssh_port com successo!"
        else
             msg "Sem mudanças para fazer na configuração do SSH."
             msg "O protocolo SSH usará a porta 22."
        fi
   }
   
# ─────────────────────────────────────────────────────────────────────────────
# Disable suspend
# ─────────────────────────────────────────────────────────────────────────────

   
      disable_suspend_configuration_systemd() {
             msg 'Desabilitando a suspenção e a hibernação via systemd'
             sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
             
             # Backup of configuration file
             sudo cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak
        
             # Change the settings on file.conf
	     sudo echo HandleLidSwitch=ignore >> /etc/systemd/logind.conf
             sudo echo HandleLidSwitchDocked=ignore >> /etc/systemd/logind.conf
             
             msg 'Configuração aplicada com sucesso!'
   }
   
# ─────────────────────────────────────────────────────────────────────────────
# Reiniciar a máquina
# ─────────────────────────────────────────────────────────────────────────────

    ask_reboot() {
      echo
      echo -e "${YELLOW}Deseja reiniciar agora? ${RESET}"
      echo
      while true; do
         read -p 'Digite sua opção (s/n): ' choice
         if [[ "$choice" == 's' || "$choice" == 'S' ]]; then
                   reboot
                   exit 0
         fi
         if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
                   break
         fi
     done
    }

# ─────────────────────────────────────────────────────────────────────────────
# Função de mensagem
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
# Mostrar banner e menu
# ─────────────────────────────────────────────────────────────────────────────

    print_banner() {
        echo -e "${GREEN}
        
 ╔════════════════════════════════════════════════════════════════════════╗
 ║                  Script de Pós Instalação                              ║
 ║                                                                        ║
 ║                                                                        ║
 ║ Feito por: Kevin Oliveira                                              ║
 ║ Versão do script: 3.0                                                  ║
 ╚════════════════════════════════════════════════════════════════════════╝
    
        ${RESET}"
    }

    show_menu() {
        echo -e "${ORANGE}Selecione o que deseja fazer: ${RESET}"
        echo
        echo -e "${ORANGE}Perfis de Configuração: ${RESET}"
        echo '1  - Aplicar todas as configurações' 
        echo '2  - Configurar para um usuário comum'
        echo '3  - Configurar para um usuário avançado'
        echo '4  - Configurar para um usuário iniciante'
        echo -e "${ORANGE}Opções de Personalização: ${RESET}"
        echo '5  - Desabilitar ADS no terminal (Versões LTS)'
        echo '6  - Desbloquear mais opções no gerenciador de inicialização'
        echo -e "${ORANGE}Pacotes de Aplicativos: ${RESET}"
        echo '7  - Instalar pacotes de aplicativos adicionais'
        echo -e "${ORANGE}Configurações Opcionais: ${RESET}"
        echo '8  - Ativar a versão pro do ubuntu'
        echo '9  - Desabilitar hibernação e suspensão via systemd (para computadores antigos)'
        echo '10 - Instalar drivers da Placa Gráfica (GPU)'
        echo 's  - Sair'
        echo
    }

# ─────────────────────────────────────────────────────────────────────────────
# Funções para o script executar as tarefas
# ─────────────────────────────────────────────────────────────────────────────

    main() {
       check_root_user
       while true; do
         print_banner
         show_menu
         read -p 'Digite sua escolha: ' choice
         case $choice in
         1)
             auto
             msg 'Configurações aplicadas com sucesso!'
             ask_reboot
             ;;
         2)
             common_user
             msg 'Configurações aplicadas com sucesso!'
             ask_reboot
             ;;
         3)
             advanced_user
             msg 'Configurações aplicadas com sucesso!'
             ask_reboot
             ;;
         4)
             begginer_user
             msg 'Configurações aplicadas com sucesso!'
             ask_reboot
             ;;
         5)
             msg 'Desabilitando ADS no terminal...'
             disable_terminal_ads
             msg 'ADS desabilitado com sucesso!'
             ;;
         6)
             msg 'Desbloqueando opções no gerenciador de inicialização...'
             startup_manager
             msg 'Opções desbloqueadas com sucesso!'
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
         s)
             msg 'Até mais!'
             exit 0
             ;;
         *)
             error_msg 'Opção inválida. Por favor, escolha um número ou "s" para sair.'
         esac
       done

    }
        
    auto() {
	msg 'Atualizando os repositórios...'
        repo_update
        msg 'Instalando ferramentas para adicionar repositórios...'
        install_repo_tools
	msg 'Configurando os repositórios...'
        repo_it_tools
        repo_programming_applications
	repo_for_gamers
	repo_for_steam
        setup_architecture_i386
        msg 'Atualizando os repositórios...'
        repo_update
        msg 'Configurando flathub'
        setup_flathub
        msg 'Atualizando os aplicativos...'
        system_update
        msg 'Atualizando o sistema...'
        dist_upgrade
        msg 'Removendo ADS do terminal (se estiver habilitado)...'
        disable_terminal_ads
        msg 'Instalando drivers adicionais...'
        gpu_install_opt
	msg 'Instalando ferramentas essenciais...'
        install_essentials_tools
	msg 'Instalando ferramentas avançadas...'
        install_advanced_tools
        msg 'Instalando aplicativos básicos...'
        install_basic_applications
        choose_browser_options
        cd_dvd_burn_option
	msg 'Instalando aplicativos básicos de design...'
        install_design_applications
        msg 'Instalando aplicativos de TI...'
        install_it_tools
        msg 'Instalando aplicativos de programação...'
        install_programming_applications
        msg 'Instalando aplicativos de vídeo e streaming...'
        install_video_editor_live
        msg 'Instalando lojas de jogos e emuladores...'
        install_for_gamers
        msg 'Ativação da versão pro do ubuntu...'
        ubuntu_pro_activate
        msg 'Atualizando os aplicativos...'
        system_update
        msg 'Atualizando os pacotes snap...'
        snap_update
        msg 'Atualizando os pacotes flatpak...'
        flatpak_update
        msg 'Desbloqueando mais opções no gerenciador de inicialização...'
        startup_manager
        msg 'Configurando SSH...'
        ssh_port_configuration
        msg 'Configurando o sistema...'
        dotfiles_repository_advanced_all
        msg 'Baixando scripts para automação...'
        scripts_repository_advanced_all
        msg 'Criando atalho para os scripts de automação...'
        desktop_repository_advanced_all
        msg 'Limpando...'
        cleanup
    }

    common_user() {
        msg 'Atualizando os repositórios...'
        repo_update
        msg 'Instalando ferramentas para adicionar repositórios...'
        install_repo_tools
        msg 'Configurando o flathub...'
        setup_flathub
        msg 'Removendo ADS do terminal (se estiver habilitado)...'
        disable_terminal_ads
        msg 'Instalando drivers adicionais...'
        gpu_install_opt
        msg 'Instalando ferramentas essenciais...'
        install_essentials_tools
        msg 'Instalando aplicativos básicos...'
        install_basic_applications
        choose_browser_options
        cd_dvd_burn_option
        msg 'Atualizando os aplicativos...'
        system_update
        msg 'Atualizando os pacotes snap...'
        snap_update
        msg 'Atualizando os pacotes flatpak...'
        flatpak_update
        msg 'Desbloqueando mais opções no gerenciador de inicialização...'
        startup_manager
        msg 'Configurando o SSH...'
        ssh_port_configuration
        choose_extra_packages
        msg 'configurando o sistema...'
        dotfiles_repository_begginer_common
        msg 'Baixando scripts para automação...'
        scripts_repository_common_begginer
        msg 'Criando atalho para os scripts de automação...'
        desktop_repository_common_begginer
        msg 'Limpando...'
        cleanup
    }
    advanced_user() {
        msg 'Atualizando os repositórios...'
        repo_update
        msg 'Instalando ferramentas para adicionar repositórios...'
        install_repo_tools
        msg 'Configurando o flathub...'
        setup_flathub
        msg 'Removendo ADS do terminal (se estiver habilitado)...'
        disable_terminal_ads
        msg 'Instalando drivers adicionais...'
        gpu_install_opt
        msg 'Instalando as ferramentas essenciais...'
        install_essentials_tools
	msg 'Instalando as ferramentas avançadas...'
        install_advanced_tools
        msg 'Instalando os aplicativos básicos...'
        install_basic_applications
        choose_browser_options
        cd_dvd_burn_option
        msg 'Atualizando os aplicativos...'
        system_update
        msg 'Atualizando os pacotes snap...'
        snap_update
        msg 'Atualizando os pacotes flatpak...'
        flatpak_update
        msg 'Desbloqueando mais opções no gerenciador de inicialização...'
        startup_manager
        msg 'Configurando o SSH...'
        ssh_port_configuration
        choose_extra_packages
        msg 'configurando o sistema...'
        dotfiles_repository_advanced_all
        msg 'Baixando os scripts para automação...'
        scripts_repository_advanced_all
        msg 'Criando atalho para os scripts de automação...'
        desktop_repository_advanced_all
        msg 'Limpando...'
        cleanup
    }
    begginer_user() {
        msg 'Atualizando os repositórios...'
        repo_update
        msg 'Instalando ferramentas para adicionar repositórios...'
        install_repo_tools
        msg 'Configurando o flathub...'
        setup_flathub
        msg 'Removendo ADS do terminal (se estiver habilitado)...'
        disable_terminal_ads
        msg 'Instalando drivers adicionais...'
        gpu_install_opt
        msg 'Instalando as ferramentas essenciais...'
        install_essentials_tools
	msg 'Instalando as ferramentas avançadas...'
        install_advanced_tools
        msg 'Instalando os aplicativos básicos...'
        install_basic_applications
        choose_browser_options
        cd_dvd_burn_option
        msg 'Atualizando os aplicativos...'
        system_update
        msg 'Atualizando os pacotes snap...'
        snap_update
        msg 'Atualizando os pacotes flatpak...'
        flatpak_update
        msg 'Desbloqueando mais opções no gerenciador de inicialização...'
        startup_manager
        msg 'Configurando o SSH...'
        ssh_port_configuration
        choose_extra_packages
        msg 'configurando o sistema...'
        dotfiles_repository_advanced_all
        msg 'Baixando os scripts para automação...'
        scripts_repository_advanced_all
        msg 'Criando atalho para os scripts de automação...'
        desktop_repository_common_begginer
        msg 'Limpando...'
        cleanup
    }
    
    (return 2> /dev/null) || main
