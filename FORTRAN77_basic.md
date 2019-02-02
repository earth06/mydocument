# FORTRAN77  basic syntax

FORTRAN77 roughly have two construction.
 One is unexecutable statement which declare variable , set initial value and save memory for caliculation.
The other is executabel statement which execute caliculation by using variable declared in unexecutable statement. So excecutable statement must be writted after unexcecutable statement. 
 FORTRAN77 doesn't distinguish between capital letter and  lower caseletter . For example 'A' and 'a' will be recognized as same character. Even though ,to improved redability some people use capital letter for control syntax (eg. DO, ENDDO,IF etc...) and use lower case for variable name.


main.F
```fortran
       PROGRAM MAIN      !program declaration
       IMPLICIT NONE      !ignore implicit data type
       INTEGER a,b        !declare variable (Data type is integer in this case)

!executable statement start       
       a = 5              
       b = 7
       WRITE(*,*)a+b

       END   PROGRAM MAIN       !end point of this program
!OUTPUT  12
```

## Limitation the number of letter in one line

FORTRAN77 limit the maximum number of letters in one line as 72 letters. letters which exceed the limitation will be ignored when compile. Moreover from first letter to  sixth letter must be used for other way (eg. sentence number or FORMAT sentence etc...). Details will be decribed below. 
So we can only use 66 letters between 7th and 72th letter .

## Continuation line

As mentioned above , FORTRAN77 have limitaion about the number of letters but we can escape the maximum limitaion of letters by using symbol for continuation line. The way is to write '$' or '&' at 6th letter in next line. See below. this is example of declare string type array 'MON' and set initial value into it.

```fortran
      CHARACTER MON(12)*3  !declare array which have 12 element and each element can save 3 characters
      DATA  MON / 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
     $            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' /    !space is ignored when compiled

```

Actually We can set any symbol except numerical character at 6th letter. 

## Comment line

Comment line is the line which is ignored when compiled.
We have to put '*' at head of line to comment.
We can put '!' wherever you want to comment out in its line . See below

```fortran

* this lien is comment
! this line is also comment
      a + b   !comment from '!' to edn of line
```

# Variable and data types in FORTRAN77


FORTRAN77 is static typing language. So we have to declare variable with data type before executable part.
But FORTRAN77 have implicit data typing . This default feature makes us confused. So it is recommended to disable it . 

## Disable implicit data typing
``` fortran
      PROGRAM MAIN
      implicit none  !disable implicit data type
```
By using `implicit none` ,FORTRAN77 output compile error when we use undeclared variable in our source code.


Next I introduce Fortran77 data types
## integer
integer is represented in 4byte so its range is $-2^{31} \sim  2^{31}-1$ 

```fortran
!ex)
       INTEGER i
!ex)  declare more than two integer at the same time
       INTEGER i,j,k 
```
## real
real number is represented in 4byte (default) or 8byte(double precision) 
```fortran
!singel precision(4byte)
      REAL  a
!double precision(8byte)
      REAL*8 b
```

### real number notation
When we write real number , We often use exponent notation by using 'E' or 'D' 
 
```fortran
!E is used in single precision
      a=1e0      !a = 1.0
      a=1E5      !a = 1.0 X 10^5
!D is used in double precision
      b=0.1D-1   !b = 0.10 X 10^-1
      b=-5.0D10  !b = -5.0 X 10^10
```
## character
When we declare character ,We have to decribe number of letters which variable can save  

```fortran
     CHARACTER  char*10   !
```
In this case, `char` variable can save 10 letters.
## logical
This data type can take only `.TRUE.` or `.False.` as value
This is often used in `IF` statement.
```fortran
      LOGICAL  flag
      
      DATA flag / .TRUE. / 
      IF ( flag )THEN
         flag = .FALSE.
      ENDIF
```

## set initial value by using DATA statement
We can set initial value after declaration. This substitution is done only one time before executable part.

```fortran
      REAL*8 x
      INTEGER count
      CHARACTER char*7
      DATA x / 0.d0 /
      DATA count / 0 /
      DATA char /'FORTRAN'/
```

## Set constant value by using PARAMETER sentence
Variable introduced above can be changed in executable sentence.
Here, we introduce the way to set constant value.
Once we set constant value ,we can't change its value in executable part.

```fortran
      REAL er
      REAL*8 pi
      PARAMETER ( er = 6400e3)            !`()` is necessary
      PARAMETER ( pi = atan(1.D0)*4.D0 )  !we can use  built-in function 
```
　

I introduced data types until here. 
Next, We'll introduce control syntax of FORTRAN77 in executable part.
#IF statement
If conditional expression is True , corresponding statements is carried out.  
We can use conditional jump as many as you like and `if statements` can be nested one inside the other. 

```fortran
     IF ( conditional expression 1 ) THEN
          executabel statement1
     ELSE IF ( conditional expression 2 ) THEN
          executable statement2
     ELSE THEN
          executable statement3
     ENDIF
     
!nested if statement
     IF (condition) THEN
        IF (condition) THEN
           write(*,*)'hello world'
        ENDIF
     ENDIF
```

## comparison operators 
Here I introduce comparison operators which is used in conditional expression.

|conditional expression|character vr.|when return True|
|:----|:-----|:-----|
|a > b|.GT.|a is greater than b|
|a >= b|.GE.|a is greater than or equal to b|
|a < b|.LT.|a is less than b|
|a <= b|.LE.|a is less than or equal to b|
|a == b|.EQ.|a is equal to b|
|a /= b|.NE.|a is not equal to b|

## logical operator
When we want to evaluate two conditional expression at the sametime , we can use logical operater.

|symbol|when return True|
|:----|:----|
|( expression A ) .AND. ( expression B )|conditional expression A is True and expression B is also True|
|( expression A ) .OR. ( expression B )|conditional expression A is True or B is True|



# Loop by DO statement
## How to use DO loop 

```fortran
     INTEGER i  !Here we used i for counter variable for loop

     DO i=<start value>,<limitation value>,<increment or decrement> 
           statement
     ENDDO
     statement
```

Here we are using `i` as counter variable fot DO statement. Counter variable must be declared as integer.
`i` is set to `<start value>` when program into loop. `i` value is updated  at end of executable statement in loop then go to start of loop and `i` value is evaluated. If `i` is under `limitation value` , executable statement in loop is carried out again　otherwise  program go to out of loop.
When <increment or decrement> is omitted ,FORTRAN77 regard <icrement or decrement>  as 'increment=1'.
`DO statement` also can be nested

## DO loop with sentence number

```fortran
      INTEGER i
      DO XXXXX i=<start value>,<limitation value>,<increment or decrement>

XXXXX CONTINUE
```
`XXXXX` is sentence number
### how to use sentence number
To set <sentence number> we write under 5-digit integer in head of line. Each sentence number must be set unique value in one program.
<sentence number> is often used to set `end of DO loop` or to set `FORMAT statement`

### CONTINUE statement
`CONTINUE statement` do nothing. This statement is used in place of `ENDDO`
By using two types `DO loop`,I introduce program to display multiple table

basic_loop.F
```fortran
!basic loop
      PROGRAM MAIN
      IMPLICIT NONE
      INTEGER i,j
      DO  i=1,9
        DO j=1,9
          WRITE(*,*)i ,'X',j,'=',i*j
        ENDDO
      ENDDO
      END
```

loop_by_continue.F
```fortran
!loop by sentence number
      PROGRAM MAIN
      IMPLICIT NONE
      INTEGER i,j
      DO 10 i=1,9
        DO 10 j=1,9
           WRITE(*,*)i ,'X', j ,'=',i*j

10    CONTINUE   !when use sentence number , end point of DO loop can be shared
      END
```

# Reference
富田博之・斎藤泰洋　共著「Fortran 90/95プログラミング」(2011年 改訂新版)

