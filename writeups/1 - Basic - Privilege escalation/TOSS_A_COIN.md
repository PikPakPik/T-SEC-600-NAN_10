# CTF: Toss a Coin

![Difficulty: Easy](https://img.shields.io/badge/difficulty-easy-%2300ff00)
![Contest Date: 2024-05-07](https://img.shields.io/badge/contest%20date-2024--05--07-informational)
![Category: Web, BruteForce](https://img.shields.io/badge/category-web,bruteforce-%237159c1)
![By: Alexandre & Eloi](https://img.shields.io/badge/by-Alexandre%20%26%20Eloi-%23f9a03c)  
![alt text](img/tossacoin4.png)
## Description

> Sing with me this amazing song !

## Write-up

The flag is a reference to the song "Toss a Coin to Your Witcher" from the Netflix series "The Witcher".

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

80/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)

MAC Address: 02:EC:2D:13:83:FB (Unknown)

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

The target machine has two open ports, 22 and 80. Port 80 is running a web server. Let's visit the website.

```
http://$IP
```

We found a page 

![alt text](./img/tossacoin.png)

We use gobuster to find hidden directories. 

```bash
gobuster dir --url http://$IP -w Tools/wordlists/dirbuster/directory-list-2.3-medium.txt
```

Results : 
```bash
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.93.57
[+] Threads:        10
[+] Wordlist:       Tools/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2024/05/16 08:49:09 Starting gobuster
===============================================================
/img (Status: 301)
/t (Status: 301)
Progress: 6045 / 220561 (2.74%)^C
[!] Keyboard interrupt detected, terminating.
===============================================================
2024/05/16 08:49:11 Finished
===============================================================
```

We found two directories `/img` and `/t`. Let's visit the `/t` directory.

http://$IP/t

![alt text](./img//tossacoin2.png)

We do the same thing with the `/t` directory.

```bash
gobuster dir --url http://$IP/t -w Tools/wordlists/dirbuster/directory-list-2.3-medium.txt
```

Results : 
```bash
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.93.57
[+] Threads:        10
[+] Wordlist:       Tools/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2024/05/16 08:49:09 Starting gobuster
===============================================================
/img (Status: 301)
/o (Status: 301)
Progress: 6045 / 220561 (2.74%)^C
[!] Keyboard interrupt detected, terminating.
===============================================================
2024/05/16 08:49:11 Finished
===============================================================
```

We do the same on the `/o` and we have to repeat this action many of times, we found lyrics of the music 

Is the lyrics of the song.

The url is : 
```
http://$IP/t/o/s/s/...
```

We found the flag in the source code of the page.

We found a ssh login. 

```bash
ssh jaskier@$IP
```

We do a `ls` and we found a file `user.txt`.

### Root Flag

```
### TO DO
```
