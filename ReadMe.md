EPICS overview for RedPitaya

<!--- begin@of@TOC --->
# Table of contents

1. [deploy](#deploy)
     1. [repositories](#repositories)
1. [compilation](#compilation)
     1. [EPICS base](#epics-base)
     1. [asynDriver](#asyndriver)
     1. [redpitaya-epics](#redpitaya-epics)
<!--- end@of@TOC --->

EPICS works on RedPitaya with:

- Ubuntu v16.04.3
- base v3.16.1
- asyn v4.31
- redpitaya-epics

# deploy

- TODO: OS repo.
- WinP: component repositories

## repositories

compiled tree from EPICS `base`, `asyn`Driver and `redpitaya-epics` repositories

~~~ { .bash }
cd ~/code/
git clone git@gitlab.in2p3.fr:/Ganil-acq/Embedded/Modules/RedPitaya/EPICS/overview  EPICS
cd EPICS/
git clone git@gitlab.in2p3.fr:/Ganil-acq/Embedded/Modules/RedPitaya/EPICS/base      base
cd base; git checkout base-3.16.1; cd ..
git clone git@gitlab.in2p3.fr:/Ganil-acq/Embedded/Modules/RedPitaya/EPICS/asyn      asyn
git clone git@gitlab.in2p3.fr:/Ganil-acq/Embedded/Modules/RedPitaya/EPICS/redpitaya-epics
cd redpitaya-epics/
git checkout bin_base-3.16.1_asyn-R4-31
~~~


# compilation

redpitaya-epics on STEMLab 125-14 Red Pitaya directly

- `~/code` folder on SSD over USB2
- compile in the order: EPICS `base`, `asyn`Driver then `redpitaya-epics`
- working even if error on `asyn` part

## hard/software

~~~ { .text }
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.4.0-xilinx armv7l)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
##############################################################################
# Red Pitaya GNU/Linux Ecosystem
# Version: 0.98
# Build: 617
# Branch: 
# Commit: 1819a1d704b949065c09b981ee84cd912179a72c
# U-Boot: "redpitaya-v2016.4"
# Linux Kernel: "redpitaya-v2016.2-RP4"
# Pro Applications:  15fbd007cc7246e710f0b0f39f91d9f824a42f48 Applications (v0.97-RC6-3-g15fbd00)
##############################################################################
~~~

## EPICS base

EPICS Base Release

### v3.16.1

- [3.16.1](https://epics.anl.gov/base/R3-16/1.php)

~~~ { .bash }
cd ~/code/
mkdir EPICS/
cd EPICS/
wget https://epics.anl.gov/download/base/base-3.16.1.tar.gz
tar xzf base-3.16.1.tar.gz 
cd base-3.16.1/
make
make install
~~~

~~~ { .bash }
find / | grep -e caget -e libca --color
/media/data/home/rp/code/EPICS/base-3.16.1/lib/linux-arm/libca.so.3.16.1
/media/data/home/rp/code/EPICS/base-3.16.1/lib/linux-arm/libca.so
/media/data/home/rp/code/EPICS/base-3.16.1/lib/linux-arm/libca.a
/media/data/home/rp/code/EPICS/base-3.16.1/lib/linux-arm/libcas.so
/media/data/home/rp/code/EPICS/base-3.16.1/lib/linux-arm/libcas.so.3.16.1
/media/data/home/rp/code/EPICS/base-3.16.1/lib/linux-arm/libcas.a

/media/data/home/rp/code/EPICS/base-3.16.1/bin/linux-arm/caget
/media/data/home/rp/code/EPICS/base-3.16.1/bin/linux-arm/caget.pl
~~~

### ~~v3.14.12.4~~

- [`3.14.12.4`](https://epics.anl.gov/base/R3-14/4.php) FAIL

~~~ { .bash }
cd ~/code/
mkdir EPICS/
cd EPICS/
wget https://epics.anl.gov/download/base/baseR3.14.12.4.tar.gz
tar xzf baseR3.14.12.4.tar.gz
mv base-3.14.12.4 base
cd base/
make
#FAIL after a while on test app.
~~~


## asynDriver

Asynchronous Driver Support

### v4.31

- [R4-31](https://epics-modules.github.io/master/asyn/)
     - EPICS 3.14.12.2 or later
     - EPICS 3.16.1 ok

~~~ { .bash }
cd ~/code/EPICS/
wget https://github.com/epics-modules/asyn/archive/R4-31.tar.gz
mv R4-31.tar.gz asyn-R4-31.tar.gz
tar xzf asyn-R4-31.tar.gz
mv asyn-R4-31 asyn
cd asyn/
#configure EPICS base path to "../base/":
src=`grep "EPICS_BASE=" configure/RELEASE | tr / @`; dst=`cd ..; ls -d $PWD/base | head -n 1 | tr / @`; mv configure/RELEASE configure/RELEASE.old ; cat configure/RELEASE.old | tr / @ | sed "s/$src/EPICS_BASE=$dst/" | tr @ / | tee configure/RELEASE | grep base
make
#FAIL after a while, but that is not a problem
~~~

~~~ { .text }
...
/usr/bin/gcc  -D_GNU_SOURCE -D_DEFAULT_SOURCE            -DUNIX  -Dlinux     -O3 -g   -Wall           -fPIC -I. -I../O.Common -I. -I. -I.. -I../../../include/compiler/gcc -I../../../include/os/Linux -I../../../include          -I/root/code/EPICS/base-3.16.1/include/compiler/gcc -I/root/code/EPICS/base-3.16.1/include/os/Linux -I/root/code/EPICS/base-3.16.1/include        -c ../ipEchoServer2.c
make[3]: *** No rule to make target 'ipSNCServer.o', needed by 'libtestIPServerSupport.a'.  Stop.
make[3]: Leaving directory '/media/data/home/rp/code/EPICS/asyn-R4-31/testIPServerApp/src/O.linux-arm'
/root/code/EPICS/base-3.16.1/configure/RULES_ARCHS:58: recipe for target 'install.linux-arm' failed
make[2]: *** [install.linux-arm] Error 2
make[2]: Leaving directory '/media/data/home/rp/code/EPICS/asyn-R4-31/testIPServerApp/src'
/root/code/EPICS/base-3.16.1/configure/RULES_DIRS:84: recipe for target 'src.install' failed
make[1]: *** [src.install] Error 2
make[1]: Leaving directory '/media/data/home/rp/code/EPICS/asyn-R4-31/testIPServerApp'
/root/code/EPICS/base-3.16.1/configure/RULES_DIRS:84: recipe for target 'testIPServerApp.install' failed
make: *** [testIPServerApp.install] Error 2
root@rp-f06ac1:~/code/EPICS/asyn-R4-31# 
~~~

~~~ { .text }
ls */linux-arm/

bin/linux-arm/:
makeSupport.pl  testArrayRingBuffer  testBroadcastAsyn   testBroadcastNoAsyn  testEpics   testGpib
test            testAsynPortDriver   testBroadcastBurst  testConnect          testErrors  testGpibSerial

lib/linux-arm/:
libasyn.a                         libtestAsynPortDriverSupport.a   libtestErrorsSupport.a
libasyn.so                        libtestAsynPortDriverSupport.so  libtestErrorsSupport.so
libdevTestGpib.a                  libtestConnectSupport.a          libtestGpibSerialSupport.a
libdevTestGpib.so                 libtestConnectSupport.so         libtestGpibSerialSupport.so
libtestArrayRingBufferSupport.a   libtestEpicsSupport.a            libtestSupport.a
libtestArrayRingBufferSupport.so  libtestEpicsSupport.so           libtestSupport.so
~~~

## redpitaya-epics

~~~ { .bash }
cd ~/code/EPICS/
https://github.com/AustralianSynchrotron/redpitaya-epics
#or
git clone https://github.com/coupdair/redpitaya-epics
cd redpitaya-epics/
#configure EPICS base path to "../base/":
src=`grep "EPICS_BASE=" configure/RELEASE | tr / @`; dst=`cd ..; ls -d $PWD/base | head -n 1 | tr / @`; mv configure/RELEASE configure/RELEASE.old ; cat configure/RELEASE.old | tr / @ | sed "s/$src/EPICS_BASE=$dst/" | tr @ / | tee configure/RELEASE | grep base
#configure ASYN path to "../asyn/":
src=`grep "ASYN=" configure/RELEASE | tr / @`; dst=`cd ..; ls -d $PWD/asyn | head -n 1 | tr / @`; mv configure/RELEASE configure/RELEASE.old ; cat configure/RELEASE.old | tr / @ | sed "s/$src/ASYN=$dst/" | tr @ / | tee configure/RELEASE | grep asyn

nano configure/RELEASE
make clean

make
~~~

~~~ { .bash }
ls */linux-arm
bin/linux-arm:
load_fpga_image.sh  RedPitayaTest

lib/linux-arm:
libdrvRedPitaya.a  libdrvRedPitaya.so
~~~

