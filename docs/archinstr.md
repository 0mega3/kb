![cover](../assets/archcover.png)

# ArchLinux Instruction

ArchLinux Deployment on [ASUS ExpertBook
B9400CEA](https://wiki.archlinux.org/title/ASUS_ExpertBook_B9450CEA).

In short, if the screen shows a dollar sign (`$`) or hash (`#`) on the left
of the blinking cursor, you are in a command-line environment.
`$`, `#`, `%` symbols indicate the user account type you are logged in to.

- Dollar sign (`$`) means you are a normal user.
- hash (`#`) means you are the system administrator (root).
- In the C shell, the prompt ends with a percentage sign (`%`).

## Bootable USB Flash Drive

```console
sudo wipefs -fa /dev/sdX
sudo fdisk /dev/sdX
sudo partprobe /dev/sdX
sudo mkfs.vfat -n 'LABEL' /dev/sdX1
sudo dd bs=4M if=/target/archlinux.iso of=/dev/sdX status=progress && sync
```

## Pre-installation

### Wireless connect to the internet

Ensure your network interface is listed and enabled.

```console
# ip link
```

Make sure the wireless card is not blocked with rfkill.

```console
# rfkill list
```

Connect to the wireless network using iwctl.

```console
# iwctl
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect <network name> [security]
Type the network passphrase for <network name> psk.
Passphrase: ********
[iwd]# station wlan0 show
```

The connection may be verified with ping.

```console
# ping archlinux.org
```

### Update the system clock

```console
# timedatectl set-ntp true
```

### Erasing

**SATA:**

If you run into trouble with a pre-existing disk signature,
you can delete it using wipefs.

```console
# wipefs --force --all /dev/sdX
```

**[NVMe Secure Erase](https://www.mankier.com/1/nvme-format)**

```console
# pacman -S nvme-cli
# nvme format /dev/nvme0 -s 1 -n 1
# nvme format /dev/nvme0 -r -n 1
# nvme format /dev/nvme1 -s 1 -n 1
# nvme format /dev/nvme1 -r -n 1
# reboot
```

### Partitioning

```console
# lsblk
```

Note: ef00 EFI system partition, 8e00 Linux LVM partition

```console
# gdisk /dev/nvme0n1
# gdisk /dev/nvme1n1
```

or

```console
# fdisk /dev/nvme0n1
# fdisk /dev/nvme1n1
# fdisk -l
```

or

```console
# cfdisk /dev/nvme0n1 --zero
# cfdisk /dev/nvme1n1 --zero
# parted -l
```

**Re-read The Partition Table Without Rebooting Linux System:**

After the fdisk or gdisk command session (which makes changes to partition table)
just type the following command:

```console
# partprobe /dev/nvme0n1
# partprobe /dev/nvme1n1
```

### [LVM]

```console
# lvmdiskscan
```

> Note: If using a SSD without partitioning it first, use

```console
# pvcreate --dataalignment 1m /dev/nvme0n1p2 /dev/nvme1n1p1 (for erase block size < 1 MiB),
# pvdisplay
# pvscan

# vgcreate vgarch /dev/nvme0n1p2 /dev/nvme1n1p1
# vgdisplay

# lvcreate -n lvroot -i 2 -L 100G vgarch
# lvcreate -n lvhome -i 2 -l 100%FREE vgarch
# lvdisplay
```

You may need to load the device-mapper kernel module (modprobe dm_mod)
for the above commands to succeed. Your logical volumes should now be
located in /dev/YourVolumeGroupName/. If you cannot find them, use the
next commands to bring up the module for creating device nodes and
to make volume groups available:

```console
# modprobe dm_mod
# cat /proc/modules | grep dm_mod
# vgscan
# vgchange -ay
```

### Formatting

```console
# mkfs.fat -F32 /dev/nvme0n1p1
# mkfs.ext4  /dev/vgarch/lvroot
# mkfs.ext4  /dev/vgarch/lvhome
```

verification

```console
# file -sL /dev/nvme[01]n1*
# file -sL /dev/vgarch/lvroot
# file -sL /dev/vgarch/lvhome
```

### Mounting

```console
# mount /dev/vgarch/lvroot /mnt
# mkdir /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot
# mkdir /mnt/home
# mount /dev/vgarch/lvhome /mnt/home
# mount | tail -n 3
```

## Installation

### Install essential packages

> Note: [package] - this is optional.

```console
# pacstrap /mnt base base-devel linux linux-firmware man-db man-pages vim \
intel-ucode [lvm2] efibootmgr networkmanager
```

## Configure the system

### Fstab

```console
# genfstab -U /mnt >> /mnt/etc/fstab
# cat /mnt/etc/fstab
```

verification

```console
# blkid -s UUID -o value /dev/vgarch/lvroot
# blkid -s UUID -o value /dev/vgarch/lvhome
# blkid -s UUID -o value /dev/nvme0n1p1 or # blkid /dev/nvme[01]n1*
```

### Chroot

```console
# arch-chroot /mnt
```

### Swap file

```console
# dd if=/dev/zero of=/swapfile bs=1M count=8192 status=progress
# chmod 600 /swapfile
# mkswap /swapfile
# swapon /swapfile
# vim /etc/fstab
/swapfile none swap defaults 0 0
```

### Time zone

```console
# ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
# hwclock --systohc
```

### Localization

```console
# vim /etc/locale.gen
en_US.UTF-8 UTF-8
# locale-gen
# echo LANG=en_US.UTF-8 >> /etc/locale.conf
```

### Network configuration

```console
# vim /etc/hostname
arch
# vim /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain    arch
```

### [Adding mkinitcpio hooks for LVM]

In case your root filesystem is on LVM, you will need to enable
the appropriate mkinitcpio hooks, otherwise your system might not boot:

- **udev** and **lvm2** for the default busybox-based initramfs
- **systemd** and **lvm2** for systemd-based initramfs

**udev** is there by default. Edit the file and insert **lvm2**
between **block** and **filesystems** like so:

```console
# vim /etc/mkinitcpio.conf
...
HOOKS=(base udev ... block lvm2 filesystems)
```

### Initramfs

> Note: You do not have to turn off VMD in BIOS as long as
> you have vmd module enabled in your initram image

```console
# vim /etc/mkinitcpio.conf
...
MODULES=(vmd)
# mkinitcpio -P
```

**Note: vmd is included in the default block hook since mkinitcpio v31.**

### NetworkManager

```console
# systemctl enable NetworkManager
```

### systemd-boot bootloader

```console
# bootctl --path=/boot install
# bootctl update
# bootctl list
# bootctl status
# bootctl is-installed

# vim /boot/loader/loader.conf
timeout 3
#console-mode keep
default arch-*
editor no

# vim /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
# blkid -s UUID -o value /dev/nvme0n1p2 >> /boot/loader/entries/arch.conf
options root=UUID=... rw quiet splash
```

### Updating the EFI boot manager (Automatic update)

Place the following pacman hook in the /etc/pacman.d/hooks/ directory:

```console
# mkdir /etc/pacman.d/hooks
# vim /etc/pacman.d/hooks/100-systemd-boot.hook
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
```

### Root password

```console
# passwd
```

### Create user

> Note: visudo — edit the sudoers file. **visudo** belongs to
> **sudo package** belongs to **base-devel meta package**.

```console
# useradd -mG wheel user
# EDITOR=vim visudo
# passwd user
```

### Reboot

```console
# exit
# umount -a
# reboot
```

## Post-installation

### Activate a connection

```console
nmtui
```

### Install extra packages

> Note: The i3-gaps project has been merged with i3.
> All i3-gaps features will become available with i3 4.22

```console
sudo pacman -S mesa xorg-server xorg-xinit xorg-xrandr xorg-xprop \
terminator i3-wm i3lock polybar feh picom rofi firefox git neofetch \
sof-firmware pulseaudio pulseaudio-alsa bluez bluez-utils \
[network-manager-applet]
```

### Manually starting a Xorg display server

```console
$ vim ~/.xinitrc
exec i3
$ startx
```

### Autostart X at login

Make sure that startx is properly configured.
Place the following in your login shell initialization file
(e.g. ~/.bash_profile for Bash or ~/.zprofile for Zsh):

```console
$ vim ~/.bash_profile

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
```

> Note: **/etc/profile**
>
> Upon login, all Bourne-compatible shells source /etc/profile,
> which in turn sources any readable *.sh files in /etc/profile.d/:
> these scripts do not require an interpreter directive,
> nor do they need to be executable. They are used to set up
> an environment and define application-specific settings.

### [Display manager]

```console
sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
sudo systemctl enable lightdm
reboot
sudo vim /etc/lightdm/lightdm.conf
ls /usr/share/xsessions/
```

### Keyboard configuration

```console
$ vim /usr/share/X11/xkb/rules/base.lst
/grp
$ sudo localectl --no-convert set-x11-keymap us,ru asus_laptop "" grp:win_space_toggle
$ sudo localectl --no-convert set-x11-keymap us,ru asus_laptop dvorak grp:win_space_toggle
$ reboot
```

### Arch User Repository (AUR)

```console
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin/
less PKGBUILD
makepkg -si
yay -S package
```

#### Yay Cache Cleaning

Apply --aur flag to target only aur packages.

```console
yay -Sc --aur
```

### Rofi

```console
rofi -show run
rofi-theme-selector
```

## Upgrading the system

> Note: Avoid doing partial upgrades. In other words, never run `pacman -Sy`;
> instead, always use `pacman -Syu`.

### Package signing

Upgrading the system regularly prevents most signing errors. If delay is
unavoidable and system upgrade gets delayed for an extended period:

1. `pacman-key` depends on system time. If your system clock is not synchronized,
system installation/upgrade may fail with invalid signature errors.
If using `ntpd` (the **ntp package**), correct the system time (as root) with:

    ```console
    # ntpd -qg && hwclock -w
    ```

2. Manually sync the package database and upgrade the **archlinux-keyring package**
before system upgrade:

    ```console
    # pacman -Sy archlinux-keyring && pacman -Su
    ```

    This command is not considered a partial upgrade since it syncs
    the package database and upgrades the **keyring package** first.
    Both must be processed just before starting system upgrade to ensure
    signatures of all upgraded packages can be properly verified.

3. Perform the full system upgrade:

    ```console
    # pacman -Syu
    ```

## apps

### Misc

| Name                   | Description                                             |
| ---------------------- | ------------------------------------------------------- |
| `vlc`                  | Multimedia player and framework                         |
| `mplayer`              | Movie player                                            |
| `mpd`                  | Music player daemon                                     |
| `ncmpcpp`              | Music player client                                     |
| `simplescreenrecorder` | A feature-rich screen recorder                          |
| `weechat`              | IRC client                                              |
| `wee-slack`            | A WeeChat native client for Slack.com                   |
| `slack-desktop`        | Slack Desktop (Beta) for Linux                          |
| `telegram-desktop`     | Official Telegram Desktop client                        |
| `discord`              | All-in-one voice and text chat for gamers               |
| `zoom`                 | Video Conferencing and Web Conferencing Service         |
| `ranger`               | Simple, vim-like file manager                           |
| `w3m`                  | Ranger image previews                                   |
| `mc`                   | A file manager that emulates Norton Commander           |
| `openssh`              | SSH protocol implementation                             |
| `firefox`              | Standalone web browser from mozilla.org                 |
| `neomutt`              | NeoMutt is a command line mail reader                   |
| `neofetch`             | A CLI system information tool                           |
| `btop`                 | A monitor of system resources, bpytop ported to C++     |
| `htop`                 | Process viewer                                          |
| `xpdf`                 | Viewer for Portable Document Format (PDF) files         |
| `pdftk`                | Command-line tool for working with PDFs                 |
| `djview`               | Viewer for DjVu documents                               |
| `djvulibre`            | Suite to create, manipulate and view DjVu documents     |
| `imagemagick`          | An image viewing/manipulation program                   |
| `mdp`                  | A command-line based markdown presentation tool         |
| `scrot`                | Simple command-line screenshot utility for X            |
| `gimp`                 | GNU Image Manipulation Program                          |
| `gimp-help-ru`         | Russian help files for Gimp                             |
| `figma-linux`          | Unofficial Figma desktop client                         |
| `timew`                | Timewarrior, A command line time tracking application   |
| `task`                 | Taskwarrior, A command-line todo list manager           |
| `cmatrix`              | A curses-based scrolling 'Matrix'-like screen           |
| `cowsay`               | Configurable talking cow (and a few other creatures)    |
| `ponysay`              | cowsay reimplemention for ponies                        |
| `figlet`               | A program for making large letters out of ordinary text |
| `toilet`               | free replacement for the FIGlet utility                 |
| `jp2a`                 | A small utility for converting JPG images to ASCII      |
| `dzen2`                | Messaging, notification and menuing program for X11     |
| `klavaro`              | Free touch typing tutor program                         |
| `transmission-gtk`     | BitTorrent client                                       |
| `libreoffice-fresh`    | LibreOffice branch which contains new features          |
| `libreoffice-fresh-ru` | Russian language pack for LibreOffice Fresh             |
| `libreoffice-still`    | LibreOffice maintenance branch                          |
| `ibreoffice-still-ru`  | Russian language pack for LibreOffice still             |
| `ntfs-3g`              | NTFS filesystem driver and utilities                    |
| `dosfstools`           | DOS filesystem utilities                                |
| `nvme-cli`             | NVM-Express user space tooling for Linux                |
| `ntp`                  | Network Time Protocol reference implementation          |
| `unzip`                | For extracting and viewing files in .zip archives       |
| `unrar`                | The RAR uncompression program                           |
| `p7zip`                | Command-line file archiver with high compression ratio  |
| `wireless-regdb`       | Central Regulatory Domain Database                      |

### Coding

| Name                   | Description                                             |
| ---------------------- | ------------------------------------------------------- |
| `git`                  | The version control system (VCS)                        |
| `plantuml`             | Component that allows to quickly write uml diagrams     |
| `gcc`                  | The GNU Compiler Collection - C and C++ frontends       |
| `clang`                | C language family frontend for LLVM                     |
| `ccls`                 | C/C++/ObjC language server                              |
| `ctags`                | Universal Ctags                                         |

### Network

| Name                   | Description                                             |
| ---------------------- | ------------------------------------------------------- |
| `iproute2`             | ss - another utility to investigate sockets             |
| `ufw`                  | ufw - program for managing a netfilter firewall         |
| `openbsd-netcat`       | nc - arbitrary TCP and UDP connections and listens      |
| `inetutils`, `xinetd`  | A collection of common network programs                 |
| `nmap`                 | Utility for network discovery and security auditing     |

### UI

| Name                      | Description                                             |
| ------------------------- | ------------------------------------------------------- |
| `mesa`                    | Xorg video driver                                       |
| `intel-media-driver`      | Intel Media Driver for VAAPI — Broadwell+ iGPUs         |
| `xorg-server`             | Xorg X server                                           |
| `xorg-xinit`              | Manually starting a Xorg display server                 |
| `xprop`                   | Property displayer for X                                |
| `xorg-xrandr`             | Primitive CLI to RandR extension                        |
| `xorg-xrdb`               | X server resource database utility                      |
| `i3-wm`                   | Improved dynamic tiling window manager                  |
| `i3lock`                  | Improved screenlocker based upon XCB and PAM            |
| `polybar`                 | A fast and easy-to-use status bar                       |
| `dmenu`                   | Generic menu for X                                      |
| `rofi`                    | A window switcher, app launcher and dmenu replacement   |
| `feh`                     | Fast and light imlib2-based image viewer                |
| `picom`                   | X compositor that may fix tearing issues                |
| `rxvt-unicode`            | Unicode enabled rxvt-clone terminal emulator (urxvt)    |
| `terminator`              | Terminal emulator that supports tabs and grids          |
| `zsh`                     | A very advanced and programmable shell for UNIX         |
| `zsh-completions`         | Additional completion definitions for Zsh               |
| `zsh-theme-powerlevel10k` | Powerlevel10k is a theme for Zsh                        |
| `zsh-syntax-highlighting` | Fish shell like syntax highlighting for Zsh             |

### Appearance

| Name                   | Description                                                |
| ---------------------- | ---------------------------------------------------------- |
| `lxappearance`         | Feature-rich GTK+ theme switcher of the LXDE Desktop       |
| `materia-gtk-theme`    | A Material Design theme for GNOME/GTK+ based desktop envs  |
| `papirus-icon-theme`   | Papirus icon theme                                         |
| `xcursor-comix`        | Comix X Cursor Theme                                       |

### Fonts

| Name                            | Description                                                                 |
| ------------------------------- | --------------------------------------------------------------------------- |
| `gucharmap`                     | Gnome Unicode Charmap                                                       |
| `ttf-nerd-fonts-symbols`        | High number of extra glyphs from popular 'iconic fonts'                     |
| `ttf-nerd-fonts-symbols-common` | High number of extra glyphs from popular 'iconic fonts' (common files)      |
| `ttf-nerd-fonts-symbols-mono`   | High number of extra glyphs from popular 'iconic fonts' (monospace)         |
| `ttf-anonymouspro-nerd`         | Patched font Anonymous Pro (Anonymice) from nerd fonts library              |
| `ttf-hack-nerd`                 | Patched font Hack from nerd fonts library                                   |
| `ttf-anonymous-pro`             | A family of four fixed-width fonts designed especially with coding in mind  |
| `ttf-hack`                      | A hand groomed and optically balanced typeface based on Bitstream Vera Mono |
| `ttf-droid`                     | General-purpose fonts released by Google as part of Android                 |
| `otf-font-awesome`              | Iconic font designed for Bootstrap                                          |
| `ttf-font-awesome`              | Iconic font designed for Bootstrap                                          |
| `ttf-unifont`                   | TrueType version of the GNU Unifont                                         |
| `siji-git`                      | Iconic bitmap font based on stlarch with additional glyphs                  |

### Sound

#### ALSA firmware

The **alsa-firmware package** contains firmware that may be required
for certain sound cards (e.g. Creative SB0400 Audigy2).
`sof-firmware` and `alsa-ucm-conf` are required for few newer laptop models
(end of 2019/2020) which implement their drivers with firmware provided by
the Sound Open Firmware project.

| Name              | Description                                                                     |
| ----------------- | ------------------------------------------------------------------------------- |
| `alsa-firmware`   | Firmware binaries for loader programs in alsa-tools and hotplug firmware loader |
| `sof-firmware`    | Sound Open Firmware                                                             |
| `alsa-ucm-conf`   | ALSA Use Case Manager configuration (and topologies)                            |
| `pulseaudio`      | A featureful, general-purpose sound server                                      |
| `pulseaudio-alsa` | ALSA Configuration for PulseAudio                                               |
| `pavucontrol`     | PulseAudio Volume Control                                                       |

### Games

| Name                     | Description                                                                               |
| ------------------------ | ----------------------------------------------------------------------------------------- |
| `gzdoom`                 | Feature centric port for all Doom engine games                                            |
| `freedoom`               | Free game based on the Doom engine                                                        |
| `brutal-doom`            | Brutal Doom for the GZDoom engine                                                         |
| `gnuchess`               | Play chess against the computer on a terminal and an engine for graphical chess frontends |
| `xboard`                 | Graphical user interfaces for chess                                                       |
| [vcmi](https://vcmi.eu/) | Open-source engine for homm3                                                              |
| `stella`                 | Atari 2600 VCS emulator                                                                   |

### Data Science

**Installing
[Miniconda](https://conda.io/projects/conda/en/stable/user-guide/install/linux.html)**

1. [Download the installer](https://docs.conda.io/en/latest/miniconda.html#linux-installers)
2. Verify your installer hashes

    ```console
    shasum -a 256 /target/Miniconda3-latest-Linux-x86_64.sh
    ```

3. In your terminal window, run

    ```console
    bash Miniconda3-latest-Linux-x86_64.sh
    source .bashrc or .zshrc
    conda config --set auto_activate_base false
    source $HOME/miniconda3/bin/activate
    ```

    > Note: An alias can be created

    ```console
    $ vim .zshrc
    alias ca='source ~/miniconda3/bin/activate'
    ```

**Updating Miniconda:**

```console
conda update conda
```

**Uninstalling Miniconda:**

```console
rm -rf ~/miniconda3
```

OPTIONAL: Edit `~/.bash_profile` or `.zprofile` to remove the
Miniconda directory from your PATH environment variable.

OPTIONAL: Remove the following hidden file and folders that may have
been created in the home directory:

```console
rm -rf ~/.condarc ~/.conda ~/.continuum
```

**Managing environments and packages:**

```console
conda create --name new python=3.11 numpy pandas matplotlib notebook qtconsole
conda activate new
conda info --envs
```

Jupyter Themes:

- Notebook

    `jupyterthemes` package:

    ```console
    conda install -c conda-forge jupyterthemes && conda update jupyterthemes
    conda install -c conda-forge gcc
    jt -l
    jt -t gruvboxd
    ```

- QtConsole

    `pygments` package:

    ```console
    conda install -c conda-forge pygments
    jupyter qtconsole --style gruvbox-dark
    ```

    or change Jupyter QtConsole settings permanently

    ```console
    $ vim ~/.jupyter/jupyter_qtconsole_config.py
    c.JupyterWidget.syntax_style = 'gruvbox-dark'
    ```
