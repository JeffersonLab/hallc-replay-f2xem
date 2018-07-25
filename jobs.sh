#!/usr/bin/bash

# jobs scripts to do DC_calibration

#RunNumber=$1

EventNumber=10000

T_Cut=/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem/PARAM/SHMS/DC/CUTS

PARAM=/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem/PARAM/SHMS/DC/CALIB

replay_dir=/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem

hcana_dir=/w/hallc-scifs17exp/xem2/abishek/hcana

calib_dir=/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem/CALIBRATION/dc_calib/scripts

source $hcana_dir/setup.sh
source $replay_dir/setup.sh
source /apps/root/6.10.02/setroot_CUE.bash

#source /site/12gev_phys/production.sh 2.1

Runs=(2510 2511)
for RunNumber in ${Runs[@]}
do
echo $RunNumber

echo

cd $T_Cut
cp pdc_cuts_0.param pdc_cuts.param

echo "************************************************************"
echo $T_Cut
echo 
echo "*************************************************************"


cd $replay_dir
./hcana -q "SCRIPTS/SHMS/PRODUCTION/replay_production_all_shms.C($RunNumber, $EventNumber)"

echo 
echo "********************************************************************"
echo we obtain the rootfile with t_zero = 0
echo
echo "*********************************************************************"

cd $calib_dir

/site/12gev_phys/2.1/Linux_CentOS7.2.1511-x86_64-gcc.4.8.5/root/6.10.02/bin/root -l -q "main_calib.C(${RunNumber}, ${EventNumber}"
#runCalib="root -l -q \"main_calib.C(${RunNumber}, ${EventNumber})\""
#eval ${runCalib}
echo 
echo "**********************************************"
echo 
echo $calib_dir
echo 
echo "**********************************************"
echo 
ls -ltrh SHMS_DC_cardLog_$RunNumber

echo
cp SHMS_DC_cardLog_$RunNumber/pdc_calib_$RunNumber.param $PARAM
cp SHMS_DC_cardLog_$RunNumber/pdc_tzero_per_wire_$RunNumber.param $PARAM

echo "****************************************"
echo "$replay_dir/SHMS_DC_cardLog_$RunNumber"
echo 

#rm -rf SHMS_DC_cardLog_$RunNumber

cd $PARAM
ln -sf pdc_calib_$RunNumber.param pdc_calib.param
ln -sf pdc_tzero_per_wire_$RunNumber.param pdc_tzero_per_wire.param

cd $T_Cut
cp pdc_cuts_1.param pdc_cuts.param

#emacs $T_Cut/pdc_cuts.param

cd $replay_dir
./hcana -q "SCRIPTS/SHMS/PRODUCTION/replay_production_all_shms.C($RunNumber, $EventNumber)"

done

