# Gtool Basic

Gtoolでよくあるトラブルは、

* 他人のディレクトリにいるときにコマンドが実行できない。
* ディレクトリ名に`.`が含まれていたりすると正常に動作しない
* 描画時にはローカルPC上で`Xサーバー`を起動しておく必要がある。

中身を確認したりするには便利だが、複雑なことをやろうとすると、少し苦しい.

よく使うコマンドは以下である。

## Contour plot

```bash
gtcont map=1 color=20 <filename> 
```
### print data


## average time(gtavr)
```bash
gtavr 
```
## Addtion (gtadd)
```bash
gtadd
```
## Subtraction (gtsub)
```bash
gtsub
```
## Multiplication (gtmlt)
```bash
gtmlt
```
## Division (gtdiv)
```bash
gtdiv
```
## Show data as text(gtshow)
```bash
gtshow
```
## Edit Header info(gtset)
```bash
gtset
```
## Slicing data(gtsel)
```bash
gtsel 
```



# Shell script with gtool



## Copy dataset

Here, we use chaser daily dataset from 2005 to 2009. 

Please copy them into your working directory.

## 1. daily => annual

日平均データ一年分を年平均に変換する。

Please make annual temperature in 2005.

You can use `gtavr`

```bash
$ gtavr T out:T.yy
```

Check T.yy by gtcont

```bash
gtcont map=1 color=20 T.yy
```

### Q) make annual temperature from 2005 to 2009 at the same time by using shell script.

Below code is incomplete.

```bash
#! /bin/tcsh f
set iyy = ?
while ( $iyy <= ? )
set INDIR = ?
set OUTDIR = $INDIR
gtavr $INDIR/T out:$OUTDIR/T.yy 
end
```

### Annotation

gtoolのコマンドライン引数の先頭が数字の時gtoolがうまく動かない。

## 2. daily => monthly

日平均データを月平均データに変換する

### Q) Let's make monthly mean temperature  as  `T_1, T_2, ... T_3` from  `T` by using shellscript

```bash
#! /bin/tcsh
set im = 1
while ( $im <= ?)
	gtavr T str=? end=? out:T_${im}
@ iyy = $im + 1
end
```



## 3. concatenate

2005-2009のデータを連結させる。



`cat` command is useful for concatenating each data into one file.

### Q) concatenate each monthly data which made at previous section into one file.


<details><summary>Answer</summary><div>

```bash
$ cat 2005/T_1 2005/T_2 ... 2005/T_12 > T.mm
```
</div></details>

※You can also solve this question by using while statement

Let's try that.

### Q)Make monthly mean `T.mm` from daily `T` at the same time by  updating  Ch.2 script.

## 4. monthly => climatology 

Here, we should learn how to make climatology.

Maybe , you can make it by using the technique  you have learned until now 

### Q) make climatology between 2005 and 2009.

DJF   

MAM

JJA

SON

## More advanced operation

より複雑な操作や、効率の良い処理を行いたい場合は直接Fortranで計算処理をする方がいいかも。

pythonでもgtool形式のデータを読むモジュールを作成したので代用は可能。



Please refer to gtool official document when you want to know gtool format ,plot etc...

