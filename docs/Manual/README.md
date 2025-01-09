
# Table of Contents

1.  [What lies here?](#org5f168e4)
2.  [Why ?](#org6d71af1)
3.  [How this manual works](#orgb3f16b0)
4.  [Customizations](#org7b7e680)
5.  [Per host - per-host.scm](#orgdd055a8)
6.  [Bootstrapping](#orga8e0b34)
7.  [Updating your system](#org03a113e)
8.  [Nix profile](#org28482f4)
9.  [Keyboard Terminology](#org245dbb9)
10. [Sway](#org5d993c6)
    1.  [Screenshot keybindings](#orgf607607)
    2.  [Application keybindings](#org63537f1)
11. [Emacs](#org6e1eb26)
    1.  [General non-vanilla bindings](#org3baaab5)
    2.  [SSS specific keybindings](#org3d70604)

You are reading the manual for the Supreme Sexp System (SSS).

This manual documents the SSS/GNU system and its functionalities.

This custom GNU + Linux setup enhances customization to infinity, encourages the hacking spirit, and offers a superior user experience thanks in part too to REPL (Read Eval Print Loop) and Lisps.

SSS is not intended for beginners to GNU/Linux systems, and requires some prior experience in this. Familiarity with Lisp dialects is also a great plus point.

SSS is my system, my workflow, my configuration files, and a big insight in the tooling I use and enjoy, and can teach you a thing or two.


<a id="org5f168e4"></a>

# What lies here?

Knowledge you may find in the repo includes:

-   GNU Guix system configurations (Guile Scheme)
-   Advanced Emacs configurations with Emacs Lisp + Elpaca
-   SwayFX configurations (Guile Scheme)
-   Foot terminal emulator (Guile Scheme)
-   Waybar configuration and style (Guile Scheme)
-   Mako configuration and style (Guile Scheme)
-   multi-user Git configuration setup (work/personal)
-   Qutebrowser configurations (Guile Scheme)

Find the divine sayings, and the destined computer configurations, all my Guix, Scheme, SwayFX, and Emacs Lisp and more configurations here for learning you a fully Lisp machine with GNU/Linux for a great good.

Warning: parts of the code and settings might default to the Dutch language ( `nl_NL.UTF-8` ).


<a id="org6d71af1"></a>

# Why ?

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

**Heed my warning**

This is the set of files that powers my day-to-day computing experience, so do not track my dotfiles (rolling, unstable, and untested), but feel free to use them and take inspiration from them or fork and work under the terms of the GNU GPL v3 or newer.

In some ways this is a laboratory of experimentation for my computing environment. What I do with any other program that forms part of sss is only meant to work for me. As such, I may introduce breaking changes without prior notice.

This is all to say that you understand the risks associated with tracking an ever-changing project that does not enjoy widespread testing and whose target audience is only me. If you are fine with that and are willing to assume responsibility for any possible breakage, then please feel welcome to follow along. You can always open an issue here or contribute any fixes, if you will.

This configuration is somehwat biased towards containing a `joe` user who also acts as administrator for most of the time. Your mileage may vary (YMMV).

Some commands in the `Makefile` are more geared towards `joe` since we assume a device is most frequently only tended to by one system administration most of the time. Some examples are `make fr` or `make jr`.

The system and home folders of users are managed independently of each other, in quite a loosely coupled manner.


<a id="orgb3f16b0"></a>

# How this manual works

This manual is written by hand with care and attention for detail.

I write my documents in Org format from Emacs and export them for your convenience to several other formats. A usual release of the manual happens as follows:

-   Edit the SSS manual
-   Export to texi and info via `org-texinfo-export-to-info`
-   Export to HTML via `org-html-export-to-html`
-   Export to LaTEX PDF via `org-latex-export-to-pdf`


<a id="org7b7e680"></a>

# Customizations

SSS supports several user customizations, more specifically:

Several color palettes, inspired by the great \`ef-themes\` by Protesilaos Stavrou, including `ef-bio`, `ef-cyprus` and `ef-dream`.

Find Prot's themes here: <https://github.com/protesilaos/ef-themes>


<a id="orgdd055a8"></a>

# Per host - per-host.scm

It is **REQUIRED** to include a `per-host.scm` in the root of this project, which is excluded from Git, and will determine certain settings for your own machine.
Find here a reference configuration with what is required.

    (use-modules (gnu)
               (gnu packages))
    
    (define sss-filesystems
        (list (file-system
               (device "/dev/nvme0n1p3")
               (mount-point "/")
               (type "ext4"))
              (file-system
               (device "/dev/nvme0n1p1")
               (mount-point "/boot/efi")
               (type "vfat"))))
    
    ;; or (define sss-per-host-packages '())
    (define sss-per-host-packages
      (list
       ;; AMD non-free drivers
       (specification->package "amd-microcode")
       (specification->package "amdgpu-firmware")
       ;; Games
       (specification->package "prismlauncher")
       (specification->package "steam")))


<a id="orga8e0b34"></a>

# Bootstrapping

It's possible you need to some manual installations, and temporary workarounds, in order to install `sss` on a brand-new Guix installation.

Some aspects will be dependent on the manner of installation and hardware.

For example including `nonguix` in your channels (`~/.config/guix/channels.scm`). You might also need to install tools like Git and GNU make temporarily.

    (cons* (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29 12AF 6F51 20A0 22FB B2D5"))))
         %default-channels)

Getting started is easy:

-   Install the Guix GNU/Linux distribution
-   Only install nonguix if you truly require additional hardware support
-   Do a guix pull from your regular user to get a recent commit of Guix
-   Clone this repository after having temporarily installed Git and Make (e.g. in a guix shell)
-   Write an appropriate `per-host.scm` for your setup
-   Contact me for any doubts <jjbigorra@gmail.com>


<a id="org03a113e"></a>

# Updating your system

You should every now and then do a `guix pull` from your regular user, and then rebuild this system with the root user. See the Makefile for more information.


<a id="org28482f4"></a>

# Nix profile

Nixpkgs contains a lot of software which we can leverage and manage from Guix.

SSS will automatically install and provide the Nix package manager for you.

SSS also provides some facilities to manage Nix from the comfort of your Guile Scheme.

You might need to activate and link the profile in order to be able to use, for the first time.

    ln -sfv /nix/var/nix/profiles/per-user/joe/profile /home/joe/.nix-profile

You can switch your install to use nixpkgs-unstable with:

    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update

You can install Nix packages by running:

    nix -L profile install --impure nixpkgs#firefox

You can keep your Nix packages updated by running:

    NIXPGS_ALLOW_UNFREE=1 nix profile upgrade --impure '.*'

The installed software will be available, for example at: `/home/joe/.nix-profile/bin/`


<a id="org245dbb9"></a>

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
</tbody>
</table>


<a id="org5d993c6"></a>

# Sway


<a id="orgf607607"></a>

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
<td class="org-left"><code>s-k</code></td>
<td class="org-left">Kill/Close a window or application</td>
</tr>


<tr>
<td class="org-left"><code>s-S-c</code></td>
<td class="org-left">Reload Sway configuration</td>
</tr>
</tbody>
</table>


<a id="org63537f1"></a>

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
<td class="org-left">Launch application fuzzy finder menu</td>
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


<a id="org6e1eb26"></a>

# Emacs


<a id="org3baaab5"></a>

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


<a id="org3d70604"></a>

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

