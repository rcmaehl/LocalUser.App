[![Build Status](https://img.shields.io/github/actions/workflow/status/rcmaehl/WhyNotWin11/wnw11.yml?branch=main)](https://github.com/rcmaehl/WhyNotWin11/actions?query=workflow%3AWNW11)
[![Download](https://img.shields.io/github/v/release/rcmaehl/localuser.app)](https://github.com/rcmaehl/LocalUser.App/releases/latest/)
[![Download count)](https://img.shields.io/github/downloads/rcmaehl/localuser.app/total?label=Downloads)](https://github.com/rcmaehl/LocalUser.App/releases/latest/)
[![Ko-fi](https://img.shields.io/badge/Support%20me%20on-Ko--fi-FF5E5B.svg?logo=ko-fi)](https://ko-fi.com/rcmaehl)
[![PayPal](https://img.shields.io/badge/Donate%20on-PayPal-00457C.svg?logo=paypal)](https://www.paypal.com/donate/?hosted_button_id=YL5HFNEJAAMTL)
[![Join the Discord chat](https://img.shields.io/badge/Discord-chat-7289da.svg?&logo=discord)](https://discord.gg/uBnBcBx)


# LocalUser.App
A Local User Account Script (with no unexpected extras)

<sup>Inspired by ChrisTitus</sup>

## Instructions

After connecting to a network in the OOBE, press Shift + F10. Then, enter the following:

```batch
curl -L my.localuser.app > lu.cmd && lu.cmd
```

## What it does

Downloads, Modifies, and Deploys a Generated [autounattended.xml Answer File](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/update-windows-settings-and-scripts-create-your-own-answer-file-sxs?view=windows-11) from [Scheegan's Generator](https://schneegans.de/windows/unattend-generator/) within the OOBE. This is the same method Rufus uses for it's Windows 10/11 tweaks.

cURL-ing `https://my.localuser.app` downloads `https://github.com/rcmaehl/LocalUser.App/releases/latest/download/localonly.bat` via HTTP Redirect. That script then cURLs `https://au.localuser.app`, which downloads `https://raw.githubusercontent.com/rcmaehl/LocalUser.App/refs/heads/main/autounattend.xml` via HTTP Redirect (this may change to a release item in the future), followed by prompting users for the Local User Account details to be set to minimize security risks.

## Setup Flow Comparisons

### Normal Setup:
Language -> Keyboard -> Second Keyboard -> WiFi -> Name Device + Reboot -> Microsoft Account Sign In -> Windows Hello Setup -> Privacy Settings -> Restore from Microsoft Account -> Select Extra Apps -> Phone Link Setup -> M365 Upsell -> Game Pass Upsell -> Desktop

### Local User Setup (Ethernet):
LOCALUSER.APP HERE + Reboot -> Language -> Keyboard -> Second Keyboard -> Privacy Settings -> Desktop

### Local User Setup (Wi-Fi):
Language -> Keyboard -> Second Keyboard -> WiFi -> LOCALUSER.APP HERE + Reboot -> Language -> Keyboard -> Second Keyboard -> Privacy Settings -> Desktop
