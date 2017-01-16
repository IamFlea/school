// Efficient CGP implementation (cgp_native.cpp)
// ==============================================
// Cartesian genetic programming, introduced by Julian Miller and Peter Thomson 
// in 2000, is a variant of genetic programming where the genotype is represented 
// as a list of integers that are mapped to directed oriented graphs. 
// In order to evaluate the fitness function, the response for each training vector 
// has to be calculated. This step involves the interpretation of a CGP genotype 
// for each vector. To maximize the overall performance, we introduced JIT compilation
// of genotype to *binary machine code*.
//
// In this CGP were added constants 1 and 0 which are usefull for approximation. 
// Also was added a loading of chromosome and user can define seed.
//
// This algorithm (Algorithm - noun - Word used by programmers when they do not want to explain what they did.)
// uses Weighted SHD as fitness value. 
/*===============================================================================
  cgp_native.cpp: Evolutionary design of combinational circuits using CGP
  ===============================================================================
  Copyright (C) 2012 Brno University of Technology,
                     Faculty of Information Technology

  Author(s): Zdenek Vasicek <vasicek AT fit.vutbr.cz>
             Petr Dvoracek <xdvora0n AT stud.fit.vutbr.cz>
  =============================================================================*/
#define COMPILE
#ifdef COMPILE
//#define COMPILE_FITNESS
#endif
#define VASIK_SOLUTION  // POZOR, pokud spustime s jinym seedem! Abychom ziskali stejny vystup je nutno predelat  LITTLE ENDIAN na BIG ENDIAN u vygenerovane populace!!!! Byl jsem prilis liny.
//#define DEBUG
#define HAVE_POPCNT
#define DONOTEVALUATEUNUSEDNODES
#define MAX_POPSIZE 100
typedef long int fitvaltype;
typedef long int nodetype;

#include "cgp.h"
#include "circ.h"
#include "native.h"

pchromosome population[MAX_POPSIZE];  
fitvaltype  fitvalues[MAX_POPSIZE];             
///default parameters
tparams params = {5000000 /*generations*/, 5 /*pop.size*/, 1 /*mut.genes*/, 0, 0, 40 /*cols*/, 1 /*rows*/, 40 /*lback*/, 2, 1, 8 /*functions*/};

nodetype*  nodeoutput; //array of node outputs used for CGP evaluation
int*       isused[MAX_POPSIZE]; //array of marked used nodes for each individual
int        usednodes[MAX_POPSIZE]; //number of used nodes for each individual
int        skip[MAX_POPSIZE]; //skipping evaluation
long int*       data;  //training data
col_validvalues **col_values; //valid gene values for each column 

// CGP mutation operator
// ----------------------------------------------------------------------------
// This function modifies `params.mutations` randomly selected genes of a given genotype. The modification is done in place.
//
// The implementation of the mutation operator has to ensure that the modifications are legal and lead to a valid phenotype.
// This is done using `col_values` array which contains valid values that can occur in each column of CGP array. 
//
// Skip neutral mutations
inline void cgp_mutate(chromosome p_chrom, int * isused, int idx) 
{
    int rnd = rand() % params.mutations;
    int genes = rnd + 1; 

    skip[idx] = 0;
    isused+=params.inputs;
    for (int j = 0; j < genes; j++) 
    {
        int i = rand() % (params.geneoutidx + params.outputs); 
        int col = (int) (i / params.genespercol);

        if (i < params.geneoutidx) 
        { 
           if ((i % params.nodeios) < params.nodeinputs) 
          {  //mutate a gene that encodes connection
              //if (col_values[col]->items > 1) {
                 do { rnd = col_values[col]->values[(rand() % (col_values[col]->items))]; } while (rnd == p_chrom[i]);
                 p_chrom[i] = rnd;
              //}
           } 
           else 
         {  //mutate a gene that encodes function
              //if (params.nodefuncs > 1) {
                 do { rnd = rand() % params.nodefuncs; } while (rnd == p_chrom[i]);
                 p_chrom[i] = rnd;
              //}
           }
           if(isused[i/3])
              skip[idx] = 0;

        } 
        else 
        {  //mutate a primary output
           do { rnd = rand() % (params.lastnodeidx + 2) -2; } while (rnd == p_chrom[i]);
           p_chrom[i] = rnd;
           skip[idx] = 0;
        }
    }
}


// CGP evaluation
// ----------------------------------------------------------------------------
// This function simulates the encoded candidate solution and calculates 
// response for single input vector. The response for each CGP node is 
// stored in array `nodeoutput`. The first `params.inputs` items contain
// input vector.
//
// The interpreter consists of a loop that calculates the response for each CGP 
// node according to the genes of CGP chromosome. The execution of the encoded graph 
// starts from the first node and continues according to the increasing node index. 
// This scheme represents the most efficient 
// implementation as it does not introduce any overhead due to function calling that 
// have to manipulate with stack. In contrast with the recursive approach, all the 
// output values are calculated in one pass. In order to improve the performance, 
// a simple preprocessing step that marks the utilized nodes only can be introduced. 
// Only the marked nodes are subsequently evaluated.  
//
inline void cgp_eval(chromosome p_chrom, int* isused) 
{
    nodetype in1,in2; int fce,i,j;
    nodetype *pnodeout = nodeoutput + params.inputs; 

    isused += params.inputs;

    /// Evaluate the response of each node
    for (i=0; i < params.cols; i++)
        for (j=0; j < params.rows; j++) 
        {
            if (!*isused++) 
            {  //This node is not used, skip it
               p_chrom += 3;
               pnodeout++;
               continue;
            }

            in1 = nodeoutput[*p_chrom++];
            in2 = nodeoutput[*p_chrom++];
            fce = *p_chrom++;
            switch (fce) 
            {
              case 0: *pnodeout++ = in1; break;          //in1
              case 1: *pnodeout++ = ~in1; break;         //not in1
              case 2: *pnodeout++ = in1 & in2; break;    //and
              case 3: *pnodeout++ = in1 | in2; break;    //or
              case 4: *pnodeout++ = in1 ^ in2; break;    //xor
              case 5: *pnodeout++ = ~(in1 & in2); break; //nand
              case 6: *pnodeout++ = ~(in1 | in2); break; //nor
              case 7: *pnodeout++ = ~(in1 ^ in2); break; //xnor
              default: abort();
            }
        }
}


#include "compiler.h"

//#define DEBUG
// Calculate fitness values
// ---------------------------------------------
// This function determines the fitness value of each candidate solution except 
// parental solution `parentidx`. The calculated fitness values are stored 
// in array denoted as `fitvalues`. 
//
// The process of fitness function calculation consists of two phases. 
// In the first phase, the CGP chromosome is translated to machine code that resides
// in the application's address space. The process of translation exhibits linear 
// time complexity with respect to the number of CGP nodes. The second phase involves 
// the calculation of response for the training vectors and fitness value.
// This procedure executes the obtained machine code stored in array `code` for each training vector. 
inline void calc_fitness(int parentidx) 
{
    chromosome p_chrom;
    long int fit, vysl;
    int lastnodeidx = params.lastnodeidx;
    long int vysl2, carry;
    long int *ptraindata = data;

    ///generate native code for each candidate solution
    for (int i=0; i < params.popsize; i++) 
    {
        if (i == parentidx || skip[i]) continue;

        usednodes[i] = used_nodes((chromosome) population[i], isused[i]);
        fitvalues[i] = 0;
        // Preskoc
        if(usednodes[i] > params.max_nodes){ 
            skip[i] = 1;
            fitvalues[i] = params.maxfitval;
            continue;
        }
        #ifdef COMPILE
        #ifdef COMPILE_FITNESS
        cgp_compile(code[i], (chromosome) population[i], isused[i], &ptraindata);
        #else
        cgp_compile(code[i], (chromosome) population[i], isused[i]);
        #endif
        #endif
    }
    
    for (int l=0; l < params.trainingvectors; l++) 
    {
        ///copy the first part of a training vector to the primary inputs
        memcpy(nodeoutput, ptraindata, params.inputs*sizeof(nodetype));
        ptraindata += params.inputs;

        ///determine and check response of each candidate solution
        for (int i=0; i < params.popsize; i++) 
        {   
            if (i == parentidx || skip[i]) continue;
            
            /// 
            #ifdef COMPILE
            #ifdef COMPILE_FITNESS
            fitvalues[i] += ((evalfunc *)(code[i]))();
            //printf("%d, %016lX \n",dbg,dbg); // FUJ DEBUG
            //exit(1);
            #else
            ((evalfunc *)(code[i]))();
            #endif
            #else
            cgp_eval((chromosome) population[i], isused[i]);
            #endif

            #ifndef COMPILE_FITNESS
            #ifndef VASIK_SOLUTION
            //FIXME kompilace fitness je v poradku ale ne tato verze
            //#else
            ///compare the output values against training vector (specification) 
            
            fit = 0; 
            int k;
            // Uloz data
            p_chrom = (chromosome) population[i] + params.geneoutidx;
            lastnodeidx = params.lastnodeidx;
#ifdef DEBUG
            printf("Obtained output\n");
#endif
            for(k = 0; k < params.outputs; k++){
                nodeoutput[k+lastnodeidx] = nodeoutput[(p_chrom[k])];
#ifdef DEBUG
                printf("%d : %016lX (from %d)\n", k, nodeoutput[lastnodeidx+k], (p_chrom[k]));
#endif
            }

            // Interpretace scitacky polovicni
            carry = (nodeoutput[lastnodeidx] & *(ptraindata));
            nodeoutput[lastnodeidx] = nodeoutput[lastnodeidx] ^ *(ptraindata);
#ifdef DEBUG
            printf("A0: %016lX B0: %016lX\n", nodeoutput[lastnodeidx], *ptraindata);
            printf("C0: %016lX S0: %016lX\n", carry, nodeoutput[lastnodeidx]);
            printf("\n");
#endif
            lastnodeidx++;
            // Interpretace scitacky cele
            for (k=1; k < params.outputs; k++, lastnodeidx++) 
            {  
#ifdef DEBUG
              printf("A%d: %016lX B%d: %016lX\n", k, nodeoutput[lastnodeidx], k, (ptraindata[k]));
#endif
                vysl = (nodeoutput[lastnodeidx] ^ (ptraindata [k]));
                vysl2 = (nodeoutput[lastnodeidx] & (ptraindata [k]));
                nodeoutput[lastnodeidx] = vysl ^ carry;
                carry = vysl2 | (vysl & carry);
#ifdef DEBUG
              printf("C%d: %016lX S%d: %016lX\n", k, carry, k, nodeoutput[lastnodeidx]);
              printf("\n");
#endif
            }
            carry= ((ptraindata [k]) ^ carry);
#ifdef DEBUG
            printf("A%d: %016lX B%d: %016lX\n", k, 0, k, *(ptraindata+k));
            printf("C%d: %016lX S%d: %016lX\n", k, 0, k, carry);
            printf("\n");
#endif
            // Ziskani absolutni hodnoty + vypocet vazene sumy
            fit = popcnt(carry);
            lastnodeidx--; 
            k--;
            for (; k >= 0; k--, lastnodeidx--){
                vysl = popcnt(carry ^ nodeoutput[lastnodeidx]) << k;
                fit += vysl;
            }
            fitvalues[i] += fit;
      
#ifdef DEBUG
            printf("Diff: %d [%d]\n", fit, l);
#endif
            #else
            p_chrom = (chromosome) population[i] + params.geneoutidx;
            //printf("%d %016lX\n", p_chrom[0], nodeoutput[p_chrom[0]]);
            //printf("%d %016lX\n", p_chrom[1], nodeoutput[p_chrom[1]]);
            //printf("%d %016lX\n", p_chrom[2], nodeoutput[p_chrom[2]]);
            //printf("%d %016lX\n", p_chrom[3], nodeoutput[p_chrom[3]]);
            //printf("%d outputs\n", params.outputs);
            for (int s=0;s<64;s++) { //32 vektoru spocitano paralelne
                p_chrom = (chromosome) population[i] + params.geneoutidx;
                unsigned long int reqval = 0; 
                unsigned long int outval = 0;

                
                for (int k=0; k < params.outputs; k++) {
                    outval = (outval << 1) + ((nodeoutput[*p_chrom++] >> s) & 1);// << (params.outputs - k - 1);
                    reqval += ((*(ptraindata + params.outputs - k - 1) >> s) & 1) << k;//(params.inputs - k - 1);

                }           
                fitvalues[i] += (outval < reqval) ? reqval - outval : outval - reqval;
        
                int inval = 0;
                for (int k=0; k < params.inputs; k++) {
                    inval += ((*(ptraindata - k - 1) >> s) & 1) << k;
                }

                //if (0) printf("pop%d %2d (%d*%d) out:%2d req:%2d (calc: %2d)\n", i, inval, ((inval) >> 2) & 3,(inval) & 3, outval, reqval, (((inval) >> 2) & 3) * ((inval) & 3));
                //if (0) printf("pop%d %2d (%d*%d) out:%2d req:%2d (calc: %2d)\n", i, inval, ((inval) >> 2) & 7,(inval) & 3, outval, reqval, (((inval) >> 2) & 7) * ((inval) & 3));
                //if (1) printf("pop%d %2d (%d+%d) out:%2d req:%2d (calc: %2d)\n", i, inval, ((inval) >> 3) & 7,(inval) & 7, outval, reqval, (((inval) >> 3) & 7) + ((inval) & 7));
                //if (0) printf("pop%d %2d (%d+%d) out:%2d req:%2d (calc: %2d)\n", i, inval, ((inval) >> 4) & 15,(inval) & 15, outval, reqval, (((inval) >> 4) & 15) + ((inval) & 15));
                
            }
            #endif
            #endif

        }

        ///next training vector
        #ifdef VASIK_SOLUTION
        ptraindata += params.outputs; 
        #else
        ptraindata += params.outputs+1; 
        #endif
        
    }

    //for (int i=0; i < params.popsize; i++) 
    //    {printf("%d: %d\t%016lX \n", i, fitvalues[i],fitvalues[i]);
    //}
        
    //printf("SAD: %d [0]\n", fitvalues[0]);
    //printf("SAD: %d [1]\n", fitvalues[1]);
    //printf("SAD: %d [2]\n", fitvalues[2]);

    //exit(1);
}

// Number of utilized nodes
// ----------------------------------------------------------------------------
// This function calculates the number of nodes that contribute to the 
// resulting phenotype that is encoded by a given genotype. 
//
int used_nodes(chromosome p_chrom, int* isused) 
{
    int in, fce, idx, used = 0;
    int *pchrom;

    memset(isused, 0, params.lastnodeidx*sizeof(int));

    //mark nodes connected to the primary outputs
    pchrom = p_chrom + params.geneoutidx;
    for (int i=0; i < params.outputs; i++) 
        isused[*pchrom++] = 1;

    //go throught the cgp array
    pchrom = p_chrom + params.geneoutidx - 1;
    idx = params.lastnodeidx-1;
    for (int i=params.cols; i > 0; i--) 
    {
        for (int j=params.rows; j > 0; j--,idx--) 
        {
            fce = *pchrom--; //fce
            if (isused[idx] == 1) 
            {  
               // the current node is marked, mark also the connected nodes
               in = *pchrom--; // in2
               if (fce > 1)    // 2-input functions
                  isused[in] = 1;
               in = *pchrom--; // in1
               isused[in] = 1;
               if (fce > 0)
                  used++;
            } else {
               // the current node is not market, skip it
               pchrom -= params.nodeinputs;
            }
        }
    }

    return used;
}


// Main application
// -------------------------------------
// Evolutionary design of combinational circuits using Cartesian 
// Genetic Programming (32-bit i686 implementation).
//
// Usage:
//
//     cgp_native truth_table.txt [-c COLUMNS] [-r ROWS] [-l LBACK] \
//     [-g GENERATIONS] [-p POPSIZE] [-m MUTATEDGENES]
//
int main(int argc, char* argv[])
{
    using namespace std; 
    int blk, bestblk, data_items, parentidx, fittest_idx;
    unsigned long int generation; 
    fitvaltype  bestfitval;

    strcpy(params.datafname, "data.txt"); 
    parse_options(argc, argv);
    ///load training data
    if ((data_items = parsefile(params.datafname, NULL, NULL, NULL)) < 1) 
    { 
       printf("Invalid data\n"); return 0; 
    }
    long int * data_read = new long int[data_items];
    parsefile(params.datafname, data_read, &params.inputs, &params.outputs);
    params.trainingvectors = data_items / (params.inputs+params.outputs); //Spocitani poctu pruchodu pro ohodnoceni
    params.maxfitval = 0;         //Vyitems max. fitness
    for(int i = 0; i < params.outputs; i++) params.maxfitval += (1 << params.inputs) << i;
    printf("Training data:\n   file:%s, items:%d, inputs:%d, outputs:%d\n", params.datafname, data_items, params.inputs, params.outputs);
    // Little endian to big endian for output data
    long int * ptr_read = data_read;
    #ifndef VASIK_SOLUTION
    for(int k = 0; k < params.trainingvectors; k++){
        ptr_read += params.inputs;
        for(int i = 0; i < (params.outputs/2); i++){
          ptr_read[i] ^= ptr_read[params.outputs - i -1];
          ptr_read[params.outputs - i -1] ^= ptr_read[i];
          ptr_read[i] ^= ptr_read[params.outputs - i -1];
        }
        ptr_read += params.outputs;
    }
    data = new long int[data_items + params.trainingvectors]; // Add one output collumn 
    long int * ptr_write = data; 
    long int carry; 
    ptr_read = data_read;
    for(int k = 0; k < params.trainingvectors; k++){
        memcpy(ptr_write, ptr_read, params.inputs*sizeof(long int));
        ptr_read += params.inputs;
        ptr_write += params.inputs;
        *ptr_write = ~(*ptr_read) ^ -1; // HAXX! 0xffffffff...
        carry = ~(*ptr_read) & -1;
        ptr_write++; ptr_read++;
        for(int i = 1; i < params.outputs; i++){
            *ptr_write = ~(*ptr_read) ^ carry;
            //printf("%016lX %016lX %016lX\n", *ptr_read, carry, *ptr_write);
            carry = ~(*ptr_read) & carry;
            //printf("%016lX \n", carry);
            ptr_write++; ptr_read++;
        }
        *ptr_write = carry ^ -1; 
        ptr_write++;
    }
    //printf("Inverted reference output:\n");
    ptr_read = data;
    for(int k = 0; k < params.trainingvectors; k++){
        ptr_read += params.inputs;
        for(int i = 0; i < (params.outputs+1); i++){
          //printf("%d:%016lX [%d]\n", i, ptr_read[i], k);
        }
        ptr_read += params.outputs;

    }
    #else
    data = data_read;
    #endif
    
    init_paramsandluts();
       
    ///memory allocation
    for (int i=0; i < params.popsize; i++) 
    {
        population[i] = new chromosome [params.geneoutidx + params.outputs];
        isused[i] = new int [params.genes];
        #ifdef COMPILE_FITNESS
        code[i] = malloc_aligned(params.cols*params.rows*MAXCODESIZE + 64 + 64*params.outputs);
        #else
        code[i] = malloc_aligned(params.cols*params.rows*MAXCODESIZE + 128);
        #endif
        skip[i] = 0;
    }
    #ifndef VASIK_SOLUTION
    nodeoutput = new nodetype [params.genes + 2 + params.outputs];
    nodeoutput[0] = -1; // Nastavime hodnotu 0xffffffffffffffff
    nodeoutput += 2;
    memset(nodeoutput, 0, sizeof(nodetype) * (params.genes + params.outputs));
    #else
    nodeoutput = new nodetype [params.genes + 2];
    nodeoutput[0] = -1; // Nastavime hodnotu 0xffffffffffffffff
    nodeoutput += 2;
    memset(nodeoutput, 0, sizeof(nodetype) * params.genes);
    
    #endif
    cgp_init_consts();

    srand(params.seed); // time if not defined

    // Initial population and its evaluation
    // -----------------------------------------------------------------------
    // The initial population which consists of `params.popsize` individuals
    // is generated randomly.

    for (int i=0; i < params.popsize; i++) 
    {
        chromosome p_chrom = (chromosome) population[i];
        for (int j=0; j < params.cols*params.rows; j++) 
        {
            int col = (int)(j / params.rows);
            for (int k=0; k < params.nodeinputs; k++)  // node inputs
                *p_chrom++ = col_values[col]->values[(rand() % (col_values[col]->items))];
            *p_chrom++ = rand() % params.nodefuncs; // node function
        }
        for (int j=0; j < params.outputs; j++) // primary outputs
            *p_chrom++ = rand() % params.lastnodeidx;
    #ifdef VASIK_SOLUTION
          //FIXME 
      //      for(int j = 0; j < (params.outputs/2); j++){
      //  p_chrom[-j-1] ^= p_chrom[+j-params.outputs];
      //  p_chrom[+j-params.outputs] ^= p_chrom[-j-1];
      //  p_chrom[-j-1] ^= p_chrom[+j-params.outputs];
      //}
    #endif
    }
    if(params.file_chromosome != NULL)
        load_chrom(copy_chromozome(population[0], population[0]));
    // Evaluate the initial population and find the fittest candidate solution 
    // that becomes parent
    calc_fitness(-1);
    bestfitval = fitvalues[0]; fittest_idx = 0;
    for (int i=1; i < params.popsize; i++) 
        if (fitvalues[i] < bestfitval) 
        {
            bestfitval = fitvalues[i];
            fittest_idx = i;
        }

    printf("CGP parameters:\n   l-back=%d, rows=%d, cols=%d, functions=%d\n", params.lback, params.rows, params.cols, params.nodefuncs);
    printf("   popsize=%d, mutgenes=%d, generations=%d\n", params.popsize, params.mutations, params.maxgenerations);
    #ifdef DONOTEVALUATEUNUSEDNODES
    printf("   evalunused=false, max_nodes=%d\n", params.max_nodes);
    #endif
    printf("Evolutionary run:\n   initial fitness=%lu, best fitness=%lu\n", bestfitval, params.maxfitval);
    double time = cpuTime(); 

    // Evolutionary loop
    // -----------------------------------------------------------------------
    for (int generation = 0; generation < params.maxgenerations; generation++) 
    {
        //printf("  :: %4d   :: \n", generation);
        // ### Step 1 ###
        // Generate offsprings of the fittest individual
        for (int i=0; i < params.popsize;  i++) 
        {
            if (fittest_idx == i) continue;
            //cgp_mutate(copy_chromozome(population[fittest_idx], population[i]));
            cgp_mutate(copy_chromozome(population[fittest_idx], population[i]), isused[fittest_idx], i);
            // We know its fitness, it used nodes and everzthing
            if(skip[i]){ 
              fitvalues[i] = bestfitval;
              memcpy(isused[i], isused[fittest_idx], params.lastnodeidx*sizeof(int));
              usednodes[i] = usednodes[fittest_idx];
            }
        }

        // ### Step 2 ###
        // Evaluate population and calculate fitness values
        calc_fitness(fittest_idx);
        //printf("%d %d %d %d %d \n", fitvalues[0], fitvalues[1], fitvalues[2], fitvalues[3], fitvalues[4]);
        // ### Step 3 ###
        // Check if there is an offspring that should replace parental solution
        int newparidx = fittest_idx;
        //printf("%d\n", fittest_idx);
        for (int i=0; i < params.popsize; i++) 
        { 
            fitvaltype fit = fitvalues[i];
            if ((i == fittest_idx) || (fit > bestfitval)) continue; 

            // current individual is at least of the same quality as its parent
            if (fit > 0) 
            {  //current individual does not 
               if (fit < bestfitval) 
                  printf("Generation: %-8d\tFitness: %d/%d\n",generation, fit, params.maxfitval);
               bestfitval = fit;
               bestblk = params.nodes;
               newparidx = i;
            } 
            else 
            {  //second optimization criterion - the number of utilized nodes
               #ifdef DONOTEVALUATEUNUSEDNODES
               blk = usednodes[i];
               #else
               blk = used_nodes((chromosome) population[i], isused[i]);
               #endif
               if (blk <= bestblk) 
               {
                  if ((blk < bestblk) || (fit > bestfitval))
                     printf("Generation: %-8d\tFitness: %lu/%lu\tNodes: %d\n",generation, fit, params.maxfitval, blk);

                  bestfitval = fit;
                  bestblk = blk;
                  newparidx = i;
               }
            }
            
        }

        fittest_idx = newparidx;
    }

    // End of evolution
    // -----------------------------------------------------------------------
    time = cpuTime() - time;
    printf("Best fitness: %lu/%lu\n",bestfitval,params.maxfitval);
    printf("Best individual: ");
    print_chrom(stdout, (chromosome)population[fittest_idx]);
    printf("Duration: %f Evaluations per sec: %f\n", time, params.maxgenerations*(params.popsize-1) / time);
    
    //save the solution
    FILE *chrfil = fopen("result.chr","wb");
    print_chrom(chrfil, (chromosome)population[fittest_idx]);
    fclose(chrfil);

    return 0;
}
