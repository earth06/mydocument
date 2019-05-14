## Shell script

you can write multiple commands on `.sh` file in advance and run them at the same time.

This is called shell script .

I want to introduce the syntax but it is different whether your shell is B Shell or C Shell.   

I'm used to using csh so I mainly explain csh grammar 
(However, csh has serious defects in its grammar and csh is deprecated for programming language)


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
$ chmod 755 shellscript.sh
$ ./shellscript.sh
```



#### Exercise_1

1. copy `/home/onishi/mydocument/Linux_advance/` to `~`

This directory have `./$iyy/test_${iyy}.txt` .

2. Please copy its file into your new directory `Test` at once

   You can use shell script

Then each file have each text.

3. Please concatenate its text and output into new file `test_all.txt`

   I recommend you to use `cat` command. To solve this exercise you can use not only shell script but also

   `cat` command with wild card.

#### Exercise_2

Make a program which show date from 2005/1/1 to 2010/12/31  on your display.
Don't forget to consider leap year

### command line argument
We can pass value to shellscript as command line argument when we execute it.
Shell script assign these value to specific shell variables.

```bash
$script.sh  aaa   bbb    ccc
  <$0>     <$1>   <$2>   <$3>
```
example
**print.sh**

```bash
#! /bin/tcsh -f
echo $1
```

```bash
$ ./print.sh 'Hello'
Hello
```
### bash

誰か書いて！
