/**
 * Sobel edge detector 
 *
 * Autor: Petr Dvoracek
 * Date: 20th March 2015
 * Language: Mostly czech.
 * 
 */

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

//#define CHECK_NASOBENI

#define DEBUG_GAUSS 

// Velikost obrazku!
int img_height;
int img_width;

// Johnnys stuff
int** dumb_mult; 
int** dumb_adder; 
int** nasobeni;

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
int ** gaussian_kernel(int k, double sigma){
    int ** result = (int **) malloc (k * sizeof(int *));
    #ifdef DEBUG_GAUSS
    printf("%f\n", sigma);
    #endif
    for(int i = 0; i < k; i++){
        int * row = (int *) malloc(k * sizeof(int));
        result[i] = row;
        for(int j = 0; j < k; j++){
            double x = i-(k-1.0)/2.0;
            double y = j-(k-1.0)/2.0;
            double value = GAUSSIAN_FUNCTION_MAX_VAL * exp(-(x*x + y*y)/(2.0*sigma*sigma));
            result[i][j] = (int) value;
            #ifdef DEBUG_GAUSS
            printf("%d ", (int) value);
            #endif
        }
        #ifdef DEBUG_GAUSS
        printf("\n");
        #endif
    }
    return result;
}

/**
 * Vytovreni sobelovych filtru
 * @param `k` Velikost jadra
 * @param `transpoze` Transponovani kernelu
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
int ** convolve_sobel(int ** src_img){
    int ** result = (int **) malloc (img_height * sizeof(int*)); // Init rows
    int margin = 1; // ta druha minus jedna bo pocitame od nuly
    int sum;

    // 1] Konvoluce prvnich radku

    for(int x = 0; x < margin; x++){ // Alokace prvnich radku 
        result[x] = (int *) malloc (img_width * sizeof(int));
        // a] Levy horni roh
        for(int y = 0; y < margin; y++){
            result[x][y] = 0;
        }
        // b] Horni hrana
        for(int y = margin+1; y<(img_width-margin); y++){
            sum = 0;
            result[x][y] = sum;
        }
        // c] Pravy horni roh
        for(int y = (img_width-margin); y<img_width; y++){
            sum = 0;
            result[x][y] = sum;
        }
    }
    // 2] Projedu stred obrazku
    for(int x = margin; x < (img_height-margin); x++){
        result[x] = (int *) malloc (img_width * sizeof(int));
        // a] Levy okraj
        for(int y = margin; y<(img_width-margin); y++){
            sum = 0;
            result[x][y] = sum;
        }
        // b] Stred
        for(int y = margin; y < (img_width-margin); y++){
            sum = 0;
            //printf("Halo %d %d\n", src_img[x-1][y-1] , src_img[x-1][y+1]);
            int a = dumb_adder[dumb_adder[src_img[x-1][y-1]][src_img[x-1][y+1]] >> 1][src_img[x-1][y]];
            int b = dumb_adder[dumb_adder[src_img[x+1][y-1]][src_img[x+1][y+1]] >> 1][src_img[x+1][y]];
            result[x][y] = a-b;
        }
        // c] Pravy okraj
        for(int y = (img_width-margin); y < img_width; y++){
            sum = 0;
            result[x][y] = sum;
        }
    }

    // 3] Projedu spodek obrazku
    for(int x = (img_height-margin); x < img_height; x++){
        result[x] = (int *) malloc (img_width * sizeof(int));
        // a] Levy dolni roh
        for(int y = 0; y < img_width; y++){
            sum = 0;
            result[x][y] = sum;
        }
    }
    return result;
}

int ** convolve_sobel_oiahewoifhiewahf(int ** src_img){
    int ** result = (int **) malloc (img_height * sizeof(int*)); // Init rows
    int margin = 1; // ta druha minus jedna bo pocitame od nuly
    int sum;

    // 1] Konvoluce prvnich radku

    for(int x = 0; x < margin; x++){ // Alokace prvnich radku 
        result[x] = (int *) malloc (img_width * sizeof(int));
        // a] Levy horni roh
        for(int y = 0; y < margin; y++){
            result[x][y] = 0;
        }
        // b] Horni hrana
        for(int y = margin+1; y<(img_width-margin); y++){
            sum = 0;
            result[x][y] = sum;
        }
        // c] Pravy horni roh
        for(int y = (img_width-margin); y<img_width; y++){
            sum = 0;
            result[x][y] = sum;
        }
    }
    // 2] Projedu stred obrazku
    for(int x = margin; x < (img_height-margin); x++){
        result[x] = (int *) malloc (img_width * sizeof(int));
        // a] Levy okraj
        for(int y = margin; y<(img_width-margin); y++){
            sum = 0;
            result[x][y] = sum;
        }
        // b] Stred
        for(int y = margin; y < (img_width-margin); y++){
            sum = 0;
            int a = dumb_adder[dumb_adder[src_img[x-1][y-1]][src_img[x+1][y-1]] >> 1][src_img[x][y-1]];
            int b = dumb_adder[dumb_adder[src_img[x-1][y+1]][src_img[x+1][y+1]] >> 1][src_img[x][y+1]];
            result[x][y] = a-b;
        }
        // c] Pravy okraj
        for(int y = (img_width-margin); y < img_width; y++){
            sum = 0;
            result[x][y] = sum;
        }
    }

    // 3] Projedu spodek obrazku
    for(int x = (img_height-margin); x < img_height; x++){
        result[x] = (int *) malloc (img_width * sizeof(int));
        // a] Levy dolni roh
        for(int y = 0; y < img_width; y++){
            sum = 0;
            result[x][y] = sum;
        }
    }
    return result;
}

/**
 * Normalizace hodnot jasu obrazku.
 * @param `img` Obrazek ktery bude normalizovan.
 */
void max_normalize(int ** img, int w, int h){
    // Nalezni maximum
    int max = 0;
    for(int x = 0; x < h; x++){
        for(int y = 0; y < w; y++){
            max = (max > img[x][y]) ? max : img[x][y];
        }
    }
    // Normalizuj
    for(int x = 0; x < h; x++){
        for(int y = 0; y < w; y++){
            img[x][y] = (int) img[x][y]*255/(float) max;
        }
    }
}
void max_normalize(int ** img){
    int w = img_width; int h =  img_height;
    int max = 0;
    for(int x = 0; x < h; x++){
        for(int y = 0; y < w; y++){
            max = (max > img[x][y]) ? max : img[x][y];
        }
    }
    // Normalizuj
    for(int x = 0; x < h; x++){
        for(int y = 0; y < w; y++){
            img[x][y] = img[x][y]*255/max;
        }
    }
}
/**
 * Vypocet sumy hodnot kernelu
 * @param `kernel` Dany kernel ve fromatu array.
 * @param `kernel_size` Velikost jadra.
 * @return Suma.
 */
int sum_kernel(int ** kernel, int kernel_size){
    int sum = 0;
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
void save_img(int ** src_img, const char * filename, int w, int h){
    cv::Mat img(w, h, CV_8UC1);
    for(int i = 0; i < img.rows; i++){ // Pruchod po radcich
        for(int j = 0; j < img.cols; j++){ // Prchod po sloupcich
            img.at<unsigned char>(i,j) = src_img[i][j];
        }
    }

    cv::imwrite(filename, img);
}
void save_img(int ** src_img, const char * filename){
    save_img(src_img, filename, img_width, img_height);
}


#define DIR_000_045 0x1 // Binarne: 0b0001
#define DIR_045_090 0x2 // Binarne: 0b0010  -----> Muzeme snadno provadet binarni and a or a pritom pouzivat jednu promennou.
#define DIR_090_135 0x4 // Binarne: 0b0100
#define DIR_135_180 0x8 // Binarne: 0b1000
/**
 * V jakem octantu se hrana nachazi?
 *    \3|2/     
 *    4\|/1     Pozor, hrana ma vetsinou smer 1--5, 2--6, 3--7, 4--8! 
 *    --+--     Hledame tedy jeden ze 4 smeru. 
 *    5/|\8     
 *    /6|7\     
 * 
 *  |sobel_i| >= |sobel_j| --> Horizontalni slozka prevazuje -> Jedna se o smer {{1, 4, 5, 8}}
 *                               HORIZONTALNI SOBEL       VERTIKALNI SOBEL 
 *                              Kladny    -> {{1,4}}  |  Kladny  -> {{1,8}}  --> Viz zdrojak  
 *                              Zaporny   -> {{5,8}}  |  Zaporny -> {{4,5}}  --> Viz zdrojak 
 *  |sobel_i| <= |sobel_j| --> Vertikalni slozka preavzuje   -> Jedna se o smer {{2, 3, 6, 7}}
 *    Analogicky.
 * @param `pixel_i`  Horizontalni slozka sobela na danem pixelu.
 * @param `pixel_j`  Vertikalni slozka sobela na danem pixelu.
 * @return Mask of directions.
 */
int get_direction(int pixel_i, int pixel_j){
    // TODO try this with elses
    int mask = 0;
    #define myabs(val) ((val > 0) ? val : -val) // Bo abs je pokazde jinak naprogramovany. Jednou je na double, podruhe na int.. 
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
    return mask;
}

/**
 * Podle smeru, viz predchozi fce zmensime hrany
 */
int non_max_surpression(int x, int y, int ** magnitude, int ** sobeled_vertical, int ** sobeled_horizontal){
    int result = 0;
    int c1, c2;
    int m = magnitude[x][y];
    int pixel_i = sobeled_horizontal[x][y];
    int pixel_j = sobeled_vertical[x][y];
    int direction = get_direction(pixel_i, pixel_j);
    if(direction & DIR_000_045){
        /**
         * Jedna se spise o smer X ale ne o smer Y!
         * Y..
         * XMX
         * ..Y
         */
        c1 = magnitude[x]  [y-1];
        c2 = magnitude[x-1][y-1];
        int c_plus  = c2 * myabs(pixel_i)  - c1 * (myabs(pixel_i) - myabs(pixel_j));
        c1 = magnitude[x]  [y+1];
        c2 = magnitude[x+1][y+1];
        int c_minus = c2 * myabs(pixel_i)  - c1 * (myabs(pixel_i) - myabs(pixel_j));
        result |= (c_plus <= (m*myabs(pixel_j))) && (c_minus <= (m*myabs(pixel_j)));
#ifdef CHECK_NASOBENI
        nasobeni[magnitude[x]  [y-1]][myabs(pixel_i)]++;
        nasobeni[magnitude[x-1][y-1]][(myabs(pixel_i) - myabs(pixel_j))]++;
        nasobeni[magnitude[x]  [y+1]][myabs(pixel_i)]++;
        nasobeni[magnitude[x+1][y+1]][(myabs(pixel_i) - myabs(pixel_j))]++;
        nasobeni[m]                  [myabs(pixel_i)]++;
        //nasobeni[myabs(pixel_j)][m]++;
#endif
    }
    if(direction & DIR_045_090){
        /**
         * Jedna se spise o smer X ale ne o smer Y!
         * YX. 
         * .M.  
         * .XY
         */
        c1 = magnitude[x+1][y];
        c2 = magnitude[x+1][y+1];
        int c_plus = c2 * myabs(pixel_j)   - c1 * (myabs(pixel_j) - myabs(pixel_i));
        
        c1 = magnitude[x-1][y];
        c2 = magnitude[x-1][y-1];
        int c_minus = c2 * myabs(pixel_j)  - c1 * (myabs(pixel_j) - myabs(pixel_i));
        result |= (c_plus <= (m*myabs(pixel_i))) && (c_minus <= (m*myabs(pixel_i)));
        //result = 1;
#ifdef CHECK_NASOBENI
        nasobeni[magnitude[x+1][y  ]][ myabs(pixel_j)]++;
        nasobeni[magnitude[x+1][y+1]][(myabs(pixel_j) - myabs(pixel_i))]++;
        nasobeni[magnitude[x-1][y  ]][ myabs(pixel_j)]++;
        nasobeni[magnitude[x-1][y-1]][(myabs(pixel_j) - myabs(pixel_i))]++;
        nasobeni[m]                  [myabs(pixel_i)]++;
        //nasobeni[myabs(pixel_i)][m]++;
#endif
    }
    if(direction & DIR_090_135){
        /**
         * Jedna se spise o smer X ale ne o smer Y!
         * .XY 
         * .M.  
         * YX.
         */
        c1 = magnitude[x+1][y];
        c2 = magnitude[x+1][y-1];
        int c_plus = c2 * myabs(pixel_j)  - c1 * (myabs(pixel_j) - myabs(pixel_i));
        c1 = magnitude[x-1][y];
        c2 = magnitude[x-1][y+1];
        int c_minus = c2 * myabs(pixel_j) - c1 * (myabs(pixel_j) - myabs(pixel_i));
        result |= (c_plus <= (m*myabs(pixel_i))) && (c_minus <= (m*myabs(pixel_i)));
#ifdef CHECK_NASOBENI
        nasobeni[magnitude[x+1][y  ]][ myabs(pixel_j)]++;
        nasobeni[magnitude[x+1][y-1]][(myabs(pixel_j) - myabs(pixel_i))]++;
        nasobeni[magnitude[x-1][y  ]][ myabs(pixel_j)]++;
        nasobeni[magnitude[x-1][y+1]][(myabs(pixel_j) - myabs(pixel_i))]++;
        nasobeni[m]                  [myabs(pixel_i)]++;
        //nasobeni[myabs(pixel_i)][m]++;
#endif
        //result |= 1;
    }
    if(direction & DIR_135_180){
        /**
         * Jedna se spise o smer X ale ne o smer Y!
         * ..Y 
         * XMX  
         * Y..
         */
        c1 = magnitude[x][y+1];
        c2 = magnitude[x-1][y+1];
        int c_plus = c2 * myabs(pixel_i)  - c1 * (myabs(pixel_i) - myabs(pixel_j));
        c1 = magnitude[x][y-1];
        c2 = magnitude[x+1][y-1];
        int c_minus = c2 * myabs(pixel_i) - c1 * (myabs(pixel_i) - myabs(pixel_j));
        result |= (c_plus <= (m*myabs(pixel_j))) && (c_minus <= (m*myabs(pixel_j)));
        //result = 1;
#ifdef CHECK_NASOBENI
        nasobeni[magnitude[x]  [y-1]][myabs(pixel_i)]++;
        nasobeni[magnitude[x-1][y-1]][(myabs(pixel_i) - myabs(pixel_j))]++;
        nasobeni[magnitude[x]  [y+1]][myabs(pixel_i)]++;
        nasobeni[magnitude[x+1][y+1]][(myabs(pixel_i) - myabs(pixel_j))]++;
        nasobeni[m]                  [myabs(pixel_j)]++;
        //nasobeni[myabs(pixel_j)][m]++;
#endif
    }//*/
    return result ? 255 : 0;
}

/**
 * Podle smeru, viz predchozi fce zmensime hrany
 */
int non_max_surpression_dumb(int x, int y, int ** magnitude, int ** sobeled_vertical, int ** sobeled_horizontal){
    int result = 0;
    int c1, c2;
    int m = magnitude[x][y];
    int pixel_i = sobeled_horizontal[x][y];
    int pixel_j = sobeled_vertical[x][y];
    int direction = get_direction(pixel_i, pixel_j);
    
    if(direction & DIR_000_045){
        c1 = magnitude[x]  [y-1];
        c2 = magnitude[x-1][y-1];
        int c_plus  = dumb_mult[c2][myabs(pixel_i)]  - dumb_mult[c1][(myabs(pixel_i)-myabs(pixel_j))];
        c1 = magnitude[x]  [y+1];
        c2 = magnitude[x+1][y+1];
        int c_minus = dumb_mult[c2][myabs(pixel_i)]  - dumb_mult[c1][(myabs(pixel_i)-myabs(pixel_j))];
        result |= (c_plus <= (dumb_mult[m][myabs(pixel_j)])) && (c_minus <= (dumb_mult[m][myabs(pixel_j)]));
    }
    //*
    if(direction & DIR_045_090){
        c1 = magnitude[x+1][y];
        c2 = magnitude[x+1][y+1];
        int c_plus =  dumb_mult[c2][myabs(pixel_j)]  - dumb_mult[c1][(myabs(pixel_j)-myabs(pixel_i))];
        c1 = magnitude[x-1][y];
        c2 = magnitude[x-1][y-1];
        int c_minus = dumb_mult[c2][myabs(pixel_j)]  - dumb_mult[c1][(myabs(pixel_j)-myabs(pixel_i))];
        result |= (c_plus <= (dumb_mult[m][myabs(pixel_i)])) && (c_minus <= (dumb_mult[m][myabs(pixel_i)]));
        //result = 1;
    }
    if(direction & DIR_090_135){
        c1 = magnitude[x+1][y];
        c2 = magnitude[x+1][y-1];
        int c_plus =  dumb_mult[c2][myabs(pixel_j)]  - dumb_mult[c1][(myabs(pixel_j)-myabs(pixel_i))];
        c1 = magnitude[x-1][y];
        c2 = magnitude[x-1][y+1];
        int c_minus = dumb_mult[c2][myabs(pixel_j)]  - dumb_mult[c1][(myabs(pixel_j)-myabs(pixel_i))];
        result |= (c_plus <= (dumb_mult[m][myabs(pixel_i)])) && (c_minus <= (dumb_mult[m][myabs(pixel_i)]));
        //result |= 1;
    }
    if(direction & DIR_135_180){
        c1 = magnitude[x][y+1];
        c2 = magnitude[x-1][y+1];
        int c_plus  = dumb_mult[c2][myabs(pixel_i)]  - dumb_mult[c1][(myabs(pixel_i)-myabs(pixel_j))];
        c1 = magnitude[x][y-1];
        c2 = magnitude[x+1][y-1];
        int c_minus = dumb_mult[c2][myabs(pixel_i)]  - dumb_mult[c1][(myabs(pixel_i)-myabs(pixel_j))];
        result |= (c_plus <= (dumb_mult[m][myabs(pixel_j)])) && (c_minus <= (dumb_mult[m][myabs(pixel_j)]));
        //result = 1;
    }//*/

    return result ? 255 : 0;
}

#define DRAW_EDGE    0x01
#define CHECKED_EDGE 0x02
/**
 * Hysterizace
 */
void check_edge(int ** result, int ** magnitude, int ** edges, int low_thold, int high_thold, int x, int y){
    // Vymyslete neco lepsiho
    if(! (result[x][y] & CHECKED_EDGE)){
        result[x][y] |= CHECKED_EDGE;
        if(edges[x+1][y+1] && magnitude[x+1][y+1] <= high_thold && magnitude[x+1][y+1] > low_thold){
            result[x+1][y+1] |= DRAW_EDGE;
            check_edge(result, magnitude, edges, low_thold, high_thold, x+1, y+1);
        }
        if(edges[x-1][y+1] && magnitude[x-1][y+1] <= high_thold && magnitude[x-1][y+1] > low_thold){
            result[x-1][y+1] |= DRAW_EDGE;
            check_edge(result, magnitude, edges, low_thold, high_thold, x-1, y+1);
        }
        if(edges[x-1][y-1] && magnitude[x-1][y-1] <= high_thold && magnitude[x-1][y-1] > low_thold){
            result[x-1][y-1] |= DRAW_EDGE;
            check_edge(result, magnitude, edges, low_thold, high_thold, x-1, y-1);
        }
        if(edges[x+1][y-1] && magnitude[x+1][y-1] <= high_thold && magnitude[x+1][y-1] > low_thold){
            result[x+1][y-1] |= DRAW_EDGE;
            check_edge(result, magnitude, edges, low_thold, high_thold, x+1, y-1);
        }
        if(edges[x][y+1] && magnitude[x][y+1] <= high_thold && magnitude[x][y+1] > low_thold){
            result[x][y+1] |= DRAW_EDGE;
            check_edge(result, magnitude, edges, low_thold, high_thold, x, y+1);
        }
        if(edges[x][y-1] && magnitude[x][y-1] <= high_thold && magnitude[x][y-1] > low_thold){
            result[x][y-1] |= DRAW_EDGE;
            check_edge(result, magnitude, edges, low_thold, high_thold, x, y-1);
        }
        if(edges[x+1][y] && magnitude[x+1][y] <= high_thold && magnitude[x+1][y] > low_thold){
            result[x+1][y] |= DRAW_EDGE;
            check_edge(result, magnitude, edges, low_thold, high_thold, x+1, y);
        }
        if(edges[x][y+1] && magnitude[x][y+1] <= high_thold && magnitude[x][y+1] > low_thold){
            result[x][y+1] |= DRAW_EDGE;
            check_edge(result, magnitude, edges, low_thold, high_thold, x, y+1);
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

int mymax(int a, int b){
    int result = b;
    if (a > b){
        result = a;
    }
    return (result > 255) ? 255 : result;
}
void sobel(int ** img, int ** result, int thold){
    int ** v = convolve_sobel(img);
    int ** h = convolve_sobel_oiahewoifhiewahf(img);
    for(int i = 0; i < img_height; i++){
        for(int j = 0; j < img_width; j++){
            result[i][j] = mymax(myabs(v[i][j]), myabs(h[i][j]));
        }
    }

    save_img(result, "out.png");
}


// TODO coments
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




void load_mult(char* filename);
void load_adder(char* filename);
/**
 * This is mine function
 * @param `argc` What the fuck
 * @param `argv` is this shit?
 */
int main(int argc, char ** argv) {
    std::string img_path = "";
    srand(time(NULL));
    // check input parameters
    if( argc > 1 ) {
        img_path = std::string( argv[1] );
    }
    //printf("LOADIN\n");
    if(argc > 2) load_adder(argv[2]);
    else{
        printf("./sobel [figure] [adder] [trashold value]\n");
        exit(1);
    }
    //exit(1);
    int low_thold = (argc > 3) ? atoi(argv[3]) : 100;
        
    
    

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
    sobel(img, edges, low_thold);
    bazdmeg = cpuTime() - bazdmeg;
    printf("Done %f sekund \n", bazdmeg);
    return 0;
}
////////////////////////////////////////////////////////////

/**
 * Nahraje scitacku do pameti.
 */
void load_adder(char* filename){
    FILE *fh = NULL;
    int  save = 0;
    int  next = 0;
    int a,b,result;
    a = -1;
    char ch;  
    char buffer[50];
    char *buff_ptr = buffer;
    dumb_adder = (int**) malloc(256 * sizeof(int*));
    for(int i = 0; i < 256; i++)
        dumb_adder[i] = (int*) malloc(256 * sizeof(int));
    printf("%s\n", filename);
    if (!(fh = fopen(filename,"r"))) {fprintf(stderr, "File '%s' not found\n", filename); exit(-1); }
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
            case '+':
                save = 1;
                next ++;
                break;
            case '=':
                save = 1;
                next ++;
                break;
            case '[':
                save = 1;
                if(next >=0)
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
                //fprintf(stderr, "f(%d,%d) = %d \n", a, b, result);
                dumb_adder[a][b]=result;
            }
            buff_ptr = buffer;
            
        }
    } while (ch != EOF);
    /*
    for(int i = 0; i < 256; i++){
        for(int j = 0; j < 256; j++){
            printf("f(%d,%d) = %d \n", i, j, dumb_adder[i][j]);
        }
        
    }
    /// */
}
