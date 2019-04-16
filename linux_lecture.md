Let's start Linux

## Please start up command line

If you don't have Linux Environment , please rely on other lab members. 

They must know the way to build it even if your PC is windows OS.

!!`Terminal` = `Shell` ⊃ {`bash`,`zsh`,`csh`,`tcsh`,`sh`} ⊃ `command line` 

Be careful that Lab server's Login shell is `tcsh` while many Linux is `bash` . 



In Linux,'Folder' is called 'Directory' and they consist of tree structure.

Top directory is  `/` ,which is called 'root' directory.

Strictly speaking, `Directory` is different from `Folder`.

For example, There are many folder ,`bin/` on Linux. Though those folder name is same ,but they are saved in each place.

ex) `/bin ` ,`/usr/bin` ,`$HOME/bin`  

Place of directory is called 'path'



Please check your current directory by using `pwd` command. 

Mabey it is your  Home directory. 

 

Then please show file and directory list of your home directory by using `ls` command.

You can find  `bin/` ,`lib/`.

`ls ` command take some option like below.



* `ls -a` :show directory and file including hidden file

* `ls -l` :show them with detailed information.

## Keyboard shortcut





## Change your current directory

Can you check your home directory or file ? 

Next let's change your current directory 

```bash
$ cd <target path>
```

You can use wildcard `*` as a part of \<target path>

**check the result **

```bash
$ cd ../
$ cd ./
$ cd ~
$ cd ../../
$ cd $HOME
$ cd /
$ cd /usr/bin
$ cd
```

`.` means current directory

`..` means upper directory of current one

`~`,`$HOME` means your home directory

When you run `cd` without target path , the result is to move to your home directory.



## Make your own directory

```bash
$ mkdir <dir>
$ mkdir <dir1> <dir2> ... <dirN>
$ mkdir -p <dir1>/<dir2>
```



## File copy and move

**Copy**

```bash
$ cp <original path> <target path>
$ cp -r #copy directory 
```

In this case original file is not deleted

**move**

```bash 
$ mv <original file> <target file>
```

original file is deleted

## Link

**Symbolic link**

```bash
$ ln -s <target> <link name>
```

## File control

**show text file**

```bash
$ less file.txt
$ cat file.txt
```

**edit a text file**

```bash
$ vim file.txt
```

please run `vimtutor` command when you want to know how to use vim editor.


### Exercise1
1. Please copy `/home/onishi/mydocument/` into your home directory
2. change directory to `~/mydocument/Linux_biginer`
3. Let's move to `./A => B=> A=> A` (step1)
4. `move two upper directory` then  `B => A ` (step2)
5. `move four upper directory` then `B => A => B =>A` (step3)
6. `move three upper directory` then `B => B => A ` (step4)

### Exercise2

1. Change directory to `~/mydocumnet/Linux_basic/` then please search under its directory  for `readme.txt`

This file is put at deep directory. It is not convenient for us to access it repeatedly. 

3. Please make the link at your home directory.
4. When you find it ,please open it.
5. Then plese link `readne.txt` under `~/mydocument/Linux_basic/` 

## Permission

Please open and edit readme.txt .

Maybe you can't change it because you are not the file owner.

Here I explain permission to you.

```bash
$ ls -l
```

![permission.PNG](https://github.com/earth06/mydocument/blob/master/permission.PNG?raw=true)

Permission is represented as 10 characters (In here,  `-rwxr-xr-x`)

First character means  directory `d` , file `-` or link`l`

The other character has meaning like this.     

| character |    meaning    | Number |
| :-------: | :-----------: | :----: |
|     r     |  **r**eading  |   4    |
|     w     |  **w**riting  |   2    |
|     x     | e**x**ectuion |   1    |
|     -     | No permision  |   0    |



Permission is different  depending on file owner , group and normal user



|   target   | digit |
| :--------: | :---: |
| File owner |  2-4  |
|   group    |  5-7  |
| other user | 8-10  |

change a permission

```bash
chmod 755 <path> #-rwxr-xr-x
```



## Redirect  and File I/O 

Your command result is outputted into your terminal window basically.

But your sometimes may want to record its result as log file in order to solve the problem.

Then you can change the output into other file by using redirect. 

 ```bash
$ echo 'Hello' > test.txt
$ echo 'World' >> test.txt
$ cat test.txt
$echo 'over write' > test.txt
 ```

```bash
$ ls 2> log # error output is log
$ ls >  log # standard output is log
$ ls >  log 2>&1 #both error and standard output is log
$ ls >/dev/null 2>&1 #throw output away
#tcsh
$ ls >&log 
```



**concatenate by using cat and redirect**

```bash
$echo 'Hello' > tmep1.txt
$echo 'World' >> temp2.txt
$cat temp1.txt temp2.txt > concat.txt
$less concat.txt
#[OUT]
Hello
World
```

This technique can use not  only text file but also binary file.



## Process Control

```bash
$ ps
$ ps ax 
```

cancel the process 


```bash
$ kill <process ID>
```

## Foreground/Background ,Suspend and Cancel 

`job` is generated after run a command

!!　`job` ∋`process`

you can check job ID by using `jobs` command

``` bash
#run a program with foreground 
$ <command>:
#run a program with backgroud
$ <command> &
#Suspend a foreground job
$ Ctrl+z
#cancel a foreground job
$ Ctrl+c
#background => foreground or suspend => foreground
$ fg <job id> # When job ID is not given, latest job ID is sellected
##################################################################
#foreground => background(Advanced)
#1.run the program
$ <command> 
#2. suspend the program
$ Ctrl+z
#3.check the job ID
$ jobs
#[OUT]
#[1] + suspend   <command name>
#[2] + suspend <command name2>

#4.restart it as background job
$ bg <job ID>
```



# Let's handle Linux

## Packing and Unpacking

```bash
#compression
$ tar czf  <archive name> <file1> <file2> ...    <archive name>
#expansion
$ tar xzf <archive name>
```

## Useful command

Here I don't explain how to use the command.

Please check it yourself.

```bash
$ [Tab] support your command typing
# check disk capacity
$ du <directory>
$ df 
# show directory tree 
$ tree <directory>
# search 
$ grep <keyword> -rl <directory>
$ grep <keyword> <directory>

# sending and reciving file between remote and local
$ scp -r <from>  <to>
$ scp -r <User name>@<ipadress>:<path> <User name>@<ipadress>:<path>
#Download item from Web
$ wget https://<url>
#show command history
$ history
#show calender
$ cal
```



## Shell config

your config file for shell is   `~/.cshrc`, `~/.tcshrc`  or `~/.bashrc`

This config file is read once when the command line is started up.

We can write `alias` and `environmental variables` on config file.

### csh or tcsh

**Alias**

```bash
alias <alias name> <real command>
#e.g
alias ls -F --color
alias ll ls -l
alias la ls -a
```

**Environmental variable**

```bash
setenv <ENV name> <value>
```



### bash

**Alias**

```bash
alias <alias name>="<real command>"
#e.g
alias ls='ls -hF --color=auto' 
alias ll='ls -l'
alias la='ls -a'
```

**Environmental variable**

```bash
export <Env name>=<value>
```



When you want to check  original command of alias 

, you can use `$ type <alias name>` or `$ which <command>`.

Moreover you can check a `environmental variable` by using `$ echo $<envuronmental variable>`

End of this section I'll introduce representative environmental variable.



| Environmental variable |       meaning       |     value <br>(not always correct)      |
| :--------------------: | :-----------------: | :-------------------------------------: |
|          HOME          | your home directory |              /home/\<User>              |
|          PATH          | command search path | /home/\<User>/bin:/usr/local/bin ...etc |
|          USER          |   your user name    |              \<User name>               |
|         SHELL          |  your login shell   |         /bin/bash or /bin/tcsh          |



## Shell script

you can write multiple commands on `.sh` file in advance and run them at the same time.

This is called shell script .

I want to introduce the syntax but it is different whether your shell is B Shell or C Shell.   

I'm used to using csh so I mainly explain csh grammar.



When you make shell script, you have to write `shebang` at first line of that file.

```bash
#! /bin/bash

```

```bash
#! /bin/tsch -f
set i = 1
```

### csh

#### declare variable

* use `set`

```bash
set var = a #OK
set var=a   # wrong
set var =a  # wrong
set var= a  # wrong

# use array
set arr = ( 10 20 30 40 )
set mon = ( DJF MAM JJA SON )
#access an each element
$ echo $arr[1]
#[OUT]
10
```

#### Math Operators

When you want to calculate with variables , you have to put `@` at beginning of the line. 

```bash
set i = 10
echo $i
# 10
@ i = $i + 1
echo $i
#11
```





#### Conditionals and Loops 



```bash
if ( <conditional expression> ) then
	<process>
else if ( <conditional expression> ) then
	<process>
else
	<process>
endif

```



| Conditional expression | meaning                     |
| :--------------------- | :-------------------------- |
| int1 == int2           | int1 equal to int2          |
| int1 != int2           | int1 is not equal to int2   |
| int1 <  int2           | int1 is less than int2      |
| int1 <= int2           | int1 is equal or less int2  |
| int1 >  int2           | int1 is more than int2      |
| int1 >= int2           | int1 is equal or more  int2 |

**conditional expression for file **

| Conditional expression | meaning                               |
| :--------------------: | :------------------------------------ |
|        -e file         | file is exist                         |
|       ! -e file        | file is not exist                     |
|        -d file         | file is exist and it is directory     |
|        -h file         | file is exist and it is symbolic link |
|        -f file         | file is exist and it is normal file   |

**Loops**



```bash
while ( <conditional expression> )
	<process>
end
```



Before running the shell script , you may have to add execute permission into its file.

```bash
chmod 755 shellscript.sh
```



#### Exercise

1. copy `/home/onishi/mydocument/Linux_advance/` to `~`

This directory have `./$iyy/test_${iyy}.txt` .

2. Please copy its file into your new directory `Test` at once

   You can use shell script

Then each file have each text.

3. Please concatenate its text and output into new file `test_all.txt`

   I recommend you to use `cat` command. To solve this exercise you can use not only shell script but also

   `cat` command with wild card.

     

### bash

誰か書いて！
