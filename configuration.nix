{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Namek"; 

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

    kvm qemu libvirt
    openssl

    wget sudo gnumake
    gcc
    vim neovim
    vimPlugins.spacevim
    vimPlugins.vundle
    oh-my-zsh
    iosevka
    
   haskellPackages.stack
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad

    xscreensaver
    xclip
    
  ];

  # List services that you want to enable:

  hardware = {
    pulseaudio.enable=true;
    pulseaudio.support32Bit = true;
  };


  # Enable CUPS to print documents.
  # services.printing.enable = true;


  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sdb3";
      preLVM = true;
    }
  ];

  virtualisation.libvirtd.enable = true;
  # GPU PASSTHROUGH NEEDED STUFF
  #boot.kernelModules = [
  # "vfio"
  # "vfio_pci"
  # "vfio_iommu_type1"
  #];

  #boot.kernelParams = [
  #  "intel_iommu=on"
  #  "vfio_iommu_type1.allow_unsafe_interrupts=1"
  #  "kvm.allow_unsafe_assigned_interrupts=1"
  #  "kvm.ignore_msrs=1"
  #];

  boot.loader.grub.device = "/dev/sdb";

  #user
  users.extraUsers.bernas = {
    name = "bernas";
    group = "users";
    extraGroups = [
     "wheel" "disk" "audio" "video"
     "networkmanager" "systemd-journal"
     "libvirtd"
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
  services = {
    openssh.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "nvidia" ];

      desktopManager = {
	kde4.enable = true;
        default = "kde4";
      };
      
      windowManager = {
	xmonad.enable = true;
	xmonad.enableContribAndExtras = true;
      };

      displayManager = {
        lightdm.enable = true;
      };

      autorun = true;

    };
  };

  #services = {
  #  xserver = {
  #    enable = true;
  #    videoDrivers = [ "nvidia" ];

  #    desktopManager = {
  #      default = "kde4";
  #      kde4 = {
  #        enable = true;
  #      };
  #    };



  #    displayManager = {
  #      kdm.enable = true;
  #    };

  #    autorun = true;

  #  };
  #};

  #oh-my-zsh
  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
    ZSH_THEME="3den"
    plugins=(git)
    
    source $ZSH/oh-my-zsh.sh
  '';
  programs.zsh.promptInit = "";

}
