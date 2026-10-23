![cover](../assets/termuxarchcover.png)

# TermuxArch Instruction

In short, if the screen shows a dollar sign (`$`) or hash (`#`) on the left
of the blinking cursor, you are in a command-line environment.
`$`, `#`, `%` symbols indicate the user account type you are logged in to.

- Dollar sign (`$`) means you are a normal user.
- hash (`#`) means you are the system administrator (root).
- In the C shell, the prompt ends with a percentage sign (`%`).

## Pre-installation

### Install F-Droid

F-Droid is an installable catalogue of FOSS (Free and Open Source Software)
applications for the Android platform.

To install F-Droid, you have to download the app from its website at
[f-droid.org](https://f-droid.org/).

### Install [Termux app](https://github.com/termux/termux-app) from F-Droid

[Termux](https://termux.dev/en/) is an Android terminal emulator
and Linux environment app that works directly with no rooting
or setup required.

1. Open F-Droid on your Android or Chrome OS device by tapping [this
link](https://f-droid.org/packages/com.termux/),
2. Tap Download APK,
3. Tap the downloaded APK on your device,
4. Tap allow installation of apps from unknown sources (you will want to set
this option anyway to be able to install [apps built on your
device](https://wiki.termux.com/wiki/Working_with_APKs) in Termux),
5. Allow the installation to complete,
6. Once installed, you will see the Termux launcher on your home screen
and in your App Drawer. Tap the icon to fire up the application.

## Installation

### [Install TermuxArch](https://termuxarch.github.io/docsTermuxArch/install)

[TermuxArch](https://github.com/TermuxArch/TermuxArch) is a
[Proot](https://github.com/termux/proot)
[Arch Linux ARM](https://archlinuxarm.org/) in
[Termux](https://github.com/termux).

Emulated computer architectures `armeabi-v7a`, `x86` and `x86-64`
are supported on `arm64-v8a` architecture smartphones.
Emulated computer architecture `x86` is supported on `armeabi-v7a`
architecture smartphones. The command `setupTermuxArch h[elp]` has
more information.

1. This method can be run by tapping
[this link](https://sdrausty.github.io/TermuxArch/setupTermuxArch.sh)
which should download `setupTermuxArch.sh` into your `~/storage/downloads/`
directory on your smartphone and tablet. If short tapping
[this link](https://sdrausty.github.io/TermuxArch/setupTermuxArch.sh)
does not download `setupTermuxArch.sh` from your web browser, try long tap
and choose download file from the popup menu. Install Arch Linux
in Termux PRoot by simply running the next line of code in Termux:

    ```console
    bash ~/storage/downloads/setupTermuxArch.sh
    ```

    Ensure Termux storage is correctly setup for this method to work. It is
    necessary to grant storage permission for Termux on Android 6 and higher.
    Use ‘Settings>Apps>Termux>Permissions>Storage’ and set to true. Then execute
    `termux-setup-storage` (run `[[apt]] update && [[apt]] upgrade` to make sure
    that this tool is available) to ensure:

    - That permission to shared storage is granted to Termux when running on
    Android 6.0 or later,
    - That an app-private folder on external storage is created
    (if external storage exists),
    - That a folder `$HOME/storage` is created.
    - The contents of the created `$HOME/storage` folder are symlinks to
    different storage folders:
        - `~/storage/shared` The root of the shared storage between all apps,
        - `~/storage/downloads` The standard directory for downloads from e.g.
        the system browser,
        - `~/storage/dcim` The traditional location for pictures and videos
        when mounting the device as a camera,
        - `~/storage/pictures` Standard directory in which to place pictures
        that are available to the user,
        - `~/storage/music` Standard directory in which to place any audio files
        that should be in the regular list of music for the user,
        - `~/storage/movies` Standard directory in which to place movies
        that are available to the user,
        - `~/storage/external` Symlink to a Termux-private folder on external
        storage (only if external storage is available).

    You want Termux storage to be set up correctly anyway, since it is
    also used by Arch Linux in Termux.

2. Run the following command lines in bash to install Arch Linux
in Termux on your device. Run each of the following command lines
separately. Running them all at once may generate errors;
Hint, copy and paste the following into the Termux window:

    ```console
    pkg install git
    cd && git clone https://github.com/sdrausty/TermuxArch
    bash TermuxArch/setupTermuxArch.sh
    ```

    Should you choose this option, the preferred method to work on projects
    at GitHub, clone to native space on device when you can. See [“Notice to
    Collaborators”](https://sdrausty.github.io/TermuxArch/NOTICE.html)
    for more information about collaborating. This repository uses submodules.
    To get all the pieces run `scripts/maintenance/pullTermuxArchSubmodules.sh`
    in the root directory after cloning.

3. Copy and paste the following command lines into your Termux bash
command shell:

    ```console
    pkg install wget
    wget https://sdrausty.github.io/TermuxArch/setupTermuxArch.sh
    bash setupTermuxArch.sh
    ```

When successfully completed, you will be at a bash prompt in Arch Linux
in Termux using an Android smartphone, tablet or a Chromebook.

```console
Welcome to Arch Linux in Termux PRoot!
Install a package: pacman -S package
More  information: pacman -[D|F|Q|R|S|T|U]h
Search   packages: pacman -Ss query
Upgrade  packages: pacman -Syu

Chat:   wiki.termux.com/wiki/Community
Discus: github.com/login/repo/discussions
GitHub: github.com/archlinuxarm
Help:   help man and info man
IRC:    archlinuxarm.org/about/contact
Rev:    github.com/login/repo/releases

root21:15~$
```

### Install essential packages

```console
# pacman -S base-devel man-db man-pages vim
```

## Configure the system

### Localization

```console
# vim /etc/locale.conf
en_US.UTF-8 UTF-8
```

### User management

Root password:

```console
# passwd
```

Delete the standard `alarm` user:

```console
# userdel -f -r alarm
# rm -rf /home/alarm
```

Create user:

> Note: visudo — edit the sudoers file.
> visudo belongs to sudo package belongs to base-devel meta package.

```console
# useradd -mG wheel username
# EDITOR=vim visudo
# passwd username
```

Login under username:

```console
# su - username
```

### Pentesting

[Archstrike](https://archstrike.org/) is an Arch Linux repository
for security professionals and enthusiasts.

[Blackarch](https://blackarch.org/) Linux is an Arch Linux-based
penetration testing distribution for penetration testers and security
researchers.

To add Archstrike and Blackarch distributions follow these steps.

Edit your `/etc/pacman.conf` by adding:

```console
[archstrike]
Server = https://mirror.archstrike.org/$arch/$repo

[blackarch]
Server = http://blackarch.org/blackarch/$repo/os/$arch
```

Next run `pacman -Syu` to update your repository listing.
To install either distribution, run one of these commands:

```console
# pacman -S archstrike –needed

# pacman -S blackarch –needed
```

There are 663 members in group archstrike: ~2G download (~6G on device).

There are 1602 members in group blackarch: ~5G download (~16G on device).

## Post-installation

### Install extra packages

```console
pacman -S git curl neofetch zsh zsh-completions zsh-syntax-highlighting \
zsh-theme-powerlevel10k
```

### Zsh

Make zsh your default shell:

```console
chsh -l
chsh -s $(which zsh) username
echo $SHELL
```

Restart Zsh with `exec zsh`.

Configure zsh

```console
autoload -Uz zsh-newuser-install
zsh-newuser-install -f
```

### Oh My Zsh

Install Oh My Zsh

```console
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Powerlevel10k

Restart Zsh with `exec zsh`.

Type `p10k configure` if the configuration wizard doesn't start automatically.

### Arch User Repository (AUR)

```console
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin/
less PKGBUILD
makepkg -si
yay -S package
```

**Yay Cache Cleaning:**

Apply --aur flag to target only aur packages.

```console
yay -Sc --aur
```

## Start Arch Linux in Termux

There are a number of ways you can start Arch Linux in Termuxonce installed.
Three methods of starting Arch Linux in Termux after installing are outlined
here:

1. Run `~/arch/startarch` at the bash prompt.
The bash shell interpreter is important!

2. Run `startarch` if you chose “copy to $PATH” during install.
The bash shell interpreter is important!

3. Run `chsh` and change your login shell to `startarch`. Option 2 is required
for this option to run correctly. When you open a session in Termux,
it will login to Arch Linux. **Important** to undo this change and return to
your Termux login, delete `.termux/shell` since `chsh` will be unavailable
in Arch Linux to change your login shell.

These are three options. Certainly there a more ways to start an Arch Linux
login in Termux on device. For the beginner CLI (Command Line Interface) user,
option 2 “copy to $PATH during install” is recommended.

## Upgrading the TermuxArch

> Note: Avoid doing partial upgrades. In other words, never run `pacman -Sy`;
> instead, always use `pacman -Syu`.

### Package signing

Upgrading the system regularly prevents most signing errors.

If delay is unavoidable and system upgrade gets delayed for
an extended period:

1. `pacman-key` depends on system time. If your system clock
is not synchronized, system installation/upgrade may fail with
invalid signature errors. If using `ntpd` (the **ntp package**),
correct the system time (as root) with:

    ```console
    # ntpd -qg && hwclock -w
    ```

2. Manually sync the package database and upgrade
the **archlinuxarm-keyring package** before system upgrade:

    If necessary, temporarily disable signature checking.
    Edit your `/etc/pacman.conf` by modifying SigLevel:

    SigLevel=Never

    ```console
    # pacman-key --init
    # pacman -Sy archlinuxarm-keyring
    # pacman-key --populate archlinuxarm
    # pacman -Su
    ```

    This command is not considered a partial upgrade since it syncs the
    package database and upgrades the **keyring package** first.
    Both must be processed just before starting system upgrade to ensure
    signatures of all upgraded packages can be properly verified.

3. Perform the full system upgrade:

    ```console
    # pacman -Syu
    ```
