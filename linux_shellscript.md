# Shell script

you can write multiple commands on `.sh` file in advance and run them at the same time.

This is called shell script .

I want to introduce the syntax but its syntax is different whether your shell is B Shell or C Shell.   

I'm used to using csh so I mainly explain csh grammar 
(However, csh has serious defects in its syntax so csh is deprecated for programming language)


When you make shell script, you have to write `shebang` at first line of that file.

```bash
#! /bin/bash

```

```bash
#! /bin/tsch -f
set i = 1
```

## csh

### declare variable

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

### Math Operators

When you want to calculate with variables , you have to put `@` at beginning of the line. 

```bash
set i = 10
echo $i
# 10
@ i = $i + 1
echo $i
#11
```
### Command line argument
We can pass value to shellscript as command line argument when we execute it.
Shell script assign these value to specific shell variables.

```bash
$script.sh  aaa   bbb    ccc
  <$0>     <$1>   <$2>   <$3>
```
#### Example

**print.sh**

```bash
#! /bin/tcsh -f
echo $1
```

```bash
$ ./print.sh 'Hello'
Hello
```

Before running the shell script , you may have to add execute permission into the file.

```bash
$ chmod 755 print.sh
$ ./print.sh
```


### Condition and Loops 


#### Condition
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



#####  Example : evaluate leap year 

```bash
#! /bin/tcsh -f
set flag = 0
@ flag = $1 % 4
if ( $flag == 0 ) then
	echo "$iyy is leap year "
else 
	echo "$iyy is not leap yaer"
```



#### Loops



```bash
while ( <conditional expression> )
	<process>
end
```

##### Example :print multiplication table

```bash
#! /bin/tcsh -f
set i = 1
set j = 1
set ans = 0
while ( $i <= 9 )
	while ( $j <= 9)
@		ans = $i * $j
		echo "$i X $j = $ans"
@  		j = $j + 1
	end
@   i = $i + 1
@   j = 1
end

```



#### Exercise_1

1. copy `/home/onishi/mydocument/Linux_advance/` to `~`

This directory have `./$iyy/test_${iyy}.txt` .

2. Please copy its file into your new directory `Test` at once

   You can use shell script

Then each file have each text.

3. Please concatenate those text and output into new file:`test_all.txt`

   I recommend you to use `cat` command. To solve this exercise you can use not only shell script but also `cat` command with wild card.


#### Exercise_2

Make a program which show date from 2005/1/1 to 2010/12/31  on your display.
Don't forget to consider leap year


## bash

### declare variable

### command replacement

### command line arguments

| variable  | meaning                                     |
| --------- | ------------------------------------------- |
| $0        | shellscript name                            |
| $1,$2 ... |                                             |
| $#        | the number of argument                      |
| $@        | return list of arguments (ex)"$1"  "$2" ... |
| $*        | (ex)"$1 $2  ..."                            |



###  Treat any number of argument

```bash
for file in "$@"
	do
		<command>
	done
```

### Separate last argument with the other ones

```bash
${@:$#} #get last argument
#meaning
${list_like:index No.:the number of slice}

```

# Reference

 SB Creative(2015)　新しいLINUXの教科書

