# 気象関係でよく使われるカラーマップをmatplotlibで再現する

## はじめに

matplotlibで気象関係の図を描くときに、カラーマップをmatplotlib搭載のものではなく、grads標準のものや気象庁で公開されているものに合わせたいことがある。

本記事では以下のような感じでそれらのカラーマップを自作して、matplotlibでも同様の配色の図を作成できるようにする。

![](C:\Users\kjkrs\OneDrive\Document\GitHub\mydocument\qiita下書き\intro.png)



## 環境

python 3.7.8

matplotlib 3.3.2

numpy 1.19.2

cartopy 0.18.0 緯度経度座標でのプロットに利用

xarray 0.16.1 netcdfデータの読み込みに利用

プログラムの実行はjupyterlabで行っています

## 自作のカラーマップを作る

カラーマップ作成に必要なモジュールのインポート

```python
#[1]
import numpy as np
from matplotlib.colors import ListedColormap,LinearSegementedColormap
```

### gradsっぽいカラーマップ

gradsデフォルトのカラーマップRGB情報は[こちら](http://cola.gmu.edu/grads/gadoc/colorcontrol.html)のサイトを参照した。

カラーマップの配色数を固定する場合は`ListedColormap`を、指定した配色に対して、その間の配色を線形補完したい場合は`LinearSegementedColormap`を用いる。

参考 :  [Creating Colormaps in Matplotlib](https://matplotlib.org/3.1.0/tutorials/colors/colormap-manipulation.html)

```python
#[2]
#gradsっぽいカラーマップ
gscolors=np.array([
    [160,0 ,200,1],#purple
    [130,0 ,220,1],#dark purple
    [30 ,60,255,1],#dark blue
    [0, 160,255,1],#medium blue
    [0, 200,200,1],#light blue
    [0, 210,140,1],#aqua
    [0,220,0,1],   #green
    [160,230,50,1],#yellow/green
    [230,220,50,1],#yellow
    [230,175,45,1],#dark yellow
    [240,130,40,1],#orange
    [250,60,60,1],#red
    [240,0,130,1]#magenta
],dtype=np.float)
gscolors[:,:3]/=256 #RGBを0-1の範囲に変換
gscmap=ListedColormap(gscolors)
gscmap2=LinearSegmentedColormap.from_list("gscmap2",colors=gscolors)
```

### 気象庁降水量っぽいカラーマップ

気象庁で使われているカラーマップRGB情報は[こちら](https://www.jma.go.jp/jma/kishou/info/colorguide/120524_hpcolorguide.pdf)を参照した。

こちらも同様にしてカラーマップを作成

```python
#[3]
#気象庁っぽいカラーマップ
jmacolors=np.array(
   [
    [242,242,242,1],#white
    [160,210,255,1],
    [33 ,140,255,1],
    [0  ,65 ,255,1],
    [250,245,0,1],
    [255,153,0,1],
    [255,40,0,1],
    [180,0,104,1]],dtype=np.float
)
jmacolors[:,:3] /=256
jmacmap=ListedColormap(jmacolors)
jmacmap2=LinearSegmentedColormap.from_list("jmacmap2",colors=jmacolors)
```

作成したカラーマップを確認してみる

```python
#[4]
mm,tmp=np.meshgrid(np.linspace(0,1,256),np.arange(10))
fig,axes=plt.subplots(figsize=(6,6),facecolor="w",nrows=4)

for ax,cmap,title in zip(axes,[gscmap,gscmap2,jmacmap,jmacmap2],["grads-Listed","grads-Linear","jma-Listed","jma-Linear"]):
    ax.imshow(mm,cmap=cmap)
    ax.axis("off")
    ax.set_title(title)
```

![](C:\Users\kjkrs\OneDrive\Document\GitHub\mydocument\qiita下書き\customcolormap.png)

割といい感じにできている

## 実際に使ってみる

作ったカラーマップを実際のデータに当てはめて見栄えを確認していく。

ここではサンプルデータとして[こちら](http://database.rish.kyoto-u.ac.jp/arch/jmadata/gpv-netcdf.html)のサイトから2020年9月9日のMSM1時間降水量を取得。

```python
#[5]データの準備
import matplotlib.pyplot as plt
import xarray as xr
import cartopy.crs as ccrs
ds=xr.open_dataset("./0909.nc")
precip=ds["r1h"].sel(time="2015-09-09T22:00")
xx,yy=ds["lon"],ds["lat"]
```

それでは作成したカラーマップ`gscmap`,`jmacmap`,`gscmap2`,`jmacmap2`をそれぞれプロットする。

```python
#[6]
levels=np.arange(0,80,5)#等高線の値

#ListedColormapで生成したカラーマップ
fig=plt.figure(figsize=(15,8),facecolor="w")
axes=fig.add_subplot(1,2,1,projection=ccrs.PlateCarree())
axes2=fig.add_subplot(1,2,2,projection=ccrs.PlateCarree())   
for ax,cmap,title in zip([axes,axes2],[gscmap,jmacmap],["grads-List","jma-List"]):
    ax.coastlines()
    gl=ax.gridlines(draw_labels=True,alpha=0.5)
    gl.top_labels=False
    gl.right_labels=False
    cf=ax.contourf(xx,yy,precip,levels=levels,transform=ccrs.PlateCarree(),cmap=cmap,extend="max")
    fig.colorbar(cf,ax=ax,orientation="horizontal")
    ax.set_title(title)
    ax.set_extent([133,144,32,42])

#LinearSegmentedColormapで生成したカラーマップ
fig=plt.figure(figsize=(15,8),facecolor="w")
axes=fig.add_subplot(1,2,1,projection=ccrs.PlateCarree())
axes2=fig.add_subplot(1,2,2,projection=ccrs.PlateCarree())     
for ax,cmap,title in zip([axes,axes2],[gscmap2,jmacmap2],["grads-Linear","jma-Linear"]):
    ax.coastlines()
    gl=ax.gridlines(draw_labels=True,alpha=0.5)
    gl.top_labels=False
    gl.right_labels=False
    cf=ax.contourf(xx,yy,precip,levels=levels,transform=ccrs.PlateCarree(),cmap=cmap,extend="max")
    fig.colorbar(cf,ax=ax,orientation="horizontal")
    ax.set_title(title)
    ax.set_extent([133,144,32,42])

```

![](C:\Users\kjkrs\OneDrive\Document\GitHub\mydocument\qiita下書き\listcmap.png)

![](C:\Users\kjkrs\OneDrive\Document\GitHub\mydocument\qiita下書き\linearcmap.png)

上図は`ListedColormap`で作成したカラーマップを用いたプロットですが、指定した等高線の数と配色の数が一致していないため、色の変化が不規則となってしまう。一方で下図の`LinearSegementedColormap`で作成したカラーマップは等高線の数に応じて、色を割り当てることができている。

## 不規則な等高線に対しても配色の割り当てを対応させる

コンター色の割り当ては等高線の値をもとに行われているため、不均一な等高線値を与えた場合、下図のように配色に偏よりが生じてしまう。

![](C:\Users\kjkrs\OneDrive\Document\GitHub\mydocument\qiita下書き\badcontour.png)

ここでは等高線の値によらずに色の割り当てを行う方法として次の2通りの方法を示す

1. 等高線の値とその時の色が1:1に対応している場合 => colorsを使う
2. 指定した等高線の値と数によって配色を割り当てたい場合 =>`BoundaryNorm`を定義する

### 1. colorsを使う

たとえば気象庁降水量のカラーマップの例では降水量ごとに色が1:1に対応している。この場合は以下のように、カラーマップを指定せずに、colorsに直接RGB配列を渡してあげるとコンターがきれいに書ける.

```python
#気象庁RGBカラー
jmacolors=np.array(
   [
    [242,242,242,1],#white
    [160,210,255,1],
    [33 ,140,255,1],
    [0  ,65 ,255,1],
    [250,245,0,1],
    [255,153,0,1],
    [255,40,0,1],
    [180,0,104,1]],dtype=np.float
)
jmacolors[:,:3] /=256
levels=[0,1,5,10,20,30,50,80] #等高線値

fig=plt.figure(figsize=(8,8),facecolor="w")
ax=fig.add_subplot(1,1,1,projection=ccrs.PlateCarree())
ax.coastlines()
gl=ax.gridlines(draw_labels=True,alpha=0.5)
gl.top_labels=False
gl.right_labels=False
cf=ax.contourf(xx,yy,precip,levels=levels,transform=ccrs.PlateCarree(),colors=jmacolors,extend="max")
fig.colorbar(cf,ax=ax,orientation="horizontal")
ax.set_extent([133,144,32,42])
```

![](C:\Users\kjkrs\OneDrive\Document\GitHub\mydocument\qiita下書き\jmacolors.png)

### 2. `BoundaryNorm`を定義する

等高線値と使用するカラーマップに使われている配色数(一般的に256色)から`BoundaryNorm`を定義。これをコンターを描くときにnormに渡すと、等高線値ごとに色の段階をあげた配色にすることができる。

参考: [matplotlibのcolormapのRGB情報取得と関連操作](https://qiita.com/HidKamiya/items/524d77e3b53a13849f1a)

```python
from matplotlib.colors import BoundaryNorm

levels=[0,1,5,10,20,30,50,80]
norm=BoundaryNorm(levels,ncolors=jmacmap2.N)

fig=plt.figure(figsize=(8,8),facecolor="w")
ax=fig.add_subplot(1,1,1,projection=ccrs.PlateCarree())
ax.coastlines()
gl=ax.gridlines(draw_labels=True,alpha=0.5)
gl.top_labels=False
gl.right_labels=False
cf=ax.contourf(xx,yy,precip,levels=levels,transform=ccrs.PlateCarree(),norm=norm,cmap=jmacmap2,extend="max")
fig.colorbar(cf,ax=ax,orientation="horizontal")
ax.set_extent([133,144,32,42])
```

![](C:\Users\kjkrs\OneDrive\Document\GitHub\mydocument\qiita下書き\jmabnorm.png)

悪くはないが理想的な配色にはならない。もともと色が青から黄色と真逆に変化するカラーマップとなっているため、LinearSegmentedColormap作成時に工夫が必要かもしれない。

等高線値とその配色があらかじめ決まっているなら、1.で対応するのが無難か。

## まとめ

matplotlibで、おなじみのカラーマップを再現することができた。



```python
def get_gscmap():
    gscolors=np.array([
        [160,0 ,200,1],#purple
        [130,0 ,220,1],#dark purple
        [30 ,60,255,1],#dark blue
        [0, 160,255,1],#medium blue
        [0, 200,200,1],#light blue
        [0, 210,140,1],#aqua
        [0,220,0,1],   #green
        [160,230,50,1],#yellow/green
        [230,220,50,1],#yellow
        [230,175,45,1],#dark yellow
        [240,130,40,1],#orange
        [250,60,60,1],#red
        [240,0,130,1]#magenta
        ],dtype=np.float)
    gscolors[:,:3]/=256 #RGBを0-1の範囲に変換

    gscmap=LinearSegmentedColormap.from_list("gscmap2",colors=gscolors)
    return gscmap
def get_jmacmap():
    jmacolors=np.array([
        [242,242,242,1],#white
        [160,210,255,1],
        [33 ,140,255,1],
        [0  ,65 ,255,1],
        [250,245,0,1],
        [255,153,0,1],
        [255,40,0,1],
        [180,0,104,1]],dtype=np.float)
    jmacolors[:,:3] /=256
    jmacmap=LinearSegmentedColormap.from_list("jmacmap2",colors=jmacolors)
    return jmacmap
```
## 参考文献

matplotlib公式
https://matplotlib.org/3.1.0/tutorials/colors/colormap-manipulation.html

カラーマップの調整
https://qiita.com/HidKamiya/items/524d77e3b53a13849f1a

気象庁降水量カラーマップ
https://www.jma.go.jp/jma/kishou/info/colorguide/120524_hpcolorguide.pdf

gradsカラーマップ
http://cola.gmu.edu/grads/gadoc/colorcontrol.html

利用したサンプルデータ
http://database.rish.kyoto-u.ac.jp/arch/jmadata/gpv-netcdf.html