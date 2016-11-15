#include <fitkitlib.h>
#include "../fpga/src_filter/addr_space.h"

/*******************************************************************************
 * Vypis uzivatelske napovedy (funkce se vola pri vykonavani prikazu "help")
*******************************************************************************/
void print_user_help(void) {
}

/*******************************************************************************
 * Dekodovani uzivatelskych prikazu a jejich vykonavani
*******************************************************************************/
unsigned char decode_user_cmd(char *cmd_ucase, char *cmd) {
   return (CMD_UNKNOWN);
}

/*******************************************************************************
 * Inicializace periferii/komponent po naprogramovani FPGA
*******************************************************************************/
void fpga_initialized() {
}

/*******************************************************************************
 Funkce fpga_read() slouzi pro cteni hodnoty z adresoveho prostoru FPGA.

 Vstupy:
   addr     index 32-bitove polozky v ramci adresoveho prostoru FPGA
 Vystupy:
   navratova hodnota reprezentuje prectenou hodnotu z FPGA
*******************************************************************************/
unsigned long fpga_read(int addr) {

   unsigned long val;
   FPGA_SPI_RW_AN_DN(SPI_FPGA_ENABLE_READ, addr, (unsigned char *)&val, 2, 4);

   return val;
}

/*******************************************************************************
 Funkce fpga_write() slouzi pro zapis hodnoty do adresoveho prostoru FPGA.

 Vstupy:
   addr     index 32-bitove polozky v ramci adresoveho prostoru FPGA
   data     data pro zapis
*******************************************************************************/
void fpga_write(int addr, unsigned long data) {

   FPGA_SPI_RW_AN_DN(SPI_FPGA_ENABLE_WRITE, addr, (unsigned char *)&data, 2, 4);
}

/***************************************************************************
 Funkce otsu() vypocte hodnotu prahu na zaklade histogramu pixelu snimku.

 Vstupy:
    hist    ukazatel na histogram
 Vystupy:
    hodnota vypocteneho prahu
***************************************************************************/
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

/*******************************************************************************
 * Hlavni funkce
*******************************************************************************/
int main(void)
{
   short counter = 0;
   long histogram[8] = {0, 0, 0, 0, 0, 0, 0, 0};
   int thresh;
   unsigned long cnt;

   initialize_hardware();
   set_led_d6(1);  //rozsvitit LED D6
   set_led_d5(0);  //zhasnout LED D5

   /**************************************************************************/
   /*                      Aktualizovany hlavni program                      */
   /**************************************************************************/
   int i = 0;
   unsigned long frames = 0;
   while (1) {
      //terminal_idle();  // obsluha terminalu
      if(! fpga_read(9)) continue;
      //for (i = 0; i<8; i++)
      //   histogra[i] = fpga_read(i);
      histogram[0] = fpga_read(0);
      histogram[1] = fpga_read(1);
      histogram[2] = fpga_read(2);
      histogram[3] = fpga_read(3);
      histogram[4] = fpga_read(4);
      histogram[5] = fpga_read(5);
      histogram[6] = fpga_read(6);
      histogram[7] = fpga_read(7);
      frames = fpga_read(10);
      frames--;
      thresh = otsu(histogram);
      fpga_write(8, thresh);
      fpga_write(9, 0);
      //term_send_str("Frame: ");
      //term_send_num(frames);
      //term_send_crlf();
      if((frames%100) == 0 && frames != 0 && frames < 1050){
         
         term_send_str("Frame: ");
         term_send_num(frames);
         term_send_crlf();

         term_send_str("Histogram: ");
         term_send_num(histogram[0]);
         for(i=1; i<8; i++) {
            term_send_str(", ");
            term_send_num(histogram[i]);
         }
         term_send_crlf();
         
         term_send_str("Threshold: ");
         term_send_num(thresh);
         term_send_crlf();
      }
   }
}

