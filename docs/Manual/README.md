
# Table of Contents

1.  [What lies here?](#orge03625a)
    1.  [An operating system (OS) configured in Scheme](#org63e43d3)
    2.  [Joe's Emacs configuration](#org6b57597)
2.  [Why ?](#org421159c)
3.  [What is Guix](#org9e011fa)
4.  [Non-free software](#org619bb3d)
5.  [How this manual works](#org5c0ff74)
6.  [Customizations](#org17d641c)
7.  [Per host - per-host.scm](#org6419a1a)
8.  [Bootstrapping](#org401b374)
    1.  [Guix Install tips](#org55c0e3e)
    2.  [After install](#org95f2eb5)
    3.  [On login managers, and login screens](#orga30af20)
9.  [Nix profile](#org12d8d4f)
10. [SSS Project](#orgab09431)
11. [System audio](#orgea95011)
12. [Keyboard Terminology](#org54ccf3b)
13. [Sway](#org1401fbf)
    1.  [General keybindings](#orga68ee6c)
    2.  [Application keybindings](#orgfbcf84e)
    3.  [Screenshot keybindings](#orgfcd1bb3)
14. [Emacs](#org6181db6)
    1.  [General non-vanilla bindings](#org63fb2ed)
    2.  [SSS specific keybindings](#org885af81)

You are reading the manual for the Supreme Sexp System (SSS).

This manual documents the SSS/GNU system and its functionalities.

SSS is a Lisp machine adventure, where the hacking culture is celebrated. Let me help you achieve *GNUrvana*.

If you like my work, please support me by [buying me a cup of coffee](https://bmc.link/jjbigorra) so I can continue with a lot of motivation.

This custom GNU + Linux setup enhances customization to infinity, encourages the hacking spirit, and offers a superior user experience thanks in part too to REPL (Read Eval Print Loop) and Lisps.

Installing and managing SSS is not intended for beginners to GNU/Linux systems, and requires some prior experience in this. Familiarity with Lisp dialects is also a great plus point.

SSS strives to have all things configured via Lisp dialects when possible and convenient, staying accessible to all kinds of users, and allowing for magical things to happen.

![img](../../resources/images/dall-e-3-thumb.png)

I would appreciate if you write your findings when using SSS and if you can, fork the project, and contribute some improvements, or mail me at <jjbigorra@gmail.com>

It is recommended to use tagged releases of SSS, as those are considered as stable by the developers.

Note: Screenshot below might be outdated and no longer representative of the current, ever-changing state of SSS.

![img](../../resources/screenshots/2024-12-29T18:08:55,108562468+01:00.png)


<a id="orge03625a"></a>

# What lies here?


<a id="org63e43d3"></a>

## An operating system (OS) configured in Scheme

-   GNU Guix system configurations
-   SwayFX configurations
-   Foot terminal emulator
-   Rofi application launcher
-   Waybar configuration and style
-   Mako configuration and style
-   multi-user Git configuration setup (work/personal)
-   Qutebrowser configurations
-   Multi user configurations
-   Theme palettes that affect the entire system


<a id="org6b57597"></a>

## Joe's Emacs configuration

An operating system unto itself.

-   Advanced Emacs configurations with Emacs Lisp + Elpaca


<a id="org421159c"></a>

# Why ?

Find the divine sayings, and the destined computer configurations, all my Guix, Scheme, SwayFX, and Emacs Lisp and more configurations here for learning you a fully Lisp machine with GNU/Linux for a great good.

Warning: parts of the code and settings might default to the Dutch language ( `nl_NL.UTF-8` ).

I am currently working on the GNU operating system in order to create a secure libre Lisp workstation.

I refer to SSS lovingly as the modern Lisp machine. With this one obtains a computing style and programming environment that can be referred to as Lisp user space. This is a modern iteration of the Lisp machines of yore.

Staying as libre as possible, any of the system's application code can be made available to you at any time.

You can be aware of all the code that is running on your machine, which puts GNU among the most secure operating systems on Earth.

Learning Lisps is really going down a rabbit hole, but trust me, you will come out with a better understanding of programming as a whole out the other end.

Secure yourself against malevolent state actors and never trust someone else's unverified binaries again, as you can build from the source all the way down.

Lisp user space provides an introspective, hackable, and transactionable operating system that can be modified live in a REPL.

The lines between data and code fade, allowing insane flexibility and power.

Lisp user space is centered on text-based user interfaces instead of graphical user interfaces, and can be mostly used without a mouse, which makes it easier to use for people living with disabilities as well as power users.

All of the system can be inspected and most of it can be hacked live in a REPL, making it a pure expression of the libre software ethic, and an incredibly versatile tool for a skilled programmer.

In some ways this is a laboratory of experimentation for my computing environment. What I do with any other program that forms part of SSS is only meant to work for me. As such, I will try to maintain backwards compatibility and consistency, but I may introduce breaking changes without prior notice.

This is all to say that you understand the risks associated with tracking an ever-changing project that does not enjoy widespread testing and whose target audience is only me. If you are fine with that and are willing to assume responsibility for any possible breakage, then please feel welcome to follow along. You can always open an issue here, contact me, or contribute any fixes, if you will.

This configuration is somewhat biased towards containing a `joe` user who also acts as administrator for most of the time. This is trivial to change and should be easy to adapt to your needs. Your mileage may vary (YMMV).

Some commands in the `Makefile` are more geared towards `joe` since we assume a device is most frequently only tended to by one system administration most of the time. Some examples are `make fr` or `make jr`. Feel free to change this or contribute improvements to make this modular.

The system and home folders of users are managed independently of each other, in quite a loosely coupled manner.


<a id="org9e011fa"></a>

# What is Guix

GNU Guix is a package management tool for and distribution of the GNU system. Guix makes reproducibility easy and allows users to install, upgrade, or remove software packages, to roll back to a previous package set, to build packages from source, and generally assists with the creation and maintenance of software environments.

While you can install GNU Guix on top of an existing GNU/Linux system where it complements the available tools without interference, I encourage the use of Guix system, as standalone operating system distro, on top of which I have built the Supreme Sexp System (SSS).

I highly recommend refering to and studying the Guix reference manual, it's a super valuable source of knowledge: <https://guix.gnu.org/manual/en/html_node/>.


<a id="org619bb3d"></a>

# Non-free software

SSS attempts to stay as libre as possible, while also respecting your convenience.

This means, among other things that SSS:

-   includes the OG Linux kernel (with proprietary blobs) so as to be more compatible with modern hardware
-   includes non-guix software channel by default, so as to allow installation of convenient software to which few/no libre alternatives exist.


<a id="org5c0ff74"></a>

# How this manual works

This manual is written by hand with care and attention for detail.

I write my documents in Org format from Emacs and export them for your convenience to several other formats. A usual release of the manual happens as follows:

-   Edit the SSS manual
-   Run `C-c # m` from Emacs, which runs lib/sss-manual.el, exporting the Org document to several other formats (LaTEX, PDF, HTML, Markdown, etc.)


<a id="org17d641c"></a>

# Customizations

SSS supports several user customizations, more specifically:

Several color palettes, inspired by the great \`ef-themes\` by Protesilaos Stavrou, including `ef-bio`, `ef-cyprus` and `ef-dream`.

Find Prot's themes here: <https://github.com/protesilaos/ef-themes>


<a id="org6419a1a"></a>

# Per host - per-host.scm

It is **REQUIRED** to include a `per-host.scm` in the root of this project, which is excluded from Git, and will determine certain settings for your own machine.
Find here a reference configuration with what is required.

    (use-modules (gnu)
                 (gnu packages))
    
    ;; system language
    (define sss-lang "en_US")
    
    ;; system timezone
    (define sss-timezone "Europe/Amsterdam")
    
    ;; system keyboard layout
    (define sss-keyboard-layout "us")
    
    ;; system hostname
    (define sss-hostname "gnusystem")
    
    ;; disk partitioning
    (define sss-filesystems
      (list (file-system
             (device "/dev/nvme0n1p3")
             (mount-point "/")
             (type "ext4"))
            (file-system
             (device "/dev/nvme0n1p1")
             (mount-point "/boot/efi")
             (type "vfat"))))
    
    ;; packages that should only be installed in the current host
    ;; or (define sss-per-host-packages '())
    (define sss-per-host-packages
      (list
       ;; AMD non-free drivers
       (specification->package "amd-microcode")
       (specification->package "amdgpu-firmware")
       ;; Games
       (specification->package "prismlauncher")
       (specification->package "steam")))
    
    ;; location where you cloned SSS Git repository
    (define sss-clone-dir
      "/home/joe/Ontwikkeling/Persoonlijk/sss")
    
    ;;
    ;; Define the active palette for all users accounts
    ;; You should reconfigure and ideally restart the system
    ;; for all changes to take effect
    ;;
    ;; Note: You could choose on a per-user basis to set a fixed palette
    ;; and not follow system wide, by just redefining this value
    ;;
    ;; Possible values are:
    ;;   - sss-palette-ef-bio
    ;;   - sss-palette-ef-cyprus
    ;;   - sss-palette-ef-dream
    ;;
    (define-public sss-active-palette
      'sss-palette-ef-dream)


<a id="org401b374"></a>

# Bootstrapping

It's possible you need to some manual installations, and temporary workarounds, in order to install `sss` on a brand-new Guix installation.

Some aspects will be dependent on the manner of installation and hardware. Below follows a simple startup guide.

Download and the Guix GNU/Linux distribution from the official Guix page: <https://guix.gnu.org/download/> and make a bootable installation medium convenient for your use case.

If you are not familiar with the `dd` command which is present in all GNU/Linux distributions and in macOS, you can always feel free to use something like Rufus on Windows, or balenaEtcher, to flash this image into a USB, with which you can then boot your computer.

It is highly recommended to first become familiar with SSS and Guix via a *throw-away* virtual machine where you can experiment and do mistakes. After familiarity is acquired then a bare metal installation is the best.

SSS strives to be completely cross-architecture and should work well everywhere. That being said, as of the latest manual, x86-64 is the preferred architecture.


<a id="org55c0e3e"></a>

## Guix Install tips

If your system doesn't boot due to lack of drivers, it can be useful to add the `nomodeset` option after `quiet` in the GRUB menu, by editing the boot "command" of the latest entry.

If you are on aarch64/arm64, or other more niche architectures, then you might need to put in some more work to get an installer image, and to get it working, likely having to generate an ISO image yourself to install Guix or a qcow2 virtual machine.

The following articles may be of help:
<https://jointhefreeworld.org/blog/articles/gnu-linux/gnu-guix-virtual-machine-image-aarch64/>

If things really aren't working with your hardware, you can build your own ISO with the right drivers, or use the one from nonguix: <https://gitlab.com/nonguix/nonguix/-/releases>

It is highly recommended to connect your device to Internet via an Ethernet cable or some other form of wired connection, specially since Guix by default will only come with free software drivers, and as such, might not immediately support your WiFi card. After installing SSS drivers will be there and you can use WiFi.

When installing Guix, make sure you take note of the Scheme code that gets generated by it, specially for the disk partitioning. You will see this at the last install step. This code can also be found after installing, at `/etc/config.scm` by default. Parts of this code will later need to be added to the `per-host.scm`.

After having installed things using the guided Guix installer, or via the command line for advanced users, boot into your new system.

I would recommend to then use a web browser and visit the web version of this manual: <https://codeberg.org/jjba23/sss/src/branch/trunk/docs/Manual>.


<a id="org95f2eb5"></a>

## After install

Add `nonguix` in your channels file (`$HOME/.config/guix/channels.scm`). This will later be overwritten by SSS.

    (cons* (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29 12AF 6F51 20A0 22FB B2D5"))))
         %default-channels)

After adding the channel, perform a `guix pull` from your user account (**no sudo or root**) and let all channels get updated.

Note: You should every now and then do a `guix pull` from your regular user, and then rebuild this system with the root user (`make sr`).

Guix is a rolling distribution and you don't need to be always on bleeding edge releases, but it's nice to stay updated.

Once you have followed all those above steps, you can enter a temporary Guix shell, so as to bootstrap SSS.

You can do this with `guix shell make git icecat`. Icecat will be used for you to browse temporarily and install SSS.

Then proceed to clone SSS with `git clone https://codeberg.org/jjba23/sss.git` to your favourite location. This location will need to be added to `per-host.scm`.

You should have by now written an appropriate `per-host.scm` for your setup. See the above section on this topic.

Enter the directory of SSS: `cd sss`.

Make sure you place your `per-host.scm` in the root of this directory. Then you can do a `make sr`.

Note: `make sr` translates to `sudo guix system reconfigure config.scm --fallback`.

For more commands take a look at the SSS Makefile: <../../Makefile>.

The `fallback` option is optional, and simply helps when upstream substitute (cache) servers are less available.

Once the system reconfigure is complete, you should also bootstrap your user's GNU home with something like: `guix home reconfigure ./home/joe.scm  --fallback`

You might at this point want to reset the font cache for the system and user.

    fc-cache -frv
    sudo fc-cache -frv

You can then reboot and you should be greeted by a simple TTY.


<a id="orga30af20"></a>

## On login managers, and login screens

SSS uses **no login managers** like GDM or SDDM. Simply login to the TTY and start your favorite GUI (or not).
That being said, feel free to use your own.

I like to alias my login command to `gui`, or sometimes I directly run `sway` from the TTY.

Sometimes for the fun I work in Emacs from the TTY for that 60's and 70's computer vibe.

If you run traditional X11 sessions, you could choose to do startx instead of a Wayland session, but SSS is more geared to Wayland.


<a id="org12d8d4f"></a>

# Nix profile

Nixpkgs contains a lot of software which we can leverage and manage from Guix.

SSS will automatically install and provide the Nix package manager for you.

SSS also provides some facilities to manage Nix from the comfort of your Guile Scheme.

You might need to activate and link the profile in order to be able to use, for the first time.

Assuming `joe` as user in question.

`/nix/var/nix/profiles/per-user/` should be:

    joe@guixvm ~ λ  ll /nix/var/nix/profiles/per-user/
    totaal 20K
    drwxr-xr-x 2 joe  users  16K 29 dec 23:09 joe/
    drwxr-xr-x 2 root root  4,0K 22 nov 13:23 root/

For this, make the directory an link it to your home.

    sudo mkdir -p /nix/var/nix/profiles/per-user/joe/profile
    sudo chown -R /nix/var/nix/profiles/per-user/joe
    ln -sfv /nix/var/nix/profiles/per-user/joe/profile /home/joe/.nix-profile

It's possible you might need to logout and log back in to re-activate the profile.

You can switch your install to use nixpkgs-unstable with:

    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update

You can install Nix packages by running:

    nix -L profile install --impure nixpkgs#firefox

You can keep your Nix packages updated by running:

    NIXPGS_ALLOW_UNFREE=1 nix profile upgrade --impure '.*'

The installed software will be available, for example at: `/home/joe/.nix-profile/bin/`


<a id="orgab09431"></a>

# SSS Project

Find the [project management of SSS here](../Project management/README.md)


<a id="orgea95011"></a>

# System audio

SSS favors modern technologies and thus makes use of Pipewire for all your GNU/Linux audio needs.

In practice this means that any user account in your system that wants to make use of audio, should have the  `(service home-dbus-service-type)` and `(service home-pipewire-service-type)` services enabled for their account (yes per-user basis).

You will also want to set the `RTC_USE_PIPEWIRE` variable to `true`. This is already the case by default in SSS.


<a id="org54ccf3b"></a>

# Keyboard Terminology

When keybindings (shortcurts) are defined, the following legend applies (a la Emacs):

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">term</th>
<th scope="col" class="org-left">meaning</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left"><code>s</code></td>
<td class="org-left">Super / Windows / CMD key</td>
</tr>


<tr>
<td class="org-left"><code>S</code></td>
<td class="org-left">Shift key</td>
</tr>


<tr>
<td class="org-left"><code>M</code></td>
<td class="org-left">Meta / Alt / Option key</td>
</tr>


<tr>
<td class="org-left"><code>C</code></td>
<td class="org-left">Control key</td>
</tr>


<tr>
<td class="org-left"><code>SPC</code></td>
<td class="org-left">Space key</td>
</tr>
</tbody>
</table>


<a id="org1401fbf"></a>

# Sway


<a id="orga68ee6c"></a>

## General keybindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left"><code>s-k</code></td>
<td class="org-left">Kill/Close a window or application</td>
</tr>


<tr>
<td class="org-left"><code>s-S-c</code></td>
<td class="org-left">Reload Sway configuration</td>
</tr>


<tr>
<td class="org-left"><code>s-l</code></td>
<td class="org-left">Lock screen</td>
</tr>


<tr>
<td class="org-left"><code>s-1..9</code></td>
<td class="org-left">Move focus to workspace 1..9</td>
</tr>


<tr>
<td class="org-left"><code>s-S-1..9</code></td>
<td class="org-left">Move window to workspace 1..9</td>
</tr>


<tr>
<td class="org-left"><code>s-v</code></td>
<td class="org-left">Vertical splits</td>
</tr>


<tr>
<td class="org-left"><code>s-h</code></td>
<td class="org-left">Horizontal splits</td>
</tr>


<tr>
<td class="org-left"><code>s-S-SPC</code></td>
<td class="org-left">Toggle floating/tiling mode for window</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>


<a id="orgfbcf84e"></a>

## Application keybindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left"><code>s-/</code></td>
<td class="org-left">Launch application fuzzy finder menu (Rofi)</td>
</tr>


<tr>
<td class="org-left"><code>s-i</code></td>
<td class="org-left">Open a Web Browser (Qutebrowser)</td>
</tr>


<tr>
<td class="org-left"><code>s-S-i</code></td>
<td class="org-left">Open a bloated Web Browser (Chrome)</td>
</tr>


<tr>
<td class="org-left"><code>s-RET</code></td>
<td class="org-left">Open a terminal emulator (Foot)</td>
</tr>


<tr>
<td class="org-left"><code>s-t</code></td>
<td class="org-left"><i>idem</i></td>
</tr>


<tr>
<td class="org-left"><code>s-e</code></td>
<td class="org-left">Open text editor (Emacs)</td>
</tr>


<tr>
<td class="org-left"><code>s--</code></td>
<td class="org-left">Open password manager (1password)</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>


<a id="orgfcd1bb3"></a>

## Screenshot keybindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left"><code>s-S-.</code></td>
<td class="org-left"><b>Copy</b> screenshot of entire screen</td>
</tr>


<tr>
<td class="org-left"><code>s-.</code></td>
<td class="org-left"><b>Save</b> screenshot of entire screen</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>


<a id="org6181db6"></a>

# Emacs


<a id="org63fb2ed"></a>

## General non-vanilla bindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left"><code>M-s r</code></td>
<td class="org-left">consult-ripgrep</td>
</tr>


<tr>
<td class="org-left"><code>M-s o</code></td>
<td class="org-left">consult-occur</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>


<a id="org885af81"></a>

## SSS specific keybindings

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">keybind</th>
<th scope="col" class="org-left">command</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left"><code>C-c # s</code></td>
<td class="org-left">Perform a system rebuild</td>
</tr>


<tr>
<td class="org-left"><code>C-c # j</code></td>
<td class="org-left">Perform a joe rebuild</td>
</tr>


<tr>
<td class="org-left"><code>C-c # f</code></td>
<td class="org-left">Perform a system + joe rebuild</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>

