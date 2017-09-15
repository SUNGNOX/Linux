## install.sh

#!/bin/bash

read -p "键入“脉冲星计时离线软件.tar.gz”绝对存储路径(/usr/local/src):" MAIN

echo $MAIN > main

if [  -z `cat main` ]; 

then MAIN=/usr/local/src;

if [ $? -eq 0 ]

then echo "默认路径‘/usr/local/src’创建成功"; 

fi

fi

rm main

cd $MAIN

read -p "键入“共享文件夹“的目录名:" SHARE

cp -rf /media/$SHARE/脉冲星计时离线软件.tar.gz $MAIN

#解压缩

tar -zxf 脉冲星计时离线软件.tar.gz

T2=$MAIN/脉冲星计时离线软件

cd $T2

tar -zxf fftw-3.2.2.tar.gz

tar -zxf psrchive.tar.gz

tar -zxf tempo2-2013.9.1.tar.gz

tar -zxf pgplot5.2.tar.gz

tar -zxf gsl-latest.tar.gz

tar -zxf cfitsio3350.tar.gz

#一.安装cfitsio

cd ./cfitsio

./configure --prefix=/usr/local

make && make install

#二.安装gsl

cd ../gsl-2.2.1

./configure --prefix=/usr/local

make && make install

#三.安装fftw-3.2.2

cd ../fftw-3.2.2

./configure --enable-shared --enable-float --enable-sse --disable-dependency-tracking --prefix=/usr/local

make clean

make && make install

#四.安装pgplot

if [ ! -d "/usr/local/pgplot" ]

then mkdir /usr/local/pgplot

fi

cp $T2/drivers.list /usr/local/pgplot

cd /usr/local/pgplot

$T2/pgplot/makemake $T2/pgplot linux g77_gcc_aout

sed -i "s/FCOMPL=g77/FCOMPL=gfortran/" `grep FCOMPL=g77 -rl ./makefile`

make

make cpg

make clean

 

#五.添加环境变量

sed -i '/PGPLOT_DIR/d' $HOME/.bashrc;

echo "export PGPLOT_DIR=/usr/local/pgplot" >> $HOME/.bashrc

sed -i '/PGPLOT_DEV/d' $HOME/.bashrc;

echo "export PGPLOT_DEV=/Xserve" >> $HOME/.bashrc

sed -i '/TEMPO2/d' $HOME/.bashrc;

echo "export TEMPO2=/usr/local/T2runtime" >> $HOME/.bashrc

#六.安装tempo2

cp -Rf /T2/tempo2-2013.9.1 /usr/local

source $HOME/.bashrc

cd /T2/tempo2-2013.9.1

./configure

make && make install

make plugins && make plugins-install

sed -i '/tempo2/d' $HOME/.bashrc;

echo "export tempo2=/usr/local/T2runtime/bin/tempo2" >> $HOME/.bashrc

source $HOME/.bashrc

 

#七.安装PSRCHIVE

cd $T2/psrchive

./bootstrap

./configure --prefix=/usr/local

make && make install

 

#清理

rm -rf $T2/../脉冲星计时离线软件

