#!/usr/bin/bash

#Run=$1
EventNumber=-1


T_Cut=/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem/PARAM/SHMS/DC/CUTS
PARAM=/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem/PARAM/SHMS/DC/CALIB

#replay_dir=/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem
#hcana_dir=/w/hallc-scifs17exp/xem2/abishek/hcana


calib_dir=/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem/CALIBRATION/dc_calib/scripts
#source $hcana_dir/setup.sh
#source $replay_dir/setup.sh
source /apps/root/6.10.02/setroot_CUE.bash

#for multiple runs
Runs=(2577 2706 2724 2750 2764 2793 2828 3021 3051 3064 3078)
for RunNumber in ${Runs[@]}

#for single run
#for RunNumber in ${Run}
do
echo $RunNumber
cd $calib_dir
runCalib="root -l -q \"main_calib.C(${RunNumber}, ${EventNumber})\""
eval ${runCalib}
echo 
echo "**********************************************"
echo 
echo $calib_dir
echo 
echo "**********************************************"
echo 
ls -ltrh SHMS_DC_cardLog_$RunNumber

cp SHMS_DC_cardLog_$RunNumber/pdc_calib_$RunNumber.param $PARAM
cp SHMS_DC_cardLog_$RunNumber/pdc_tzero_per_wire_$RunNumber.param $PARAM
done

#cd $calib_dir
#cp SHMS_DC_cardLog_$RunNumber/pdc_calib_$RunNumber.param $PARAM
#cp SHMS_DC_cardLog_$RunNumber/pdc_tzero_per_wire_$RunNumber.param $PARAM

#cd $PARAM
#cp pdc_calib_$RunNumber.param pdc_calib.param
#cp pdc_tzero_per_wire_$RunNumber.param pdc_tzero_per_wire.param

cd $T_Cut
cp pdc_cuts_1.param pdc_cuts.param

echo "Job done !!!"
