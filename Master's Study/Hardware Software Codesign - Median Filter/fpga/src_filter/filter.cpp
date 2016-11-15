#include <ac_int.h>
#include "filter.h"
#include "addr_space.h"

#define SORT(a,b) { if ((a)>(b)) SWAP((a),(b)); }
#define SWAP(a,b) { t_pixel temp=(a);(a)=(b);(b)=temp; }

#define READ_A       0
#define READ_B       1
#define WRITE_C      2

/***************************************************************************
 Procedura histogram_clean() zajistuje vymazani histogramu, ktery je potreba
 zejmena na konci zpracovani kazdeho snimku.

 Vstupy:
   hist     adresa histogramu
***************************************************************************/
void histogram_clean(ac_int<17,false> *hist) {
   hist[0] = 0;
   hist[1] = 0;
   hist[2] = 0;
   hist[3] = 0;
   hist[4] = 0;
   hist[5] = 0;
   hist[6] = 0;
   hist[7] = 0;
}

/***************************************************************************
 Procedura buffer() uklada vstupni hodnoty pixelu do dvou-radkovou bufferu
 a vraci hodnoty odpovidajici aktualne zpracovavanemu sloupci 3 pixelu
 (posledni sloupec okenka 3x3).

 Vstupy:
   din   hodnota vstupniho pixelu
   c     cislo sloupce prave zpracovavaneho pixelu
 Vystupy:
   col_window  aktualne zpracovavany sloupec tri pixelu
***************************************************************************/
void buffer(t_pixel din, ac_int<9,false> c, t_pixel *col_window){
   static t_pixel buf[2 * FRAME_COLS];
   static bool dummy = ac::init_array<AC_VAL_DC>(buf,2 * FRAME_COLS);
   static ac_int<1, false> sel=1;
   static t_pixel t0, t1;

   if(c == 0) sel = !sel;
   BUU:for(int i = 0; i < 3; i++){
      if (i==0) t1 = buf[c + FRAME_COLS];
      else if (i == 1) t0 = buf[c];
      else if (i == 2){
         //buf[sel][c] = din;
         if(sel == 1){
            buf[c+FRAME_COLS] = din; 
         } else{ 
            buf[c] = din;
         } 
         col_window[0] = (sel==1) ? t1:t0;
         col_window[1] = (sel==1) ? t0:t1;
         col_window[2] = din;
      }
   }
}

/***************************************************************************
 Procedura clip_window() provadi clipping tj. doplnuje krajni hodnoty okenka
 3x3 na okrajich snimku, kde nejsou pixely k dispozici.

 Vstupy:
   r     aktualni cislo radku
   c     aktualni cislo sloupce
   iw    aktualni hodnoty posuvneho okenka 3x3
 Vystupy:
   ow    upravene hodnoty posuvneho okenka 3x3 po osetreni krajnich hodnot
***************************************************************************/
void clip_window(ac_int<8,false> r, ac_int<9,false> c, t_pixel *iw, t_pixel *ow) {
	
   ac_int<1,false> first_row, last_row, first_col, last_col;
   ac_int<2,false> test1, test2, test3, test4;

   first_row = (r == 0);
   first_col = (c == 0);
   last_row  = (r == FRAME_ROWS-1);
   last_col  = (c == FRAME_COLS-1);

   ow[4] = iw[4];
   ow[1] = first_col ? iw[4] : iw[1];
   ow[5] = last_row  ? iw[4] : iw[5];
   ow[7] = last_col  ? iw[4] : iw[7];
   ow[3] = first_row ? iw[4] : iw[3];

   test1 = first_row | (first_col << 1);
   switch(test1) {
      case 3:  ow[0] = iw[4]; break; /* first_row, first_col */
      case 1:  ow[0] = iw[1]; break; /* first_row, not first_col */
      case 2:  ow[0] = iw[3]; break; /* not first_row, first_col */
      default: ow[0] = iw[0]; break; /* not first_row, not first_col */
   }

   test2 = first_row | (last_col << 1);
   switch(test2) {
      case 3:  ow[6] = iw[4]; break; /* first_row, last_col */
      case 1:  ow[6] = iw[7]; break; /* first_row, not last_col */
      case 2:  ow[6] = iw[3]; break; /* not first_row, last_col */
      default: ow[6] = iw[6]; break; /* not first_row, not last_col */
   }

   test3 = last_row | (first_col << 1);
   switch(test3) {
      case 3:  ow[2] = iw[4]; break; /* last_row, first_col */
      case 1:  ow[2] = iw[1]; break; /* last_row, not first_col */
      case 2:  ow[2] = iw[5]; break; /* not last_row, first_col */
      default: ow[2] = iw[2]; break; /* not last_row, not first_col */
   }

   test4 = last_row | (last_col << 1);
   switch(test4) {
      case 3:  ow[8] = iw[4]; break; /* last_row, last_col */
      case 1:  ow[8] = iw[7]; break; /* last_row, not last_col */
      case 2:  ow[8] = iw[5]; break; /* not last_row, last_col */
      default: ow[8] = iw[8]; break; /* not last_row, not last_col */
   }
}

/***************************************************************************
 Procedura shift_window() provadi posun okenka 3x3 o jednu pozici do prava.

 Vstupy:
   window      puvodni hodnoty posuvneho okenka 3x3
   col_window  nove nasouvany sloupec  
 Vystupy:
   window      hodnoty vstupniho pole jsou aktualizovany
***************************************************************************/
void shift_window(t_pixel *window, t_pixel *col_window) {
   window[2] = window[5];
   window[1] = window[4];
   window[0] = window[3];

   window[5] = window[8];
   window[4] = window[7];
   window[3] = window[6];

   window[8] = col_window[2];
   window[7] = col_window[1];
   window[6] = col_window[0];
} 


/***************************************************************************
 Funkce thresholding() provadi prahovani vstupniho pixelu vuci zadanemu
 prahu.

 Vstupy:
   pixel       vstupni pixel
   threshold   hodnota prahu
 Vystupy:
   navratova hodnota reprezentuje vystupni pixel po provedeni prahovani
***************************************************************************/
t_pixel thresholding(t_pixel pixel, ac_int<3,false> threshold) {
   if (pixel >= threshold)
      return MAX_PIXEL;
   else
      return MIN_PIXEL;
}      

/***************************************************************************
 Funkce median() vraci hodnotu medianu ze zadaneho okenka hodnot 3x3 pixelu.
 Jedna se o paralelni verzi algoritmu vhodnou pro hardware. 
 
 Pouzita lehce upravena verze od Vasicka. Bitonic sorting network.
 http://www.fit.vutbr.cz/~vasicek/pubs.php?file=%2Fpub%2F8604%2Fs5_01.pdf&id=8604

 Vstupy:
   window   ukazatel na hodnoty okenka 3x3 pixelu
 Vystupu:
   pix_out  hodnota medianu
***************************************************************************/
t_pixel median(t_pixel *window){
    SORT(window[0], window[1]); SORT(window[3], window[2]); SORT(window[5], window[4]); SORT(window[7], window[8]);
    SORT(window[2], window[0]); SORT(window[3], window[1]); SORT(window[6], window[8]);
    SORT(window[1], window[0]); SORT(window[3], window[2]); SORT(window[4], window[8]); SORT(window[6], window[7]);
    SORT(window[0], window[8]); SORT(window[4], window[6]); SORT(window[5], window[7]); 
    SORT(window[4], window[5]); SORT(window[6], window[7]); 
    SORT(window[0], window[4]); SORT(window[1], window[5]); SORT(window[2], window[6]); SORT(window[3], window[7]);
    SORT(window[4], window[6]); SORT(window[5], window[7]);
    SORT(window[4], window[5]);
    return window[4];
}


/***************************************************************************
 Funkce system_input() zajistuje zpracovani a bufferovani vstupnich pixelu.
 Vstupni pixel ulozi do radkoveho bufferu a provede posun a clipping posuvneho
 okenka. Funkce rozlisuje mezi vstupnim pixelem a skutecne filtrovanym
 pixelem. Filtrovany pixel je oproti vstupnimu posunut o jeden radek a jeden
 pixel.

 Vstupy:
   din            vstupni pixel
 Vystupy:
   cliped_window  posuvne okenko 3x3 po osetreni okrajovych bodu
   last_pixel     infomace o tom, zda se jedna o posledni pixel snimku
   navratova hodnota ukazu, zda je okenko platne ci nikoliv. Okenko nemusi
   byt platne napr. na zacatku zpracovani, kdy jeste neni v bufferu nasunut 
   dostatek novych pixelu
***************************************************************************/
ac_int<1,false> system_input(t_pixel din, t_pixel *cliped_window, ac_int<1,false> *last_pixel){
   static ac_int<9,false>   c = 0, c_filter = 0;
   static ac_int<8,false>   r = 0, r_filter = 0;
   static ac_int<1,false>   output_vld = 0;

   static t_pixel window[9];
   t_pixel col_window[3];

   /* ulozeni pixelu do bufferu, posun okenka a clipping */
   buffer(din, c, col_window);
   shift_window(window, col_window);
   clip_window(r_filter, c_filter, window, cliped_window);

   /* od druheho radku a druheho sloupce je vystup platny */
   if ((r == 1) && (c == 1))
      output_vld = 1;

   /* oznaceni posledniho filtrovaneho pixelu snimku */
   *last_pixel = ((r_filter == FRAME_ROWS-1) && (c_filter == FRAME_COLS-1));

   /* aktualizace souradnic filtrovaneho pixelu */
   if ((c_filter == FRAME_COLS-1) && (output_vld == 1)) {
      r_filter = (r_filter == FRAME_ROWS-1) ? 0 : r_filter+1;
   }
   c_filter = c;

   /* aktualizace souradnic vstupniho pixelu */
   if (c == FRAME_COLS-1) {
      c = 0;
      r = (r == FRAME_ROWS-1) ? 0 : r+1;
   }
   else 	
      c++;

   return output_vld;
}


/***************************************************************************
 Procedura filter() zajistuje zpracovani vstupniho pixelu. Tato jednoducha
 verze provadi pouze kopirovani vstupniho pixelu na vystup.

 Vstupy:
   in_data        vstupni pixel
   in_data_vld    informace o tom, zda je vstupni pixel platny
   mcu_data       pamet pro vymenu dat s MCU

 Vystupy:
   out_data       vystupni pixel
   mcu_data       pamet pro vymenu dat s MCU
***************************************************************************/
#pragma hls_design top

void filter(t_pixel &in_data, bool &in_data_vld, t_pixel &out_data, 
         t_mcu_data mcu_data[MCU_SIZE]){
   static ac_int<32,false> framesCNT = 0;
   static ac_int<17,false> histogram[8] = {0,0,0,0,0,0,0,0};
   static ac_int<3,false>  threshold = 4;
   ac_int<1,false> last_pixel;
   ac_int<1,false> data_out_vld = 0;
   static ac_int<4,false> write_histogram=0;
   static ac_int<1,false> get_thresh = 0;
   t_pixel         window[9], pix_filtered;
   static ac_int<4,false> frame = 0;
#ifdef CCS_DUT_SYSC
   static ac_int<4,false> cnt = 0; 
   static ac_int<4,false> cntf = 1;       
#endif

   //static t_mcu_data a = 0, b = 0, c;
   //static int state = READ_A;

   // Kopirovani vstupniho pixelu na vystup
   if (in_data_vld) {
      //out_data = in_data;
      data_out_vld = system_input(in_data, window, &last_pixel);
      if(data_out_vld) {
          /* Filtrace medianem, aktualizace histogramu, prahovani */
          pix_filtered = median(window);
          if(frame == 0)
              histogram[pix_filtered]++;

          /* Test na posledni pixel predchoziho snimku */
          if (last_pixel) {
              framesCNT++;
             if(frame == 0) {
                 write_histogram = 1;
                 frame++;
             } else if(frame== 1) {
                 get_thresh = 1;
                 histogram_clean(histogram);
                 frame++;
             } else if(frame==9) {
                 frame = 0;
             } else frame++;
         }//if
        switch(write_histogram){
            case 1: mcu_data[0] = histogram[0];
                    write_histogram = 2;
                    break;
            case 2: mcu_data[1] = histogram[1];
                    write_histogram = 3;
                    break;
            case 3: mcu_data[2] = histogram[2];
                    write_histogram = 4;
                    break;
            case 4: mcu_data[3] = histogram[3];
                    write_histogram = 5;
                    break;
            case 5: mcu_data[4] = histogram[4];
                    write_histogram = 6;
                    break;
            case 6: mcu_data[5] = histogram[5];
                    write_histogram = 7;
                    break;
            case 7: mcu_data[6] = histogram[6];
                    write_histogram = 8;
                    break;
            case 8: mcu_data[7] = histogram[7];
                    write_histogram = 9;
                    break;
            case 9: mcu_data[10] = framesCNT;
                    write_histogram = 10;
                    break;
            case 10: mcu_data[9] = 1;
                    write_histogram = 11;
                    break;
            case 11:
                    if(get_thresh) {
                        write_histogram = 0;
                        get_thresh = 0;
                        threshold = mcu_data[8];
                    }
            default: break;
            }//switch
          out_data = thresholding(pix_filtered, threshold);
      }//datavld
   
   }

   // Demo aplikace pro test komunikace MCU - FPGA
   /*
   c = a + b; 
   switch(state){
      case READ_A:   a = mcu_data[FPGA_ADDR_A]; state = READ_B;  break;
      case READ_B:   b = mcu_data[FPGA_ADDR_B]; state = WRITE_C; break;
      case WRITE_C:  mcu_data[FPGA_ADDR_C] = c; state = READ_A;  break;
      default: break;
   }
   */
}

