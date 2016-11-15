/* Soubor:  proj3.c
 * Datum:   5.12.2010
 * Autor:   Petr Dvoracek, xdvora0n@stud.fit.vutbr.cz
 * Projekt: Projekt c.3
 * Popis:   MATICOVE OPERACE
 *           - Testovaci vystup - otesotvani vstupniho souboru, jestli je dany prvek vektorem, matici ci vektorem matic
 *           - Vektorovy soucet
 *           - Skalarni soucin vektoru
 *           - Soucin dvou matic
 *           - Maticovy vyray A*B*A
 *           - Osmismerka - nalezeni vekotru v matici
 *           - Bubliny - spocitani 0 v matici
 *           - Bubliny 3D - spocitani 0 ve vektoru matic
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
/* Chyby programu */
enum tecodes
{
   EOK = 0,
   ECLWRONG,
   EFILE,
   EOPEN,
   EMALLOC,
   EVADD,
   EVSCAL,
   EMMULT,
   EDATA,
   EFALSE,
   EMATRIX,
   EUNKNOWN
};
/* Stavy programu */
enum tstates
{
   CHELP = 0,
   // potreba jednoho souboru
   CTEST,
   CBUBBLES,
   CEXTBUBBLES,
   CMAZE,
   CCAROM,
   // potreba dvou souboru
   CEIGHT,
   CVADD,
   CVSCAL,
   CMMULT,
   CMEXPR,

};
/* Chybova hlaseni */
const char *ECODEMSG[] =
{
   //EOK
   "Alles gutte. \n",
   //ECLWRONG
   "Chybne parametry prikazoveho radku! \n",
   //EFILE
   "Spatny soubor! \n",
   //EOPEN
   "Nepodarilo se otevrit soubor! \n",
   //EMALLOC
   "Nepodarilo se alokovat pamet! \n",
   //EVADD
   "Chyba pri scitani vektru! \n",
   //EVSDAL
   "Chyba pri soucinu vektrou! \n",
   //EMMULT
   "Chyba pri soucinu matic! \n",
   //EDATA
   "Chybne zadani vstupnich dat! \n",
   //EFALSE
   "false \n",
   //EMATRIX
   "Vstupni soubor neni matici! \n",
   //EUNKNOWN
   "Neznama chyba! \n",
};
/* Napoveda */
const char *HELPMSG =
   "MATICOVE OPERACE \n"
   "================ \n"
   "Autor: Petr Dvoracek \n"
   "E-mail: xdvora0n@stud.fit.vutbr.cz \n"
   "Program provadi ruzne maticove operace. \n"
   "Popis parametru: \n"
   "  -h vypise napovedu \n"
   "  --test [file.txt]       overi zda jsou vstupni data ve spravnem formatu\n"
   "  --vadd [a.txt] [b.txt]  secte dva vektory (a+b)\n"
   "  --vscal [a.txt] [b.txt] vypocte skalarni soucin vektru (a*b)\n"
   "  --mmult [A.txt] [B.txt] vypocte soucin dvou matic (A*B)\n"
   "  --mexpr [A.txt] [B.txt] vypocte maticovy vyraz (A*B*A)\n"
   "  --eight [v.txt] [M.txt] vyhleda v matici M vektor v\n"
   "  --bubbles [M.txt]       spocita pocet bublin v matici M\n"
   "  --extbubbles [3DM.txt]  spocita pocet bublin v 3d matici 3DM\n"
   "Posledni uprava: 5. prosince 2010\n";

/* Struktura obsahujici hodnoty parametru prikazove radky. */ 
typedef struct params{
   int ecode;     // chybovy kod programu
   int state;     // stavovy kod programu
   char *file_name1;   // soubor1
   char *file_name2;   // soubor2
} TParams;

void printECode(int ecode)
{
   if(ecode < EOK || ecode > EUNKNOWN)
      ecode = EUNKNOWN;
   fprintf(stderr, "%s", ECODEMSG[ecode]);
}

TParams getParams(int argc, char **argv)
{
   TParams result = 
   {
      .ecode = EOK,
      .state = CHELP,
      .file_name1 = NULL,
      .file_name2 = NULL,
   };

   if(argc == 2)
   {
      if(strcmp("-h", argv[1]) == 0)
         result.state = CHELP;
      else 
         result.ecode = ECLWRONG;
   }
   else if(argc == 3)
   {
      result.file_name1 = argv[2];
      if((strcmp("--test", argv[1])) == 0)
         result.state = CTEST;
      else if((strcmp("--bubbles", argv[1])) == 0)
         result.state = CBUBBLES;
      else if((strcmp("--extbubbles", argv[1])) == 0)
         result.state = CEXTBUBBLES;
      else
         result.ecode = ECLWRONG;
   }
   else if(argc == 4)
   {
      result.file_name1 = argv[2];
      result.file_name2 = argv[3];
      if((strcmp("--vadd", argv[1])) == 0)
         result.state = CVADD;
      else if((strcmp("--vscal", argv[1])) == 0)
         result.state = CVSCAL;
      else if((strcmp("--mmult", argv[1])) == 0)
         result.state = CMMULT;
      else if((strcmp("--mexpr", argv[1])) == 0)
         result.state = CMEXPR;
      else if((strcmp("--eight", argv[1])) == 0)
         result.state = CEIGHT;
      else
         result.ecode = ECLWRONG;
   }
   else
      result.ecode = ECLWRONG;
   return result;
}




/* definujeme matici */
typedef struct matrix 
{
   int x;
   int y;
   int z;
   int *data;
} TMatrix;

/* urci aktualni pozici v matici za pouziti x, y, z*/
int get_index(TMatrix *m, int x, int y, int z)
{
   return (x + m->x * y + m->x * m->y * z);
}
/* wrapper fce na matici... 
cti blbosti ze vstupu a nahraj matici
*/
int _load_matrix(TMatrix *matrix, FILE *f)
{
   int err, n, value;
   int x, y = 1, z = 1;
           
   // vektor matice nebo 3d?
   if((err = fscanf(f, "%d", &n)) <= 0)
      return EFILE;
   if(n <= 0 || n > 3)
      return EFILE;


   //omg.... z, y, x ....
   //to je teda logika...
   if(n == 3)
      if((err = fscanf(f, "%d", &z)) <= 0)
         return EFILE;
    if(n >= 2)
      if((err = fscanf(f, "%d", &y)) <= 0)
         return EFILE;
   // inicializuj x, y, z
   if((err = fscanf(f, "%d", &x)) <= 0)
      return EFILE;
  
   matrix->x = x;
   matrix->y = y;
   matrix->z = z;
   matrix->data = malloc(x*y*z*sizeof(int));
   if(! matrix->data)
      return EMALLOC;
   
   //naladujeme matici 
   for(int i = 0; i < z; i++) 
      for(int j = 0; j < y; j++)
         for(int k = 0; k < x; k++)
            if((err = fscanf(f, "%d", &value)) > 0)
               matrix->data[get_index(matrix, k, j, i)] = value;
            else
               return EFILE;

   return EOK;
}
/* vytvori matici */
int load_matrix(TMatrix *matrix, char *file_name)
{
   int error;
   FILE *f;
   // otevri soubor
   if((f = fopen(file_name, "r")) == NULL)
   {
      perror("proj3: ");
      return EOPEN;
   }
   
   error = _load_matrix(matrix, f);
   fclose(f);
   return error;
}


/* delete matrix */
void destroy_matrix(TMatrix *a, TMatrix *b, TMatrix *c)
{
   if(a->data)
      free(a->data);
   if(b->data)
      free(b->data);
   if(c->data)
      free(c->data);  
}

/* Vytiskne celou matici na vstup */
/* m = matrix, to long for writing... */
void print_matrix(TMatrix *m)
{
   if(m->z != 1)
      printf("3 \n%d %d %d \n", m->z, m->y, m->x);
   else if(m->y != 1)
      printf("2 \n%d %d \n", m->y, m->x);
   else   
      printf("1 \n%d \n", m->x);
   
   for(int i = 0; i < m->z; i++)
   {
      for(int j = 0; j < m->y; j++)
      {
         for(int k = 0; k < m->x; k++)
            printf("%d ", m->data[get_index(m, k, j, i)]);
         printf("\n");
      }
      printf("\n");
   }
}

/*vytvori konecnou matici*/
int make_result_matrix(int x, int y, TMatrix *m)
{
   m->x = x;
   m->y = y;
   m->z = 1;
   m->data = malloc(x*y*1*sizeof(int));
   if(! m->data)
      return EMALLOC;
   return EOK;
}

/*Funkce na zjisteni vektoru ci matice*/
int notvector(TMatrix *a, TMatrix *b)
{
   if((a->y != 1) || (b->y != 1) || (a->z != 1) || (b->z != 1))
      return 1;
   return 0;
}
int notmatrix(TMatrix *a, TMatrix *b)
{
   if((a->z != 1) || (b->z != 1))
      return 1;
   return 0;
}
int notavector(TMatrix *a)
{
   if((a->y != 1) || (a->z != 0))
      return 1;
   return 0;
}
int notamatrix(TMatrix *a)
{
   if(a->z != 1)
      return 1;
   return 0;
}
/*Soucet dvou vektoru*/
int vadd(TMatrix *a, TMatrix *b, TMatrix *c)
{
   if(notvector(a, b))
      return EFALSE;
   int err;
   if(a->x != b->x)
      return EFALSE;
   if((err = make_result_matrix(a->x, 1, c)) != EOK)
      return err;
   for(int i = 0; i < a->x; i++)
      c->data[i] = (a->data[i] + b->data[i]);
   return EOK;
}

/*Soucin dvou vektrou*/
int vscal(TMatrix *a, TMatrix *b)
{
   if(notvector(a, b))
      return EFALSE;
   if(a->x != b->x)
      return EFALSE;
   int result = 0;
   for(int i = 0; i < a->x; i++)
      result += a->data[i] * b->data[i];
   printf("%d \n", result);
   return EOK;
}

/*nasobeni matic*/
int mmult(TMatrix *a, TMatrix *b, TMatrix *c)
{
   if(notmatrix(a, b))
      return EFALSE;
   int err;
   if(a->x != b->y)
      return EFALSE;
   if((err = make_result_matrix(b->x, a->y, c)) != EOK)
      return err;
   int result = 0;
   for(int i = 0; i < c->y; i++)
      for(int j = 0; j < c->x; j++)
      {
         for(int k = 0; k < a->x; k++)
            result += a->data[get_index(a, k, i, 0)] * b->data[get_index(b, j, k, 0)]; 
         c->data[get_index(c, j, i, 0)] = result;
         result = 0;
      }
   return EOK;
}

/* A*B*A  vysledek je ulozeny v druhe matici!! */
int mexpr(TMatrix *a, TMatrix *b, TMatrix *c)
{
   if(notmatrix(a, b))
      return EFALSE;

   int err;
   if(a->y != b->x)
      return EFALSE;
   err = mmult(a, b, c);
   if(err != EOK)
      return err;
   free(b->data);
   return mmult(c, a, b);
}

enum bubble_move
{
   BRIGHT = 0,
   BDOWN,
   BLEFT,
   BUP, 
   BFORWARD,
   BBACK
};

typedef struct bubbles_inc
{
   int x;
   int y;
   int z;
} Tbubble_inc;


const Tbubble_inc bub[] =
{
   {1, 0, 0},   //RIGHT
   {0, 1, 0},   //DOWN
   {-1, 0, 0},  //LEFT
   {0, -1, 0},  //UP
   {0, 0, 1},   //FORWARD
   {0, 0, -1}   //BACK
};
/*zniceni bubliny*/
void bubble_destroy(TMatrix *m, int x, int y)
{
   int rotate = BRIGHT;
   int new_x;
   int new_y;
   Tbubble_inc bubble;
   m->data[get_index(m, x, y, 0)] = 1;
   while(rotate <= BUP)
   {
      bubble = bub[rotate];
      new_x = x + bubble.x;
      new_y = y + bubble.y;
      rotate++;
      // !!
      if((new_x < 0) || (new_x >= m->x))
         continue;
      if((new_y < 0) || (new_y >= m->y)) 
         continue;
      if(m->data[get_index(m, new_x, new_y, 0)] == 0)
         bubble_destroy(m, new_x, new_y);
   }
}
/* BUBLINY */
int bubbles(TMatrix *m)
{
   int bub = 0;
   int x = 0;
   int y = 0;
   while(y < m->y)
   {
      while(x < m->x)
      {
         if(m->data[get_index(m, x, y, 0)] == 0)
         {
            bubble_destroy(m, x, y);
            bub++;
         }
         x++;
      }
      x = 0;
      y++;
   }
//   print_matrix(m);
   printf("%d \n", bub);
   return EOK;
}

void bubble_3d_destroy(TMatrix *m, int x, int y, int z)
{
   int rotate = BRIGHT;
   int new_x;
   int new_y;
   int new_z;
   Tbubble_inc bubble;
   m->data[get_index(m, x, y, z)] = 1;
   while(rotate <= BBACK)
   {
      bubble = bub[rotate];
      new_x = x + bubble.x;
      new_y = y + bubble.y;
      new_z = z + bubble.z;
      rotate++;
      // !!
      if((new_x < 0) || (new_x >= m->x))
         continue;
      if((new_y < 0) || (new_y >= m->y)) 
         continue;
      if((new_z < 0) || (new_z >= m->z)) 
         continue;
      if(m->data[get_index(m, new_x, new_y, new_z)] == 0)
         bubble_3d_destroy(m, new_x, new_y, new_z);
   }
}

/* BUBLINY 3D*/
int bubbles_3d(TMatrix *m)
{
   int bub = 0;
   int x = 0;
   int y = 0;
   int z = 0;
   while(z < m->z)
   {
      while(y < m->y)
      {
         while(x < m->x)
         {
            if(m->data[get_index(m, x, y, z)] == 0)
            {
               bubble_3d_destroy(m, x, y, z);
               bub++;
            }
            x++;
         }
         x = 0;
         y++;
      }
      y = 0;
      z++;
   }
   printf("%d \n", bub);
   return EOK;
}

/* OSMISMERKA */
enum move
{
   MRIGHT = 0,
   MDOWNRIGHT,
   MDOWN,
   MDOWNLEFT,
};

typedef struct eight_inc
{
   int x;
   int y;
} Teight_inc;

const Teight_inc eight[] =
{
   {1, 0},   //RIGHT
   {1, 1},   //DOWN RIGHT
   {0, 1},   //DOWN
   {-1, 1},  //DOWN LEFT
};

/* Funkce na konrolovani smeru. */
bool check(TMatrix *m, int x, int y, TMatrix *v)
{
   Teight_inc eightie;
   int next_x, next_y, i = 0;
   int rotate = MRIGHT;
   while(rotate <= MDOWNLEFT)
   {
   // !! pocatecni podminka
      if(((v->x + x ) > m->x) && (rotate < MDOWN))
      {
         rotate++;
         continue;
      }
      if(((v->x + y ) > m->y) && (rotate > MRIGHT)) 
      {
         rotate++;
         continue;
      }
      if(((v->x - x) < 0) && (rotate == MDOWNLEFT))
      {
         rotate++;
         continue;
      }

      eightie = eight[rotate];
      next_x = x;
      next_y = y;
      i = 0;
      while(m->data[get_index(m, next_x, next_y, 0)] == v->data[i])
      {
         next_x += eightie.x;
         next_y += eightie.y;
         i++;
         if(i == v->x)
            return true;
      }
      i = v->x-1;
      while(m->data[get_index(m, next_x, next_y, 0)] == v->data[i])
      {
         next_x += eightie.x;
         next_y += eightie.y;
         i--;
         if(i == 0)
            return true;
      }
      rotate++;
   }
   return false;
}

/* osmismerka */
int eightways(TMatrix *m, TMatrix *v)
{
   int x = 0;
   int y = 0;
   int vx = v->x;
   int dat;
   while(y < m->y)
   {
      while(x < m->x)
      {
         dat = m->data[get_index(m, x, y, 0)];
         if(dat == v->data[vx-1] || dat == v->data[0])
         {
            if(check(m, x, y, v))
            {
               printf("true\n");
               return EOK;
            }
         }
         x++;
      }
      x = 0;
      y++;
   }
   printf("false\n");
   return EOK;
}

/* Hlavni program */
int main(int argc, char **argv)
{
   TParams params = getParams(argc, argv);
   if(params.ecode != EOK)
   {
      printECode(params.ecode);
      return EXIT_FAILURE;
   }
   if(params.state == CHELP)
   {
      printf("%s", HELPMSG);
      return EXIT_SUCCESS;
   }

   int err = EOK;
   TMatrix matrix_a, matrix_b, matrix_c;
   matrix_a.data = NULL;
   matrix_b.data = NULL;
   matrix_c.data = NULL;
   
   // nahrani prvni matice
   if((err = load_matrix(&matrix_a, params.file_name1)) != EOK)
   {
      printECode(err);
      destroy_matrix(&matrix_a, &matrix_b, &matrix_c);
      return EXIT_FAILURE;
   }
   // nahrani druhe matice
   if(params.state >= CEIGHT)
   {
      if((err = load_matrix(&matrix_b, params.file_name2)) != EOK)
      {
         printECode(err);
         destroy_matrix(&matrix_a, &matrix_b, &matrix_c);
         return EXIT_FAILURE;
      }
   }
   
   // test vstupniho souboru
   if(params.state == CTEST)
      print_matrix(&matrix_a);
   
   if(params.state == CVADD)
      err = vadd(&matrix_a, &matrix_b, &matrix_c);

   if(params.state == CVSCAL)
      err = vscal(&matrix_a, &matrix_b);

   if(params.state == CMMULT)
      err = mmult(&matrix_a, &matrix_b, &matrix_c);

   if(params.state == CMEXPR)
      err = mexpr(&matrix_a, &matrix_b, &matrix_c);
   
   if(params.state == CBUBBLES)
      err = bubbles(&matrix_a);

   if(params.state == CEXTBUBBLES)
      err = bubbles_3d(&matrix_a);

   if(params.state == CEIGHT)
      err = eightways(&matrix_b, &matrix_a);
   
   if(err == EFALSE)
   {
      printf("false\n");
      return EXIT_SUCCESS;
   }

   if(err != EOK)
   {
      printECode(err);
      destroy_matrix(&matrix_a, &matrix_b, &matrix_c);
      return EXIT_FAILURE;
   }

   if(params.state == CMEXPR)
      print_matrix(&matrix_b);
   else if(matrix_c.data)
      print_matrix(&matrix_c);

   destroy_matrix(&matrix_a, &matrix_b, &matrix_c);
   return EXIT_SUCCESS;
}
// odpoved je 42.
