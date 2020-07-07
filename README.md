# Tips in Shell/Bash/Linux

**TIPS:**

- Avoid carriage return in bash
``` bash
tr -d '\r' < script.sh > script1.sh
```
- Find something in a list of directory
```bash
find * -iname "string" -type f -exec <command> {} \;
#find * -iname "*.log" -type f -exec grep -i "python" {] \;
```

# Package Manager

## Debian/Ubuntu based

```bash
# APT
apt update / apt upgrade
apt install <package>
apt-get install <package>
# no confirm =>  -y
```

## CentOS / Red Hat
```bash
# YUM
yum update / yum upgrade
yum install <package>
# no confirm =>  -y
```

## Arch based

```bash
# pacman / yaourt
pacman -Syy / pacman -Syu
pacman -S <package>
# no confirm =>  --noconfirm
```

## Fedora
```bash
# DNF
dnf update / dnf upgrade
dnf install <package>
# no confirm =>  -y
```

## Alpine
```bash
# APK
apk update / apk upgrade
apk add <package>
```

## Solus
```bash
# eopkg
eopkg update-repo / eopkg upgrade
eopkg install <package>
# no confirmation =>  -y
```

## OpenSUSE
```bash
# ZYpp
zypper update
zypper install <package>
# no confirmation =>  -y
```

## Gentoo
```bash
# emerge
emerge --sync / emerge 
emerge <package>
```

## MacOS
```bash
# brew
brew update / brew upgrade
brew install <package>
```
