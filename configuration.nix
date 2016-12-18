# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Namek"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    
    wget sudo gnumake
    gcc
    vim
    vimPlugins.vundle
    oh-my-zsh
    
   haskellPackages.stack
    haskellPackages.xmobar
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad

    dmenu
    xscreensaver
    xclip
    

  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  #services.xserver.layout = "us";
  #services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sdb3";
      preLVM = true;
    }
  ];

  boot.loader.grub.device = "/dev/sdb";

  #user
  users.extraUsers.bernas = {
    name = "bernas";
    group = "users";
    extraGroups = [
     "wheel" "disk" "audio" "video"
     "networkmanager" "systemd-journal"
    ];
    createHome = true;
    uid = 1000;
    home = "/home/bernas";
    shell = "/run/current-system/sw/bin/zsh";
  };

  #nvidia unfree software
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.driSupport32Bit = true;

  #xmonad and slim and nvidia drivers
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
    windowManager.default= "xmonad";
    displayManager = {
      slim = {
        enable = true;
        defaultUser = "bernas";
      };
    };
  };

  #oh-my-zsh
  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
    ZSH_THEME="agnoster"
    plugins=(git)
    
    source $ZSH/oh-my-zsh.sh
  '';
  programs.zsh.promptInit = "";



}
