

# FORTRAN77 syntax

FORTRAN77 　roughly have two construction.
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

## limitation the number of letter in one line

FORTRAN77 limit the maximum number of letters in one line as 72 letters. letters which exceed the limitation will be ignored when compile. Moreover from first letter to  sixth letter must be used for other way (eg. sentence number or FORMAT sentence etc...). Details will be decribed below. 
So we can only use 66 letters between 7th and 72th letter .

## continuation line

As mentioned above , FORTRAN77 have limitaion about the number of letters but we can escape the maximum limitaion of letters by using symbol for continuation line. The way is to write '$' or '&' at 6th letter in next line. See below. this is example of declare string type array 'MON' and set initial value into it.

```fortran
      CHARACTER MON(12)*3  !declare array which have 12 element and each element can save 3 characters
      DATA  MON / 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
     $            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' /    !space is ignored when compiled

```

Actually We can set any symbol except numerical character at 6th letter. 

## Comment line
コメント行はコンパイル時に無視される行で、`*`や`!`を用いて行のコメントアウトを行います。
`*`を用いてコメントアウトするときは`*`を行頭に置かなけれなりません。
`!`を用いてコメントアウトするときは`!`を行のどこに置いてもよく、`!`から行末までをコメントアウトします。
Comment line is the line which is ignored when compiled
```fortran
!利用例
* コメント
! コメント
      a + b   !ここから行末までコメント
```

# FORTRAN77の変数
 
FORTRANはpythonとかと違い、変数の型推論をやってくれないので事前に型を定めて変数を宣言する必要があります。
ただ、その前にやっておいたほうがよいことが、暗黙の型宣言の無効化です。

## 暗黙の型宣言の無効化
暗黙の型宣言を無効化すると、宣言していない変数が実行文中に使われているとコンパイル時にエラーになります。
タイプミスなどのヒューマンエラーをプログラム実行前に除去できるので、利用が推奨されています。

次にそれぞれの型の変数宣言の例を紹介していきます。
## 整数型(integer)
整数は4byteで表されるので、$-2^{31} \sim  2^{31}-1$ の整数値をとることができます。

```fortran
!宣言例
       INTEGER i
!複数同時に
       INTEGER i,j,k 
```
## 実数型(real)
実数は4byteで表される単精度(デフォルト)と8byteで表される倍精度をとります。

```fortran
!単精度
      REAL  a
!倍精度
      REAL*8 b
```

### 実数の表記法
実数値を記述するときはE,Dを用いた指数表記を使うことが多いです。

```fortran
!単精度実数ではEを使う
      a=1e0      !a = 1.0
      a=1E5      !a = 1.0 X 10^5
!倍精度実数ではDを使う
      b=0.1D-1   !b = 0.10 X 10^-1
      b=-5.0D10  !b = -5.0 X 10^10
```
## 文字型(character)
文字型を宣言するときはその変数が所持できる文字数も同時に記述する必要があります。

```fortran
     CHARACTER  char*10   !このときcharは10文字だけ文字を格納することができる
```
## 論理型(logical)
```fortran
      LOGICAL  flag
!論理型がとる値は.TRUE.と.FALSE.の2つだけ 
      DATA flag / .TRUE. / 
      IF ( flag )THEN
         flag = .FALSE.
      ENDIF
```
## DATA文による変数への初期値の代入
変数を宣言した後に以下のようにDATA文を使用することでその変数に初期値を代入することができます。初期値の代入はプログラムの実行に入る前に1度だけ行われます。

```fortran
      REAL*8 x
      INTEGER count
      DATA x / 0.d0 /
      DATA count / 0 /
```

## PARAMETER文による定数の設定
これまで扱ってきたものは変数であり、プログラムの実行文中でその値を変更することができました。ここでは変数を宣言した後にPARAMETER文を用いて定数を定めます。PARAMETER文で定められた定数は実行文中で変更することはできません。

```fortran
      REAL re
      REAL*8 pi
      PARAMETER ( re = 6400e3)            !()は必要
      PARAMETER ( pi = atan(1.D0)*4.D0 )  !宣言時に関数を使ってもOK
```
　
　
ここまでで変数と定数の宣言を見てきました。

次はいよいよFORTRAN77の制御構文に入ります。
#IF文による条件分岐
条件式が真のときそれに対応する実行文を実行します。
分岐はいくつに分けてもよく、またIF文の中にIF文を記述する多重構造になっても構いません。(ただしIF文がクロスすることは不可能)

```fortran
     IF ( 条件式1 ) THEN
          実行文1
     ELSE IF ( 条件式2 ) THEN
          実行文2
     ELSE THEN
          実行文3
     ENDIF
```

## 条件式に用いられる比較演算子

|条件式|文字表記|真を返す条件|
|:----|:-----|:-----|
|a > b|.GT.|aはbより大きい|
|a >= b|.GE.|aはb以上|
|a < b|.LT.|aはbより小さい|
|a <= b|.LE.|aはb以下|
|a == b|.EQ.|aとbは等しい|
|a /= b|.NE.|aとbは等しくない|

## 論理演算子
複数の条件式を同時に判定するときには論理演算子を用います。

|記号|真を返す条件|
|:----|:----|
|( 条件式A ) .AND. ( 条件式B )|条件式Aが真かつ条件式Bが真|
|( 条件式A ) .OR. ( 条件式B )|条件式Aが真または条件式Bが真|



# DOループによる繰り返し
## 基本的な使い方

```fortran
     INTEGER i  !カウンタ変数

     DO i=<開始値>,<限界値>,<増分値>  !増分値は負でもよい
           <処理>
     ENDDO
     <処理2>
```
ここでは変数iをDOループのカウンタ変数として使用しています。カウンタ変数は整数でないとダメです。
iにはループの初回に<開始値>が代入されます。ループの中の<処理>が終わるとiの値は<増分値>だけ加算され、加算されたiの値が<限界値>以下であるとき繰り返し処理を行い、iが<限界値>を上回ったとき繰り返し処理を行わずにDO文の下の<処理2>に移ります。
<増分値>は省略することができ、その場合は増分値は1として扱われます。
DOループもif文と同様に多重にすることができますがループがクロスすることは許されません。

## 文番号を用いるパターン
文番号を用いるDOループは今後廃止予定みたいですが、それはFORTRAN77には関係ない話で、私が使用している数値モデルのソースにはがっつり使用されているのでその使用例も書いておきます。

```fortran
      INTEGER i
      DO <文番号> i=<開始値>,<限界値>,<増分値>

<文番号>  CONTINUE
```

### 文番号
文番号は行の先頭に5桁以下の整数を定めます。一つのプログラム中に同じ文番号を定めることはできません。
ループの終点や変数を出力するときのformatを指定するときに文番号は使われます。文番号の決め方にルールはありませんが、プログラムを書くときはダブらないように自分の中でルールを定めておくとよいでしょう。

### CONTINUE文
CONTINUE文は'何も処理を行わない'という実行文です。`ENDDO`の代わりに用いられます。

以上をふまえて基本のループと文番号を用いたループで九九を画面に表示するプログラムを書いておきます。

loop1.F

```fortran
!基本のループ
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

loop2.F

```fortran
!文番号を用いたループ
      PROGRAM MAIN
      IMPLICIT NONE
      INTEGER i,j
      DO 10 i=1,9
        DO 10 j=1,9
           WRITE(*,*)i ,'X', j ,'=',i*j

10    CONTINUE   !文番号を用いる場合ループの終点を共有することができる。
      END
```
# 次回の予定
次回はサブルーチンの使い方やファイル入出力、プリプロセッサによる条件付きコンパイル、NAMELISTによる変数の代入などをまとめていきたいと思います。

# 参考文献
富田博之・斎藤泰洋　共著「Fortran 90/95プログラミング」(2011年 改訂新版)

（この書籍はFortran90/95を対象としているがFORTRAN77式の文法も紹介されており、大変助けられた。）
