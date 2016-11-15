/* Soubor:  proj2.c
 * Datum:   21.11.2010 
 * Autor:   Petr Dvoracek, xdvora0n@stud.fit.vutbr.cz
 * Projekt: Projekt c.2
 * Popis:   INTERACNI VYPOCTY
 *           - Hyperbolicky tangens
 *           - Logaritmy
 *           - Vazeny kvadraticky prumer
 *           - Vazeny aritmeticky prumer
 *           - Vypocet integralu v hyperbolickem tangens obdelnikovou metodou
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <math.h>
#include <float.h>
const double e = 2.7182818284590452354; //eulerovo cislo

/* Kody chyb v programu */
enum tecodes
{
   EOK = 0,       // bez chyby
   ECLWRONG,      // chybny prikazovy radek
   ESIGDIGWRONG,  // chybne zadani presnosti
   EAWRONG,       // chybne zadani zakladu logaritmu
   EUNKNOWN       // neznama chyba
};

/* Statove kody programu */
enum tstates
{
   CHELP,         // rtfm 
   CTANH,         // hyperbolicky tangens
   CLOGAX,        // logaritmus
   CWAM,          // vazeny logaritmicky prumer
   CWQM,          // vazeny kvadraticky prumer
   CINTEGRAL
};

/* Chybova hlaseni */
const char *ECODEMSG[] = 
{
   /* EOK */
   "Vse v poradku.\n",
   /* ECLWRONG */
   "Chybne parametry prikazoveho radku!\n",
   /* ESIGIDIGWRONG */
   "Chybne zadani presnosti!\n",
   /* EAWRONG */
   "Chybne zadani zakladu logaritmu [a]!\n",
   /* EUNKOWN */
   "Neznama chyba!\n"
};

/* Help */
const char *HELPMSG =
   "INTERACNI VYPOCTY\n"
   "=================\n"
   "Autor: Petr Dvoracek\n"
   "E-mail: xdvora0n@stud.fit.vutbr.cz\n"
   "Program vypocita hyperbolicky tangens, logaritmus, vazeny kvadraticky\n"
   "prumer a vazeny aritmeticky prumer.\n"
   "Popis parametru:\n"
   "  -h                    zobrazi tuto napovedu\n"
   "  --tanh [sigdig]       hyperbolicky tangens, [sigdig] oznacuje kolik\n"
   "                        cisel bude ve vysledku presnych\n"
   "  --logax [sigdig] [a]  obecny logaritmus, [sigdig] oznacuje kolik cisel\n"
   "                        bude ve vysledku presnych\n"
   "                        [a] znamena zaklad logaritmu\n"
   "  --wam                 vypocita vazeny aritmeticky prumer\n"
   "  --wqm                 vypocita kvadraticky prumer\n"
   "                        uzivatel na vstupu zada [x1] [h1] [x2] [h2] ..\n"
   "                        hodnota h musi byt kladne cislo\n"
   "  --integral [sigdig]   vypocet integralu hyperbolickeho tangensu\n"
   "                        obdelnikovou metodou\n"
   "                        uzivatel na vstup zada bod [a] bod [b] a [interval]\n"
   "                        [interval] musi byt prirozene cislo, a znamena\n"
   "                        na kolik obdelniku ma byt dany interval rozdelen \n"
   "Posledni uprava: 21.listopadu 2010\n"
   "\n";

/* Struktura, ktera obsahuje hodnoty paramtru prikazove radky. */
typedef struct params{
   double eps; // presnost
   double a;   // zaklad logaritmu
   int ecode;  // chybovy kod programu
   int state;  // stavovy kod programu
} TParams;

/* Struktura obsahujici aktualni hodnoty jmenovatele a citatele predavane wam, wqm */
typedef struct averages{
   double SumNumerator;    // citatel
   double SumDenominator;  // jmenovatel
} TAverageValues;

/* Tisk chybovych hlaseni programu */
void printECode(int ecode){
   if (ecode < EOK || ecode > EUNKNOWN)
      ecode = EUNKNOWN;
   fprintf(stderr, "%s", ECODEMSG[ecode]);
}

/* Zpracovani argumentu prikazoveho radku. Vrati to strukture TParams. */
TParams getParams(int argc, char *argv[]){
   // incializace struktury
   TParams result =
   {
      .eps    = 1, // je 1
      .a      = 0,
      .ecode  = EOK,
      .state  = CHELP,
   };
   int sigdig;
   // dva parametry, wam, wqm, help
   if(argc == 2){
      if(strcmp("-h", argv[1]) == 0)
         result.state = CHELP;
      else if(strcmp("--wam", argv[1]) == 0)
         result.state = CWAM;
      else if(strcmp("--wqm", argv[1]) == 0)
         result.state = CWQM;
      else
         result.ecode = ECLWRONG;
   } 

   // tri parametry tanh, integral
   else if(argc == 3){
      if(strcmp("--tanh", argv[1]) == 0)
         result.state = CTANH;
      else if(strcmp("--integral", argv[1]) == 0)
         result.state = CINTEGRAL;
      else
         result.ecode = ECLWRONG;
      if(isdigit(*argv[2])){
         char *endptr = NULL;
         errno = 0;
         sigdig = strtod(argv[2], &endptr);
         if((*endptr != '\0') || (errno == ERANGE) || (sigdig <= 0) || (sigdig > DBL_DIG))
            result.ecode = ESIGDIGWRONG;
      }
      else
         result.ecode = ECLWRONG;
   }

   // ctyri parametry logax
   else if(argc == 4){
      if(strcmp("--logax", argv[1]) == 0){
         result.state  = CLOGAX;
      }
      else
         result.ecode = ECLWRONG;
      // zpracovani cisel
      if(isdigit(*argv[3])){
         char *endptr = NULL;
         errno = 0;
         result.a = strtod(argv[3], &endptr);
         if((*endptr != '\0') || (errno == ERANGE) || (result.a <= 0) || (result.a == 1))
            result.ecode = EAWRONG;
      }
      else
         result.ecode = ECLWRONG;
      if(isdigit(*argv[2])){
         char *endptr = NULL;
         errno = 0;
         sigdig = strtod(argv[2], &endptr);
         if((*endptr != '\0') || (errno == ERANGE) || (sigdig <= 0) || (sigdig > DBL_DIG))
            result.ecode = ESIGDIGWRONG;
      }
      else
         result.ecode = ECLWRONG;
   }
   else
      result.ecode = ECLWRONG;
   
   // spracovani hodnoty sigdig na eps.
   // pow(0.1, sigdig);
   for(int i = 0; i < sigdig; i++)
      result.eps *= 0.1;   
   return result;
}

/* HYPERBOLICKY SINUS 
 * Pouzit vzorec: sinh x = x + x^3/3! + x^5/5! + ...
 * @x   = cislo x
 * @eps = presnost
 * return: vysledek sinh
 */
double msinh(double x, double eps){
   bool zaporne = false;
   if(x < 0){
      x = fabs(x);
      zaporne = true; // prepsal jsem si cislo...
   }
   double result = x, sinnum = x;
   double sindec = 1, i = 1, ti = 1;
   double x2 = x*x;
   while(fabs(ti) > eps){
      i += 2;
      sinnum *= x2;
      sindec *= i*(i-1);
      ti = sinnum / sindec;
      result += ti;
   }
   if(zaporne == true)
      result = -result;
   return result;
}
/* HYPERBOLICKY KOSINUS 
 * Pouzit vzorec: cosh x = 1 + x^2/2! + x^4/4! + ...
 * @x   = cislo x
 * @eps = presnost
 * return: vysledek cosh
 */
double mcosh(double x, double eps){
   if(x < 0)
      x = fabs(x);
   double result = 1, sinnum = 1, ti = 1;
   double i = 0, sindec = 1;
   double x2 = x*x;
   while(fabs(ti) > eps){
      i += 2;
      sinnum *= x2;
      sindec *= i*(i-1);
      ti = sinnum / sindec;
      result += ti;
   }
   return result;
}
/* HYPERBOLICKY TANGENS
 * Funkce vypocita hyperbolicky tangens o presnosti [sigdig] cisel
 * pomoci vzorce: tanh (x) = sinh(x) / cosh(x)
 * Pomocne pouzite funkce: msinh(), mcosh().
 * @x   = cislo
 * @eps = presnost
 * return: vysledek tanh
 */
double mtanh(double x, double eps){
   double result;
   //kvuli deleni!
   eps *= 0.1;
   if(DBL_DIG < x)
      result = 1;
   else if(x < -DBL_DIG)
      result = -1;
   else if(x == 0)
      result = 0;
   else{
      double sinh = msinh(x, eps);
      double cosh = mcosh(x, eps);
      result = sinh / cosh;
   }
   return result;
}
/* LOGARITMUS
 * Fce vypocita logaritmus o zakladu [a] a o presnosti [sigdig] cisel
 * Vypocita se pomocoi vzorcu: log_a x = ln x / ln a
 * ln x = ln y*e*e*e*e*e*... = ln y * e^n = ln y + ln e^n = ln b + n * ln e
 * ln e = 1
 * Pro 0 < x <= 2: ln x =  (x-1)^1 / 1   -  (x-1)^2 / 2   +  (x-1)^3 / 3  - ...
 * pomalu konverguje, udela vice jak 32 opakovani... lepsi je tento vzorecek
 * Pro x > 0: x = 2*((x-1)/(x+1) + (x-1)^3/3(x+1)^3 + (x-1)^5/5(x+1)^5 + ...
 * konverguje velice rychle v intervalu (1; e) 5-15 opakovani
 * viz testing
 * Existujou zde specialni pripady treba x == 0 && a > 1 -> result = -INF etc.
 * 
 * @x   hodnota x
 * @a   zaklad logaritmu a
 * @eps presnost
 * return: vysledek log.
 */
double mln(double x, double eps){
   // x je vetsi nez eulerovo cislo
   double n = 0;
   while(x > e){
      x /= e;
      n++;
   }
   while(x < 1){
      x *= e;
      n--;
   }
   // vysledek + n
   double num = x-1;
   double den = x+1;
   double xnum = (x-1)*(x-1);
   double xden = (x+1)*(x+1);
   double ti = 1;
   double result = 0;
   double i = 1;
   while(fabs(ti) > eps){
      ti = num/(i*den);
      result += ti;
      num *= xnum;
      den *= xden;
      i += 2;
   }
   result *= 2;
   result += n;
   return result;

}

double mlogax(double x, double a, double eps){
   // vseobecne zname vlastnosti logaritmu
   if((x < 0) || isnan(x))
      return NAN;
   if((a < 1) && (x == 0))
      return INFINITY;
   if(x == 0)
      return -INFINITY;
   
   return mln(x, eps)/mln(a, eps);
}
/* VAZENY KVADRATICKY PRUMER
 * Fce vypocita vazeny kvadraticky prumer o presnosti [sigdig] 
 * E = soucet rady
 * x_k = (E(x_i^2 * h_i) / E(h_i) )^0.5
 *
 * @x                 hodnota x
 * @h                 vaha prislusne hodnoty
 * @value             struktura obsahujici tyto hodnoty
 *    .SumNumerator   soucet citatele
 *    .SumDenominator soucet jmenovatele
 * return: vysledek wqm
 */
double wqm(double x, double h, TAverageValues *value){
   double result;
   if(isnan(x) || isnan(h) || isnan(value -> SumNumerator) || isinf(x) || isinf(h)){
      value -> SumNumerator = NAN;
      return NAN;
   }  
   value -> SumNumerator += (x*x*h);
   value -> SumDenominator += h;
   
   result = value -> SumNumerator / value -> SumDenominator;
   result = sqrt(result);
   return result;
}

/* VAZENY ARITMETICKY PRUMER
 * x = E(x_i * h_i) / E(h_i)
 * 
 * @x                 hodnota x
 * @h                 vaha prislusne hodnoty
 * @value             struktura
 *    .SumNumerator   soucet citatele
 *    .SumDenominator soucet jmenovatele
 * return: vysledek vazeneho aritmetickeho prumeru
 */
double wam(double x, double h, TAverageValues *value){
   if(isnan(x) || isnan(value -> SumNumerator) || isinf(x) || isinf(h) || isinf(value -> SumNumerator) || isinf(value -> SumDenominator)){ 
      value -> SumNumerator = NAN;
      return NAN;
   }

   value -> SumNumerator   += (x*h);
   value -> SumDenominator += h;
   
   return value -> SumNumerator / value -> SumDenominator;
}

/* INTEGRAL HYPERBOLICKEHO TANGENS POMOCI OBDELNIKOVE METODY
 * @a        = zacatek inervalu
 * @b        = konec intervalu
 * @eps      = presnost
 * @interval = pocet opakovani mezi body a, b
 */
double integraltanh(double a, double b, int interval, double eps){
   double x;
   if(isnan(a))
      return NAN;
   //drobnost
   if(a > b){
      x = a;
      a = b;
      b = x;
   }
   double height = 0;
   double width = (b-a)/interval; 
   while (a < b){
      height += mtanh(a, eps); 
      a += width;
   }
   return height * width;
}

/* Hlavni program. */
int main(int argc, char *argv[]){
   TParams params = getParams(argc, argv);
   if(params.ecode != EOK){
      printECode(params.ecode);
      return EXIT_FAILURE;
   }
   TAverageValues average = {  // Hodnoty pro prumery
      .SumNumerator   = 0,     // soucet citatele
      .SumDenominator = 0,     // soucet jmenovatele
   };
   double x, h, b, result;  // nactene cislo
   int stdin_err = 1; // chybny vstup

   if(params.state == CHELP){
      printf("%s", HELPMSG);
      return EXIT_SUCCESS;
   }

   while((stdin_err = scanf("%lf", &x)) != EOF){
      if(stdin_err == 0){
         scanf("%*s");
         x = NAN;
      }

      if(params.state == CTANH)
         result = mtanh(x, params.eps);
         
      if(params.state == CLOGAX)
         result = mlogax(x, params.a, params.eps);
      
      if((params.state == CWAM) || (params.state == CWQM) || (params.state == CINTEGRAL)){
         if((stdin_err = scanf("%lf", &h)) == EOF){ 
            x = NAN; 
            printf("%.10e \n", x);
            break; //narazil jsme na EOF.
         }
         if(stdin_err == 0){
            scanf("%*s");
            h = NAN;
         }
         b = h; // pro integral
         if(h < 0)
            h = NAN;
         if(params.state == CWAM)
            result = wam(x, h, &average);
         if(params.state == CWQM)
            result = wqm(x, h, &average);
         if(params.state == CINTEGRAL){
            int interval;
            if((stdin_err = scanf("%d", &interval)) == EOF){
               x = NAN;
               printf("%.10e \n", x);
               break;
            }
            if(stdin_err == 0 || interval <= 0){
               scanf("%*s");
               x = NAN;
            }
            result = integraltanh(x, b, interval, params.eps);
         }
      }
      printf("%.10e \n", result);
   }
   return EXIT_SUCCESS;
}
// log 100 = 2 
