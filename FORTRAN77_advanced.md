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
__result of example 1
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

__result of example 2
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
# File IO
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
OPEN文で指定する装置番号は整数(整数型変数でも可)で記述します。(前回の記事に出てきた文番号とは異なるので注意してください)
5番と6番はREAD,WRITE文で予約されているので避けた方がよいでしょう。
以後開いたファイルへの入出力はこの装置番号を用います

## READ文・WRITE文によるデータの読み書き
READ文もWRITE文も基本的にとる引数は同じで第1引数には装置識別子を、第2引数にはフォーマットを定める書式識別子をとります。

```fortran
      READ(<装置識別子>,<書式識別子>)<読み取ったデータを代入するリスト(変数とか)>
      WRITE(<装置識別子>,<書式識別子>)<ファイルに書き込むデータのリスト(変数とか)>
```
### 装置識別子

|装置識別子|意味|
|:-----:|:----|
|*|コンソール入出力|
|装置番号|OPEN文でこの番号と関連づけられているファイルに対して入出力|
|5|パンチカード時代の名残(らしい),使ったことないです|
|6|同上|
|文字型変数|入出力を文字変数に対して行う(詳しくは「数値と数字の変換」で紹介します)|

### 書式識別子の書き方
書式識別子は編集記述子を用いて記述されます。書式識別子をREAD・WRITE文の第2引数渡す方法は２つあり、1つは直接記述する方法、もう一つはFORMAT文に書式識別子を記述し、その文番号を第2引数に渡す方法です。
ここではどちらも紹介していきます。
#### 編集記述子
編集記述子の表中の`w,d,m,r`は正の整数値で以下の意味を持ちます。

|記号|意味|
|:---:|:-----|
|w|記述欄の桁数|
|d|実数型で、小数点より右側の桁数|
|m|整数型で、数字を書く桁数|
|r|反復回数|

__編集記述子__

|編集記述子|意味|備考|
|:---:|:-----|:----------------|
|[r]__I__w[.m]|10進整数をw桁の欄に右詰め,m桁の欄に空白がある場合0を代入|w>=m|  
|[r]__E__w[.d]|実数型をw桁の欄に小数点以下d桁で指数形式で表示,仮数部は0.1~1.0になる|w>=d+7 |
|[r]__A__[w]|文字型をw桁の欄で右詰め|
|[r]__X__|スペース|

#### 編集記述子を直接渡す方法

```fortran
      INTEGER i
      REAL*8  a
      CHARACTER  month*16,label*16,formt*32
      i = 8
      a = 123.674e10
      month = 'monthly'
      label = 'value'
      OPEN(10,file='output.text')
      WRITE(10,'(2A16)')month,label
      WRITE(10,'(I2.2,1X,E12.5)')i,a
!書式識別子は文字型変数で与えてもよい
      formt = '(I2,E14.3)'
      WRITE(10,formt)i,a
```

```text:output.text
monthly         value
08  0.12367E+13
 8     0.124E+13
```
#### FORMAT文を経由する方法

```fortran
<文番号>   FORMAT(<書式識別子>)    !FORMATに渡す書式識別子は文字型ではない
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

結果は先ほどと同じになるので省略します。
どちらの方法が良いかはよくわかりません。
## CLOSE文でファイルを閉じる
読み書きの必要がなくなったファイルはCLOSE文で閉じておきます。

```fortran
      CLOSE(<装置番号>)
```
# 文字の連結
FORTRANで文字の連結を行うときは'`+`'の代わりに'`//`'を使います。

```fortran:concat.F
      PROGRAM MAIN
      IMPLICIT NONE
      CHARACTER text*7
      DATA  text /'FORTRAN'/
      CHARACTER ver /' 77'/
      WRITE(*,*)text//ver   !'FORTRAN77'が出力される
      END
```
## 数値と数字の変換
文字の連結は当然文字同士でしか行うことができないので、下の例のように、整数型や実数型の数値を文字として扱うには型の変換を行う必要があります。ところが、Fortranでは宣言した変数の型自体を変えることができないので、あらかじめ文字型の変数も宣言しておくことで、この問題に対処します。
このとき`数値=>数字`の変換にはWRITE文を使います。

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
