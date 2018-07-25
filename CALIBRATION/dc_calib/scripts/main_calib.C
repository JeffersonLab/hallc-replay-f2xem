//Main Calibration Code
#include "DC_calib.h"
#include "DC_calib.C"
#include <iostream>
#include <ctime>
using namespace std;

int main_calib(Int_t run_NUM, Int_t even_NUM)
{

  //prevent root from displaying graphs while executing
  gROOT->SetBatch(1);

   TString filename = "/w/hallc-scifs17exp/xem2/abishek/hallc-replay-f2xem/ROOTfiles/uncal_rootfiles/shms_replay_production_all_";

  //TString filename = "/volatile/hallc/xem2/abels/ROOTfiles/hms_replay_production_all_";
  filename += run_NUM;
  filename += "_";
  filename += even_NUM;
  filename += ".root";
  //measure execution time
  clock_t cl;
  cl = clock();
                                                                                                  
                                                                                                        //pid_elec,  pid_kFALSE (no PID cuts) 
                                                                                                        // |
                                                                                                        // v
  //  DC_calib obj("HMS", "../../../ROOTfiles/hms_replay_production_all_1856_hodtrefcut1000_-1.root", 1856,-1, "pid_elec", "card");
  //DC_calib obj("SHMS", "../../../ROOTfiles/shms_replay_production_all_2774_-1.root", 2774, -1, "pid_elec"); 
  //  DC_calib obj("SHMS", "~/abishek/hallc_replay/ROOTfiles/shms_replay_production_all_1791_-1.root", 1791, 10000000, "pid_elec", "card");
    DC_calib obj("SHMS", filename, run_NUM, even_NUM, "pid_kFALSE", "card");                                                                                                        
  // DC_calib obj("HMS", "../../../ROOTfiles/hms_coin_replay_production_1866_1000000.root", 1866, 1000, "pid_kFALSE");
  
  obj.setup_Directory();
  obj.SetPlaneNames();
  obj.GetDCLeafs();
  obj.AllocateDynamicArrays();
  obj.SetTdcOffset();
  obj.CreateHistoNames();
  obj.EventLoop("FillUncorrectedTimes");
  obj.Calculate_tZero();
  obj.EventLoop("ApplyT0Correction");
  obj.WriteTZeroParam();
  obj.WriteLookUpTable();
  obj.WriteToFile(1);  //set argument to (1) for debugging
 

  //stop clock
 cl = clock() - cl;
 cout << "execution time: " << cl/(double)CLOCKS_PER_SEC << " sec" << endl;

  return 0;
}
