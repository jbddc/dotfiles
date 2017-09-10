{ config, pkgs, ... }:

let zsh = "/run/current-system/sw/bin/zsh";
    antigen = pkgs.fetchgit {
      url = "https://github.com/zsh-users/antigen";
      rev = "1359b9966689e5afb666c2c31f5ca177006ce710";
      sha256 = "13b4a6239p5xsrqmg43bw3z5y7nz25awzclgyb697pqpf139drc9";
    };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  nix.extraOptions = ''
    binary-caches-parallel-connections = 6
    connect-timeout = 5
  '';

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [

    kvm qemu libvirt pciutils seabios
    openssl
    
    htop
    wget sudo gnumake
    gcc
    nodejs
    vim neovim
    vimPlugins.spacevim
    
    opera
    firefox-bin

    haskellPackages.stack

    xscreensaver
    xclip
   
    xfce.xfce4_xkb_plugin
    xfce.xfce4_whiskermenu_plugin
    xfce.xfce4_pulseaudio_plugin
    xfce.xfce4_systemload_plugin
    xfce.xfce4_netload_plugin
    xfce.xfce4_pulseaudio_plugin
    xfce.xfce4_eyes_plugin

  ];
  
  hardware = {
    bluetooth.enable=true;
    pulseaudio.enable=true;
    pulseaudio.support32Bit = true;
    pulseaudio.extraConfig = ''
      load-module module-echo-cancel aec_method=webrtc aec_args="analog_gain_control=0 digital_gain_control=1" source_name=echoCancel_source sink_name=echoCancel_sink
      set-default-source echoCancel_source
      set-default-sink echoCancel_sink
    '';
  };

  boot.extraModprobeConfig = ''
    options snd-hda-intel vid=8086 pid=8ca0 snoop=0
  '';

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";

  boot.initrd.kernelModules = [ "pci-stub" ];
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sdb3";
      preLVM = true;
    }
  ];

  # GPU Passthrough and Windows VM stuff
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [
   "pci-stub"
   "vfio"
   "vfio_pci"
   "vfio_iommu_type1"
  ];

  boot.kernelParams = [
    "pci-stub.ids=10de:100c,10de:0e1a"
    "intel_iommu=on"
    "vfio_iommu_type1.allow_unsafe_interrupts=1"
    "kvm.allow_unsafe_assigned_interrupts=1"
    "kvm.ignore_msrs=1"
    "nvidia.NVreg_EnablePCIeGen3=1"
    "nvidia-drm.modeset=1"
    "hugepages=4300"
  ];

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


  networking = {
    hostName = "Namek";
    nameservers = ["8.8.8.8" "8.8.4.4"];
    networkmanager = {
      enable = true;
    };
  };

  services = {
    redshift.enable = true;
    redshift.latitude = "41.545449";
    redshift.longitude = "-8.426507";

    keybase.enable = true;
    kbfs.enable = true;

    openssh.enable = true;
    printing = {
      enable = true;
      drivers = [ pkgs.brgenml1cupswrapper ];
    };
    avahi.enable=true;
    mongodb.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "nvidia" ];

      desktopManager = {
        xfce.enable = true;
        gnome3.enable = true;
        plasma5.enable = true;
        default = "xfce";
      };

      displayManager = {
        lightdm = {
          enable = true;
        };
      };

      autorun = true;

    };
  };


  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
        iosevka
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    interactiveShellInit = ''
      source ${antigen}/antigen.zsh
    '';
  };

}
