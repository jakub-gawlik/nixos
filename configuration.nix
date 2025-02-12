{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  networking.hostName = "apollo";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  time.hardwareClockInLocalTime = true;

  hardware.tuxedo-drivers.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA configuration
  hardware.nvidia = {
    # Modesetting is required for most Wayland compositors
    modesetting.enable = true;

    # Enable power management (recommended for laptops)
    powerManagement = {
      enable = true;
    };

    # Use the NVidia open source kernel module (not recommended for older cards)
    open = false;

    # Enable the nvidia-prime sync mode
    prime = {
      sync.enable = true;

      # Intel GPU is the first GPU in the PCI bus
      intelBusId = "PCI:0:2:0";

      # NVIDIA GPU bus ID (you may need to adjust this)
      # Use `lspci | grep -i nvidia` to find your bus ID
      nvidiaBusId = "PCI:1:0:0";
    };

    # Enable the Optimus manager
    prime.offload.enable = false;
    
    # Force full composition pipeline for better performance
    forceFullCompositionPipeline = true;

    # Package selection
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Environment variables for better compatibility
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.caasi = {
    isNormalUser = true;
    description = "Jacob";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  security.sudo.extraRules = [
    { 
      users = [ "caasi" ];
      commands = [
      { 
        command = "ALL";
        options = [ "NOPASSWD" ];
      }
    ];
    }
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Docker
  virtualisation.docker.enable = true;

  # ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    brave
    neovim
    nextcloud-client
    docker-compose
    wget
    freetube
    unzip
    git
    gnupg
    libmysqlclient
    inkscape
    gimp
    powerline-fonts
    nodejs
    php83
    php83Packages.composer
    yarn
    nmap
    easyeffects
    thunderbird
    libreoffice-qt
    gcc8
    lazygit
    xsel
    ripgrep
    fd
    zellij
    # NVIDIA
    nvidia-vaapi-driver    # VAAPI support
    glxinfo                # For debugging GPU info
    vulkan-tools          # Vulkan utilities
    vulkan-validation-layers
    libva-utils           # VAAPI utilities
    # DUALBOOT
    os-prober
    ntfs3g    # For NTFS support
  ];

  system.stateVersion = "24.11";

}
