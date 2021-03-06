# array and its caliculation
Variable declared as array can save multiple value.Actually array was used in FORTRAN77 basic chapetr. Please check it.
Fortran can treat not only one dimensional array but also multi dimensional array easily and fast. This is oen of the feature that Fortran is popular in numerical analysys even now.

## How to declare array
```
      <datatype> variable_name(<lower limit:>upper limit)
```
`lower limit` and `upper limit` should be set as integer (including nagative value)
If we skip `lower limit`,its value is set to 1 by default

### Various array declaration

```fortran
      INTEGER iarr(10)      !index number :from 1 to 10
      INTEGER iarr0(0:9)    !set index number from 0 to 9に指定(like C language)
      CHARACTER carr(64)*16 !index number :from 1 to 64 & each element can save 16 letters
      REAL  farr(10,10)     !10 X 10 :two dimensional array

!!!!!!set index number by using constant value
      INTEGER idim,jdim,kmax
      PARAMETER (idim=128,jdim=64,kmax=32)
      REAL*8 dat(idim,jdim,kmax) ! 128 X 64 X 36 :three dimensional array

!!!!!!how to accces each element
      INTEGER arr(3)
      DATA arr / 3, 2, 1  /
      WRITE(*,*)arr(1)   !In this case ,output is '3' (arr(1)=3)
```
## example of array caliculation and output
Here I introduce representative array manipulation.

array.F
```fortran
      PROGRAM main
      IMPLICIT NONE
      INTEGER  arr(20,10),i,j
      INTEGER  new(10,5)
      arr=0                         !set 0 into all array elements
      DO i=1,20
        DO j=1,10
           arr(i,j)=i*j             !set i*j into i row j column element
        ENDDO
      ENDDO
      new(:,:) = arr(1:10,1:5)      !assign 1~10row、1~5column values of `arr` into `new` array
      new(:,:) = new(:,:)*2         !assign values which was generate to multiply original `new` array by 2 into `new` array recusively
!example of output 1
      DO j=1,5
        DO i=1,10
           WRITE(*,*)arr(i,j)    !access speed become faster when we access from inner element because we can access its memory continuously
        ENDDO
      ENDDO
!ex2) output 10lines and each line have 5 element
      DO i=1,10
        WRITE(*,100)(new(i,j),j=1,5)  !expand array toward horisontal
      ENDDO
!ex3)  ex2)+ output with 10 times value without changing original array 
      DO i=1,10
        WRITE(*,100)(new(i,j)*10,j=1,5)
      ENDDO

100   FORMAT(10I5)
      END

```
__result of example 1__
```
           1
           2
           3
           4
           5
           6
           7
           8
           9
           .
           .
           .
```

__result of example 2__
```
    2    4    6    8   10
    4    8   12   16   20
    6   12   18   24   30
    8   16   24   32   40
   10   20   30   40   50
   12   24   36   48   60
   14   28   42   56   70
   16   32   48   64   80
   18   36   54   72   90
   20   40   60   80  100
```

__result of example 3__
```
   20   40   60   80  100
   40   80  120  160  200
   60  120  180  240  300
   80  160  240  320  400
  100  200  300  400  500
  120  240  360  480  600
  140  280  420  560  700
  160  320  480  640  800
  180  360  540  720  900
  200  400  600  800 1000
```
In this case ,output is done on display. Nexr section I introduce how to output result as  file
# File I/O
Basically file inuput and output is done by next three steps.
1. OPEN statement
2. READ and WRITE statement
3. CLOSE statement

See in detail. 
## load external file into program by using OPEN statement

We have to load external file on our program in order to input data from external file or output it to its file.
Here we use `OPEN` statement
```fortran
! file IO by text format 
      OPEN(<unit number>,file='<file name>')
! file IO by binary format
      OPEN(<unit number>,file='<file name>',form='unformatted')
```
If `<file name>`file doesn't exist ,new file is created.
File will be treated as text file if we don't set `form`. In this case we have to set `FORMAT` when READ or WRITE statement. See in later.
If we set `form='unformatted'`,data which is input or output is treated as binarr. Because its file is written by baynary , we can't read it by using excel or Notepad but we can save file memory or make file faster than text file.   

### Unit number
`Unit nuber` which is designated in `OPEN` statement has to be written in positive integer. 
You can also use variable declared as integer for unit number
(Unit number is different from sentence number)
`5` and `6` are already reserved by FORTRAN77 systematically so we shoule avoid to use these number for unit number 
Next , I intorduce file I/O by using `READ` or `WRITE` statement with unit number.

## File I/O by using READ and WRITE statement 
Basically both READ and WRITE statement recieve same arguments. We have to pass `unit identifier ` as first arugument and `format identifier` as second argument.

```fortran
!reading file  (INPUT)
      READ(<unit identifier>,<format identifier>)variables
      
```
read data is substitute into variables which are put on right of READ()statement. 
```fortran
!writing data into file (OUTPUT)
      WRITE(<unit identifier>,<format identifier>)variables
```
values of variables is output into file related to <unit identifier>  
See below about unit identifier.
### Unit identifier

|unit identifier|mean|
|:-----:|:----|
|*|console input or output|
|unit number| I/O target is file related into unit number designated by OPEN statement|
|5|legacy of period that punch card were used for programing|
|6| as above|
| variable| I/O target is variable(this feature is intorduced later)|

### How to write format identifier
Format identifier is written in field discriptor.
I show table of field discriptor before tell you about format identifier

#### Field discriptor 
`w,d,m,r` in field discriptor table are positive values and have below mean

|symbol|mean|
|:---:|:-----|
|w|total length of I/O data |
|d|lenght after the decimal point,for `real` data type |
|m|total length,for `integer` data type|
|r|number of occurrence|

__field discriptor__

|field discriptor|mean|note|
|:---:|:-----|:----------------|
|[r]__I__'w[.m]|rgiht-align integer value in `w`digit. IF space exist by `m` digit ,space is replaced to `0`|w>=m|  
|[r]__E__'w[.d]|show real value `d` digit after decimal point in `w` digit as exponent.Mantisa range is from 0.1 to 1.0 |w>=d+7 |
|[r]__A__[w]|right- align character in 'w' digit|
|[r]__X__|one space|

There are two ways to pass format identifier to second argument of `READ` and `WRITE` statement
#### How to pass format identifier directly.

```fortran
      INTEGER i
      REAL*8  a
      CHARACTER  month*16,label*16,formt*32
      i = 8
      a = 123.674e10
      month = 'monthly'
      label = 'value'
      OPEN(10,file='output.text')
      WRITE(10,'(2A16)')month,label   !-------(1)
      WRITE(10,'(I2.2,1X,E12.5)')i,a  !-------(2)
      
! we can pass format identifier by using string variable
      formt = '(I2,E14.3)'
      WRITE(10,formt)i,a              !-------(3)
```
__output__
```text
monthly         value    (1)
08  0.12367E+13          (2)
 8     0.124E+13         (3)
```
In this way, we have to treat format identifier as character data type
#### FORMAT文を経由する方法

```fortran
<sentence number>   FORMAT(<fromat identifier>)    !In this case , format identifier is not character
```
先ほどと同様の例で書いてみます。

```fortran
      INTEGER i
      REAL*8  a
      CHARACTER  month*16,label*16,formt*32
      i = 8
      a = 123.674e10
      month = 'monthly'
      label = 'value'
      OPEN(10,file='output.text')
      WRITE(10,100)month,label
      WRITE(10,200)i,a
      WRITE(10,300)i,a
100   FORMAT(2A16)      !FORMAT文はプログラムのどこに書いてもOK
200   FORMAT(I2.2,1X,E12.5)
300   FORMAT(I2,E14.3)
```

## Close file by CLOSE statement
We should close file and release momory of computer when its file is necessary.

```fortran
      CLOSE(<unit number>)
```
# Concatenation of character
FORTRANで文字の連結を行うときは'`+`'の代わりに'`//`'を使います。

We can use `//` when we want to concatenate more than two character.
```fortran:concat.F
      PROGRAM MAIN
      IMPLICIT NONE
      CHARACTER text*7
      DATA  text /'FORTRAN'/
      CHARACTER ver /' 77'/
      WRITE(*,*)text//ver   !output 'FORTRAN77'
      END
```
## Convertion between numerical value and numerical character
文字の連結は当然文字同士でしか行うことができないので、下の例のように、整数型や実数型の数値を文字として扱うには型の変換を行う必要があります。ところが、Fortranでは宣言した変数の型自体を変えることができないので、あらかじめ文字型の変数も宣言しておくことで、この問題に対処します。
このとき`numerical value=>numerical character`の変換にはWRITE文を使います。

```fortran
     WRITE(<出力先の文字型変数>,<数値型の書式識別子>)<文字型に変換したい数値型の変数>
```

```fortran
!具体例
      INTEGER iyy
      CHARACTER cyy*4
      iyy = 2018
      WRITE(cyy,('I4.4'))iyy
```
整数型変数のiyyをWRITE文で数字として読み取って、文字型変数のcyyに出力しています。


## 文字の連結の実例
文字の連結は個人的には、モデルのアウトプットを、ある座標における時系列データに整理するときに、日付ラベルを作成するために利用しています。日付ラベルは一般的によく使われる`YYYY-MM-DD`型([ISO 8601](https://ja.wikipedia.org/wiki/ISO_8601)の拡張型と呼ばれるらしい)になるようにします。

```fortran
      INTEGER    iyy,imm,idd
      INTEGER    mday(12)
      DATA   mday /31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 /
      CHARACTER  cyy*4,cmm*2,cdd*2
      CHARACTER  date*10
      DO iyy=2000,2005          !年
        WRITE(cyy,'(I4.4)')iyy
        IF (iyy % 4 == 0) THEN  !うるう年の判定
            mday(2) = 29
        ELSE THEN
            mday(2) = 28
        ENDIF
        DO imm=1,12             !月
          WRITE(cmm,'(I2.2)')imm
          DO idd=1,mday(imm)    !日
            WRITE(cdd,'(I2.2)')idd
            date=cyy//'-'//cmm//'-'//cdd !ここでカウンタ変数をもとに日付ラベルを作成
            !!~~~~~ファイルへの書き込み処理等は省略~~~~~~~~
          ENDDO
        ENDDO
      ENDDO
```
(可読性を高めるためにDOループを階層にするとすぐに文字数制限に到達してしまうところが悩みどころ...)

# サブルーチンを使う
数値モデルではしばしば1つのメインプログラムとその他膨大な数の副プログラムで構成されます。ここでは副プログラムを構成するサブルーチンの使い方についてまとめていきます。
サブルーチンのイメージを下図に書いてみました。

![subroutine](https://github.com/earth06/mydocument/blob/master/subroutine.png)
      


ここでは渡された素材に対して色を塗るというサブルーチンがあったとします。メインプログラムからは`CALL文`によって素材をサブルーチンに渡すことで、素材の色塗りを依頼することができます。サブルーチンでの処理が終わると加工された素材がメインプログラムに返却されます。
このとき渡した素材の個数と返却されるものの個数は一致していなければなりません。 ここでいう素材は変数に対応します。
それではサブルーチンの具体的な書き方に移っていきます。

## サブルーチンの構造
サブルーチンは呼び出し側のプログラムとは独立して書かれます。そのためサブルーチン内で用いる変数や定数は宣言されなければなりません。また基本的に呼び出し側のプログラムで使われている変数は共有されません。同じ変数名であっても別のものと考えなければなりません。
サブルーチンを呼び出すときは呼び出し側から`CALL文`を用いて呼び出します。

```fortran
      PROGRAM MAIN
      IMPLICIT NONE
      INTEGER <実引数1> 
      !~~~~~~~~~中略~~~~~~~~~!
      CALL  sub(<実引数1>,<実引数2>,...,)     

      END
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!      
      SUBROUTINE sub(<仮引数1>,<仮引数2>,...,<仮引数n>)
      IMPLICIT NONE
      INTEGER <仮引数1>   !仮引数も含めて変数を宣言する     
      !~~~~~~~~~中略~~~~~~~~~!
      RETURN
      END
```
実引数には呼び出し側のプログラムで宣言している変数および定数を指定します。仮引数にはサブルーチン内で宣言される変数および定数を指定します。実引数と仮引数は書かれた順に1対1に対応します。そのため対応する実引数と仮引数の型は一致していなければならず、また引数の数も一致していなければなりません。
CALL文でサブルーチンへ処理が移ったとき、仮引数は対応する実引数と同じ値を保持します。その後RETURN文に到達したときの仮引数と値を実引数へと渡します。

引数の個数が多くなってくると誤りを起こしやすくなるので、下記のように継続行をうまく使って書くこともできます。

__継続行を用いて引数を見やすくした書き方__

```fortran
      PROGRAM MAIN
     !~~~~~~~~中略~~~~~~~~~~~~~!
      CALL sub
     I        ( <実引数1>,
     M          <実引数2>,.....,<実引数n-1>,
     O          <実引数n> )
     !~~~~~~~~中略~~~~~~~~~~~~!
      SUBROUTINE sub
     I        ( <仮引数1>,
     M          <仮引数2>,.....,<仮引数n-1>,
     O          <仮引数n>)
     !~~~~~~~~省略~~~~~~~~~~~~!
```
(書きながら気づいたのですが、どうやら6桁目の継続行記号は0以外なら何でもいいみたいですね...)

この例では`I`は入力専用(ルーチンの中での書き換えはない),`M`は入力値を変更して出力,`O`は出力専用(入力時は不定でよい)といった使い方をしてみました。ところがこの書き方では引数の値の変更を制限してくれません。もしそのような制限を加えたい場合は`INTENT文`を使うのが良いでしょう。(ソースコードには出てこないので割愛)


## 具体例
かなり回りくどい書き方ですがサブルーチンからさらに別のサブルーチンを呼び出すパターンも紹介しておきます。
ここではメインプログラムから実引数としてi,j,totalをサブルーチンに渡し、i,jを入れ替え、iとjの和をtotalに代入するという処理を行っています。

main.F
```fortran
      PROGRAM MAIN
      IMPLICIT NONE
      INTEGER i,j,total
      i=1 ;  j=2  !!   ; 記号で改行したことにできます。
      WRITE(*,*)'before'
      WRITE(*,100)'i=',i,'j=',j,'total=',total
      CALL swap(i,j,total)
      WRITE(*,*)'after'
      WRITE(*,100)'i=',i,'j=',j,'total=',total
100   FORMAT(A3,I2,A3,I2,A6,I2)
      END
```

sub.F
```fortran
      SUBROUTINE swap(ii,jj,total)
      IMPLICIT NONE
      INTEGER ii,jj,total,temp
      temp  = jj
      jj    = ii
      ii    = temp
      CALL add(ii,jj,total)
      RETURN
      END

      SUBROUTINE add(ii,jj,total)
      IMPLICIT NONE
      INTEGER ii,jj,total
      total = ii + jj
      RETURN
      END
```

ファイルを２つに分けた場合`ifort main.F sub.F`でまとめてコンパイルできます。

```fortran
 before
 i= 1 j= 2 total= 1
 after
 i= 2 j= 1 total= 3
```

# まとめ
思っていた以上に長くなりましたが、今回の記事で数値モデルに登場するFORTRAN77文法の8割くらいは網羅できました。残りは番外編で消化します。
FORTRAN77は一行あたりの文字数制限と行頭6桁にコードを記述できないことに気を付ければ、古い言語だけに機能も少なく、仕様も単純なので習得はさほど難しくないのではないでしょうか...

私自身そこまで知識や技術に乏しいところがあるので、表現がおかしかったり、文法的に間違っている所とかがありましたらご指摘いただけると助かります。
(正直サブルーチンはうまくまとめきれていないと感じています。)

# 次回の予定
サブルーチンに関わるCOMMON文,SAVE文,ENTRY文、推奨されていないのでスルーしたGOTO文、あとはNAMELISTとかプリプロセッサについて記述する予定です。
