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

