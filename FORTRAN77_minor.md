応用編が思った以上に長くなったので完結編を作りました。サブルーチンの応用、NAMELIST、(条件付き)コンパイルの方法など、規模の大きい数値モデルに使われているテクニック的なことを中心にまとめます。ここで紹介する内容は、一部FORTRAN77の機能でないものも含まれています。

# サブルーチンの応用

## COMMON文を用いてメインプログラム側とサブルーチン側の変数を共有
COMMON文(非推奨)は以下のように共通ブロック名と共有する変数のリストを記述します。共通ブロック名を指定しないパターンもあり、無名COMMONブロックと呼びます。


```fortran
      COMMON  / 共通ブロック名 / 変数のリスト
OR
      COMMON  変数のリスト         !共通ブロックを指定しないVer
```
COMMON文で指定された変数は他の言語でいうところのグローバル変数としての性質を持ちます。
便利といえば便利ですが多用しすぎるとコードの検証が難しくなってしまうことがあるので推奨されていません。
またCOMMON文の変数はPARAMETER文で定数にすることはできないようです。
### 例
ここでは物理定数の値をセットするサブルーチンを呼び出すことで、メインプログラム側の物理定数にも値をセットする例を挙げます。
common.F
```fortran
      PROGRAM MAIN
      IMPLICIT NONE
      REAL*8 grav,er,rair,melt
      COMMON  /const/  grav,er,rair,melt

      CALL SETVAL()
      WRITE(*,*)grav,er,rair,melt
      melt=0.d0
      WRITE(*,*)'melt:',melt !定数としては扱われないので書き換えることもできてしまいます。
      END

      SUBROUTINE SETVAL()
      IMPLICIT NONE
      REAL*8 grav,er,rair,melt
      COMMON /const/ grav,er,rair,melt

      grav=9.8d0
      er = 6400d3
      rair=287.1d0
      melt=273.15d0
      RETURN
      END
```
output
```text
  0.98E+01  0.64E+07  0.29E+03  0.27E+03
 melt:  0.00E+00
```
CALL文で引数を指定していませんが、メインプログラム側のCOMMON文で指定されている変数に値がセットされていることが確認できます。

変数を宣言する部分を別のファイルに作成し、後述するinclude文で必要に応じて呼び出すというテクニックが用いられています。

## SAVE宣言文によるルーチン内変数の値の保証
SAVE宣言文とは、あるサブルーチンが繰り返し呼び出されるとき、そのルーチン内で宣言されている変数の値が次に呼び出されるときに保持されることを保証するための文です。

```fortran
      SAVE  <宣言済みの変数のリスト>      
```
### 例
i,jを入れ替えるサブルーチンswapが呼び出された回数をルーチン内変数freqに記録する例を紹介します。
pr_save.F
```fortran
      PROGRAM MAIN
      IMPLICIT NONE
      INTEGER i,j,loop
      i = 1;  j = 2
      DO loop=1,3
        CALL swap(i,j)
        WRITE(*,'(A3,I2,A3,I2)')'i=',i,'j=',j
      ENDDO
      END

      SUBROUTINE swap(i,j)
      IMPLICIT NONE
      INTEGER i,j,temp
      INTEGER freq
      SAVE  freq       !SAVE宣言文
      DATA  freq / 0 /  !初めてサブルーチンが呼び出されたときにだけ機能し、freqの初期値を0に設定する
      temp = i
      i = j
      j = temp
      freq = freq + 1
      WRITE(*,'(A7,I2)')'freq:',freq
      RETURN
      END
```
実行結果
```text
 freq: 1
 i= 2 j= 1
 freq: 2
 i= 1 j= 2
 freq: 3
 i= 2 j= 1
```
SAVE宣言を行うとサブルーチン内の変数freqの値が前の呼び出しの時の値を覚えておいてくれます。

##ENTRY文によるサブルーチンの機能追加
ENTRY文(非推奨)を使うと、あるサブルーチンに対してルーチン内変数を共有して別の機能を持たせることができます。SAVE文と併用して、ENTRY文によってルーチン内変数を書き換えてから、そのサブルーチン本体を呼び出すというテクニックがしばしば使われていました。

次の例ではentry文にルーチン内変数を初期化する働きを持たせ、SUBROUTINE文でその変数を画面に出力する処理を行っています。
entry.F
```fortran
      PROGRAM MAIN
      IMPLICIT NONE
      INTEGER idd,ihh
      INTEGER time

      DO idd=1,3
        CALL init()     !ENTRY文を呼び出し
        DO ihh=1,24
           CALL sub()   !SUBROUTINE文を呼び出し
        ENDDO
      ENDDO
      END

      SUBROUTINE sub()
        IMPLICIT NONE
        INTEGER time
        SAVE time
        WRITE(*,*)time
        time = time + 1
      RETURN

      ENTRY init()
        time = 0
      RETURN
      END       !ENDはSUBROUTINE文とENTRY文で共有
```

# GOTO文(廃止予定)
絶滅したかと思いきや、数値モデルでは現役でした。
GOTO文を使うと指定した文番号に無条件でジャンプすることができます。GOTO文を乱用するとプログラムの流れを混沌とさせるので非推奨とされています。素直にサブルーチンとかを使いましょう。

```fortran
      GOTO  <文番号>
```

# NAMELISTによる変数への値の代入
NAMELISTはFORTRAN77の機能ではなくFortranの機能ですが、コンパイル後に変数の値を代入できるため、数値モデルにしばしば導入されています。変数に値を代入するために、別途テキストファイルを用意する必要があります
FORTRAN側のNAMELSITの使い方
```fortran
      NAMELIST /<NAMELIST名>/ <代入する変数名のリスト>
      
      OPEN(<装置番号>,<テキストファイル名>)
      READ(<OPEN文で指定した装置番号>,<NAMELIST名>)
```
テキスト側のNAMELSITの書き方
```text
&<NAMELIST名>　var1=1.d0 ,var2=2.d0 ...   &end 
```
NAMELISTの書き方はどうもコンパイラによる書き方の違いがあるようです。(投稿者の環境では下の例でifort,gfortranで実行を確認できました)
うまくいかないときは使用しているコンパイラのドキュメントを参照するとよいでしょう。

## 例
nmlist.F
```fortran
      PROGRAM MAIN
      IMPLICIT NONE
      INTEGER int1, int2
      CHARACTER infile*16,outfile*16
      REAL*8  fact1,fact2

      NAMELIST /NMINOUT/ infile,outfile
      NAMELIST /NMFACT/ fact1,fact2
      NAMELIST /NMINT/  int1,int2

      OPEN(10,file='name.txt')  !ファイルの開き方は同じ
      READ(10,NMINOUT)           !書式識別子にNAMELIST名を記述,変数名のリストを並べる必要はない
      READ(10,NMFACT)
      READ(10,NMINT)

      WRITE(*,*)'infile:',infile,'outfile:',outfile
      WRITE(*,*)'fact1:',fact1,'fact2:',fact2
      WRITE(*,*)'int1:',int1,'int2',int2

      CLOSE(10)
      END
```
name.txt
```text
&nminout infile='init.csv' ,outfile='output.csv' &end
&nmfact fact2=2.d0,fact1=1.d0  &end
&nmint  int1=10,int2=20  &end
```
実行結果
```text
 infile:init.csv        outfile:output.csv
 fact1:   1.00000000000000      fact2:   2.00000000000000
 int1:          10 int2          20
```
name.txtの`&nmfact`では`fact2=2.d0,fact1=1.d0`とFORTRAN側とで順番を入れ替えていますが、問題なく代入されています。


NAMELISTで入力ファイルのパスを渡すことで、多次元配列の情報を持つ入力ファイルを変更することもできます。

#コンパイルとC言語プリプロセッサ―
Fortranはコンパイルを行い、機械語に翻訳してからでないとプログラムを実行できません。
ここでは作成したプログラムをコンパイルして実行ファイルを作成する方法とコンパイル時に条件を付ける方法を紹介します。

## コンパイルの基本
コンパイラには代表的なものが2つあって一つはIntel社が出している有償のIntel Fortran Compiler(ifort)と無償のGNU Fortran Compiler(gfortran)です。
Debian系ならgfortranは`sudo apt install gfortran`で導入できます。
コンパイルは基本的にshell上で以下のコマンドを用いて行われます。

```bash
gfortran <プログラムファイル>
#または
ifort <プログラムファイル>
```
## C言語プリプロセッサで条件付きコンパイル
ソースコード中にC言語プリプロセッサを記述すると、コンパイル時にコードの条件選択を行ったり、外部ファイルのインポートを行うことができます。数値モデルの一部の計算スキームを変更し、その結果を比較したいときに既存のソースコードを書き換えたり、新しくファイルを作成する必要がなくなる、物理定数などを宣言したファイルをインポートすることで、それぞれのファイルでそれらを宣言する必要がなくなる、などの利点があります。

C言語プリプロセッサが含まれたコードをコンパイルするときはコンパイルオプションに`-cpp`を加えて

```sh
ifort -cpp <プログラムファイル>
#または
gfortran -cpp <プログラムファイル>
```
とします。
また`#defined`などでオプションが設定されているときは`-cpp`に加えて`-D<オプション名>`を指定します。

```sh
ifort -cpp -D<オプション名> <プログラムファイル>
#または
gfortran -cpp -D<オプション名> <プログラムファイル>
```

* __\#include__ : 外部ファイルをコードに内挿する。
* __\#if,defined,\#ifdef,#ifndef__ : 条件の真偽によって使用するFORTRANコードを選択する。

## 例
次の例では、プリプロセッサを用いてコンパイル時に、メインプログラムが`val.F`をincludeするかどうかを決め、includeされたとき画面に`地球の体積`を計算し表示する、されなかったときは`-999`を表示します。
main.F
```fortran
      PROGRAM main
      IMPLICIT NONE
      REAL*8 vol

#ifdef EARTH   　　/*プリプロセッサ行中のコメントはC言語式で書きます*/
#include   "val.F"
      vol = (4.0e0*pi*er**3)/3.0e0
#else
      vol= -999
#endif
      WRITE(*,*)vol
      END
```
val.F
```fortran
!　サブルーチンと異なり、プログラムとしては不完全な状態です。
      REAL*8 pi
      PARAMETER ( pi = 3.141592e0)
      REAL*8 er
      PARAMETER ( er = 6.40e6)
```
この例では`ifort -cpp -DEARTH main.F`とコンパイルしたときは、プリプロセッサによって以下のfortranコードに変換されてからコンパイルを実行します。

```fortran
      PROGRAM main
      IMPLICIT NONE
      REAL*8 vol
!!!!!!!!include文で内挿された部分!!!!!!!!!!!      
      REAL*8 pi
      PARAMETER ( pi = 3.141592e0)
      REAL*8 er
      PARAMETER ( er = 6.40e6)    
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      vol = (4.0e0*pi*er**3)/3.0e0
      WRITE(*,*)vol
      END
```
同様に`ifort -cpp main.F`とコンパイルされたときは

```fortran
      PROGRAM main
      IMPLICIT NONE
      REAL*8 vol
      vol= -999
      WRITE(*,*)vol
      END
```
となります。

C言語プリプロセッサについてはまだ他の使い方もあると思いますが、詳しくはほかの資料を参照ください。
