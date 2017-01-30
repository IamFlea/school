//=======================================================================================
//This file was generated by CGP generator (http://www.fit.vutbr.cz/~vasicek/cgp) 
//=======================================================================================

#if !(defined __LP64__ || defined __LLP64__) || defined _WIN32 && !defined _WIN64
 #error "32-bit architecture is not supported"
#else
 // we are compiling for a 64-bit system
#endif

unsigned char* consts;
void cgp_init_consts()
{
    #define B(val)  *(pconst++)=(val)
    unsigned char* pconst;
    pconst = consts = malloc_aligned(10);
    ///Initialize constants
    B(0x34); B(0x12); B(0x00); B(0x00); B(0x56); B(0x13); B(0x00); B(0x00); B(0xe2); B(0x1f); 
}

#define MAXCODESIZE 24
unsigned char* code[MAX_POPSIZE];
#ifdef COMPILE_FITNESS
typedef long int evalfunc(void);
void cgp_compile(unsigned char* pcode, chromosome p_chrom, int* isused, long int** inputdata)
#else
typedef void evalfunc(void);
void cgp_compile(unsigned char* pcode, chromosome p_chrom, int* isused)
#endif
{
    #define C(val)  *(pcode++)=(val)
    #define CI(val) {*((uint32_t *)(pcode))= (uint32_t)((__PTRDIFF_TYPE__)val); pcode += sizeof(uint32_t);}
    #define CL(val) {*((uint64_t *)(pcode))= (uint64_t)((__PTRDIFF_TYPE__)val); pcode += sizeof(uint64_t);}

    int pnodeout = 0;
    int in1,in2,fce;
    int out = params.inputs - 1;

    /// Save modified registers
    /// %rbx, %rax
    C(0x53);                                          //push   %rbx
    /// Load pointer to node outputs array into ebx
    C(0x48);C(0xbb);CL(nodeoutput);

#ifdef COMPILE_FITNESS
    C(0x56);                                          //push   %rsi
    /// Load *inputdata to rsi
    C(0x48);C(0xb8);CL(inputdata);
    C(0x48);C(0x8b);C(0x30);
#endif
    /// Native code generation
    for (int i=0; i < params.cols; i++)
        for (int j=0; j < params.rows; j++) 
        { 
            in1 = *p_chrom++; in2 = *p_chrom++; fce = *p_chrom++; out++;
            #ifdef DONOTEVALUATEUNUSEDNODES
            if (!isused[out]) continue;
            #endif
            switch (fce)
            {
              case 0:
                  ///nodeoutput[out] = nodeoutput[in1];
                  C(0x48);C(0x8b);C(0x83);CI(8*in1);                //mov    in1(%rbx),%rax
                  C(0x48);C(0x89);C(0x83);CI(8*out);                //mov    %rax,out(%rbx)
                  //code size: 14, stack requirements: 0
                  //registers: %rbx, %rax
                  break;
              case 1:
                  ///nodeoutput[out] = ~nodeoutput[in1];
                  C(0x48);C(0x8b);C(0x83);CI(8*in1);                //mov    in1(%rbx),%rax
                  C(0x48);C(0xf7);C(0xd0);                          //not    %rax
                  C(0x48);C(0x89);C(0x83);CI(8*out);                //mov    %rax,out(%rbx)
                  //code size: 17, stack requirements: 0
                  //registers: %rbx, %rax
                  break;
              case 2:
                  ///nodeoutput[out] = nodeoutput[in1] & nodeoutput[in2];
                  C(0x48);C(0x8b);C(0x83);CI(8*in1);                //mov    in1(%rbx),%rax
                  C(0x48);C(0x23);C(0x83);CI(8*in2);                //and    in2(%rbx),%rax
                  C(0x48);C(0x89);C(0x83);CI(8*out);                //mov    %rax,out(%rbx)
                  //code size: 21, stack requirements: 0
                  //registers: %rbx, %rax
                  break;
              case 3:
                  ///nodeoutput[out] = nodeoutput[in1] | nodeoutput[in2];
                  C(0x48);C(0x8b);C(0x83);CI(8*in1);                //mov    in1(%rbx),%rax
                  C(0x48);C(0x0b);C(0x83);CI(8*in2);                //or     in2(%rbx),%rax
                  C(0x48);C(0x89);C(0x83);CI(8*out);                //mov    %rax,out(%rbx)
                  //code size: 21, stack requirements: 0
                  //registers: %rbx, %rax
                  break;
              case 4:
                  ///nodeoutput[out] = nodeoutput[in1] ^ nodeoutput[in2];
                  C(0x48);C(0x8b);C(0x83);CI(8*in1);                //mov    in1(%rbx),%rax
                  C(0x48);C(0x33);C(0x83);CI(8*in2);                //xor    in2(%rbx),%rax
                  C(0x48);C(0x89);C(0x83);CI(8*out);                //mov    %rax,out(%rbx)
                  //code size: 21, stack requirements: 0
                  //registers: %rbx, %rax
                  break;
              case 5:
                  ///nodeoutput[out] = ~(nodeoutput[in1] & nodeoutput[in2]);
                  C(0x48);C(0x8b);C(0x83);CI(8*in1);                //mov    in1(%rbx),%rax
                  C(0x48);C(0x23);C(0x83);CI(8*in2);                //and    in2(%rbx),%rax
                  C(0x48);C(0xf7);C(0xd0);                          //not    %rax
                  C(0x48);C(0x89);C(0x83);CI(8*out);                //mov    %rax,out(%rbx)
                  //code size: 24, stack requirements: 0
                  //registers: %rbx, %rax
                  break;
              case 6:
                  ///nodeoutput[out] = ~(nodeoutput[in1] | nodeoutput[in2]);
                  C(0x48);C(0x8b);C(0x83);CI(8*in1);                //mov    in1(%rbx),%rax
                  C(0x48);C(0x0b);C(0x83);CI(8*in2);                //or     in2(%rbx),%rax
                  C(0x48);C(0xf7);C(0xd0);                          //not    %rax
                  C(0x48);C(0x89);C(0x83);CI(8*out);                //mov    %rax,out(%rbx)
                  //code size: 24, stack requirements: 0
                  //registers: %rbx, %rax
                  break;
              case 7:
                  ///nodeoutput[out] = ~(nodeoutput[in1] ^ nodeoutput[in2]);
                  C(0x48);C(0x8b);C(0x83);CI(8*in1);                //mov    in1(%rbx),%rax
                  C(0x48);C(0x33);C(0x83);CI(8*in2);                //xor    in2(%rbx),%rax
                  C(0x48);C(0xf7);C(0xd0);                          //not    %rax
                  C(0x48);C(0x89);C(0x83);CI(8*out);                //mov    %rax,out(%rbx)
                  //code size: 24, stack requirements: 0
                  //registers: %rbx, %rax
                  break;
              default:
                  abort();
              }
        } 
#ifdef COMPILE_FITNESS
int i;
        C(0x52);                                              //push   %rdx
        C(0x57);                                              //push   %rdi


/*
0 : FFEEFFAAFFEEFFAA (from 10)
1 : FFFFCCCCFFFFCCCC (from 11)
2 : 0F0F0F0FF0F0F0F0 (from 7)
3 : F0F0F0F000000000 (from 8)
A0: FFEEFFAAFFEEFFAA B0: 55AA55AA55AA55AA
C0: 55AA55AA55AA55AA S0: AA44AA00AA44AA00

A1: FFFFCCCCFFFFCCCC B1: CC993366CC993366
C1: DDBB55EEDDBB55EE S1: 66CCAA0066CCAA00

A2: 0F0F0F0FF0F0F0F0 B2: 3C78F0E1C3870F1E
C2: 1D3B55EFD1B355FE S2: EECCAA00EECCAA00

A3: F0F0F0F000000000 B3: 03070F1F3F7FFFFE
C3: 113355FF113355FE S3: EECCAA00EECCAA00

A4: 0000000000000000 B4: FFFFFFFFFFFFFFFE
C4: 0000000000000000 S4: EECCAA00EECCAA00
// Adder 3+3 bit
*/
        in1 = *p_chrom++;                        // OP     SRC   DST         ; rax | rcx | rdx | rdi | STACK (top is on left)                                 
        C(0x48);C(0x8b);C(0x8b);CI(8*in1);       // mov    in1(%rbx), %rcx   ;     | A0  |     |     |     
        C(0x48);C(0x8b);C(0x16);                 // mov    [%rsi] -> %rdx    ;     | A0  | B0  |     |   
        C(0x48);C(0x89);C(0xC8);                 // mov    %rcx, %rax        ; A0  | A0  | B0  |     |       
        C(0x48);C(0x23);C(0xca);                 // and    %rdx, %rcx        ; A0  | C0  | B0  |     |            // carry = (nodeoutput[lastnodeidx] & *(ptraindata));
        C(0x48);C(0x33);C(0xc2);                 // xor    %rdx, %rax        ; S0  | C0  | B0  |     |            // nodeoutput[lastnodeidx] = nodeoutput[lastnodeidx] ^ *(ptraindata);
        C(0x50);                                 // push   %rax              ; S0  | C0  | B0  |     | [S0]
        C(0x48);C(0x89);C(0xcf);                 // mov    %rcx, %rdi        ; S0  | C0  | B0  | C0  | [S0]
       
    for(i = 1; i < params.outputs; i++) {
        in1 = *p_chrom++;
        C(0x48);C(0x8b);C(0x8b);CI(8*in1);       // mov    in1(%rbx), %rci   ; S0  | A1  | B0  | C0  | [S0]       // nodeoutput[lastnodeidx + i]
        C(0x48);C(0x83);C(0xc6);C(0x08);         // add    %rsi, $8          ; S0  | A1  | B0  | C0  | [S0]       // *training_data++; *rsi++;
        C(0x48);C(0x8b);C(0x16);                 // mov    [%rsi] -> %rdx    ; S0  | A1  | B1  | C0  | [S0]
        C(0x48);C(0x89);C(0xc8);                 // mov    %rcx, %rax        ; A1  | A1  | B1  | C0  | [S0]
        C(0x48);C(0x33);C(0xc2);                 // xor    %rax, %rdx        ; X1  | A1  | B1  | C0  | [S0]       // X1 = A1 XOR B1
        C(0x48);C(0x23);C(0xd1);                 // and    %rdx, %rcx        ; X1  | A1  | ab  | C0  | [S0]       // ab = A1 AND B1 
        C(0x48);C(0x89);C(0xc1);                 // mov    %rax, %rcx        ; X1  | X1  | ab  | C0  | [S0]
        C(0x48);C(0x33);C(0xc7);                 // xor    %rdi, %rax        ; S1  | X1  | ab  | C0  | [S0]       // S1 = (A1 XOR B1) XOR C0
        C(0x50);                                 // push   %rax              ; S1  | X1  | ab  | C0  | [S1, S0]
        C(0x48);C(0x23);C(0xcf);                 // xor    %rdi, %rcx        ; S1  | XC  | ab  | C0  | [S1, S0]   // XC = (A1 XOR B1) XOR C0
        C(0x48);C(0x0b);C(0xca);                 // or     %rcx, %rdx        ; S1  | C1  | ab  | C0  | [S1, S0]   // C1 = ((A1 XOR B1) XOR C0) OR (A1 AND B1)
        C(0x48);C(0x89);C(0xcf);                 // mov    %rcx, %rdi        ; S1  | C1  | ab  | C1  | [S1, S0]
    }
        C(0x48);C(0x83);C(0xc6);C(0x08);         // add    %rsi, $8          ;     | Ci  |     | Ci  | [Si, Si-1] 
        C(0x48);C(0x8b);C(0x16);                 // mov    [%rsi] -> %rdx    ;     | Ci  |  S? |     | [Si, Si-1]
        C(0x48);C(0x33);C(0xca);                 // xor    %rdx, %rcx        ;     | MSB |  S? |     | [Si, Si-1]
        C(0xF3);C(0x48);C(0x0F);C(0xB8);C(0xd1); // popcnt %rdx, %rcx        ;     | MSB | FIT |     | [Si, Si-1]
i--;
    for(; i >= 0; i--){
        C(0x58);                                 // pop    %rax              ; Si  | MSB | FIT |     | [Si-1,...]
        C(0x48);C(0x33);C(0xc1);                 // xor    %rcx, %rax        ; dif | MSB | FIT |     | [Si-1,...]
        C(0xF3);C(0x48);C(0x0F);C(0xB8);C(0xc0); // popcnt %rax, %rax        ; dif | MSB | FIT |     | [Si-1,...]
        C(0x48);C(0xC1);C(0xC0);C(i);            // shl    i, %rax           ; w   | MSB | FIT |     | [Si-1,...]
        C(0x48);C(0x01);C(0xc2);                 // add    %rax,%rdx         ; w   | MSB | FIT |     | [Si-1,...]

            
    }
        //<DEBUG>
        //C(0x58);
        //C(0x5f);C(0x5f);C(0x5f);
        //C(0x48);C(0x89);C(0xf8);  // mov rdi rax
        //C(0x48);C(0x89);C(0xC8);  // mov rcx rax
        C(0x48);C(0x89);C(0xd0);  // mov rdx rax
        C(0x5f);                 //pop    %rdi ; haha poprdi
        C(0x5a);                 //pop    %rdx
        C(0x5e);                 //pop    %rsi ; haha poprsi
        //break;
        //</DEBUG>
#endif
    /// Restore modified registers
    C(0x5b);                                          //pop    %rbx
    /// Return
    C(0xc3);
    // +2 code size
}