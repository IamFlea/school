/**
 * Canny edge detector 
 *
 * Autor: Petr Dvoracek
 * Date: 20th March 2015
 * Language: Mostly czech and hungarian.
 * 
Zadani
    Vytvořte aplikaci realizující Cannyho hranový detektor. 
    Vstupními parametry detektoru jsou: 
              standadrní odchylka Gaussova filtru
              horní hranice hystereze při prahování
              dolni hranice hystereze pri prahovani
    Implementujte dvě verze filtru:
              demonstrační, složenou z jednotlivých kroků detekce zvlášť 
              optimální, jedna efektivně pracující funkce.

Princip
 1) Obrazek se rozmaze pomoci Gaussova kernelu.
 2) Aplikujeme sobelovy operatory, vertical a horizontal.
    Z nich ziskame magnitudu pomoci absolutni hodnoty [rychlejsi] nebo vypoctem fce sqrt(v*v + h*h) [pomalejsi] pro kazdy pixel . 
 3) Ziskani smeru hrany. Zjistujeme, jak je natocena hrana 0° - 180°.
 4) Dle smeru ztencime linie.. potlacime minima a maxima. Viz tutorials. Ci zdrojak... Ja nad tim stravil 
 5) Double Thresholding + hystereze
    a) High thresholding -> hrana je ve vyslednem obrazu
    b) Low thresholding  -> overit zda hrana je napojena na high thold, pokud je - vykreslime ji

Reference a tutorialy ke Cannymu
    http://en.wikipedia.org/wiki/Canny_edge_detector
    http://dasl.mem.drexel.edu/alumni/bGreen/www.pages.drexel.edu/_weg22/can_tut.html
    http://docs.opencv.org/doc/tutorials/imgproc/imgtrans/canny_detector/canny_detector.html
         Pozor, nejedna se o totozne dilo jako je v opencv! Je jiste ze mohli pouzit jine algoritmy, 
         treba na hysterizaci, ci potlaceni extremu. 
    https://www.youtube.com/watch?v=-Z3kr26Eci4    
         Na to jsem se nekoukal.

Kompilace
    Potreba mit stazenou OpenCV knihovnu.
    [user@si ~/]$ make clean; make;

Spusteni    
    ./canny filename [double int int]
    Napriklad: `./canny lena.png 2.525 20 100`
             kde 2.525 je sigma value 
             low thold 20 
             high thold 100
    Vysledek je ulozen jako out.png 


TODO
 a) Urcite bude potreba {{optimalizovat hysterizaci}}, na kterou jsem pouzil rekurzivni volani.
 b) MAYBE FINISHED:
    Specialni konvoluce pro Sobela.
    Sobelovy operatory 
      1  2  1     1 0 -1     =>   6 x se nasobi nula
      0  0  0  a  2 0 -2     =>   8 x se nasobi jednicka -- lze pouze scitat ci odecitat
     -1 -2 -1     1 0 -1     =>   4 x se nasobi dvojka -- lze pouzit bitovy posuv
    Vytvorit konvoluce ktera NEMA nasobeni
    Jednim pruchodem obrazku udelat vertikalni sobel + horizontalni sobel + zjistit magnitudu!
 c) Verze ktera pracuje pouze s double hodnotami. 
        Gaussovka, bude klasickovou gaussovkou. Pocita se i prvni cast.
        Pro vypocet magnitudy se pouzije sqrt(x*x + y*y). 
        Nalezeni smeru pomoci atan2(x, y) 
 d) Vytvorit testovaci dataset. O ruznych velikostech: 256*256, 512*512, 1024*1024. Prosim, ne obrazky z porna. 

Rozdelte si to.

BONUS TODO
 x) Ke kazdemu malloc() pridelit free(). - FINISHED!
 y) Promenne pro sobelovy kernel?
 z) Lepsi zpracovani parametru. 

 */

#include <stack>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <math.h>
#include <time.h> 

#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>


#define GAUSSIAN_FUNCTION_MAX_VAL 64 // Maximum v Gaussovem kernelu, viz dale
#define GAUSSIAN_KERNEL_SIZE 5       // Velikost kernelu Gausse
#define SOBEL_KERNEL_SIZE 3          // Velikost Sobelova kernelu


#define myabs(val) ((val > 0) ? val : -val)

//#define DEBUG_GAUSS 

// Velikost obrazku!
int img_height;
int img_width;

// Johnnys stuff
int** dumb_mult; 

/**
 * Zmeni cv::Mat na Ceckovsky array
 * @param `img`  Vstupni obrazek
 * @return Pole bytu. [[pixel, pixel...] for row in matrix]
 */
int ** img2array(const cv::Mat img){
    int ** result = (int **) malloc(img.rows * sizeof(int *));
    for(int i = 0; i < img.rows; i++){ // Pruchod po radcich
        int * row = (int *) malloc(img.cols * sizeof(int));
        result[i] = row;
        for(int j = 0; j < img.cols; j++){ // Prchod po sloupcich
            result[i][j] = img.data[img.step * i + j * img.elemSize()];
        }
    }
    img_height = img.rows;
    img_width = img.cols;
    return result;
}




/**
 * Deallocates the specified matrix of integers.
 * @param `matrix` Matrix for deallocation.
 * @param `rowSize` Matrix row size.
 */
void freeIntMatrix(int **matrix, int rowSize) {
  for (int i = 0; i < rowSize; i++) {
    free(matrix[i]);
  }
  free(matrix);
}

/**
 * Deallocates the specified matrix of doubles.
 * @param `matrix` Matrix for deallocation.
 * @param `rowSize` Matrix row size.
 */
void freeDoubleMatrix(double **matrix, int rowSize) {
  for (int i = 0; i < rowSize; i++) {
    free(matrix[i]);
  }
  free(matrix);
}
inline int get_direction(double pixel_i, double pixel_j);

/**
 * Vytvori Gaussovsky kernel podle rovnice:
 *         1              / -(x^2 + y^2) \
 *    ------------  *    |  ------------  |
 *    (2PI)sigma^2     E^ \   2sigma^2   /
 *
 *   `-----v------'
 *     THIS PART
 *   Normalizuje rozlozeni pravdepodbonosti tak, aby byl jeho integral roven 1. (Jako pravdepodobnost)
 *   Tato hodnota byla nasilne zmenena napr. na 255 (tedy 2^8 - 1)
 *   
 *   Druha cast nam vykresli kopec. _,.-.,_
 *
 * @param `k`  Velikost kernelu - vetsinou 5
 * @param `sigma` Smerodatna odchylka, sigma**2 je rozptyl (jak moc to rozmaze)
 * @return Gaussian kernel
 */
inline double ** gaussian_kernel(int k, double sigma){
    double ** result = (double **) malloc (k * sizeof(double *));
    #ifdef DEBUG_GAUSS
    printf("%f\n", sigma);
    #endif
    double THIS_PART = 1/(2*M_PI * sigma * sigma);
    for(int i = 0; i < k; i++){
        double * row = (double *) malloc(k * sizeof(double));
        result[i] = row;
        for(int j = 0; j < k; j++){
            double x = i-(k-1.0)/2.0;
            double y = j-(k-1.0)/2.0;
            result[i][j] = THIS_PART  * exp(-(x*x + y*y)/(2.0*sigma*sigma));
            #ifdef DEBUG_GAUSS
            printf("%lf ", result[i][j] );
            #endif
        }
        #ifdef DEBUG_GAUSS
        printf("\n");
        #endif
    }
    return result;
}

/**
 * Vytvoreni sobelovych filtru
 * @param `k` Velikost jadra
 * @param `transpose` Transponovani kernelu
 */
int ** sobel_kernel(int k, bool transpose){
    int ** result = (int **) malloc (k * sizeof(int *));
    if(k != 3){
        printf("Insert your code here.\n"); // I am sorry
        exit(1);
    }
    result[0] = (int *) malloc (3 * sizeof(int));
    result[1] = (int *) malloc (3 * sizeof(int));
    result[2] = (int *) malloc (3 * sizeof(int));
    if(transpose){
        result[0][0] = 1; result[0][1] = 2; result[0][2] = 1;
        result[1][0] = 0; result[1][1] = 0; result[1][2] = 0;
        result[2][0] =-1; result[2][1] =-2; result[2][2] =-1;
    } else {
        result[0][0] = 1; result[0][1] = 0; result[0][2] =-1;
        result[1][0] = 2; result[1][1] = 0; result[1][2] =-2;
        result[2][0] = 1; result[2][1] = 0; result[2][2] =-1;
    }
    return result;
}


/**
 * Calculates horizontal and vertical sobel values for the specified pixel.
 * @param `img` Source image.
 * @param `x` Column index.
 * @param `y` Row index.
 * @param `horizontal_sobel_val` Output horizontal sobel value.
 * @param `vertical_sobel_val` Output vertical sobel value.
 * It uses this kernel for convolution for horizontal sobel: 
 *      1  1  1
 *      0  0  0
 *     -1 -1 -1 
 * and this for vertical sobel:
 *      1 0 -1
 *      1 0 -1
 *      1 0 -1 
 */
inline void getSobelValues(double **img, int x, int y, double &horizontal_sobel_val, double &vertical_sobel_val) {
  // TOP MARGIN:
  if (y == 0) {
    // Left corner
    if (x == 0) {
      // [x  ,y  ]*( 1) | [x  ,y  ]*( 1) | [x+1,y  ]*( 1)
      //      0         |      0         |      0
      // [x  ,y+1]*(-1) | [x  ,y+1]*(-1) | [x+1,y+1]*(-1)
      horizontal_sobel_val = img[y][x] + (img[y][x]) + img[y][x+1] - img[y+1][x] - (img[y+1][x]) - img[y+1][x+1];
      // [x,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // [x,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // [x,y+1]*1 | 0 | [x+1,y+1]*(-1)
      vertical_sobel_val = img[y][x] + (img[y][x]) + img[y+1][x] - img[y][x+1] - (img[y][x+1]) - img[y+1][x+1];
    } 
    // Right corner
    else if (x == img_width-1) {
      // [x-1,y  ]*( 1) | [x  ,y  ]*( 1) | [x  ,y  ]*( 1)
      //      0         |      0         |      0
      // [x-1,y+1]*(-1) | [x  ,y+1]*(-1) | [x  ,y+1]*(-1)
      horizontal_sobel_val = img[y][x-1] + (img[y][x]) + img[y][x] - img[y+1][x-1] - (img[y+1][x]) - img[y+1][x];
      // [x-1,y  ]*1 | 0 | [x,y  ]*(-1)
      // [x-1,y  ]*1 | 0 | [x,y  ]*(-1)
      // [x-1,y+1]*1 | 0 | [x,y+1]*(-1)
      vertical_sobel_val = img[y][x-1] + (img[y][x-1]) + img[y+1][x-1] - img[y][x] - (img[y][x]) - img[y+1][x];
    }
    // Middle
    else {
      // [x-1,y  ]*( 1) | [x  ,y  ]*( 1) | [x+1,y  ]*( 1)
      //      0         |      0         |      0
      // [x-1,y+1]*(-1) | [x  ,y+1]*(-1) | [x+1,y+1]*(-1)
      horizontal_sobel_val = img[y][x-1] + (img[y][x]) + img[y][x+1] - img[y+1][x-1] - (img[y+1][x]) - img[y+1][x+1]; 
      // [x-1,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // [x-1,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // [x-1,y+1]*1 | 0 | [x+1,y+1]*(-1)
      vertical_sobel_val = img[y][x-1] + (img[y][x-1])+ img[y+1][x-1] - img[y][x+1] - (img[y][x+1])- img[y+1][x+1]; 
    }
  } 
  // BOTTOM MARGIN:
  else if (y == img_height-1) {
    // Left corner
    if (x == 0) {
      // [x  ,y-1]*( 1) | [x  ,y-1]*( 1) | [x+1,y-1]*( 1)
      //      0         |      0         |      0
      // [x  ,y  ]*(-1) | [x  ,y  ]*(-1) | [x+1,y  ]*(-1)
      horizontal_sobel_val = img[y-1][x] + (img[y-1][x])+ img[y-1][x+1] - img[y][x] - (img[y][x])- img[y][x+1];
      // [x,y-1]*1 | 0 | [x+1,y-1]*(-1)
      // [x,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // [x,y  ]*1 | 0 | [x+1,y  ]*(-1)
      vertical_sobel_val = img[y-1][x] + (img[y][x])+ img[y][x] - img[y-1][x+1] - (img[y][x+1])- img[y][x+1];
    }
    // Right corner
    else if (x == img_width-1) {
      // [x-1,y-1]*( 1) | [x  ,y-1]*( 1) | [x  ,y-1]*( 1)
      //      0         |      0         |      0
      // [x-1,y  ]*(-1) | [x  ,y  ]*(-1) | [x  ,y  ]*(-1)
      horizontal_sobel_val = img[y-1][x-1] + (img[y-1][x])+ img[y-1][x] - img[y][x-1] - (img[y][x])- img[y][x];
      // [x-1,y-1]*1 | 0 | [x,y-1]*(-1)
      // [x-1,y  ]*1 | 0 | [x,y  ]*(-1)
      // [x-1,y  ]*1 | 0 | [x,y  ]*(-1)
      vertical_sobel_val = img[y-1][x-1] + (img[y][x-1])+ img[y][x-1] - img[y-1][x] - (img[y][x])- img[y][x];
    } 
    // Middle
    else {
      // [x-1,y-1]*( 1) | [x  ,y-1]*( 1) | [x+1,y-1]*( 1)
      //      0         |      0         |      0
      // [x-1,y  ]*(-1) | [x  ,y  ]*(-1) | [x+1,y  ]*(-1)
      horizontal_sobel_val = img[y-1][x-1] + (img[y-1][x])+ img[y-1][x+1] - img[y][x-1] - (img[y][x])- img[y][x+1];
      // [x-1,y-1]*1 | 0 | [x+1,y-1]*(-1)
      // [x-1,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // [x-1,y  ]*1 | 0 | [x+1,y  ]*(-1)
      vertical_sobel_val = img[y-1][x-1] + (img[y][x-1])+ img[y][x-1] - img[y-1][x+1] - (img[y][x+1])- img[y][x+1];
    }
  // MIDDLE:
  } else {
    // Left edge
    if (x == 0) {
      // [x  ,y-1]*( 1) | [x  ,y-1]*( 1) | [x+1,y-1]*( 1)
      //      0         |      0         |      0
      // [x  ,y+1]*(-1) | [x  ,y+1]*(-1) | [x+1,y+1]*(-1)
      horizontal_sobel_val = img[y-1][x] + (img[y-1][x])+ img[y-1][x+1] - img[y+1][x] - (img[y+1][x])- img[y+1][x+1];
      // [x,y-1]*1 | 0 | [x+1,y-1]*(-1)
      // [x,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // [x,y+1]*1 | 0 | [x+1,y+1]*(-1)
      vertical_sobel_val = img[y-1][x] + (img[y][x])+ img[y+1][x] - img[y-1][x+1] - (img[y][x+1])- img[y+1][x+1];
    }
    // Right edge
    else if (x == img_width-1) {
      // [x-1,y-1]*( 1) | [x  ,y-1]*( 1) | [x  ,y-1]*( 1)
      //      0         |      0         |      0
      // [x-1,y+1]*(-1) | [x  ,y+1]*(-1) | [x  ,y+1]*(-1)
      horizontal_sobel_val = img[y-1][x-1] + (img[y-1][x])+ img[y-1][x] - img[y+1][x-1] - (img[y+1][x])- img[y+1][x];
      // [x-1,y-1]*1 | 0 | [x,y-1]*(-1)
      // [x-1,y  ]*1 | 0 | [x,y  ]*(-1)
      // [x-1,y+1]*1 | 0 | [x,y+1]*(-1)
      vertical_sobel_val = img[y-1][x-1] + (img[y][x-1])+ img[y+1][x-1] - img[y-1][x] - (img[y][x])- img[y+1][x];
    }
    // Middle
    else {
      // [x-1,y-1]*( 1) | [x  ,y-1]*( 1) | [x+1,y-1]*( 1)
      //      0         |      0         |      0
      // [x-1,y+1]*(-1) | [x  ,y+1]*(-1) | [x+1,y+1]*(-1)
      horizontal_sobel_val = img[y-1][x-1] + (img[y-1][x])+ img[y-1][x+1] - img[y+1][x-1] - (img[y+1][x])- img[y+1][x+1];
      // [x-1,y-1]*1 | 0 | [x+1,y-1]*(-1)
      // [x-1,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // [x-1,y+1]*1 | 0 | [x+1,y+1]*(-1)
      vertical_sobel_val = img[y-1][x-1] + (img[y][x-1])+ img[y+1][x-1] - img[y-1][x+1] - (img[y][x+1])- img[y+1][x+1];
    }
  }
}

// /**
 // * Calculates horizontal and vertical sobel values for the specified pixel.
 // * @param `img` Source image.
 // * @param `x` Column index.
 // * @param `y` Row index.
 // * @param `horizontal_sobel_val` Output horizontal sobel value.
 // * @param `vertical_sobel_val` Output vertical sobel value.
 // * It uses this kernel for convolution for horizontal sobel: 
 // *      1  2  1
 // *      0  0  0
 // *     -1 -2 -1 
 // * and this for vertical sobel:
 // *      1 0 -1
 // *      2 0 -2
 // *      1 0 -1 
 // */
// inline void getSobelValues(double **img, int x, int y, double &horizontal_sobel_val, double &vertical_sobel_val) {
  // // TOP MARGIN:
  // if (y == 0) {
    // // Left corner
    // if (x == 0) {
      // // [x  ,y  ]*( 1) | [x  ,y  ]*( 2) | [x+1,y  ]*( 1)
      // //      0         |      0         |      0
      // // [x  ,y+1]*(-1) | [x  ,y+1]*(-2) | [x+1,y+1]*(-1)
      // horizontal_sobel_val = img[y][x] + (img[y][x] *2.0) + img[y][x+1] - img[y+1][x] - (img[y+1][x] *2.0) - img[y+1][x+1];
      // // [x,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // // [x,y  ]*2 | 0 | [x+1,y  ]*(-2)
      // // [x,y+1]*1 | 0 | [x+1,y+1]*(-1)
      // vertical_sobel_val = img[y][x] + (img[y][x] *2.0) + img[y+1][x] - img[y][x+1] - (img[y][x+1] *2.0) - img[y+1][x+1];
    // } 
    // // Right corner
    // else if (x == img_width-1) {
      // // [x-1,y  ]*( 1) | [x  ,y  ]*( 2) | [x  ,y  ]*( 1)
      // //      0         |      0         |      0
      // // [x-1,y+1]*(-1) | [x  ,y+1]*(-2) | [x  ,y+1]*(-1)
      // horizontal_sobel_val = img[y][x-1] + (img[y][x] *2.0) + img[y][x] - img[y+1][x-1] - (img[y+1][x] *2.0) - img[y+1][x];
      // // [x-1,y  ]*1 | 0 | [x,y  ]*(-1)
      // // [x-1,y  ]*2 | 0 | [x,y  ]*(-2)
      // // [x-1,y+1]*1 | 0 | [x,y+1]*(-1)
      // vertical_sobel_val = img[y][x-1] + (img[y][x-1] *2.0) + img[y+1][x-1] - img[y][x] - (img[y][x] *2.0) - img[y+1][x];
    // }
    // // Middle
    // else {
      // // [x-1,y  ]*( 1) | [x  ,y  ]*( 2) | [x+1,y  ]*( 1)
      // //      0         |      0         |      0
      // // [x-1,y+1]*(-1) | [x  ,y+1]*(-2) | [x+1,y+1]*(-1)
      // horizontal_sobel_val = img[y][x-1] + (img[y][x] *2.0) + img[y][x+1] - img[y+1][x-1] - (img[y+1][x] *2.0) - img[y+1][x+1]; 
      // // [x-1,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // // [x-1,y  ]*2 | 0 | [x+1,y  ]*(-2)
      // // [x-1,y+1]*1 | 0 | [x+1,y+1]*(-1)
      // vertical_sobel_val = img[y][x-1] + (img[y][x-1] *2.0) + img[y+1][x-1] - img[y][x+1] - (img[y][x+1] *2.0) - img[y+1][x+1]; 
    // }
  // } 
  // // BOTTOM MARGIN:
  // else if (y == img_height-1) {
    // // Left corner
    // if (x == 0) {
      // // [x  ,y-1]*( 1) | [x  ,y-1]*( 2) | [x+1,y-1]*( 1)
      // //      0         |      0         |      0
      // // [x  ,y  ]*(-1) | [x  ,y  ]*(-2) | [x+1,y  ]*(-1)
      // horizontal_sobel_val = img[y-1][x] + (img[y-1][x] *2.0) + img[y-1][x+1] - img[y][x] - (img[y][x] *2.0) - img[y][x+1];
      // // [x,y-1]*1 | 0 | [x+1,y-1]*(-1)
      // // [x,y  ]*2 | 0 | [x+1,y  ]*(-2)
      // // [x,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // vertical_sobel_val = img[y-1][x] + (img[y][x] *2.0) + img[y][x] - img[y-1][x+1] - (img[y][x+1] *2.0) - img[y][x+1];
    // }
    // // Right corner
    // else if (x == img_width-1) {
      // // [x-1,y-1]*( 1) | [x  ,y-1]*( 2) | [x  ,y-1]*( 1)
      // //      0         |      0         |      0
      // // [x-1,y  ]*(-1) | [x  ,y  ]*(-2) | [x  ,y  ]*(-1)
      // horizontal_sobel_val = img[y-1][x-1] + (img[y-1][x] *2.0) + img[y-1][x] - img[y][x-1] - (img[y][x] *2.0) - img[y][x];
      // // [x-1,y-1]*1 | 0 | [x,y-1]*(-1)
      // // [x-1,y  ]*2 | 0 | [x,y  ]*(-2)
      // // [x-1,y  ]*1 | 0 | [x,y  ]*(-1)
      // vertical_sobel_val = img[y-1][x-1] + (img[y][x-1] *2.0) + img[y][x-1] - img[y-1][x] - (img[y][x] *2.0) - img[y][x];
    // } 
    // // Middle
    // else {
      // // [x-1,y-1]*( 1) | [x  ,y-1]*( 2) | [x+1,y-1]*( 1)
      // //      0         |      0         |      0
      // // [x-1,y  ]*(-1) | [x  ,y  ]*(-2) | [x+1,y  ]*(-1)
      // horizontal_sobel_val = img[y-1][x-1] + (img[y-1][x] *2.0) + img[y-1][x+1] - img[y][x-1] - (img[y][x] *2.0) - img[y][x+1];
      // // [x-1,y-1]*1 | 0 | [x+1,y-1]*(-1)
      // // [x-1,y  ]*2 | 0 | [x+1,y  ]*(-2)
      // // [x-1,y  ]*1 | 0 | [x+1,y  ]*(-1)
      // vertical_sobel_val = img[y-1][x-1] + (img[y][x-1] *2.0) + img[y][x-1] - img[y-1][x+1] - (img[y][x+1] *2.0) - img[y][x+1];
    // }
  // // MIDDLE:
  // } else {
    // // Left edge
    // if (x == 0) {
      // // [x  ,y-1]*( 1) | [x  ,y-1]*( 2) | [x+1,y-1]*( 1)
      // //      0         |      0         |      0
      // // [x  ,y+1]*(-1) | [x  ,y+1]*(-2) | [x+1,y+1]*(-1)
      // horizontal_sobel_val = img[y-1][x] + (img[y-1][x] *2.0) + img[y-1][x+1] - img[y+1][x] - (img[y+1][x] *2.0) - img[y+1][x+1];
      // // [x,y-1]*1 | 0 | [x+1,y-1]*(-1)
      // // [x,y  ]*2 | 0 | [x+1,y  ]*(-2)
      // // [x,y+1]*1 | 0 | [x+1,y+1]*(-1)
      // vertical_sobel_val = img[y-1][x] + (img[y][x] *2.0) + img[y+1][x] - img[y-1][x+1] - (img[y][x+1] *2.0) - img[y+1][x+1];
    // }
    // // Right edge
    // else if (x == img_width-1) {
      // // [x-1,y-1]*( 1) | [x  ,y-1]*( 2) | [x  ,y-1]*( 1)
      // //      0         |      0         |      0
      // // [x-1,y+1]*(-1) | [x  ,y+1]*(-2) | [x  ,y+1]*(-1)
      // horizontal_sobel_val = img[y-1][x-1] + (img[y-1][x] *2.0) + img[y-1][x] - img[y+1][x-1] - (img[y+1][x] *2.0) - img[y+1][x];
      // // [x-1,y-1]*1 | 0 | [x,y-1]*(-1)
      // // [x-1,y  ]*2 | 0 | [x,y  ]*(-2)
      // // [x-1,y+1]*1 | 0 | [x,y+1]*(-1)
      // vertical_sobel_val = img[y-1][x-1] + (img[y][x-1] *2.0) + img[y+1][x-1] - img[y-1][x] - (img[y][x] *2.0) - img[y+1][x];
    // }
    // // Middle
    // else {
      // // [x-1,y-1]*( 1) | [x  ,y-1]*( 2) | [x+1,y-1]*( 1)
      // //      0         |      0         |      0
      // // [x-1,y+1]*(-1) | [x  ,y+1]*(-2) | [x+1,y+1]*(-1)
      // horizontal_sobel_val = img[y-1][x-1] + (img[y-1][x] *2.0) + img[y-1][x+1] - img[y+1][x-1] - (img[y+1][x] *2.0) - img[y+1][x+1];
      // // [x-1,y-1]*1 | 0 | [x+1,y-1]*(-1)
      // // [x-1,y  ]*2 | 0 | [x+1,y  ]*(-2)
      // // [x-1,y+1]*1 | 0 | [x+1,y+1]*(-1)
      // vertical_sobel_val = img[y-1][x-1] + (img[y][x-1] *2.0) + img[y+1][x-1] - img[y-1][x+1] - (img[y][x+1] *2.0) - img[y+1][x+1];
    // }
  // }
// }



/**
 * Computes both vertical and horizontal sobel filters and after that the magnitude too.
 * Allocates memory for all of the resulting matrices. For their deallocation the caller is responsible.
 */
inline void computeSobelsAndMagnitude(double **src_img, double ***sobeled_vertical, double ***sobeled_horizontal, double ***magnitude, int ***direction) {
  // Memmory allocations
  double tmp_v, tmp_h;
  *sobeled_vertical = (double **) malloc(img_height * sizeof(double *));
  *direction = (int **) malloc(img_height * sizeof(int *));
  *magnitude = (double **) malloc(img_height * sizeof(double *));
  // Start calculation
  for (int y = 0; y < img_height; y++) {
    // Allocate memory for this row
    (*magnitude)[y] = (double *) malloc(img_width * sizeof(double));
    (*direction)[y] = (int *) malloc(img_width * sizeof(int));
    for (int x = 0; x < img_width; x++) {
      // Compute sobels first using convolution
      // We cannot lose the margins of the original picture => it must be extended with 1 pixel in every direction (the pixels on the margins are duplicated)
      getSobelValues(src_img, x, y, tmp_h, tmp_v);
      // Compute magnitude using the previously computed sobel values
      (*magnitude)[y][x] = myabs(tmp_v) + myabs(tmp_h); 
      (*direction)[y][x] = get_direction(tmp_v, tmp_h);

      // (*magnitude)[y][x] = (double) sqrt((*sobeled_vertical)[y][x] * (*sobeled_vertical)[y][x] + (*sobeled_horizontal)[y][x] * (*sobeled_horizontal)[y][x]);
      
    }
  }
}


/**
 * Konvoluce obrazku, ktera nazanedbava okraje. Okraje se roztahnou.
 *
 *                              Roztahnuty obrazek
 *                             +---+---+---+---+---+
 *  Obrazek 3x3                |105|105| 45| 42| 42|                 Result
 * +---+---+---+               +---+---+---+---+---+             +---+---+---+
 * |105| 45| 42|               |105|105| 45| 42| 42|             | 10| 4 | 4 |
 * +---+---+---+   roztahnuti  +---+---+---+---+---+  Konvoluce  +---+---+---+
 * |102|103| 5 |  -----------> |102|102|103| 5 | 5 | ----------> | 10| 10| 0 |
 * +---+---+---+               +---+---+---+---+---+             +---+---+---+
 * |201|248|125|               |201|201|248|125|125|             | 20| 24| 12|
 * +---+---+---+               +---+---+---+---+---+             +---+---+---+
 *                             |201|201|248|125|125|
 *                             +---+---+---+---+---+
 * @param `src_img` zdrojovy obrazek
 * @param `kernel` jadro konvoluce
 * @param `kernel_size` velikost jadra
 * @return Konvoluvany obrazek
 */
inline double ** convolve(int ** src_img, double ** kernel, int kernel_size){
    double ** result = (double **) malloc (img_height * sizeof(double*)); // Init rows
    int margin = (kernel_size - 1)/2  ; // ta druha minus jedna bo pocitame od nuly
    double sum;

    // 1] Konvoluce prvnich radku
    int fixed_x, fixed_y;

    for(int x = 0; x < margin; x++){ // Alokace prvnich radku 
        result[x] = (double *) malloc (img_width * sizeof(double));
        // a] Levy horni roh
        for(int y = 0; y < margin; y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    fixed_x = ((x+i-margin) > 0) ? x+i-margin : 0; // Saturace X na min. index pole
                    fixed_y = ((y+j-margin) > 0) ? y+j-margin : 0; // Saturace Y na min. index pole
                    sum += (double) src_img[fixed_x][fixed_y] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }
        // b] Horni hrana
        for(int y = margin+1; y<(img_width-margin); y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    fixed_x = ((x+i-margin) > 0) ? x+i-margin : 0; // Saturace X na min. index
                    sum += (double) src_img[fixed_x][y+j-margin] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }
        // c] Pravy horni roh
        for(int y = (img_width-margin); y<img_width; y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    fixed_x = ((x+i-margin) > 0) ? x+i-margin : 0; // Saturace X na min. index
                    fixed_y = ((y+j-margin) < img_width) ? y+j-margin : img_width-1; // Saturace Y na max index
                    sum += (double) src_img[fixed_x][fixed_y] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }
    }
    // 2] Projedu stred obrazku
    for(int x = margin; x < (img_height-margin); x++){
        result[x] = (double *) malloc (img_width * sizeof(double));
        // a] Levy okraj
        for(int y = margin; y<(img_width-margin); y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    fixed_y = ((y+j-margin) > 0) ? y+j-margin : img_width-1; // Saturace Y na min index
                    sum += (double) src_img[x+i-margin][fixed_y] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }
        // b] Stred
        for(int y = margin; y < (img_width-margin); y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    sum += (double) src_img[x+i-margin][y+j-margin] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }
        // c] Pravy okraj
        for(int y = (img_width-margin); y<img_width; y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    fixed_y = ((y+j-margin) < img_width) ? y+j-margin: img_width-1; // Saturace Y na max index
                    sum += (double) src_img[x+i-margin][fixed_y] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }
    }

    // 3] Projedu spodek obrazku
    for(int x = (img_height-margin); x < img_height; x++){
        result[x] = (double *) malloc (img_width * sizeof(double));
        // a] Levy dolni roh
        for(int y = 0; y < margin; y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    fixed_x = ((x+i-margin) < img_height) ? x+i-margin : img_height-1; // Saturace X na max. index 
                    fixed_y = ((y+j-margin) > 0) ? y+j-margin : 0; // Saturace Y na min. index 
                    sum += (double) src_img[fixed_x][fixed_y] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }
        // b] Horni hrana
        for(int y = margin; y<(img_width-margin); y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    fixed_x = ((x+i-margin) < img_height) ? x+i-margin : img_height-1; // Saturace X na max. index 
                    sum += (double) src_img[fixed_x][y+j-margin] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }
        // c] Pravy horni roh
        for(int y = margin; y<(img_width-margin); y++){
            sum = 0;
            for(int i = 0; i < kernel_size; i++){
                for(int j = 0; j < kernel_size; j++){
                    fixed_x = ((x+i-margin) < img_height) ? x+i-margin : img_height-1; // Saturace X na max. index 
                    fixed_y = ((y+j-margin) < img_width) ? y+j-margin : img_width-1; // Saturace Y na max index
                    sum += (double) src_img[fixed_x][fixed_y] * kernel[i][j];
                }
            }
            result[x][y] = sum;
        }       
    }
    return result;
}

/**
 * Normalizace hodnot jasu obrazku.
 * @param `img` Obrazek ktery bude normalizovan.
 */
void max_normalize(double ** img){
    // Nalezni maximum
    double max = 0;
    for(int x = 0; x < img_height; x++){
        for(int y = 0; y < img_width; y++){
            max = (max > img[x][y]) ? max : img[x][y];
        }
    }
    // Normalizuj
    for(int x = 0; x < img_height; x++){
        for(int y = 0; y < img_width; y++){
            img[x][y] = img[x][y]*256.0/max;
        }
    }
}

/**
 * Vypocet sumy hodnot kernelu
 * @param `kernel` Dany kernel ve fromatu array.
 * @param `kernel_size` Velikost jadra.
 * @return Suma.
 */
double sum_kernel(double ** kernel, int kernel_size){
    double sum = 0;
    for(int i = 0; i < kernel_size; i++){
        for(int j = 0; j < kernel_size; j++)
            sum += kernel[i][j];
    }
    return sum;
}

/**
 * Ulozeni matice as obrazek
 * @param `src_img` Obrazek
 * @param `filename` Soubor kaj se ten obraz ulozi
 */
void save_img(int ** src_img, const char * filename){
    cv::Mat img(img_height,img_width, CV_8UC1);
    for(int i = 0; i < img.rows; i++){ // Pruchod po radcich
        for(int j = 0; j < img.cols; j++){ // Prchod po sloupcich
            img.at<unsigned char>(i,j) = src_img[i][j];
        }
    }

    cv::imwrite(filename, img);
}



#define DIR_000_045 0x1 // Binarne: 0b0001
#define DIR_045_090 0x2 // Binarne: 0b0010  -----> Muzeme snadno provadet binarni and a or a pritom pouzivat jednu promennou.
#define DIR_090_135 0x4 // Binarne: 0b0100
#define DIR_135_180 0x8 // Binarne: 0b1000

#define DIR_000 0x1 // Binarne: 0b0001
#define DIR_045 0x2 // Binarne: 0b0010  -----> Muzeme snadno provadet binarni and a or a pritom pouzivat jednu promennou.
#define DIR_090 0x4 // Binarne: 0b0100
#define DIR_135 0x8 // Binarne: 0b1000


/**
 * V jakem octantu se hrana nachazi?
 * via tanh./
 */
inline int get_direction(double pixel_i, double pixel_j){
#define D45 45*M_PI/180    
#define D90 90*M_PI/180    
#define D135 135*M_PI/180 
#define D22_5 22.5*M_PI/180 
#define D157_5 157.5*M_PI/180 
#define D180 M_PI 
#define D67_5 67.5*M_PI/180 
#define D112_5 112.5*M_PI/180 


    double theta = atan2(pixel_i, pixel_j);
    if (theta < 0) {
      theta += M_PI;
    }
    
    if ((theta >= 0 && theta <= D22_5) || (theta > D157_5 && theta <= D180)) {
      return DIR_000;
    } else if (theta > D22_5 && theta <= D67_5) {
      return DIR_045;
    } else if (theta > D67_5 && theta <= D112_5) {
      return DIR_090;
    } else if (theta > D112_5 && theta <= D157_5) {
      return DIR_135;
    } else {
      fprintf(stderr, "Internal error: Invalid edge direction.\n");
      exit(-1);
    }
    
    /*
    DIRECTION DISTRIBUTION I.
    if (theta >=0 && theta <= D45) {
      return DIR_000_045;
    } else if (theta > D45 && theta < D90) {
      return DIR_045_090;
    } else if (theta >= D90 && theta < D135) {
      return DIR_090_135;
    } else {
      return DIR_135_180;
    }*/
    
    
    /*
    DIRECTION DISTRIBUTION - OLD
    int mask = 0;
    if(myabs(pixel_i) >= myabs(pixel_j)){ // Horizontalni sobel prevazuje
        // <0° - 45°>
        if((pixel_i >= 0 && pixel_j >= 0) || (pixel_i <= 0 && pixel_j <= 0)) // 1 nebo 5 octant 
            mask |= DIR_000_045;
        // <135° - 180°)
        if((pixel_i <= 0 && pixel_j >= 0) || (pixel_i >= 0 && pixel_j <= 0)) // 4 nebo 8 octant
            mask |= DIR_135_180;
        
    } 
    if(myabs(pixel_i) <= myabs(pixel_j)){
    //else{                                 // Verticalni sobel pravzuje 
        // (45° - 90°)
        if((pixel_i >= 0 && pixel_j >= 0) || (pixel_i <= 0 && pixel_j <= 0))  //
            mask |= DIR_045_090;
        // <90° - 135°)
        //else
        if((pixel_i <= 0 && pixel_j >= 0) || (pixel_i >= 0 && pixel_j <= 0))
            mask |= DIR_090_135;
    }
   return mask;*/
}

/**
 * Podle smeru, viz predchozi fce zmensime hrany
 */
inline int non_max_surpression(int x, int y, double ** magnitude, int direction){
    double c1, c2;
    double m = magnitude[x][y];
    //int direction = get_direction(pixel_i, pixel_j);
    
    
    // if(direction & DIR_000_045){
    if(direction & DIR_000){
        c1 = magnitude[x-1][y];
        c2 = magnitude[x+1][y];
    }
    else if(direction & DIR_045){
        c1 = magnitude[x-1][y-1];
        c2 = magnitude[x+1][y+1];
    }
    else if(direction & DIR_090){
        c1 = magnitude[x]  [y-1];
        c2 = magnitude[x]  [y+1];
    }
    else{
        c1 = magnitude[x+1]  [y-1];
        c2 = magnitude[x-1]  [y+1];      
      }

    return (m > c1) && (m > c2) ? 255 : 0;
}


#define DRAW_EDGE    0x01
#define CHECKED_EDGE 0x02

/**
 * Hysteresis function.
 * Checks every neighbour pixels of the specified strong edge pixel (x,y) whether they are weak edge pixels.
 * If so, the given edge pixel is drawn to the resulting image and the search continues with its neighbours till no unchecked edges remains.
 * @param `result` Resulting image ready for final procession.
 * @param `magnitude` Magnitude
 * @param `edges` Image of edges.
 * @param `low_thold` Low threshold for edge detection. low_thold < weak_thold <= high_thold, strong_thold > high_thold
 * @param `high_thold` High threshold for edge detection.
 * @param `x` X coordinate of the strong edge pixel. 
 * @param `y` Y coordinate of the strong edge pixel. 
 */
inline void check_edge(int ** result, double ** magnitude, int ** edges, double low_thold, double high_thold, int x, int y){
  // Stack containing <x,y> pairs which point to an unchecked edge
  std::stack<int> unchecked_edges;
  unchecked_edges.push(x);
  unchecked_edges.push(y);
  while (!unchecked_edges.empty()) {
    int uy = unchecked_edges.top();
    unchecked_edges.pop();
    int ux = unchecked_edges.top();
    unchecked_edges.pop();
    // Set checked flag
    result[ux][uy] |= CHECKED_EDGE;
    
    if(!(result[ux+1][uy+1] & CHECKED_EDGE) && edges[ux+1][uy+1] && magnitude[ux+1][uy+1] <= high_thold && magnitude[ux+1][uy+1] > low_thold){
        result[ux+1][uy+1] |= DRAW_EDGE;
        unchecked_edges.push(ux+1);
        unchecked_edges.push(uy+1);
    }
    if(!(result[ux-1][uy+1] & CHECKED_EDGE) && edges[ux-1][uy+1] && magnitude[ux-1][uy+1] <= high_thold && magnitude[ux-1][uy+1] > low_thold){
        result[ux-1][uy+1] |= DRAW_EDGE;
        unchecked_edges.push(ux-1);
        unchecked_edges.push(uy+1);
    }
    if(!(result[ux-1][uy-1] & CHECKED_EDGE) && edges[ux-1][uy-1] && magnitude[ux-1][uy-1] <= high_thold && magnitude[ux-1][uy-1] > low_thold){
        result[ux-1][uy-1] |= DRAW_EDGE;
        unchecked_edges.push(ux-1);
        unchecked_edges.push(uy-1);
    }
    if(!(result[ux+1][uy-1] & CHECKED_EDGE) && edges[ux+1][uy-1] && magnitude[ux+1][uy-1] <= high_thold && magnitude[ux+1][uy-1] > low_thold){
        result[ux+1][uy-1] |= DRAW_EDGE;
        unchecked_edges.push(ux+1);
        unchecked_edges.push(uy-1);
    }
    if(!(result[ux][uy+1] & CHECKED_EDGE) && edges[ux][uy+1] && magnitude[ux][uy+1] <= high_thold && magnitude[ux][uy+1] > low_thold){
        result[ux][uy+1] |= DRAW_EDGE;
        unchecked_edges.push(ux);
        unchecked_edges.push(uy+1);
    }
    if(!(result[ux][uy-1] & CHECKED_EDGE) && edges[ux][uy-1] && magnitude[ux][uy-1] <= high_thold && magnitude[ux][uy-1] > low_thold){
        result[ux][uy-1] |= DRAW_EDGE;
        unchecked_edges.push(ux);
        unchecked_edges.push(uy-1);
    }
    if(!(result[ux+1][uy] & CHECKED_EDGE) && edges[ux+1][uy] && magnitude[ux+1][uy] <= high_thold && magnitude[ux+1][uy] > low_thold){
        result[ux+1][uy] |= DRAW_EDGE;
        unchecked_edges.push(ux+1);
        unchecked_edges.push(uy);
    }
    if(!(result[ux][uy+1] & CHECKED_EDGE) && edges[ux][uy+1] && magnitude[ux][uy+1] <= high_thold && magnitude[ux][uy+1] > low_thold){
        result[ux][uy+1] |= DRAW_EDGE;
        unchecked_edges.push(ux);
        unchecked_edges.push(uy+1);
    }
  }
}

/**
 * Kennyho detekce hran. 
 * 0] Vytvorit filtry.
 * 1] Rozmazat gaussem
 * 2] Sobelovy detekce hran + magnituda
 * 3] Urceni maxim a minim "ztenceni"
 * 4] Prahovani a hysterizace
 * 5] FAP
 */
void canny(int ** img, int ** result, double sigma, double low_thold, double high_thold){
    // Vytvoreni kernelu
    // -----------------
    double** gauss_kernel = gaussian_kernel(GAUSSIAN_KERNEL_SIZE, sigma); 

    // Rozmazani obrazku
    // -----------------
    double** blured_image = convolve((int **) img, gauss_kernel, GAUSSIAN_KERNEL_SIZE);
    // Musim to normalizovat, todo pres bitovy posun
    //max_normalize(blured_image);

    // Nalezeni gradientu
    // ------------------
    double **sobeled_vertical = NULL;
    double **sobeled_horizontal = NULL;
    double **magnitude = NULL;
    int **direction = NULL;
    computeSobelsAndMagnitude(blured_image, &sobeled_vertical, &sobeled_horizontal, &magnitude, &direction);    
    //inline void computeSobelsAndMagnitude(double **src_img, double ***sobeled_vertical, double ***sobeled_horizontal, double ***magnitude, double ***direction) {
    // Normalizace (Johnny's stuff)
    // ---------------------------
    //max_normalize(sobeled_vertical);
    //max_normalize(sobeled_horizontal);
    //max_normalize(magnitude);

    // Potlaceni ne-maxim
    // ------------------
    int ** edges = (int **) malloc(img_height * sizeof(int *));
    for(int x = 0; x < img_height; x++){
        edges[x] = (int *) malloc(img_width * sizeof(int));
        memset(edges[x], 0, img_width*sizeof(int)); 
    }
    //inline int non_max_surpression(int x, int y, double ** magnitude, int direction){

    for(int x = 1; x < img_height-1; x++){ // for each row
        for(int y = 1; y < img_width-1; y++){ // for each col
            if(magnitude[x][y] <= 0) continue; // Nechceme nulovou magnitudu a zaporna neexistuje. 
            edges[x][y] = non_max_surpression(x,y,magnitude,direction[x][y]);
        }
    }

    // Double threshold
    // ----------------
    for(int x = 1; x < img_height-1; x++){
        for(int y = 1; y < img_width-1; y++){
            if(edges[x][y] && magnitude[x][y] > high_thold){
                result[x][y] |= DRAW_EDGE;
                check_edge(result, magnitude, edges, low_thold, high_thold, x, y);
            }
        }       
    }
    for(int x = 1; x < img_height-1; x++){
        for(int y = 1; y < img_width-1; y++){
            result[x][y] = (result[x][y]&DRAW_EDGE)*255; // NOT MULT
        }
    }

    // FAP
    // ---
    save_img(result, "out.png");
    // Deallocation
    //printf("FUCK\n");
}


// TODO comments
#if defined (_MSC_VER) || defined (_WIN32)

#include <ctime>

static inline double cpuTime(void) {
    return (double)clock() / CLOCKS_PER_SEC; }

#else

#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>

static inline double cpuTime(void) {
    struct rusage ru;
    getrusage(RUSAGE_SELF, &ru);
    return (double)ru.ru_utime.tv_sec + (double)ru.ru_utime.tv_usec / 1000000; }
#endif


/**
 * Prints help of the application.
 */
void printHelp(void) {
  printf("Canny Edge Detector Help:\n");
  printf("Use: ./canny -i <input_image> [-s <sigma>] [-l <low_thold>] [-h <high_thold>]\n");
  printf("Default values: -s 2.0 -l 100 -h 200\n");
}


//void load_mult(char* filename);
/**
 * Main function.
 * @param `argc` Number of arguments.
 * @param `argv` Argument values.
 */
int main(int argc, char ** argv) {
    srand(time(NULL));
    // Default setup
    std::string img_path = "";
    double sigma = 2.0;
    double low_thold = 15.0;
    double high_thold = 30.0;
    high_thold = 0.0;
    // Process program arguments
    int c;
    opterr = 0;

    while ((c = getopt (argc, argv, "i:s:l:h:")) != -1) {
      switch (c) {
        case 'i':
          img_path = std::string(optarg);
          break;
        case 's':
          sigma = atof(optarg);
          break;
        case 'l':
          low_thold = atof(optarg);
          break;
        case 'h':
          high_thold = atof(optarg);
          break;
        case '?':
          if (optopt == 'i' || optopt == 's' || optopt == 'l' || optopt == 'h') {
            fprintf (stderr, "Option -%c requires an argument.\n", optopt);
          } else if (isprint (optopt)) {
            fprintf (stderr, "Unknown option `-%c'.\n", optopt);
          } else {
            fprintf (stderr, "Unknown option character `\\x%x'.\n", optopt);
          }
          printHelp();
          return EXIT_FAILURE;
        default:
          printf("DUCK\n");
      }
    }

    for (int index = optind; index < argc; index++) {
      printf ("Non-option argument %s\n", argv[index]);
    }
    
    if (optind != argc) {
      printHelp();
      return EXIT_FAILURE;
    }
    
    ///if(argc > 5)
    ///    load_mult(argv[5]);
    ///else
    ///    load_mult("../dumb_mults_v2/1.log");
    
    
    

    // load testing images
    cv::Mat src_rgb = cv::imread( img_path );

    // check testing images
    if(src_rgb.empty()) {
        std::cout << "Failed to load image: " << img_path << std::endl;
        return -1;
    }

    // Grayscale
    cv::Mat gray;
    cv::cvtColor( src_rgb, gray, CV_BGR2GRAY ); 
    //printf("Rozmery: %d %d\n", src_rgb.rows, src_rgb.cols); 
    
    int ** img = img2array(gray);
    int ** edges = img2array(gray);
    for(int x = 0; x < img_height; x++){ // for each row
        memset(edges[x], 0, img_width*sizeof(int));
    }
    double bazdmeg = cpuTime();
    canny(img, edges, sigma, low_thold, high_thold);
    bazdmeg = cpuTime() - bazdmeg;
    // printf("Duration: %f sekund \n", bazdmeg);
    printf("%f", bazdmeg);
    // Deallocation
    freeIntMatrix(img, img_height);
    freeIntMatrix(edges, img_height);
    return 0;
}
////////////////////////////////////////////////////////////

/**
 * Nahraje nasobicku do pameti.
 *//*
void load_mult(char* filename){
    FILE *fh = NULL;
    int  save = 0;
    int  next = 0;
    int a,b,result;
    a = -1;
    char ch;  
    char buffer[50];
    char *buff_ptr = buffer;
    dumb_mult = (int**) malloc(256 * sizeof(int*));
    for(int i = 0; i < 256; i++)
        dumb_mult[i] = (int*) malloc(256 * sizeof(int));
    
    if (!(fh = fopen(filename,"r"))) {fprintf(stderr, "File '%s' not found\n", filename); exit(-1); }
    int i = 0;
    do {
        ch = getc(fh);
        save = 0;
        switch(ch){
            case '#':
                next = -10;
                break;
            case '\n':
                buff_ptr = buffer;
                next = 0;
                break;
            case '*':
                save = 1;
                next ++;
                break;
            case '=':
                save = 1;
                next ++;
                break;
            case '[':
                save = 1;
                next ++;
                break;
        }
        if(next < 0)
            continue;
        if(isdigit(ch) || ch == '-'){
            *buff_ptr = ch;
            buff_ptr++;
        }
        if(save){
            *buff_ptr = 0;
            if(next == 1)
                a = atoi(buffer);
            if(next == 2)
                b = atoi(buffer);
            if(next == 3){
                result = atoi(buffer);
                //fprintf(stderr, "%d * %d = %d\n", a, b, result);
                dumb_mult[a][b]=result;
            }
            buff_ptr = buffer;
            
        }
    } while (ch != EOF);
}
*/
