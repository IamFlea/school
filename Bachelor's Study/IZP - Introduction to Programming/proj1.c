/*
 * Soubor:  projekt1.c
 * Datum:   30.10.2010 21:14
 * Autor:   Petr Dvoracek, xdvora0n@fit.vutbr.cz
 * Projekt: Projekt c.1
 * Popis:   Jednoducha komprese textu.
 */
/*
To do:
* -extra c
* -extra d
* dekomprese fix code
*/
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
const int MAX_OF_REPEAT = 9;
/* Kody chyb v programu */
enum tecodes
{
   EOK = 0,       // bez chyby
   ECLWRONG,      // chybny prikazovy radek
   ENWRONG,       // chybna hodnota N
   EMALLOC,       // nepodarilo se alokovat buffer
   EILLEGALCHAR,  // na vstupu nelegalni znak
   EUNKNOWN       // neznama chyba
};

/* Statove kody programu */
enum tstates
{
   CHELP,         // rtfm 
   CCOMP,         // komprese
   CDECOMP,       // dekomprese
   CEXTRACOMP,    // extra komprese
   CEXTRADECOMP,  // extra dekomprese
};

/* Chybova hlaseni */
const char *ECODEMSG[] =
{
   /* EOK */
   "Vse v poradku.\n",
   /* ECLWRONG */
   "Chybne parametry prikazoveho radku!\n",
   /* ENWRONG */
   "Chybne zadani cisla N!\n",
   /* EMALLOC */
   "Nedostatek pameti!\n",
   /* EILLEGALCHAR */
   "Chyba! Na vstupu se objevil nelegalni znak!\n",
   /* EUNKOWN */
   "Neznama chyba!\n"
};

/* Help */
const char *HELPMSG =
   "Jednoducha komprese textu\n"
   "=========================\n"
   "\n"
   "Autor: Petr Dvoracek\n"
   "E-mail: xdvora0n@fit.vutbr.cz\n"
   "Program provadi jednoduchou kompresi a dekompresi textu. \n"
   "Popis parametru:\n"
   "  -h    zobrazi tuto napovedu\n"
   "  -c N  komprese textu\n"
   "  -d N  dekomprese textu\n"
   "  -ec N extra komprese textu\n"
   "  -ed N extra dekomprese textu\n"
   "\n"
   "extra (de)komprese, dokaze (de)komprimovat text vic nez 9x\n"
   "N predstavuje cele cislo, ktere znamena pocet znaku \n"
   "potrebnych k opakovani bloku v kompresi ci dekompresi\n";

/* Struktura, ktera obsahuje hodnoty paramtru prikazove radky. */
typedef struct params
{
   unsigned int N;   // hodnota N z prikazove radky
   int ecode;        // chybovy kod programu
   int state;        // stavovy kod programu
} TParams;

/* Tisk chybovych hlaseni programu */
void printECode(int ecode)
{
   if (ecode < EOK || ecode > EUNKNOWN)
      ecode = EUNKNOWN;
   fprintf(stderr, "%s", ECODEMSG[ecode]);
}

/* Zpracovani argumentu prikazoveho radku. Vrati to strukture TParams. */
TParams getParams(int argc, char *argv[])
{
   // incializace struktury
   TParams result =
   {
      .N     = 0,
      .ecode = EOK,
      .state = CCOMP,
   };
   // tisk napovedy (dva parametrz)
   if(argc == 2 && strcmp("-h", argv[1]) == 0)
   {
      result.state = CHELP;
   }
   // tri parametry
   else if(argc == 3)
   {  // komprimace, dekomprimace, extra komprimace, extra dekomprimace
      if(strcmp("-c", argv[1]) == 0)
         result.state = CCOMP;
      else if(strcmp("-d", argv[1]) == 0)
         result.state = CDECOMP;
      else if(strcmp("-ec", argv[1]) == 0)
         result.state = CEXTRACOMP;
      else if(strcmp("-ed", argv[1]) == 0)
         result.state = CEXTRADECOMP;
      else
         result.ecode = ECLWRONG;
      // je druhy parametr cislo
      if(isdigit(*argv[2]))
      {
         char *endptr = NULL;
         errno = 0;
         // zjistime zda je cislo cislem
         result.N = strtoul(argv[2], &endptr, 10);
         if((*endptr != '\0') || (errno == ERANGE) || (result.N == 0) || (result.N > UINT_MAX))
            result.ecode = ENWRONG;
      }
      else
         result.ecode = ECLWRONG;
   }
   else
      result.ecode = ECLWRONG;
   return result;
}

/* Funkce naplni buffery.
 * 0 pri uspesnem ukonceni (EOF)
 * 1 pri uspesnem naplneni
 * pri chybovem vstupu vytiskne chybu, a ukonci program
 * @*Buffer = pole
 * @N = velikost pole
 * @j = pocitadlo
 * return vraci jestli se ma jeste opakovat nebo ni
 */
int FillBuffer(char *Buffer, unsigned int N, unsigned int j, int *chyba){
   char c;
   for(unsigned int i = j - N; i < j; i++){
      c = getchar();
      if(isdigit(c)){
         *chyba = EILLEGALCHAR;
         return 1;
      }
      if(c == EOF){
         Buffer[i%N] = EOF; //konec souboru!
         return 1;
      }
      Buffer[i%N] = c;
   }
   return 0; // probehlo uspesne
}

/* Komprese 
 * Alokujeme pole, naplnime pole a budem porovnavat dokud to neni eof.
 * pokud jsou si rovny, nacti dalsi pole, pricti
 * pokud ne, vytiskni cislo a pricti
 * @Buffer1 = alokovany buffer
 * @Buffer2 = alokovany buffer 2
 * @N       = delka opakovani v bloku
 */
int _compress(char *Buffer1, char *Buffer2, unsigned int N){
   int repeat = 1;      // pocet opakovani
   int ecode  = EOK;    // chybovy stav, a ten vraci
   int end    = 0;      // je konec souboru?
   unsigned int j = N;  // circular Buffer 
   char c;              // pomocna promenna

   end = FillBuffer(Buffer1, N, j, &ecode); 
   end = FillBuffer(Buffer2, N, j, &ecode);
   
   while(end == 0){
      while((memcmp(Buffer1, Buffer2, N) == 0) && (repeat < MAX_OF_REPEAT)){
         repeat++;
         end = FillBuffer(Buffer1, N, j, &ecode);
      }

      if(repeat > 1){ //tiskni co je v bufferu
         putchar(repeat + '0');
//         printf("%d", repeat);
         for(unsigned int i = j-N; i < j; i++)
            putchar(Buffer2[i%N]);
         end = FillBuffer(Buffer2, N, j, &ecode);
         repeat = 1;
      }
      else{ //posun buffer
         putchar(Buffer1[j%N]);
         Buffer1[j%N] = Buffer2[j%N];
         c = getchar();

         if(isdigit(c)){
            ecode = EILLEGALCHAR;
            end = 1;
         }
         if(c == EOF){
            Buffer2[j%N] = 0;
            end = 1;
         }
         else
            Buffer2[j%N] = c;
         j++;
      }
   }
   //tiskni zbytek co zbylo v bufferu
   for(unsigned int i = j-N; i < j; i++)
      if(Buffer1[i%N] != EOF)
         putchar(Buffer1[i%N]);
      else
         return ecode;
   for(unsigned int i = j-N; i < j; i++)
      if(Buffer2[i%N] != EOF)
         putchar(Buffer2[i%N]);
      else
         break;
   return ecode;
}
/* komprese */
int compress(unsigned int N){
   int result;
   char *Buffer1, *Buffer2;
   Buffer1 = (char *)malloc(N * sizeof(char) + 1);
   Buffer2 = (char *)malloc(N * sizeof(char) + 1);
   if((Buffer1 == NULL) || (Buffer2 == NULL))
      return EMALLOC;
   result = _compress(Buffer1, Buffer2, N);
   free(Buffer1);
   free(Buffer2);
   return result;
}

/* Dekomprese. N = velikost bloku, k opakovani
 * Nacti znak. Pokud znak je cislo k, nacti dalsi znak(y) a vytiskni cislo-krat.
 * Pokud neni cislo, tak vytiskni znak.
 * Opakuj do te doby nez dosahneme EOF.
 * Buffer = pole //je pouze ve wrapper funkci
 * N      = delka pole v bloku 
 */


int _decompress(unsigned int N, char *Buffer){
   char c;
   unsigned int repeat = 0;
   while((c = getchar()) != EOF){
      if(isdigit(c)){
         repeat = (c - '0'); /*+ (repeat * 10);*/
         //continue;
      }
      
      if(repeat > 0){ // mame opakovani, je cislo
         Buffer[0] = c;
         for(unsigned int i = 1; i < N; i++){  
            c = getchar();
            if((c == EOF) || (isdigit(c)))
               return EILLEGALCHAR;
            Buffer[i] = c;
         }
         for(unsigned int i = 0; i < repeat; i++)
            for(unsigned int j = 0; j < N; j++)
               putchar(Buffer[j]);
         repeat = 0;
      }
      else //neni cislo
         putchar(c);
   }
   return EOK;
}
int decompress(unsigned int N){
   int result;
   char *Buffer;
   Buffer = (char *)malloc(N * sizeof(char) + 1);
   if(Buffer == NULL)
      return EMALLOC;
   result = _decompress(N, Buffer);
   free(Buffer);
   return result;
}

/* Komprese extra (pro dekompresi)
 * Alokujeme pole, naplnime pole a budem porovnavat dokud to neni eof.
 * pokud jsou si rovny, nacti dalsi pole, pricti
 * pokud ne, vytiskni cislo a pricti
 * @Buffer1 = alokovany buffer
 * @Buffer2 = alokovany buffer 2
 * @N       = delka opakovani v bloku
 */
int _ecompress(char *Buffer1, char *Buffer2, unsigned int N){
   int repeat = 1;      // pocet opakovani
   int ecode  = EOK;    // chybovy stav, a ten vraci
   int end    = 0;      // je konec souboru?
   unsigned int j = N;  // circular Buffer 
   char c;              // pomocna promenna

   end = FillBuffer(Buffer1, N, j, &ecode); 
   end = FillBuffer(Buffer2, N, j, &ecode);
   
   while(end == 0){
      while((memcmp(Buffer1, Buffer2, N) == 0)/* && (repeat < MAX_OF_REPEAT)*/){
         repeat++;
         end = FillBuffer(Buffer1, N, j, &ecode);
      }

      if(repeat > 1){ //tiskni co je v bufferu
//         putchar(repeat + '0');
         printf("%d", repeat);
         for(unsigned int i = j-N; i < j; i++)
            putchar(Buffer2[i%N]);
         end = FillBuffer(Buffer2, N, j, &ecode);
         repeat = 1;
      }
      else{ //posun buffer
         putchar(Buffer1[j%N]);
         Buffer1[j%N] = Buffer2[j%N];
         c = getchar();

         if(isdigit(c)){
            ecode = EILLEGALCHAR;
            end = 1;
         }
         if(c == EOF){
            Buffer2[j%N] = 0;
            end = 1;
         }
         else
            Buffer2[j%N] = c;
         j++;
      }
   }
   //tiskni zbytek co zbylo v bufferu
   for(unsigned int i = j-N; i < j; i++)
      if(Buffer1[i%N] != EOF)
         putchar(Buffer1[i%N]);
      else
         return ecode;
   for(unsigned int i = j-N; i < j; i++)
      if(Buffer2[i%N] != EOF)
         putchar(Buffer2[i%N]);
      else
         break;
   return ecode;
}
/* komprese */
int ecompress(unsigned int N){
   int result;
   char *Buffer1, *Buffer2;
   Buffer1 = (char *)malloc(N * sizeof(char) + 1);
   Buffer2 = (char *)malloc(N * sizeof(char) + 1);
   if((Buffer1 == NULL) || (Buffer2 == NULL))
      return EMALLOC;
   result = _ecompress(Buffer1, Buffer2, N);
   free(Buffer1);
   free(Buffer2);
   return result;
}

/* Dekomprese. N = velikost bloku, k opakovani
 * Nacti znak. Pokud znak je cislo k, nacti dalsi znak(y) a vytiskni cislo-krat.
 * Pokud neni cislo, tak vytiskni znak.
 * Opakuj do te doby nez dosahneme EOF.
 * Buffer = pole
 * N      = delka pole v bloku 
 */


int _edecompress(unsigned int N, char *Buffer){
   char c;
   unsigned int repeat = 0;
   while((c = getchar()) != EOF){
      if(isdigit(c)){
         repeat = (c - '0') + (repeat * 10);
         continue;
      }
      
      if(repeat > 0){ // mame opakovani, je cislo
         Buffer[0] = c;
         for(unsigned int i = 1; i < N; i++){  
            c = getchar();
            if((c == EOF) || (isdigit(c)))
               return EILLEGALCHAR;
            Buffer[i] = c;
         }
         for(unsigned int i = 0; i < repeat; i++)
            for(unsigned int j = 0; j < N; j++)
               putchar(Buffer[j]);
         repeat = 0;
      }
      else //neni cislo
         putchar(c);
   }
   return EOK;
}
int edecompress(unsigned int N){
   int result;
   char *Buffer;
   Buffer = (char *)malloc(N * sizeof(char) + 1);
   if(Buffer == NULL)
      return EMALLOC;
   result = _edecompress(N, Buffer);
   free(Buffer);
   return result;
}
/* Hlavni program. */
int main(int argc, char *argv[]){
   int SomeError;
   TParams params = getParams(argc, argv);
   if(params.ecode != EOK) //nejaka chyba
   {
      printECode(params.ecode);
      return EXIT_FAILURE;
   }
   // vse v poradku   
   if(params.state == CHELP){
      printf("%s", HELPMSG);
   }
   if(params.state == CCOMP)
      SomeError = compress(params.N);
         
   if(params.state == CDECOMP)
      SomeError = decompress(params.N);
   
   if(params.state == CEXTRACOMP)
      SomeError = ecompress(params.N);

   if(params.state == CEXTRADECOMP)
      SomeError = edecompress(params.N);
   
   if(SomeError != EOK){
      printECode(SomeError);
      return EXIT_FAILURE;
   }
   return EXIT_SUCCESS;
}
// Neustale zvatlal: "Uiiiiiii, blablabla" a "blebleble" a "hophop hophop", kdyz skakal po jedne noze.
