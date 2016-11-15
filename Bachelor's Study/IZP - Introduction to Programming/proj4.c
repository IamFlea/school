/* Soubor:  proj4.c
 * Datum:   16.12.2010
 * Autor:   Petr Dvoracek, xdvora0n@stud.fit.vutbr.cz
 * Projekt: Projekt c.4
 * Popis:   CESKE RAZENI
 *          Vytvorit program, ktery bude schopen vybirat z textoveho souboru
 *          retezec znaku. Dale je pozadovano, aby se tiskly retezce do jineho
 *          textoveho souboru.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>
#include <ctype.h>
const int SIZE_ALLOC = 64;
const int CH = 14;

const int ISO_8859_2_FIRST[255] = {
   [(unsigned char) 'A'] = 1, [(unsigned char) 'a'] = 1,  
   [(unsigned char) 'Á'] = 1, [(unsigned char) 'á'] = 1,
   [(unsigned char) 'B'] = 3, [(unsigned char) 'b'] = 3,
   [(unsigned char) 'C'] = 4, [(unsigned char) 'c'] = 4,
   [(unsigned char) 'È'] = 5, [(unsigned char) 'è'] = 5,
   [(unsigned char) 'D'] = 6, [(unsigned char) 'd'] = 6,
   [(unsigned char) 'Ï'] = 6, [(unsigned char) 'ï'] = 6,
   [(unsigned char) 'E'] = 8, [(unsigned char) 'e'] = 8,
   [(unsigned char) 'É'] = 8, [(unsigned char) 'é'] = 8,
   [(unsigned char) 'Ì'] = 8, [(unsigned char) 'ì'] = 8,
   [(unsigned char) 'F'] = 11, [(unsigned char) 'f'] = 11,
   [(unsigned char) 'G'] = 12, [(unsigned char) 'g'] = 12,
   [(unsigned char) 'H'] = 13, [(unsigned char) 'h'] = 13,
   //CH
   [(unsigned char) 'I'] = 15, [(unsigned char) 'i'] = 15,
   [(unsigned char) 'Í'] = 15, [(unsigned char) 'í'] = 15,
   [(unsigned char) 'J'] = 17, [(unsigned char) 'j'] = 17,
   [(unsigned char) 'K'] = 18, [(unsigned char) 'k'] = 18,
   [(unsigned char) 'L'] = 19, [(unsigned char) 'l'] = 19,
   [(unsigned char) 'M'] = 20, [(unsigned char) 'm'] = 20,
   [(unsigned char) 'N'] = 21, [(unsigned char) 'n'] = 21,
   [(unsigned char) 'Ò'] = 21, [(unsigned char) 'ò'] = 21,
   [(unsigned char) 'O'] = 23, [(unsigned char) 'o'] = 23,
   [(unsigned char) 'Ó'] = 23, [(unsigned char) 'ó'] = 23,
   [(unsigned char) 'P'] = 25, [(unsigned char) 'p'] = 25,
   [(unsigned char) 'Q'] = 26, [(unsigned char) 'q'] = 26,
   [(unsigned char) 'R'] = 27, [(unsigned char) 'r'] = 27,
   [(unsigned char) 'Ø'] = 28, [(unsigned char) 'ø'] = 28,
   [(unsigned char) 'S'] = 29, [(unsigned char) 's'] = 29,
   [(unsigned char) '©'] = 30, [(unsigned char) '¹'] = 30,
   [(unsigned char) 'T'] = 31, [(unsigned char) 't'] = 31,
   [(unsigned char) '«'] = 31, [(unsigned char) '»'] = 31,
   [(unsigned char) 'U'] = 33, [(unsigned char) 'u'] = 33,
   [(unsigned char) 'Ú'] = 33, [(unsigned char) 'ú'] = 33,
   [(unsigned char) 'Ù'] = 33, [(unsigned char) 'ù'] = 33,
   [(unsigned char) 'V'] = 36, [(unsigned char) 'v'] = 36,
   [(unsigned char) 'W'] = 37, [(unsigned char) 'w'] = 37,
   [(unsigned char) 'X'] = 38, [(unsigned char) 'x'] = 38,
   [(unsigned char) 'Y'] = 39, [(unsigned char) 'y'] = 39,
   [(unsigned char) 'Ý'] = 39, [(unsigned char) 'ý'] = 39,
   [(unsigned char) 'Z'] = 41, [(unsigned char) 'z'] = 41,
   [(unsigned char) '®'] = 42, [(unsigned char) '¾'] = 42,
   [(unsigned char) '0'] = 43, [(unsigned char) '1'] = 44,
   [(unsigned char) '2'] = 45, [(unsigned char) '3'] = 46,
   [(unsigned char) '4'] = 47, [(unsigned char) '5'] = 48,
   [(unsigned char) '6'] = 49, [(unsigned char) '7'] = 50,
   [(unsigned char) '8'] = 51, [(unsigned char) '9'] = 52,
   [(unsigned char) '.'] = 53, [(unsigned char) ','] = 54,
   [(unsigned char) ';'] = 55, [(unsigned char) '?'] = 56,
   [(unsigned char) '!'] = 57, [(unsigned char) ':'] = 58,
   [(unsigned char) '"'] = 59, [(unsigned char) '-'] = 60,
};

const int ISO_8859_2_SECOND[255] = { 
   [(unsigned char) 'Á'] = 2, [(unsigned char) 'á'] = 2,
   [(unsigned char) 'Ï'] = 7, [(unsigned char) 'ï'] = 7,
   [(unsigned char) 'É'] = 9, [(unsigned char) 'é'] = 9,
   [(unsigned char) 'Ì'] = 10, [(unsigned char) 'ì'] = 10,
   [(unsigned char) 'Í'] = 16, [(unsigned char) 'í'] = 16,
   [(unsigned char) 'Ò'] = 22, [(unsigned char) 'ò'] = 22,
   [(unsigned char) 'Ó'] = 24, [(unsigned char) 'ó'] = 24,
   [(unsigned char) '«'] = 32, [(unsigned char) '»'] = 32,
   [(unsigned char) 'Ú'] = 34, [(unsigned char) 'ú'] = 34,
   [(unsigned char) 'Ù'] = 35, [(unsigned char) 'ù'] = 35,
   [(unsigned char) 'Ý'] = 40, [(unsigned char) 'ý'] = 40,
};


/* Chybove stavy */
enum tecodes
{
   EOK = 0,
   ECLWRONG,
   EFILE,
   EMALLOC,
   EEOF,
   EFILEFORMAT,
   //
   EUNKNOWN
};

/* Jejich hlasky */
const char *ECODEMSG[] =
{
   //EOK
   "Alles gutte. \n",
   //ECLWRONG
   "Spatny prikaz! \n",
   //EFILE
   "Chyba souboru! \n",
   //EMALLOC
   "Nedostatek pameti! \n",
   //EEOF
   "Neocekavany konec souboru! \n",
   //EFILEFORMAT
   "Spatny format souboru! \n",
   
   //EUNKNOWN
   "Chyba pri scitani bitu! \n"
};

/* HELP  */
const char *HELPMSG =
   "CESKE RAZENI \n"
   "============ \n"
   "Autor: Petr Dvoracek \n"
   "E-mail: xdvora0n@stud.fit.vutbr.cz \n"
   "Program vybira z tabulky hodnoty a dane hodnoty seradi abecedne. \n"
   "Popis parametru: \n"
   "  -h               vypise tuhle napovedu \n"
   "* --before [S] [R] seradi hodnoty ze sloupce S, abecedne pred retezcem R\n"
   "* --after [S] [R]  seradi hodnoty ze sloupce S, abecedne po retezci R \n"
   "  --print [S]      vytiskne hodnoty ze sloupce S, nebo ze vsech radku \n"
   "* --sort           seradi hodnoty abecedne\n"
   "Popis spusteni programu: ./proj4 [parametry] vstupni_soubor vystupni_soubor\n"
   "* nepovinne parametry \n" 
   "Posledni uprava: 16. prosince 2010 \n";

/* Funkce, ktera rve chybove hlasky */
void print_ecode(int ecode)
{
   if(ecode < EOK || ecode > EUNKNOWN)
      ecode = EUNKNOWN;
   fprintf(stderr, "%s", ECODEMSG[ecode]);
}
/* stavy programu */
enum tstates
{
   CHELP = 0,
   CNOTHING = 2,
   CBEFORE = -1,
   CAFTER = 1,
   CSORT = 3,
};

/* zpracovani parametru */
typedef struct params{
   int ecode;     //chyba
   int order;     //serazeni
   int sort;      //serazeni
   
   char *column;  //sloupec
   char *string;  //porovnavaci retezec
   char *print;   //tisknuti

   char *input;   //vstupni soubor
   char *output;  //vystupni soubor
} TParams;

/* Toto funkce zatoci s parametry */
TParams get_params(int argc, char **argv)
{
   TParams result = 
   {
      .ecode  = EOK,
      .order  = CNOTHING,
      .sort   = CNOTHING,
      .column = NULL,
      .string = NULL,
      .print  = NULL,
      .input  = NULL,
      .output = NULL
   };
   int n = 1; // na kterem jsem parametru

   if(argc == 2) // JUST HELP
   {
      if(strcmp("-h", argv[1]) == 0)
         result.order = CHELP;
      else
         result.ecode = ECLWRONG;
   }
   else if(argc == 5)
   {  // n = 0; u ktereho argumentu ted jsme 
      if(strcmp("--print", argv[1]) == 0)
         result.print = argv[2];
      else
         result.ecode = ECLWRONG;
   }
   else if(argc == 6)
   {
      while(n < 4)
      {
         if(strcmp("--print", argv[n]) == 0)
         {
            n++;
            result.print = argv[n];
         }
         else if(strcmp("--sort", argv[n]) == 0)
            result.sort = CSORT;
         else
            result.ecode = ECLWRONG;
         n++;
      }
   }
   else if(argc == 8)
   {
      while(n < 6)
      {
         if(strcmp("--print", argv[n]) == 0)
         {
            n++;
            result.print = argv[n];
         }
         else if(strcmp("--before", argv[n]) == 0)
         {
            result.order = CBEFORE;
            n++;
            result.column = argv[n];
            n++;
            result.string = argv[n];
         }
         else if(strcmp("--after", argv[n]) == 0)
         {
            result.order = CAFTER;
            n++;
            result.column = argv[n];
            n++;
            result.string = argv[n];
         }
         else
            result.ecode = ECLWRONG;
         n++;
      }
   }
   else if(argc == 9)
   {
      while(n < 7)
      {
         if(strcmp("--print", argv[n]) == 0)
         {
            n++;
            result.print = argv[n];
         }
         else if(strcmp("--before", argv[n]) == 0)
         {
            result.order = CBEFORE;
            n++;
            result.column = argv[n];
            n++;
            result.string = argv[n];
         }
         else if(strcmp("--after", argv[n]) == 0)
         {
            result.order = CAFTER;
            n++;
            result.column = argv[n];
            n++;
            result.string = argv[n];
         }
         else if(strcmp("--sort", argv[n]) == 0)
            result.sort = CSORT;
         else
            result.ecode = ECLWRONG;
         n++;
      }
   }
   else
      result.ecode = ECLWRONG;
   
   result.input = argv[argc-2]; //Neni to magie!
   result.output = argv[argc-1];
   return result;
}



/* Struktura pro polozku */
typedef struct item TItem;
struct item{
   TItem *previous;  //pointie na predchozi polozku
   char  *string;    //for printing 
   TItem *next;      //pointie na dalsi polozku
};

/* Struktura ukazujici na prvni a posledni polozku seznamu */
typedef struct list{
   TItem *first;
   TItem *last;
} TList;

/* Inicializace seznamu */
void list_init(TList *list)
{
   assert(list != NULL);
   list->first = NULL;
   list->last  = NULL;
}

/* Funkce na mazani prvni polozky ze seznamu */
void list_delete_first(TList *list)
{
   // assert(list != NULL);
   // assert(list->first != NULL);

   TItem *item = list->first;
   list->first = item->next;

   if(item->next != NULL)
      item->next->previous = NULL;

   free(item->string);
   free(item);
}

/* Smaze vsechny polozky ze seznamu */
void list_free(TList *list)
{
   while(list->first != NULL)
      list_delete_first(list);
   list->last = NULL;
}

/* Vlozeni polozky na posledni misto v seznamu */
void list_insert(TList *list, TItem *item)
{
   // assert(list != NULL);
   // assert(item != NULL);
   
   item->previous = list->last;
   list->last = item;
   if(item->previous != NULL)
      item->previous->next = item;
   item->next = NULL;
   if(list->first == NULL)
      list->first = item;
}

/* Prohodi pointery na data */
void list_xchg_values(TItem *src, TItem *dest)
{
   // assert(src != NULL);
   // assert(dest != NULL);
   
   char *tmp;
   tmp = src->string;
   src->string = dest->string;
   dest->string = tmp;
}

/* Vytvor novou polozku */
TItem *item_new(char *print)
{
   TItem *item = malloc(sizeof(TItem));
   if(item != NULL)
      item->string = print;
   return item;
}



/* Moje porovnani retezcu 
 * src zdroj, dst cil
 * return: 
 *   -1 src < dst
 *   0  src = dst
 *   1  src > dst
 */
int mcmp(char *src, char *dst)
{
   int result = 0;
   int i = 0;
   int c1, c2, ch1, ch2;
   while((src[i] != 0) || (dst[i] != 0))
   {
      c1  = ISO_8859_2_FIRST[(unsigned char) src[i]];
      c2  = ISO_8859_2_FIRST[(unsigned char) dst[i]];
      ch1 = ISO_8859_2_SECOND[(unsigned char) src[i]];
      ch2 = ISO_8859_2_SECOND[(unsigned char) dst[i]];
      if(src[i] == 'C' || src[i] == 'c')
         if(src[i + 1] == 'H' || src[i + 1] == 'h')
            c1 = CH;

      if(dst[i] == 'C' || dst[i] == 'c')
         if(dst[i + 1] == 'H' || dst[i + 1] == 'h')
            c2 = CH;
      
      if(c1 > c2)
         return 1;
      else if(c1 < c2)
         return -1;
      if(ch1 > ch2)
         result = 1;
      else if(c1 < c2)
         result = -1;
      i++;
   }
   if(src[i] != 0)
      return 1;
   if(dst[i] != 0)
      return -1;
   return result; // 0
}

/* nacte retezec, ktery pak vraci*/
char *read_str(int *err, char *ch, FILE *f)
{
   int i = 1;
   int c;
   int lenght = SIZE_ALLOC;
   char *dst = malloc(lenght*sizeof(char));
   if(dst == NULL)
   {
      *err = EMALLOC;
      return NULL;
   }
   dst[0] = *ch;
   while((c = getc(f)) != EOF)
   {
      if(isspace(c))
         break;
      if(i == (lenght - 1))
      {
         lenght += SIZE_ALLOC;
         char *new = realloc(dst, lenght*sizeof(char));
         if(new == NULL)
         {
            free(dst);
            *err = EMALLOC;
            return NULL;
         }
         else
            dst = new;
      }
      dst[i] = c;
      i++;
   }
   dst[i] = 0;
   if(c == EOF)
      *err = EEOF;
   *ch = c;
   return dst;
}

/* Funkce na zjisteni cisla u dvou sloupcu, a velikost tabulky na sirku */
int get_columns(int *num_of_cols, int *column1, int *column2, char *s1, char *s2, FILE *f)
{
   assert(s1 != NULL);
   assert(f  != NULL);
   int err = EOK;
   char c;
   int i = 0, n = 0;
   int size1 = strlen(s1);
   int size2 = 0;
   if(s2)
      size2 = strlen(s2);
      
   while((c = fgetc(f)) != EOF && c != '\n')
   {
      if(isspace(c))
         continue;
      i = 0;
      if(c == s1[i])
      {  
         while((c = fgetc(f)) != EOF)
         {
            i++;
            if(isspace(c))
            {
               if(i == size1)
                  *column1 = n;
               break;
            }
            if(c != s1[i])
               break;
         }
         if(s2 && strcmp(s1, s2) == 0)
            *column2 = n;
      }
      else if(s2 && s2[0] == c)
      {
         while((c = fgetc(f)) != EOF)
         {
            i++;
            if(isspace(c))
            {
               if(i == size2)
                  *column2 = n;
               break;
            }
            if(c != s2[i])
               break;
         }
      }
      else
         while((c = fgetc(f)) != EOF)
            if(isspace(c))
               break;

      if(c == '\n')
         break;
      n++;
   }
   if(c == EOF)
      err = EEOF;
   *num_of_cols = n;
   return err;  
}   

/* nacti data do struktury */
int get_items(TList *list, int order, char *string, int n, int col_cmp, int col_print, FILE *f)
{
   TItem *item;
   char c;
   int err = EOK;
   int col = 0;
   char *print = NULL;
   char *compare = NULL;
   while((c = fgetc(f)) != EOF)
   {
      if(isspace(c))
         continue;
      if(col == col_print)
      {
         if((print = read_str(&err, &c, f)) == NULL)
         {  
            if(compare)
               free(compare);
            return err;
         }
      }
      else if(col == col_cmp)
      {
         if((compare = read_str(&err, &c, f)) == NULL)
         {
            if(print)
               free(print);
            return err;
         }
      }
      else
      {
         while((c = fgetc(f)) != EOF)
            if(isspace(c))
               break;
      }
      if(col == n)
      {

         assert(print != NULL);
         col = 0;
         if(col_print == col_cmp)
         {

            if(order == CNOTHING || (mcmp(print, string) == order))
            {
               item = item_new(print);
               if(item == NULL)
               {
                  free(print);
                  return EMALLOC;
               }
               else
                  list_insert(list, item);
            }
            else
               free(print);
         }
         else
         {

            if(order == CNOTHING || (mcmp(compare, string) == order))
            {
               item = item_new(print);

               if(item == NULL)
               {
                  free(print);
                  free(compare);
                  return EMALLOC;
               }
               else
                  list_insert(list, item);
            }
            else
               free(print);
            free(compare);
         }
         compare = NULL;
         print = NULL;
      }
      else
         col++;
   }
   if(c == EOF && col != 0)
      err = EEOF;
   return err;
}

/* nahrani dat do pameti*/
int _list_make(TList *list, int order, char *str, char *column, char *print, FILE *f)
{ 
   int err = EOK;    //chyba
   int n = 0;            //celkovy pocet sloupcu
   int col_column = -1;   //porovnavaci sloupec
   int col_print = -1;    //sloupec urcen pro tisk
   //TItem *item;

   if((err = get_columns(&n, &col_print, &col_column, print, column, f)) != EOK)
      return err;

   if(col_print == -1)
      return EFILEFORMAT;

   if(column && col_column == -1)
      return EFILEFORMAT;
     
   if((err = get_items(list, order, str, n, col_column, col_print, f)) != EOK)
   {
      list_free(list);
      return err;
   }
   return err;
}

/* Otevreni souboru */
int list_make(TList *list, TParams *params)
{
   int err = EOK; 
   FILE *f;
   if((f = fopen(params->input, "r")) == NULL)
   {
      perror("proj4: ");
      return EFILE;
   }
   err = _list_make(list, params->order, params->string, params->column, params->print, f);

   fclose(f);
   return err;
}

/* seradi seznam pomoci selection sort */
void list_sort(TList *list)
{
   TItem *item = list->first;
   TItem *min = list->first;
   
   do {
      do {
         if(mcmp(min->string, item->string) == 1)
            list_xchg_values(min, item);
         item = item->next;
      } while(item);
      item = min->next;
      min = min->next;
   } while(min);
}


/* Tisk seznamu, wrapper*/
void _list_print(TList const *list, FILE *f)
{
   TItem *item = list->first;
   while(1)
   {
      fprintf(f, "%s \n", item->string);
      if(item->next == NULL)
         break;
      item = item->next;
   }
}

/* Tisk seznamu - otevreni souboru na zapis */
int list_print(TList *list, char *out)
{

   FILE *f;
   int err = EOK;
   f = fopen(out, "w");
   if(! f)
   {
      perror("proj4: ");
      err = EFILE;
      return err;
   }
   _list_print(list, f);
   fclose(f);
   return err;
}
/* DO IT! */
int sort(TParams *params)
{
   TList list;
   list_init(&list);
   int err = EOK; 
   if((err = list_make(&list, params)) != EOK)
      return err;
   if(params->sort == CSORT)
      list_sort(&list);
   
   err = list_print(&list, params->output);
   list_free(&list);
   return err;
}

/* Musim se pochvalit, main vypada pekne (ale zbytek kodu ne) */
int main(int argc, char **argv)
{
   int err; // na pripadne chyby
   TParams params = get_params(argc, argv);
   if(params.ecode != EOK)
   {
      print_ecode(params.ecode);
      return EXIT_FAILURE;
   }
   if(params.order == CHELP)
   {
      printf("%s", HELPMSG);
      return EXIT_SUCCESS;
   }
   if((err = sort(&params)) != EOK)
   {
      print_ecode(err);
      return EXIT_FAILURE;
   }
   return EXIT_SUCCESS;
}
// Where are end credits?
