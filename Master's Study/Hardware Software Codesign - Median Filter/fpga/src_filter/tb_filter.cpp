#include "filter.h"
#include "addr_space.h"
#include "../cpu/common.h"

#include <iostream>
using namespace std;
#include "mc_scverify.h"
#include "../cpu/cpu.h"

#define FRAMES    1002

int otsu(long *hist) {
   const int n = 8;
   int   total = 0;
   float sum = 0;
   float sumB = 0, varMax = 0, varBetween;
   int   wB = 0,  wF = 0, threshold = 0;
   float mB, mF;  
   int   t;

   for (t=0 ; t<n ; t++) {
      sum += t * hist[t];
      total += hist[t];
   }

   for (t=0 ; t<n; t++) {

      wB += hist[t];             /* Weight Background */
      if (wB == 0) continue;

      wF = total - wB;           /* Weight Foreground */
      if (wF == 0) break;

      sumB += (float) (t * hist[t]);

      mB = sumB / wB;            /* Mean Background */
      mF = (sum - sumB) / wF;    /* Mean Foreground */

      /* Calculate Between Class Variance */
      varBetween = (float)wB * (float)wF * (mB - mF) * (mB - mF);

      /* Check if new maximum found */
      if (varBetween > varMax) {
         varMax = varBetween;
         threshold = t+1;
      }
   }

   if(threshold >=8) threshold = 7; // protoze proto
   return threshold;
} 


/***************************************************************************
 Hlavni program Testbench souboru. Zajistuje generovani vstupnich vektoru,
 vol?n? puvodniho (referencniho) kodu a modifikovaneho kodu a porovnani
 jejich vystupu.
***************************************************************************/
CCS_MAIN(int argv, char *argc){
   long histogram[8];
   int thresh;
   long frames;
   t_pixel pix_in_hw, pix_out_hw = 0;
   t_pixel_sw pix_in_sw, pix_out_sw = 0;
   int pix_out_sw_vld;
   bool valid = true, non_valid = false;
   t_mcu_data mcu_data[MCU_SIZE];

   for(int i=0;i<MCU_SIZE;i++)
      mcu_data[i] = 0;

   /* Tyto dva radky slouzi pouze pro demo aplikaci, ve vyslednem kodu je odstrante */
   for(int f=0;f<FRAMES;f++){
      for(int r=0;r<FRAME_ROWS;r++){
         for(int c=0;c<FRAME_COLS;c++){
            /* Generovani vstupniho pixelu */
            pix_in_sw = gen_pixel();
            pix_in_hw = (t_pixel)pix_in_sw;
            /* Volani puvodniho (referencniho) kod */
            pixel_processing(pix_in_sw, &pix_out_sw, &pix_out_sw_vld); 
            /* Volani modifikovaneho kodu */
            CCS_DESIGN(filter)(pix_in_hw, valid, pix_out_hw, mcu_data); 

            /* Porovnani vysledku referencniho vs. modifikovaneho kodu */
            if(pix_out_sw_vld && (f>=100) && (pix_out_hw != pix_out_sw)) {
               cout << endl << "ERROR: Chyba na pozici: (" << f << ":" << r << "," << c << "), ";
               cout << "In: out_sw/out_hw = " << pix_in_hw << ": " << (int)pix_out_sw << "/" << pix_out_hw <<  endl;
               CCS_RETURN(1);
            }
         }
      }
      if(mcu_data[9]){
         histogram[0] = mcu_data[0];
         histogram[1] = mcu_data[1];
         histogram[2] = mcu_data[2];
         histogram[3] = mcu_data[3];
         histogram[4] = mcu_data[4];
         histogram[5] = mcu_data[5];
         histogram[6] = mcu_data[6];
         histogram[7] = mcu_data[7];
         frames = mcu_data[10];
         thresh = otsu(histogram);
         mcu_data[8] = thresh;
         mcu_data[9] = 0;
      }
         
   }
   cout << "INFO: ***********************************************************" << endl;
   cout << "INFO: Test referencniho kodu oproti upravenemu probehl v poradku." << endl;
   cout << "INFO: ***********************************************************" << endl;
   CCS_RETURN(0);
}
 
