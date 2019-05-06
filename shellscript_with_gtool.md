# Statistical processing by gtool

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

Next ,make annual temperature from 2005 to 2009 at the same time by using shell script.

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

Let's make monthly temperature  as  `T_1, T_2, ... T_3` from  `T` by using shellscript



## 3. concatenate

2005-2009のデータを連結させる。



`cat` command is useful for concatenating each data into one file.


**Q) concatenate each monthly data which made at previous section into one file.**


<details><summary>Answer</summary><div>

```bash
$ cat 2005/T 2006/T 2007/T 2008/T 2009/T > T.yy
```
</div></details>

**Q)**

Then please make `T.mm` from `T` at the same time by  updating  Ch.2 script.


## 4. monthly => climatology 

2.で求めた月平均から気候値を求める。

## More advanced operation

より複雑な操作や、効率の良い処理を行いたい場合は直接Fortranで計算処理をする方がいいかも。

pythonでもgtool形式のデータを読むモジュールを作成したので代用は可能。
