#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>
#include <string>
#include <unistd.h>
#include <getopt.h>
#include <stdint.h>

typedef int* chromosome;
typedef chromosome* pchromosome;

typedef struct {
  //ES parameters
  unsigned long int maxgenerations;
  int popsize;
  int mutations;

  // CGP parameters
  int inputs;
  int outputs;
  int cols;
  int rows;
  int lback;
  int nodeinputs;
  int nodeoutputs;
  int nodefuncs;

  //Aux. parameters
  int trainingvectors;
  fitvaltype maxfitval;
  int lastnodeidx;
  int nodes;
  int nodeios;
  int genes;
  int genespercol;
  int geneoutidx;
  int chromosomesz;
  char datafname[128];

  char* file_chromosome;
  unsigned int seed;
  int max_nodes;
} tparams;

typedef struct { 
 int items; int *values;
} col_validvalues;

#ifndef HAVE_POPCNT
unsigned char lookupbit_tab[256];

void init_lookuptab() 
{
   //builds lookuptable that gives the number of zero bits in 8-bit number
   for (int i = 0; i < 256; i++) {
        int poc1 = 0;
        int zi = ~i;
        for (int j=0; j < 8; j++) {
            poc1 += (zi & 1);
            zi = zi >> 1;
        }
        lookupbit_tab[i] = poc1;
   }
}
#endif

#ifdef HAVE_POPCNT
#define popcnt(val) __builtin_popcountl((unsigned long int) val)
#else
char popcnt(unsigned long int val)
{
  fprintf(stderr, "TODO za domaci ukol\n");
  exit(1);
}
#endif

inline char zeroscount(unsigned long int val) 
{
  #ifdef HAVE_POPCNT
  //this implementation utilizes buildin popcount intruction
  return 64 - __builtin_popcountl(val);
  #else

  //alternative method

//printf("%016lX %d ",val, __builtin_popcountl(val));
  register unsigned char cnt;
  cnt = lookupbit_tab[val & 0xff]; //items 0 => items spravnych
  val >>= 8;
  cnt += lookupbit_tab[val & 0xff];
  val >>= 8;
  cnt += lookupbit_tab[val & 0xff];
  val >>= 8;
  cnt += lookupbit_tab[val & 0xff];
  val >>= 8;
  cnt += lookupbit_tab[val & 0xff];
  val >>= 8;
  cnt += lookupbit_tab[val & 0xff];
  val >>= 8;
  cnt += lookupbit_tab[val & 0xff];
  val >>= 8;
  cnt += lookupbit_tab[val & 0xff];
//printf("%016lX %d\n",val,cnt);
  return cnt;
  #endif
}

extern tparams params;

extern int used_nodes(chromosome p_chrom, int* isused);

//-----------------------------------------------------------------------
//Clone chromosome
//-----------------------------------------------------------------------
#define copy_chromozome(from,to) ((chromosome) memcpy(to, from, params.chromosomesz))

//-----------------------------------------------------------------------
//Print chromosome
//-----------------------------------------------------------------------
void print_chrom(FILE *fout, chromosome p_chrom) 
{
  fprintf(fout, "{%d,%d, %d,%d, %d,%d,%d}", params.inputs, params.outputs, params.cols, params.rows, params.nodeinputs, params.nodeoutputs, params.lback);
  for (int i=0; i<params.geneoutidx; i++) 
  {
     if (i % (params.nodeinputs + params.nodeoutputs) == 0) fprintf(fout,"([%d]",(i/(params.nodeinputs + params.nodeoutputs))+params.inputs);
     fprintf(fout,"%d", *p_chrom++);
     ((i+1) % (params.nodeinputs + params.nodeoutputs) == 0) ? fprintf(fout,")") : fprintf(fout,",");
   }
  fprintf(fout,"(");
    // LITTLE BIG ENDIAN HELL INCOMING"""
  for (int i=params.geneoutidx; i<params.geneoutidx+params.outputs; i++) 
  {
    //if (i > params.geneoutidx) fprintf(fout,",");
    //fprintf(fout,"%d", *p_chrom++);
    *p_chrom++;
  }
  for (int i=params.geneoutidx; i<params.geneoutidx+params.outputs; i++) 
  {
     if (i > params.geneoutidx) fprintf(fout,",");
     fprintf(fout,"%d", * --p_chrom);
  }
  fprintf(fout,")");
  fprintf(fout,"\n");
}

//-----------------------------------------------------------------------
//Load chromosome
//-----------------------------------------------------------------------
inline void load_chrom(chromosome p_chrom){
    FILE *fh = NULL;
    int  i = 0;
    int  state = 0;
    int  next = 0;
    char ch;  
    char buffer[50];
    char *buff_ptr = buffer;
    if (!(fh = fopen(params.file_chromosome,"r"))) {fprintf(stderr, "File '%s' not found\n", params.file_chromosome); exit(-1); }
    do {
        ch = getc(fh);
        next = 0;
        switch(ch){
            case '[':
            case '{':
                state = 1;
                break;
            case '}':
            case ']':
                state = 0;
                break;
            case ',':
            case ')':
                next = 1;
                break;
            case '\n':
                goto PEW_PEW;
                break;
        }
        if(state == 1)
            continue;
        if(next == 0){
            if(isdigit(ch) || ch == '-'){
                *buff_ptr = ch;
                buff_ptr++;
            }
        }else{
            *buff_ptr = 0;
            p_chrom[i] = atoi(buffer);
            //printf("%d\n", p_chrom[i]);
            i++;
            buff_ptr = buffer;
        }
    } while (ch != EOF);
    PEW_PEW: ;
    //LITTLE ENDIAN BIG ENDIAN HELL
    for(int j = 0; j < (params.outputs/2); j++){
      p_chrom[i-j-1] ^= p_chrom[i+j-params.outputs];
      p_chrom[i+j-params.outputs] ^= p_chrom[i-j-1];
      p_chrom[i-j-1] ^= p_chrom[i+j-params.outputs];
    }
    
    
}

//-----------------------------------------------------------------------
//Parse options from command line
//-----------------------------------------------------------------------
void parse_options(int argc, char* argv[])
{
    int i;
    params.file_chromosome = NULL; // Init value
    params.seed = (unsigned) time(NULL);
    params.max_nodes = 0;
    //parse options
    while ((i = getopt_long(argc,argv,"g:r:c:m:l:p:x:s:n:", 0, 0)) != -1) 
    {
        if (i == -1) break;
        switch (i) {
           case 'r': //number of CGP rows
                params.rows = atoi(optarg);
                break;

           case 'c': //number of CGP cols
                params.cols = atoi(optarg);
                break;

           case 'm': //max. number of mutated genes
                params.mutations = atoi(optarg);
                break;

           case 'p': //pop. size
                params.popsize = atoi(optarg);
                break;

           case 'g': //max. number of generations
                params.maxgenerations = atoi(optarg);
                break;

           case 'l': //l-back
                params.lback = atoi(optarg);
                break;

           case 'x': //load chromosome
                params.file_chromosome = optarg;
                break;

           case 's': //load seed
                params.seed = (unsigned) atoi(optarg);
                break;
           case 'n':
                params.max_nodes = atoi(optarg);
                break;
           default:
                printf("uknown argument");
                abort();
        }
    }
    if(params.max_nodes == 0) params.max_nodes = params.cols * params.rows;
    if (optind < argc) 
    {
       //training data file name
       strcpy(params.datafname, argv[optind]);
    }
}

void init_paramsandluts()
{
   extern col_validvalues ** col_values;

   params.nodeios = params.nodeinputs+params.nodeoutputs;
   params.genespercol = params.rows*params.nodeios; 
   params.geneoutidx = params.cols*params.genespercol;
   params.chromosomesz = (params.geneoutidx + params.outputs)*sizeof(int);
   params.nodes = params.rows*params.cols;
   params.lastnodeidx = params.nodes + params.inputs;
   params.genes = params.nodes + params.inputs + params.outputs;
   if (params.lback > params.cols) params.lback = params.cols;
   if (params.popsize > MAX_POPSIZE) params.popsize = MAX_POPSIZE;

   //-----------------------------------------------------------------------
   //Priprava pole moznych hodnot vstupu pro sloupec podle l-back a ostatnich parametru
   //-----------------------------------------------------------------------
   col_values = new col_validvalues *[params.cols];
   for (int i=0; i < params.cols; i++) {
       col_values[i] = new col_validvalues;
 
       int minidx = params.rows*(i-params.lback) + params.inputs;
       if (minidx < params.inputs) minidx = params.inputs; //cgpnodes bloku zacinaji od params.inputs do params.inputs+m*n
       int maxidx = i*params.rows + params.inputs;
 
       col_values[i]->items = params.inputs + 2 + maxidx - minidx;
       col_values[i]->values = new int [col_values[i]->items];
 
       int j=0;
       for (int k=-2; k < params.inputs; k++,j++) //vlozeni indexu vstupu komb. obvodu
           col_values[i]->values[j] = k;
       for (int k=minidx; k < maxidx; k++,j++) //vlozeni indexu moznych vstupu ze sousednich bloku vlevo
           col_values[i]->values[j] = k;
   }
 
   #ifndef HAVE_POPCNT
   init_lookuptab(); 
   #endif
        
}


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

