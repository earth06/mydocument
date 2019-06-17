# Gtool Basic

Trouble that happens often is mainly below reasons. 

* Permission is denied when you try to run gtool  even though you stay in other's directory.
* gtool dosen't work correctly when beginning character is  `./` 
* We have to be running `X server` on local PC before plotting

Almost all of the case,option and file order don't influence the result. 

中身を確認したりするには便利だが、複雑なことをやろうとすると、少し苦しい.

よく使うコマンドは以下である。

## Contour plot

```bash 
gtcont map=1 color=20 <input file> 
<argument>
[args] [type]       [ meaning]                  [example]       
color  int    : the number of color            color=20
range  float  : set contour range              range=0,100
str    int    : set begining of data timestep  str=1
end    int    : set end of data timestep       end=2
fact   float  : multiply fact and input data   fact=10
x,y,z  int    : slicing dimension                  x=1 ,z=30 ,y=0
```
### Generate postscript file

```bash
gtcont <input file> str=1 end=1 -print ps:<output file>.ps
```

add `-print` option and write output file name after`ps:` .

you should add `.ps` extension to output file.


## average time(gtavr)
```bash
gtavr <input file> out:<output file>
<argument>
[args] [type]       [ meaning]                  [example]
str    int    : set begining of data timestep  str=1
end    int    : set end of data timestep       end=2
fact   float  : multiply fact and input data   fact=10

<example>
gtavr mc_bc str=1 end=30 out:mc_bc_jan
```
Basically, This average operation  is used in order to get time average of data.


## Four arithmetic operation
### Addtion (gtadd)

```bash
gtadd <input file1> <input file2> out:<output file>
```
### Subtraction (gtsub)
```bash
gtsub <input file1> <input file2> out:<output file>
```
### Multiplication (gtmlt)
```bash
gtmlt <input file1> <input file2> out:<output file>
```
### Division (gtdiv)
```bash
gtdiv <input file1> <input file2> out:<output file>
```
## Show data as text(gtshow)

```bash
gtshow <input file>
```
This command is often used when we want to check header information of input file

```bash
<exmaple>
gtshow mc_bc |head -n 60
```

## Edit Header info(gtset)

```bash
gtset <input file> title='new title' ...  <output file>
```
rewrite header

See Gtool Document in detail 



## Slicing data(gtsel)

```bash
gtsel z=1 <inputfile> out:<output file>
```

Slicing data.

We often use this command to get only surface data from 3dimensional  data.

(Because 3D hourly data is so large that I have to wait  for a longtime to read the original data ...)



# About model grid



![model_grid.png](https://github.com/earth06/Figure/blob/master/model_grid.png?raw=true)

default model grid is  128 X 64 X 36 grid called `t42`

``` 
  the number of grid      meaning           difinition file
x         128            :logitude          GTAXLOC.GLON128
y          64            :latitude          GTAXLOC.GGLA64
z          36            :sgima level       GTAXLOC.HETA36
```

GRID difinition file are saved  at `GTAXDIR`,and you can show them by `gtshow GTAXLOC.GGLA64`

Model vertical level is `sigma`
you can convert it to pressure level by using GTAXLOC.HETA36

```python
for k in range(36):
    P[i,lat,lon]=a[i]+b[i]*Ps[i,lat,lon]
```



# Model (Gtool) data structure

![gtool_data_structure2.png](https://github.com/earth06/Figure/blob/master/gtool_data_structure2.png?raw=true)

Fortran header/footer 

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

