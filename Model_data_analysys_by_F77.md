# Model data Analysys

## FORTRAN77



Compare with observation

観測データは定点か船上観測か航空機観測なので以下3つの方法を知っておけば応用できるはず

#### get station data

#### get shipborne data
#### get airplane data





### Caliculate colmun mass by vertical integration

質量濃度に関しては以下の式を計算するとカラム量を求めることができる

$$
column = \sum_{k=1}^{36}C_{mass}(k)\times\Delta z_k　\tag{1}
$$

ここで静水圧平衡の式から


$$
\Delta z_k = \frac{\Delta P_M(k)}{\rho_{air} g} \tag{2}
$$

ただし

$$
\Delta P_M(k) = | P_M(k+1)-P_M(k) |   \tag{3}
$$

またρは乾燥空気の密度を表し、気体の状態方程式から

$$
\rho_{air}= \frac{P(k)}{R_{air}T} \tag{4}
$$

以上からカラム量を求めることができる。

<img src="https://github.com/earth06/Figure/blob/master/column.png?raw=true" height="30%" width="30%" align="left">

一応コードも紹介するが、この書き方でないとダメというものではない。(FORTRAN77なのは許して)

構造化プログラミングの原則に従ってサブルーチンを用いて説明する。

```fortran
　　　　PROGRAM MAIN
　　　　IMPLICIT NONE
　　　　INTEGER ix  ,iy  ,k,
　　　　INTEGER idim,jdim,kmax
　　　　INTEGER iyy,imm,idd,mday(12),mdax(12)
　　　　INTEGER ps_num,t_num,bc_num
　　　　DATA mday /31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 /
　　　　PARAMETER (idim=128,jdim=64,kmax=36)
　　　　REAL sm(kmax+1),ameta(kmax+1),bmeta(kmax+1)
　　　　REAL s(kmax)   ,aeta(kmax)   ,beta(kmax)
　　　　REAL bcdat(idim, jdim, kmax)
　　　　REAL Tdat (idim, jdim, kmax)
　　　　REAL psdat(idim, jdim, kmax)
　　　　REAL colbc(idim, jdim)
　　　　
　　　　CHARACTER head(16)*64
　　　　
　　　　OPEN(10,file="GTAXLOC.HETA36",form="unformatted")
　　　　 read(10)head
　　　　 read(10)s
       read(10)head
       read(10)aeta
       read(10)head
       read(10)beta
       close(10)
       
　　　　open(11,file="GTAXLOC.HETA36.M",form="unformatted")
　　　    read(11)head
　　　    read(11)sm
　　　    read(11)head
　　　    read(11)ameta
　　　    read(11)head
　　　    read(11)bmeta
　　　    close(11)
　　　 
      bc_num=12
      ps_num=13
      t_num =14
      OPEN(12,file="mc_bc",form="unformatted")
      OPEN(13,file="ps",form="unformatted")
      OPEN(14,file="T",form="unformatted")
      
　　　  DO iyy=2005,2005   !In this case ,year is dummy info
　　　      mdax = mday
　　　      IF (mod(iyy-2000,4).eq.0)mdax(2)=mdax(2)+1
　　　      if iyy 
　　　      DO imm=1,12
　　　          DO idd=1,mdax(im)
　　　          	READ(t_num)head
　　　          	READ(t_num)Tdat
　　　          	READ(ps_num)head
　　　          	READ(ps_num)psdat
　　　          	READ(bc_num)head
　　　          	READ(bc_num)bcdata
　　　          	CALL COL_SUM(
     $　     	bcdat,Tdat,psdat
     $      	,idim,jdim,kmax,17
     $      	,aeta,beta
     $      	,ameta,bmeta
     $      	,coldat
     )
     			!ファイル出力
　　　          ENDDO
　　　      EDDO
      ENDDO
　　　　END
　　　　
　　　　SUBROUTINE COL_SUM(
　　　$    input, Temp ,ps
     $    ,idim,jdim,kmax,upperlim
     $    ,aeta,beta
     $    ,ameta,bmeta
     $    ,coldat)
　　　　IMPLICIT NONE
　　　　INTEGER ix,iy,k,idim,jdim,kmax
　　　　INTEGER upperlim
　　　　REAL   rd
　　　　PARAMETER (rd = 287.e0)
　　　　REAL   aeta(kmax),beta(kmax)
　　　　REAL   ameta(kmax+1),bmeta(kmax+1)
　　　　REAL   input (idim,jdim,kmax)
　　　　REAL   Temp  (idim,jdim,kmax)
　　　　REAL   ps    (idim,jdim)
　　　　REAL   coldat(idim,jdim)
　　　　REAL   P     (idim,jdim)
　　　　REAL   Pup   (idim,jdim)
　　　　REAL   Pbot  (idim,jdim)
　　　　REAL   delP  (idim,jdim)
　　　　REAL   rho   (idim,jdim)
　　　　REAL   delZ  (idim,jdim)
　　　　DO k=1,upperlim
　　　　	P     = aeta(k)    + beta(k)*ps
　　　　	Pup   = ameta(k+1) + bmeta(k+1)*ps
　　　　	Plow  = ameta(k)   + bmeta(k)*ps
　　　　	Plow  = ameta(k)   + bmeta(k)*ps
　　　　	delP  = Plow - Pup
　　　　	rho   = (P*100e0)   /(Temp(:,:,k)*rd)
　　　　	dz    = (delP*100e0)/(rho*9.8e0)
　　　　	colbc = colbc + input(:,:,k)*dz

       ENDDO
　　　　RETURN
　　　　END
```

またデータが混合比で表現されている場合は(1)はΔPを用いた積分に変換することができる。混合比の場合、温度の情報が不要なので積分は濃度よりも簡単になる。変換は一度自分の手で確認してみるとよい。

**Mass Mixing Ratio(MMR)**
$$
column = \sum_{k=1}^{36}\frac{MMR_k}{g}\times\Delta P_M(k)　\tag{5}
$$

**Volume Mixing Ratio(VMR)**
$$
column = \sum_{k=1}^{36}\frac{M}{M_{air}}\times\frac{VMR_k}{g}\times\Delta P_M(k)　\tag{6}
$$

以下のリンクに変換の実例が記述されているので参考になるかも

[ecmwf confluence](https://confluence.ecmwf.int/pages/viewpage.action?pageId=61121586)

コードは上の例を改変すれべ容易に作成できるはずである。



さらに全球総量へと変換するにはカラム量は単位面積当たりの量なので、そのグリッドの面積を乗じて水平方向に和をとることで求めることができる。
$$
global\ abundance = \sum_{lat}\sum_{lon}column(lat,lon)\times area(lat,lon)
$$



### 水平fluxを計算する

### anomaly を計算する
