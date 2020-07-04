# Tips in Shell/Bash/Linux

**TIPS:**

- Avoid carriage return in bash
``` 
tr -d '\r' < script.sh > script1.sh
```
# Package Manager

## Debian/Ubuntu based

```
# APT
apt update / apt upgrade
apt install <package>
apt-get install <package>
# no confirm =>  -y
```

## CentOS / Red Hat
```
# YUM
yum update / yum upgrade
yum install <package>
# no confirm =>  -y
```

## Arch based

```
# pacman / yaourt
pacman -Syy / pacman -Syu
pacman -S <package>
# no confirm =>  --noconfirm
```

## Fedora
```
# DNF
dnf update / dnf upgrade
dnf install <package>
# no confirm =>  -y
```

## Alpine
```
# APK
apk update / apk upgrade
apk add <package>
```

## Solus
```
# eopkg
eopkg update-repo / eopkg upgrade
eopkg install <package>
```

## OpenSUSE
```
# ZYpp
zypper update
zypper install <package>
# no confirmation =>  -y
```

## Gentoo
```
# emerge
emerge --sync / emerge 
emerge <package>
```

## MacOS
```
# brew
brew update / brew upgrade
brew install <package>
```
