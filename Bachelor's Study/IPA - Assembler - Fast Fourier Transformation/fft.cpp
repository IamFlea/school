/*

  READ: sry for my english.. :)


Algoritmh:
  
  FFT

Task:
  
  Create an FFT algorithm using SSE instructions (use either inline assembler or intrisnsic functions). Try to make
  the function run faster than the reference implementation. Fill your code in the prepared regions below.

Functions:

  CustomInit() is a one-time initialization function called from the constructor of an instance of the CFFT class.

  CustomDeinit() is a one-time initialization function called from the destructor of an instance of the CFFT class.

  FFT(float *re, float *im, int N, int direction) calculates the Fast Fourier Transform of an array of the 
  complex numbers. The real and imaginary parts of the complex numbers are stored separately in two arrays of floats,
  which are being pointed at by the pointers re and im. Both addresses re and im are aligned to 16 bytes. The lenght
  of the array is N and direction equals 1 for the forward FFT and -1 for the inverse FFT. The result of the transform
  is stored in the same place, hence the algorithm should either work in-site or allocate memory itself. Lenght of the
  array will always be power of 2.

Student: 
  Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
*/

/* ladíme..
; DEBUG START			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov [i], eax
   mov [j], ebx
   mov [k], ecx
   mov [i2], edx
   push eax
   push ebx
   push ecx
   push edx
}
for(i = 0; i < N; i++)
	   printf("R: im[%d] = %f, re[%d] = %f\n", i, im[i], i, re[i]);
   printf("\n");
   getchar();
__asm{
   pop edx
   pop ecx
   pop ebx
   pop eax

      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DEBUG END



; DEBUG START			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov [i], eax
   mov [j], ebx
   mov [k], ecx
   mov [i2], edx
   push eax
   push ebx
   push ecx
   push edx
}
printf("%d %d %d %d\n", i, j, k, i2);
__asm{
   pop edx
   pop ecx
   pop ebx
   pop eax





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DEBUG END
   
   
   
   
    ; DEBUG START			
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov [i], eax
   mov [j], ebx
   mov [k], ecx
   mov [i2], edx
   push eax
   push ebx
   push ecx
   push edx
}
for(i = 0; i < N; i++)
	   printf("M: re[%d] = %f, im[%d] = %f\n", i, re[i], i, im[i]);
   printf("\n");
   getchar();
__asm{
   pop edx
   pop ecx
   pop ebx
   pop eax

      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DEBUG END*/  
   
   
   
   
   
   
 
#include "fft.h"

void CFFT::CustomInit()
{
	/*******************************************************************/
	/* TO DO: Insert your one-time initialization code here if needed. */
	/*******************************************************************/

}

void CFFT::CustomDeinit()
{

	
	/*************************************************************/
	/* TO DO: Insert your one-time clean up code here if needed. */
	/*************************************************************/
	

}

#include <math.h>

void CFFT::FFT(float *re, float *im, int N, int direction)
{
   float c1; 
   c1 = -1.0;

__asm{

	mov eax, [N] 
    shr eax, 1  

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; BIT REVERSAL DATA SORTING  ;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
								; INIT REGISTERS
								;
   mov esi, [re]				; esi: Real part forever in this program
   mov edi, [im]				; edi: Imaginary part, forever in this program
								;
   mov eax, [N]					; eax: N
   xor ecx, ecx					; ecx: 0 (counter)
   mov ebx, eax					; ebx: N
   xor edx, edx					; edx: 0 (second counter)
   sub ebx, 1					; ebx: N-1
   shr eax, 1					; eax: N >> 1 (i2 Do not change eax plz)
   jz the_end					; ? N == 1
								;
								; Sorting data in the arrays
for_begin_arr_rev_swap:			;
								; eax is const in this array.
								;
   cmp ecx, edx					; i cmp j
   jge skip_swap				;    >=
								;  
   ;Need two registers.			;
   push eax						;
   push ebx						;
								; ...real part.
   mov eax, [esi + ecx*4]		;
   mov ebx, [esi + edx*4]		;
   mov [esi + edx*4], eax		;
   mov [esi + ecx*4], ebx		;
								; ....imaginary part .
   mov eax, [edi + ecx*4]		;
   mov ebx, [edi + edx*4]		;
   mov [edi + edx*4], eax		;
   mov [edi + ecx*4], ebx		;
								;
   pop ebx						;
   pop eax						;
skip_swap:						;
								;
   push ebx						; ebx: pushed
   mov ebx, eax					; ebx: k: N/2, eax == const
   cmp edx, ebx					; j cmp k
   jl swap_bits_in_index_end	;    >   //skip it
swap_bits_in_index:				;
   sub edx, ebx					; edx: j: j - k
   shr ebx, 1					; ebx: k: k/2
   cmp edx, ebx					; j cmp k
   jge swap_bits_in_index		;    >=
swap_bits_in_index_end:			;
   add edx, ebx					; edx: j + k
   pop ebx						; ebx: popped
								; 
								; Loop condition (i < N-2) then jump
   add ecx, 1					;
   cmp ecx, ebx					;
   jl for_begin_arr_rev_swap	;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BIT REVERSAL DATA SORT

   




	; Inverse || forward fft?
   
   mov ecx, [direction]         
   cmp ecx, 1
   je forward_direction	



   


   ;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;    INVERSE FREQUENCY   ;
   ;    DOMAIN SYNTHESIS    ; Init registers
   ;;;;;;;;;;;;;;;;;;;;;;;;;; eax: N >> 1 (constant from BIT REVERSAL)
							; edi, esi: im, re pointers
   mov      ecx,  eax		; ecx: N >> 1 (counter in da main loop)
   movss    xmm7, [c1]		; xmm7: [a,  b,  c,  c1]
   xorps    xmm4, xmm4		; xmm4
   mov      eax, 1			; eax: l2		// 1
   shr      ecx, 1			; ecx: N >> 2
   jz	inv_one_butterfly   ; 
   movsldup	xmm7, xmm7		; xmm7: [b,  b,  c1, c1]
   movss    xmm7, xmm4		; xmm4: [-,  -,  c1, c2] 
   shr      ecx, 1			; ecx: N >> 3
   jz   inv_two_butterflies ;
   mov		edx,  [N]		; edx: length
							;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;		 MAIN LOOP			;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ; MAIN LOOP
loop_log2_n_stage_inv:			; =========
								;
   pcmpeqw xmm5,xmm5			; const 1
   pslld xmm5,25				;
   psrld xmm5,2					;
   xorps	xmm6, xmm6			; xmm6 = [0, 0, 0, 0] // u2
   push ecx						; save it.. 
   ;shufps   xmm5, xmm5, 0x00	; xmm5 = [1, 1, 1, 1] // op_code 0x00 is written in the CODE instruction. Not in DATA!
								;
   mov ebx, eax					; eax
   shl eax, 1					; eax: <<= 1
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	SIZE OF BUTTERFLY
									;   =================
   xor ecx, ecx						;                  ///                BUTTERFLY SIZE = 2^ecx
for_sub_dft_inv:						; ecx: J counter   //   1           2                4
									;                  // .-/\-. .-----/\-----. .--------/\--------.
									; ebx: counter+ebx //     1 |		     2 |                  4 | 
									;       (index)    //     2 |            4 |                  8 |
									;		           // 1 + 0 | 2 + 0; 2 + 1 | 4+0; 4+1; 4+2; 4+3 | etc..
   push     ebx						; ebx: push        // Save it cuz of loop condition
   push     ecx						; ecx: push        // save it cuz butterfly loop will fuck it up  
	add ebx, ecx					;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	BUTTERFLY LOOP
   ;              ____________           ;   ==============
   ;    /~\     _/  asm vs me|           ;
   ;   ( oo|  <      42 : 0  /           ; eax = NEXT BUTTER FLY... SHIFT IN THE ARRAY (ON FIRST MAIN LOOP BY 2, ON SECOND MAIN LOOP BY 4....)
   ;   _\=/_   |____________/            ; ebx = eax >> 1 (Half of the shift) (1 2 4)
   ;  /     \                           ; ecx = INDEX I, is defined by J
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; edx = N 
										;
for_butterfly_inv:						; REAL PART - LEFT WING
										;
   movss    xmm0, [esi + ebx*4]			; xmm0: [ -,  -,  -, Ra]
   shufps 	xmm0, xmm0, 0x93			; xmm0: [ -,  -, Ra, - ]
   add      ebx, eax					; ebx:  s1
   movss    xmm4, [esi + ebx*4]			; xmm0: [ -,  -, Ra, Rb]
   movss    xmm0, xmm4					;
   add      ebx, eax					; ebx:  s2
   shufps	xmm0, xmm0, 0x93			; xmm0: [ -, Ra, Rb, - ]
   movss    xmm4, [esi + ebx*4]			; xmm0: [ -, Ra, Rb, Rc]
   movss    xmm0, xmm4					;
   add      ebx, eax					; ebx:  s3
   shufps	xmm0, xmm0, 0x93			; xmm0: [Ra, Rb, Rc, - ]
   movss    xmm4, [esi + ebx*4]			; xmm0: [Ra, Rb, Rc, Rd]
   movss    xmm0, xmm4                  ;
   sub      ebx, eax					; ebx:  s2
   movaps   xmm1, xmm5					; xmm1: [u1]
   sub      ebx, eax					; ebx:  s1
   mulps    xmm1, xmm0					; xmm1: [Ra*u1, Rb*u1, Rc*u1, Rd*u1]
   sub      ebx, eax					; ebx:  s0
   mulps    xmm0, xmm6					; xmm0: [Ra*u2, Rb*u2, Rc*u2, Rd*u2]
										;
										; IMAGINARY PART - LEFT WING
										;
   movss    xmm2, [edi + ebx*4]			; xmm2: [ -,  -,  -, Ia]
   shufps	xmm2, xmm2, 0x93			; xmm2: [ -,  -, Ia, - ]
   add      ebx, eax					; ebx:  s1
   movss    xmm4, [edi + ebx*4]			; xmm2: [ -,  -, Ia, Ib]
   movss    xmm2, xmm4					;
   shufps	xmm2, xmm2, 0x93			; xmm2: [ -, Ia, Ib, - ]
   add      ebx, eax					; ebx:  s2
   movss    xmm4, [edi + ebx*4]			; xmm2: [ -, Ia, Ib, Ic]
   movss    xmm2, xmm4					;
   shufps	xmm2, xmm2, 0x93			; xmm2: [Ia, Ib, Ic, - ]
   add      ebx, eax					; ebx:  s3, keep it!
   movss    xmm4, [edi + ebx*4]			; xmm2: [Ia, Ib, Ic, Id]
   movss    xmm2, xmm4					;
   movaps   xmm3, xmm5					; xmm3: [u1]
   mulps    xmm3, xmm2					; xmm3: [Ia*u1, Ib*u1, Ic*u1, Id*u1]
   mulps    xmm2, xmm6					; xmm2: [Ia*u2, Ib*u2, Ic*u2, Id*u2]
										;
										; BUTTERFLY BODY :) 
										;
   addps    xmm0, xmm3					; xmm0: [Ia*u1, Ib*u1, Ic*u1, Id*u1] + [Ra*u2, Rb*u2, Rc*u2, Rd*u2] < t2
   subps    xmm1, xmm2					; xmm1: [Ra*u1, Rb*u1, Rc*u1, Rd*u1] - [Ia*u2, Ib*u2, Ic*u2, Id*u2] < t1
										;
										; REAL PART - RIGHT WING
										;
   movss    xmm2, [esi + ecx*4]			; xmm2: [ -,  -,  -, RA]
   shufps	xmm2, xmm2, 0x93			; xmm2: [ -,  -, RA, - ]
   add      ecx, eax					; ecx: s1
   movss    xmm4, [esi + ecx*4]			; xmm2: [ -,  -, RA, RB]
   movss    xmm2, xmm4					;
   shufps	xmm2, xmm2, 0x93			; xmm2: [ -, RA, RB, - ]
   add      ecx, eax					; ecx: s2
   movss    xmm4, [esi + ecx*4]			; xmm2: [ -, RA, RB, RC]
   movss    xmm2, xmm4					;
   shufps	xmm2, xmm2, 0x93			; xmm2: [RA, RB, RC, - ]
   add      ecx, eax					; ecx: s3
   movss    xmm4, [esi + ecx*4]			; xmm2: [RA, RB, RC, RD]
   movss    xmm2, xmm4					;
   sub      ecx, eax					; ecx: s2
   movaps   xmm4, xmm2					; xmm4: [RA, RB, RC, RD]
   sub      ecx, eax					; ecx: s1
										;
   subps    xmm4, xmm1					; xmm4: [RA, RB, RC, RD] - t1
   sub      ecx, eax					; ecx: s0
										;
										; SAVE REAL PART - LEFT WING
										;
										; ebx: s3
   movss    [esi + ebx*4], xmm4			; result: Rd 
   sub      ebx, eax					; ebx: s2
   shufps   xmm4, xmm4, 0x39			; xmm4: [Rd, Ra, Rb, Rc]
   movss    [esi + ebx*4], xmm4			; result: Rc
   sub      ebx, eax					; ebx: s1
   shufps   xmm4, xmm4, 0x39			; xmm4: [Rc, Rd, Ra, Rb]
   movss    [esi + ebx*4], xmm4			; result: Rb
   sub      ebx, eax					; ebx: s0
   shufps   xmm4, xmm4, 0x39			; xmm4: [Rb, Rc, Rd, Ra]
   movss    [esi + ebx*4], xmm4			; result: Ra
										;
										; IMAGINARY PART - RIGHT WING
										;
   movss    xmm3, [edi + ecx*4]			; xmm3: [ -,  -,  -, IA]
   shufps	xmm3, xmm3, 0x93			; xmm3: [ -,  -, IA, - ]
   add      ecx, eax					; ecx: s1
   movss    xmm4, [edi + ecx*4]			; xmm3: [ -,  -, IA, IB]
   movss    xmm3, xmm4					;
   shufps	xmm3, xmm3, 0x93			; xmm3: [ -, IA, IB, - ]
   add      ecx, eax					; ecx: s2
   movss    xmm4, [edi + ecx*4]			; xmm3: [ -, IA, IB, IC]
   movss    xmm3, xmm4					;
   shufps	xmm3, xmm3, 0x93			; xmm3: [IA, IB, IC, - ]
   add      ecx, eax					; ecx: s3
   movss    xmm4, [edi + ecx*4]			; xmm3: [IA, IB, IC, ID]
   movss    xmm3, xmm4					;
										;
   movaps   xmm4, xmm3					; xmm4: [IA, IB, IC, ID]
   subps    xmm4, xmm0					; xmm4: [IA, IB, IC, ID] - t2
										;
   										; SAVE IMAGINARY PART - LEFT WING
										;
										; ebx: s0
   shufps   xmm4, xmm4, 0x93			; xmm4: [Ib, Ic, Id, Ia]
   movss    [edi + ebx*4], xmm4			; result: Ia	
   add      ebx, eax					; ebx: s1
   shufps   xmm4, xmm4, 0x93			; xmm4: [Ic, Id, Ia, Ib]
   movss    [edi + ebx*4], xmm4			; result: Ib
   add      ebx, eax					; ebx: s2
   shufps   xmm4, xmm4, 0x93			; xmm4: [Id, Ia, Ib, Ic]
   movss    [edi + ebx*4], xmm4		    ; result: Ic
   add      ebx, eax					; ebx: s3
   shufps   xmm4, xmm4, 0x93			; xmm4: [Ia, Ib, Ic, Id]
   movss    [edi + ebx*4], xmm4			; result: Id
										; 
   addps    xmm2, xmm1					; xmm2: [RA, RB, RC, RD] + t1 
   addps    xmm3, xmm0					; xmm3: [IA, IB, IC, ID] + t2
										; 
										; SAVE IMAGINARY PART - RIGHT WING
										;
										; ecx: s3
   movss    [edi + ecx*4], xmm3			; result: ID 
   sub      ecx, eax					; ecx: s2
   shufps   xmm3, xmm3, 0x39			; xmm3: [ID, IA, IB, IC]
   movss    [edi + ecx*4], xmm3			; result: IC
   sub      ecx, eax					; ecx: s1
   shufps   xmm3, xmm3, 0x39			; xmm3: [IC, ID, IA, IB]
   movss    [edi + ecx*4], xmm3			; result: IB
   sub      ecx, eax					; ecx: s0
   shufps   xmm3, xmm3, 0x39			; xmm3: [IB, IC, ID, IA]
   movss    [edi + ecx*4], xmm3			; result: IA
										;  
										; SAVE REAL PART - RIGHT WING
										;  
   shufps   xmm2, xmm2, 0x93			; xmm2: [RA, RC, RB, RD]
   movss    [esi + ecx*4], xmm2			; result: RA
   add		ecx, eax					; ecx: s1
   shufps   xmm2, xmm2, 0x93			; xmm2: [RC, RD, RA, RB]
   movss    [esi + ecx*4], xmm2			; result: RB
   add		ecx, eax					; ecx: s2
   shufps   xmm2, xmm2, 0x93			; xmm2: [RD, RA, RB, RC]
   movss    [esi + ecx*4], xmm2			; result: RC
   add		ecx, eax					; ecx: s3
   shufps   xmm2, xmm2, 0x93			; xmm2: [RA, RB, RC, RD]
   movss    [esi + ecx*4], xmm2			; result: RD
										;
										; NEXT BUTTERFLY CONDITION
										;  
										; eax: is constant in this loop
   add ecx, eax							; ecx: s4		
   add ebx, eax							; ebx: s4
   cmp ecx, edx							; i < N?
   jl for_butterfly_inv					;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	END OF BUTTERFLY LOOP
   pop ecx							; xmm7: [c1, c2, c1, N]
   mulps    xmm5, xmm7				; xmm5: [ -,  -, u1c1, u1c2]
   mulps    xmm6, xmm7				; xmm6: [ -,  -, u2c1, u2c2]
   shufps   xmm6, xmm6, 0x01		; xmm6: [22, 22, u2c2, u2c1]
   movaps   xmm4, xmm6				; xmm4: [ -,  -, u2c2, u2c1]
   addps    xmm4, xmm5				; xmm4: [ -,  -,  -, OK]
   shufps   xmm4, xmm4, 0x00		; xmm4: [U2, U2, U2, U2] !! 
   subps    xmm5, xmm6				; xmm6: [ -,  -, OK,  -]
   shufps   xmm5, xmm5, 0x55		; xmm6: [U1, U1, U1, U1]
									; but they are in wrong registers.
   pop ebx							;
   add ecx, 1						;
   movaps    xmm6, xmm4				; xmm6: U2  
   cmp ecx, ebx					    ; j < (eax >> 1) ?
   jl for_sub_dft_inv				;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY SIZE
								;	
   pop ecx						; xmm7: - - c1 c2
   pcmpeqw  xmm3, xmm3			; const 1
   pslld    xmm3, 25			;
   psrld    xmm3, 2				;
   movshdup xmm7, xmm7			; xmm4: - - c1 c1
   addsubps xmm3, xmm7			; xmm3: - -  1+c1  1-c1
   pcmpeqw  xmm0, xmm0			; const 0.5
   pslld    xmm0, 26			;
   psrld    xmm0, 2				;
   mulps    xmm3, xmm0			; 0.5*asdf
   sqrtps   xmm3, xmm3          ; xmm3: sqrt(v) new: - - c1 c2
   movaps    xmm7, xmm3		   	; xmm7: - - c1 +c2 (new)
   shr ecx, 1					;
   jnz loop_log2_n_stage_inv	;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF LOOP (INVERSED)
							;   
inv_two_butterflies:		;
							;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;  INVERSE PART FIRST STATE	; // state bulgaria
   ; There are two butterflies. ;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
								;
   mov ebx, eax					;
   pcmpeqw  xmm5,xmm5			; const 1
   pslld    xmm5,25				;
   psrld    xmm5,2				;
   xorps	xmm6, xmm6			; xmm6 = [0, 0, 0, 0] // u2
   ;shufps   xmm5, xmm5, 0x00	; xmm5 = [1, 1, 1, 1] // op_code 0x00 is written in the CODE instruction. Not in DATA!
   shl eax, 1					;
								;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	SIZE OF BUTTERFLY
									;   =================
   xor ecx, ecx						;                  ///                BUTTERFLY SIZE = 2^ecx
									; ecx: J counter   //   1           2                4
									;                  // .-/\-.   .-----/\-----.   .--------/\--------.
for_sub_dft_invb:					; ebx: l2          //     2  |            4   |                  8   |
									; ebx: counter+ebx //     1  |		      2   |                  4   | 
									; eax: <<= 1       // 1 + 0  | 2 + 0; 2 + 1   | 4+0; 4+1; 4+2; 4+3   | etc..
   push     ebx						; ebx: push        // Save it cuz of loop condition
   push     ecx						; ecx: push        // save it cuz butterfly loop will fuck it up  
   add ebx, ecx						;
									;		BUTTERFLY
									;		=========
									;
									; REAL PART - LEFT WING
									;
   movss    xmm0, [esi + ebx*4]		; xmm0: [ -,  -,  -, Ra]
   shufps 	xmm0, xmm0, 0x93		; xmm0: [ -,  -, Ra, - ]
   add      ebx, eax				; ebx:  s1
   movss    xmm4, [esi + ebx*4]		; xmm0: [ -,  -, Ra, Rb]
   movss    xmm0, xmm4				;
   movaps   xmm1, xmm5				; xmm1: [u1]
   mulps    xmm1, xmm0				; xmm1: [-, -, Rc*u1, Rd*u1]
   sub      ebx, eax				; ebx:  s0
   mulps    xmm0, xmm6				; xmm0: [-, -, Rc*u2, Rd*u2]
									;
									; IMAGINARY PART - LEFT WING
									;
   movss    xmm2, [edi + ebx*4]		; xmm2: [ -,  -,  -, Ia]
   shufps	xmm2, xmm2, 0x93		; xmm2: [ -,  -, Ia, - ]
   add      ebx, eax				; ebx:  s1 (keep it)
   movss    xmm4, [edi + ebx*4]		; xmm2: [ -,  -, Ia, Ib]
   movss    xmm2, xmm4				;
   movaps   xmm3, xmm5				; xmm3: [u1]
   mulps    xmm3, xmm2				; xmm3: [ -,  -, Ic*u1, Id*u1]
   mulps    xmm2, xmm6				; xmm2: [ -,  -, Ic*u2, Id*u2]
									;
									; BUTTERFLY BODY :) 
									;
   addps    xmm0, xmm3				; xmm0: [Ia*u1, Ib*u1, Ic*u1, Id*u1] + [Ra*u2, Rb*u2, Rc*u2, Rd*u2] < t2
   subps    xmm1, xmm2				; xmm1: [Ra*u1, Rb*u1, Rc*u1, Rd*u1] - [Ia*u1, Ib*u1, Ic*u1, Id*u1] < t1
									;
									; REAL PART - RIGHT WING
									;
   movss    xmm2, [esi + ecx*4]		; xmm2: [ -,  -,  -, RA]
   shufps	xmm2, xmm2, 0x93		; xmm2: [ -,  -, RA, - ]
   add      ecx, eax				; ecx: s1
   movss    xmm4, [esi + ecx*4]		; xmm2: [ -,  -, RA, RB]
   movss    xmm2, xmm4				;
   sub      ecx, eax				; ecx: s0
									;
   movaps   xmm4, xmm2				; xmm4: [ x,  x, RA, RB]
   subps    xmm4, xmm1				; xmm4: [ -,  -, RA, RB] - t1
									;
									; SAVE REAL PART - LEFT WING
									;
   movss    [esi + ebx*4], xmm4		; result: Rb 
   sub      ebx, eax				; ebx: s0
   shufps   xmm4, xmm4, 0x39	    ; xmm4: [Rb, -, -, Ra]
   movss    [esi + ebx*4], xmm4		; result: Ra
									;
									; IMAGINARY PART - RIGHT WING
   									;
   movss    xmm3, [edi + ecx*4]		; xmm3: [ -,  -,  -, IA]
   shufps	xmm3, xmm3, 0x93		; xmm3: [ -,  -, IA, - ]
   add      ecx, eax				; ecx: s1
   movss    xmm4, [edi + ecx*4]		; xmm3: [ -,  -, IA, IB]
   movss    xmm3, xmm4				;
   									;
   movaps   xmm4, xmm3				; xmm4: [ -,  -, IA, IB]
   add      ebx, eax				; ebx: s1
   subps    xmm4, xmm0				; xmm4: [ -,  -, IA, IB] - t2
									;
   									; SAVE IMAGINARY PART - LEFT WING
									;
   movss    [edi + ebx*4], xmm4		; result: Ib	
   sub      ebx, eax				; ebx: s0
   shufps   xmm4, xmm4, 0x39		; xmm4: [Ib,  -,  -, Ia]
   movss    [edi + ebx*4], xmm4		; result: Ia
									; 
   addps    xmm2, xmm1				; xmm2: [RA, RB, RC, RD] + t1 
   addps    xmm3, xmm0				; xmm3: [IA, IB, IC, ID] + t2
									; 
									; SAVE IMAGINARY PART - RIGHT WING
									;
   movss    [edi + ecx*4], xmm3		; result: IB
   sub      ecx, eax				; ecx: s0
   shufps   xmm3, xmm3, 0x39		; xmm3: [ID, IA, IB, IC]
   movss    [edi + ecx*4], xmm3		; result: IA
   add		ecx, eax				; ecx: s1
   									;  
									; SAVE REAL PART - RIGHT WING
									;  
   movss    [esi + ecx*4], xmm2		; result: RB
   sub 		ecx, eax				; ecx: s0
   shufps   xmm2, xmm2, 0x39		; xmm2: [RB,  -,  -, RA]
   movss    [esi + ecx*4], xmm2		; result: RA
									;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY
   pop ecx						; xmm7: [c1, c2, c1, N]
   mulps    xmm5, xmm7			; xmm5: [ -,  -, u1c1, u1c2]
   mulps    xmm6, xmm7			; xmm6: [ -,  -, u2c1, u2c2]
   shufps   xmm6, xmm6, 0x01	; xmm6: [22, 22, u2c2, u2c1]
   movaps   xmm4, xmm6			; xmm4: [ -,  -, u2c2, u2c1]
   addps    xmm4, xmm5			; xmm4: [ -,  -,  -, OK]
   shufps   xmm4, xmm4, 0x00	; xmm4: [U2, U2, U2, U2] !! 
   subps    xmm5, xmm6			; xmm6: [ -,  -, OK,  -]
   shufps   xmm5, xmm5, 0x55    ; xmm6: [U1, U1, U1, U1]
								; but they are in wrong registers.
   pop ebx						;
   add ecx, 1					;
   movaps    xmm6, xmm4         ; xmm6: U2      
   cmp ecx, ebx					; j < (eax >> 1) ?
   jl for_sub_dft_invb			;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY SIZE
							;
							;			
   pcmpeqw  xmm3, xmm3		; const 1
   pslld    xmm3, 25		;
   psrld    xmm3, 2			;
   movshdup xmm7, xmm7		; xmm4: - - c1 c1
   addsubps xmm3, xmm7		; xmm3: - -  1+c1  1-c1
   pcmpeqw  xmm0, xmm0		; const 0.5
   pslld    xmm0, 26		;
   psrld    xmm0, 2			;
   mulps    xmm3, xmm0		; 0.5*asdf
   sqrtps   xmm3, xmm3      ; xmm3: sqrt(v) new: - - c1 c2 
   movaps   xmm7, xmm3		; xmm7: - - c1 +c2 (new)
							; 
   ;;;;;;;;;;;;;;;;;;;;;;;;;; NEXT STATE lol
                        ;
inv_one_butterfly:		;
                        ;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;  INVERSE PART FIRST STATE	; // state denmark
   ; There are two butterflies. ;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
								; 01 00 01 00
   shufps xmm7, xmm7, 0x44      ; c1 c2 c1 c2
   cvtsi2ss xmm6, edx			; -   -  - n
   movss xmm7, xmm6				; c1 c2 c1 n
   pcmpeqw  xmm3, xmm3			; Load: const 1
   pslld    xmm3, 25			;
   psrld    xmm3, 2				;
   movaps    xmm5, xmm3
   xorps	xmm6, xmm6			; xmm6 = [0, 0, 0, 0] // u2
   shufps   xmm5, xmm5, 0x00	; xmm5 = [1, 1, 1, 1] // op_code 0x00 is written in the CODE instruction. Not in DATA!
   mov ebx, eax					;
   shl eax, 1					;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	SIZE OF BUTTERFLY
									;   =================
   xor ecx, ecx						;                  ///                BUTTERFLY SIZE = 2^ecx
for_sub_dft_inv_bbb:				; ecx: J counter   //   1           2                4
   ; Big butterfly					;                  // .-/\-.   .-----/\-----.   .--------/\--------.
									; ebx: l2          //     2  |            4   |                  8   |
									; ebx: counter+ebx //     1  |		      2   |                  4   | 
									; eax: <<= 1       // 1 + 0  | 2 + 0; 2 + 1   | 4+0; 4+1; 4+2; 4+3   | etc..
   push     ebx						; ebx: push        // Save it cuz of loop condition
   push     ecx						; ecx: push        // save it cuz butterfly loop will fuck it up  
   add ebx, ecx						;
									;		BUTTERFLY
									;		=========
									;
									; REAL PART - LEFT WING
									;
   movss    xmm0, [esi + ebx*4]		; xmm0: [ -,  -,  -, Ra]
   movaps   xmm1, xmm5				; xmm1: [u1]
   mulps    xmm1, xmm0				; xmm1: [-, -, -, Ra*u1]
   mulps    xmm0, xmm6				; xmm0: [-, -, -, Ra*u2]
									;
									; IMAGINARY PART - LEFT WING
									;
   movss    xmm2, [edi + ebx*4]		; xmm2: [ -,  -,  -, Ia]
   movaps   xmm3, xmm5				; xmm3: [u1]
   mulps    xmm3, xmm2				; xmm3: [ -,  -, -, Ia*u1]
   mulps    xmm2, xmm6				; xmm2: [ -,  -, -, Ia*u2]
									;
									; BUTTERFLY BODY :) 
									;
   addps    xmm0, xmm3				; xmm0: [Ia*u1] + [Ra*u2] < t2
   subps    xmm1, xmm2				; xmm1: [Ra*u1] - [Ia*u2] < t1
									;
									; REAL PART - RIGHT WING
									;
   movss    xmm2, [esi + ecx*4]		; xmm2: [ -,  -,  -, RA]
   movaps   xmm4, xmm2				;
   subps    xmm4, xmm1				; xmm2: [ -,  -,  -, RA] - t1
									;
									; SAVE REAL PART - LEFT WING
   									;
									;
   movss    [esi + ebx*4], xmm4		; result: Ra
  									;
									; IMAGINARY PART - RIGHT WING
   									;
   movss    xmm3, [edi + ecx*4]		; xmm3: [ -,  -,  -, IA]
   									;
   movaps   xmm4, xmm3				; xmm4: [ -,  -,  -, IA]
   subps    xmm4, xmm0				; xmm4: [ -,  -,  -, IA] - t2
									;
   									; SAVE IMAGINARY PART - LEFT WING
									;
   movss    [edi + ebx*4], xmm4		; result: Ia
									; 
   addps    xmm2, xmm1				; xmm2: [RA, RB, RC, RD] + t1 
   addps    xmm3, xmm0				; xmm3: [IA, IB, IC, ID] + t2
									; 
   									;  
									; SAVE REAL PART - RIGHT WING
									;  
   movss    [esi + ecx*4], xmm2		; result: RB
									;
									; SAVE IMAGINARY PART - RIGHT WING
									;
   movss    [edi + ecx*4], xmm3		; result: IB
									;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY
								;
   pop ecx						; xmm7: [c1, c2, c1, N]
   shufps   xmm7, xmm7, 0x4E	; xmm7: [c1   N  c1  c2]
   mulps    xmm5, xmm7			; xmm5:				[ -,  -, u1c1, u1c2]
   mulps    xmm6, xmm7			; xmm6:  [ -,  -, u2c1, u2c2]
   shufps   xmm6, xmm6, 0x01	; xmm6:				[x, x,   u2c2, u2c1]
   movaps   xmm4, xmm6			; xmm4: [ -,  -, u2c2, u2c1]
   addps    xmm4, xmm5			; xmm4: [ -,  -,  -, OK]
   shufps   xmm4, xmm4, 0x00	; xmm4: [U2, U2, U2, U2] !! 
   subps    xmm5, xmm6			; xmm6: [ -,  -, OK,  -]
   shufps   xmm5, xmm5, 0x55    ; xmm6: [U1, U1, U1, U1]
								; but they are in wrong registers.
   pop ebx						;
   add ecx, 1					;
   movaps    xmm6, xmm4         ; xmm6: U2      
   shufps   xmm7, xmm7, 0x4E	; xmm7: [N    N  c1  c2]
   cmp ecx, ebx					; j < (eax >> 1) ?
   jl for_sub_dft_inv_bbb		;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY SIZE
							;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;
						;
   jmp the_end			;
   ;;;;;;;;;;;;;;;;;;;;;;
   


forward_direction:



   ;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;    FORWARD FREQUENCY   ;
   ;    DOMAIN SYNTHESIS    ; Init registers
   ;;;;;;;;;;;;;;;;;;;;;;;;;; eax: N >> 1 (constant from BIT REVERSAL)
							; edi, esi: im, re pointers
   mov      ecx,  eax		; ecx: N >> 1 (counter in da main loop)
   movss    xmm7, [c1]		; xmm7: [a,  b,  c,  c1]
   xorps    xmm4, xmm4		; xmm4
   mov      eax, 1			; eax: l2		// 1
   shr      ecx, 1			; ecx: N >> 2
   jz	fw_one_butterfly    ; 
   movsldup	xmm7, xmm7		; xmm7: [b,  b,  c1, c1]
   movss    xmm7, xmm4		; xmm4: [-,  -,  c1, c2] 
   shr      ecx, 1			; ecx: N >> 3
   jz   fw_two_butterflies  ;
   mov		edx,  [N]		; edx: length
							;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;		 MAIN LOOP			;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ; MAIN LOOP
loop_log2_n_stage_fw:			; =========
								;
   pcmpeqw xmm5,xmm5			; const 1
   pslld xmm5,25
   psrld xmm5,2
   xorps	xmm6, xmm6			; xmm6 = [0, 0, 0, 0] // u2
   push ecx						; save it.. 
   ;shufps   xmm5, xmm5, 0x00	; xmm5 = [1, 1, 1, 1] // op_code 0x00 is written in the CODE instruction. Not in DATA!
								;
   mov ebx, eax					; eax
   shl eax, 1					; eax: <<= 1
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	SIZE OF BUTTERFLY
									;   =================
   xor ecx, ecx						;                  ///                BUTTERFLY SIZE = 2^ecx
for_sub_dft_fw:						; ecx: J counter   //   1           2                4
									;                  // .-/\-. .-----/\-----. .--------/\--------.
									; ebx: counter+ebx //     1 |		     2 |                  4 | 
									;       (index)    //     2 |            4 |                  8 |
									;		           // 1 + 0 | 2 + 0; 2 + 1 | 4+0; 4+1; 4+2; 4+3 | etc..
   push     ebx						; ebx: push        // Save it cuz of loop condition
   push     ecx						; ecx: push        // save it cuz butterfly loop will fuck it up  
	add ebx, ecx					;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	BUTTERFLY LOOP
   ;              ____________          ;   ==============
   ;    /~\     _/  asm vs me|          ;
   ;   ( oo|  <      42 : 0  /          ; eax = NEXT BUTTER FLY... SHIFT IN THE ARRAY (ON FIRST MAIN LOOP BY 2, ON SECOND MAIN LOOP BY 4....)
   ;   _\=/_   |____________/           ; ebx = eax >> 1 (Half of the shift) (1 2 4)
   ;  /     \                           ; ecx = INDEX I, is defined by J
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; edx = N 
										;
for_butterfly_fw:						; REAL PART - LEFT WING
										;
   movss    xmm0, [esi + ebx*4]			; xmm0: [ -,  -,  -, Ra]
   shufps 	xmm0, xmm0, 0x93			; xmm0: [ -,  -, Ra, - ]
   add      ebx, eax					; ebx:  s1
   movss    xmm4, [esi + ebx*4]			; xmm0: [ -,  -, Ra, Rb]
   movss    xmm0, xmm4					;
   add      ebx, eax					; ebx:  s2
   shufps	xmm0, xmm0, 0x93			; xmm0: [ -, Ra, Rb, - ]
   movss    xmm4, [esi + ebx*4]			; xmm0: [ -, Ra, Rb, Rc]
   movss    xmm0, xmm4					;
   add      ebx, eax					; ebx:  s3
   shufps	xmm0, xmm0, 0x93			; xmm0: [Ra, Rb, Rc, - ]
   movss    xmm4, [esi + ebx*4]			; xmm0: [Ra, Rb, Rc, Rd]
   movss    xmm0, xmm4                  ;
   sub      ebx, eax					; ebx:  s2
   movaps   xmm1, xmm5					; xmm1: [u1]
   sub      ebx, eax					; ebx:  s1
   mulps    xmm1, xmm0					; xmm1: [Ra*u1, Rb*u1, Rc*u1, Rd*u1]
   sub      ebx, eax					; ebx:  s0
   mulps    xmm0, xmm6					; xmm0: [Ra*u2, Rb*u2, Rc*u2, Rd*u2]
										;
										; IMAGINARY PART - LEFT WING
										;
   movss    xmm2, [edi + ebx*4]			; xmm2: [ -,  -,  -, Ia]
   shufps	xmm2, xmm2, 0x93			; xmm2: [ -,  -, Ia, - ]
   add      ebx, eax					; ebx:  s1
   movss    xmm4, [edi + ebx*4]			; xmm2: [ -,  -, Ia, Ib]
   movss    xmm2, xmm4					;
   shufps	xmm2, xmm2, 0x93			; xmm2: [ -, Ia, Ib, - ]
   add      ebx, eax					; ebx:  s2
   movss    xmm4, [edi + ebx*4]			; xmm2: [ -, Ia, Ib, Ic]
   movss    xmm2, xmm4					;
   shufps	xmm2, xmm2, 0x93			; xmm2: [Ia, Ib, Ic, - ]
   add      ebx, eax					; ebx:  s3, keep it!
   movss    xmm4, [edi + ebx*4]			; xmm2: [Ia, Ib, Ic, Id]
   movss    xmm2, xmm4					;
   movaps   xmm3, xmm5					; xmm3: [u1]
   mulps    xmm3, xmm2					; xmm3: [Ia*u1, Ib*u1, Ic*u1, Id*u1]
   mulps    xmm2, xmm6					; xmm2: [Ia*u2, Ib*u2, Ic*u2, Id*u2]
										;
										; BUTTERFLY BODY :) 
										;
   addps    xmm0, xmm3					; xmm0: [Ia*u1, Ib*u1, Ic*u1, Id*u1] + [Ra*u2, Rb*u2, Rc*u2, Rd*u2] < t2
   subps    xmm1, xmm2					; xmm1: [Ra*u1, Rb*u1, Rc*u1, Rd*u1] - [Ia*u2, Ib*u2, Ic*u2, Id*u2] < t1
										;
										; REAL PART - RIGHT WING
										;
   movss    xmm2, [esi + ecx*4]			; xmm2: [ -,  -,  -, RA]
   shufps	xmm2, xmm2, 0x93			; xmm2: [ -,  -, RA, - ]
   add      ecx, eax					; ecx: s1
   movss    xmm4, [esi + ecx*4]			; xmm2: [ -,  -, RA, RB]
   movss    xmm2, xmm4					;
   shufps	xmm2, xmm2, 0x93			; xmm2: [ -, RA, RB, - ]
   add      ecx, eax					; ecx: s2
   movss    xmm4, [esi + ecx*4]			; xmm2: [ -, RA, RB, RC]
   movss    xmm2, xmm4					;
   shufps	xmm2, xmm2, 0x93			; xmm2: [RA, RB, RC, - ]
   add      ecx, eax					; ecx: s3
   movss    xmm4, [esi + ecx*4]			; xmm2: [RA, RB, RC, RD]
   movss    xmm2, xmm4					;
   sub      ecx, eax					; ecx: s2
   movaps   xmm4, xmm2					; xmm4: [RA, RB, RC, RD]
   sub      ecx, eax					; ecx: s1
										;
   subps    xmm4, xmm1					; xmm4: [RA, RB, RC, RD] - t1
   sub      ecx, eax					; ecx: s0
										;
										; SAVE REAL PART - LEFT WING
										;
										; ebx: s3
   movss    [esi + ebx*4], xmm4			; result: Rd 
   sub      ebx, eax					; ebx: s2
   shufps   xmm4, xmm4, 0x39			; xmm4: [Rd, Ra, Rb, Rc]
   movss    [esi + ebx*4], xmm4			; result: Rc
   sub      ebx, eax					; ebx: s1
   shufps   xmm4, xmm4, 0x39			; xmm4: [Rc, Rd, Ra, Rb]
   movss    [esi + ebx*4], xmm4			; result: Rb
   sub      ebx, eax					; ebx: s0
   shufps   xmm4, xmm4, 0x39			; xmm4: [Rb, Rc, Rd, Ra]
   movss    [esi + ebx*4], xmm4			; result: Ra
										;
										; IMAGINARY PART - RIGHT WING
										;
   movss    xmm3, [edi + ecx*4]			; xmm3: [ -,  -,  -, IA]
   shufps	xmm3, xmm3, 0x93			; xmm3: [ -,  -, IA, - ]
   add      ecx, eax					; ecx: s1
   movss    xmm4, [edi + ecx*4]			; xmm3: [ -,  -, IA, IB]
   movss    xmm3, xmm4					;
   shufps	xmm3, xmm3, 0x93			; xmm3: [ -, IA, IB, - ]
   add      ecx, eax					; ecx: s2
   movss    xmm4, [edi + ecx*4]			; xmm3: [ -, IA, IB, IC]
   movss    xmm3, xmm4					;
   shufps	xmm3, xmm3, 0x93			; xmm3: [IA, IB, IC, - ]
   add      ecx, eax					; ecx: s3
   movss    xmm4, [edi + ecx*4]			; xmm3: [IA, IB, IC, ID]
   movss    xmm3, xmm4					;
										;
   movaps   xmm4, xmm3					; xmm4: [IA, IB, IC, ID]
   subps    xmm4, xmm0					; xmm4: [IA, IB, IC, ID] - t2
										;
   										; SAVE IMAGINARY PART - LEFT WING
										;
										; ebx: s0
   shufps   xmm4, xmm4, 0x93			; xmm4: [Ib, Ic, Id, Ia]
   movss    [edi + ebx*4], xmm4			; result: Ia	
   add      ebx, eax					; ebx: s1
   shufps   xmm4, xmm4, 0x93			; xmm4: [Ic, Id, Ia, Ib]
   movss    [edi + ebx*4], xmm4			; result: Ib
   add      ebx, eax					; ebx: s2
   shufps   xmm4, xmm4, 0x93			; xmm4: [Id, Ia, Ib, Ic]
   movss    [edi + ebx*4], xmm4		    ; result: Ic
   add      ebx, eax					; ebx: s3
   shufps   xmm4, xmm4, 0x93			; xmm4: [Ia, Ib, Ic, Id]
   movss    [edi + ebx*4], xmm4			; result: Id
										; 
   addps    xmm2, xmm1					; xmm2: [RA, RB, RC, RD] + t1 
   addps    xmm3, xmm0					; xmm3: [IA, IB, IC, ID] + t2
										; 
										; SAVE IMAGINARY PART - RIGHT WING
										;
										; ecx: s3
   movss    [edi + ecx*4], xmm3			; result: ID 
   sub      ecx, eax					; ecx: s2
   shufps   xmm3, xmm3, 0x39			; xmm3: [ID, IA, IB, IC]
   movss    [edi + ecx*4], xmm3			; result: IC
   sub      ecx, eax					; ecx: s1
   shufps   xmm3, xmm3, 0x39			; xmm3: [IC, ID, IA, IB]
   movss    [edi + ecx*4], xmm3			; result: IB
   sub      ecx, eax					; ecx: s0
   shufps   xmm3, xmm3, 0x39			; xmm3: [IB, IC, ID, IA]
   movss    [edi + ecx*4], xmm3			; result: IA
										;  
										; SAVE REAL PART - RIGHT WING
										;  
   shufps   xmm2, xmm2, 0x93			; xmm2: [RA, RC, RB, RD]
   movss    [esi + ecx*4], xmm2			; result: RA
   add		ecx, eax					; ecx: s1
   shufps   xmm2, xmm2, 0x93			; xmm2: [RC, RD, RA, RB]
   movss    [esi + ecx*4], xmm2			; result: RB
   add		ecx, eax					; ecx: s2
   shufps   xmm2, xmm2, 0x93			; xmm2: [RD, RA, RB, RC]
   movss    [esi + ecx*4], xmm2			; result: RC
   add		ecx, eax					; ecx: s3
   shufps   xmm2, xmm2, 0x93			; xmm2: [RA, RB, RC, RD]
   movss    [esi + ecx*4], xmm2			; result: RD
										;
										; NEXT BUTTERFLY CONDITION
										;  
										; eax: is constant in this loop
   add ecx, eax							; ecx: s4		
   add ebx, eax							; ebx: s4
   cmp ecx, edx							; i < N?
   jl for_butterfly_fw					;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	END OF BUTTERFLY LOOP
   pop ecx							; xmm7: [c1, c2, c1, N]
   mulps    xmm5, xmm7				; xmm5: [ -,  -, u1c1, u1c2]
   mulps    xmm6, xmm7				; xmm6: [ -,  -, u2c1, u2c2]
   shufps   xmm6, xmm6, 0x01		; xmm6: [22, 22, u2c2, u2c1]
   movaps   xmm4, xmm6				; xmm4: [ -,  -, u2c2, u2c1]
   addps    xmm4, xmm5				; xmm4: [ -,  -,  -, OK]
   shufps   xmm4, xmm4, 0x00		; xmm4: [U2, U2, U2, U2] !! 
   subps    xmm5, xmm6				; xmm6: [ -,  -, OK,  -]
   shufps   xmm5, xmm5, 0x55		; xmm6: [U1, U1, U1, U1]
									; but they are in wrong registers.
   pop ebx							;
   add ecx, 1						;
   movaps    xmm6, xmm4				; xmm6: U2  
   cmp ecx, ebx					    ; j < (eax >> 1) ?
   jl for_sub_dft_fw				;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY SIZE
								;	
   pop ecx						; xmm7: - - c1 c2
   pcmpeqw  xmm3, xmm3			; const 1
   pslld    xmm3, 25			;
   psrld    xmm3, 2				;
   movshdup xmm7, xmm7			; xmm4: - - c1 c1
   addsubps xmm3, xmm7			; xmm3: - -  1+c1  1-c1
   pcmpeqw  xmm0, xmm0			; const 0.5
   pslld    xmm0, 26			;
   psrld    xmm0, 2				;
   mulps    xmm3, xmm0			; 0.5*asdf
   sqrtps   xmm3, xmm3          ; xmm3: sqrt(v) new: - - c1 c2
   xorps    xmm7, xmm7			; xmm7: 0 0  0   0
   addsubps xmm7, xmm3			; xmm7: - - c1 -c2 (new)
   shr ecx, 1					;
   jnz loop_log2_n_stage_fw		;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF LOOP (INVERSED)
							;   
fw_two_butterflies:			;
							;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;  FORWARD PART FIRST STATE	; // state bulgaria
   ; There are two butterflies. ;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
								;
   mov ebx, eax					;
   pcmpeqw  xmm5,xmm5			; const 1
   pslld    xmm5,25				;
   psrld    xmm5,2
   xorps	xmm6, xmm6			; xmm6 = [0, 0, 0, 0] // u2
   ;shufps   xmm5, xmm5, 0x00	; xmm5 = [1, 1, 1, 1] // op_code 0x00 is written in the CODE instruction. Not in DATA!
   shl eax, 1					;
								;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	SIZE OF BUTTERFLY
									;   =================
   xor ecx, ecx						;                  ///                BUTTERFLY SIZE = 2^ecx
									; ecx: J counter   //   1           2                4
									;                  // .-/\-.   .-----/\-----.   .--------/\--------.
for_sub_dft_fwb:					; ebx: l2          //     2  |            4   |                  8   |
									; ebx: counter+ebx //     1  |		      2   |                  4   | 
									; eax: <<= 1       // 1 + 0  | 2 + 0; 2 + 1   | 4+0; 4+1; 4+2; 4+3   | etc..
   push     ebx						; ebx: push        // Save it cuz of loop condition
   push     ecx						; ecx: push        // save it cuz butterfly loop will fuck it up  
   add ebx, ecx						;
									;		BUTTERFLY
									;		=========
									;
									; REAL PART - LEFT WING
									;
   movss    xmm0, [esi + ebx*4]		; xmm0: [ -,  -,  -, Ra]
   shufps 	xmm0, xmm0, 0x93		; xmm0: [ -,  -, Ra, - ]
   add      ebx, eax				; ebx:  s1
   movss    xmm4, [esi + ebx*4]		; xmm0: [ -,  -, Ra, Rb]
   movss    xmm0, xmm4
   movaps   xmm1, xmm5				; xmm1: [u1]
   mulps    xmm1, xmm0				; xmm1: [-, -, Rc*u1, Rd*u1]
   sub      ebx, eax				; ebx:  s0
   mulps    xmm0, xmm6				; xmm0: [-, -, Rc*u2, Rd*u2]
									;
									; IMAGINARY PART - LEFT WING
									;
   movss    xmm2, [edi + ebx*4]		; xmm2: [ -,  -,  -, Ia]
   shufps	xmm2, xmm2, 0x93		; xmm2: [ -,  -, Ia, - ]
   add      ebx, eax				; ebx:  s1 (keep it)
   movss    xmm4, [edi + ebx*4]		; xmm2: [ -,  -, Ia, Ib]
   movss    xmm2, xmm4				;
   movaps   xmm3, xmm5				; xmm3: [u1]
   mulps    xmm3, xmm2				; xmm3: [ -,  -, Ic*u1, Id*u1]
   mulps    xmm2, xmm6				; xmm2: [ -,  -, Ic*u2, Id*u2]
									;
									; BUTTERFLY BODY :) 
									;
   addps    xmm0, xmm3				; xmm0: [Ia*u1, Ib*u1, Ic*u1, Id*u1] + [Ra*u2, Rb*u2, Rc*u2, Rd*u2] < t2
   subps    xmm1, xmm2				; xmm1: [Ra*u1, Rb*u1, Rc*u1, Rd*u1] - [Ia*u1, Ib*u1, Ic*u1, Id*u1] < t1
									;
									; REAL PART - RIGHT WING
									;
   movss    xmm2, [esi + ecx*4]		; xmm2: [ -,  -,  -, RA]
   shufps	xmm2, xmm2, 0x93		; xmm2: [ -,  -, RA, - ]
   add      ecx, eax				; ecx: s1
   movss    xmm4, [esi + ecx*4]		; xmm2: [ -,  -, RA, RB]
   movss    xmm2, xmm4
   sub      ecx, eax				; ecx: s0
									;
   movaps   xmm4, xmm2				; xmm4: [ x,  x, RA, RB]
   subps    xmm4, xmm1				; xmm4: [ -,  -, RA, RB] - t1
									;
									; SAVE REAL PART - LEFT WING
									;
   movss    [esi + ebx*4], xmm4		; result: Rb 
   sub      ebx, eax				; ebx: s0
   shufps   xmm4, xmm4, 0x39	    ; xmm4: [Rb, -, -, Ra]
   movss    [esi + ebx*4], xmm4		; result: Ra
									;
									; IMAGINARY PART - RIGHT WING
   									;
   movss    xmm3, [edi + ecx*4]		; xmm3: [ -,  -,  -, IA]
   shufps	xmm3, xmm3, 0x93		; xmm3: [ -,  -, IA, - ]
   add      ecx, eax				; ecx: s1
   movss    xmm4, [edi + ecx*4]		; xmm3: [ -,  -, IA, IB]
   movss    xmm3, xmm4
   									;
   movaps   xmm4, xmm3				; xmm4: [ -,  -, IA, IB]
   add      ebx, eax				; ebx: s1
   subps    xmm4, xmm0				; xmm4: [ -,  -, IA, IB] - t2
									;
   									; SAVE IMAGINARY PART - LEFT WING
									;
   movss    [edi + ebx*4], xmm4		; result: Ib	
   sub      ebx, eax				; ebx: s0
   shufps   xmm4, xmm4, 0x39		; xmm4: [Ib,  -,  -, Ia]
   movss    [edi + ebx*4], xmm4		; result: Ia
									; 
   addps    xmm2, xmm1				; xmm2: [RA, RB, RC, RD] + t1 
   addps    xmm3, xmm0				; xmm3: [IA, IB, IC, ID] + t2
									; 
									; SAVE IMAGINARY PART - RIGHT WING
									;
   movss    [edi + ecx*4], xmm3		; result: IB
   sub      ecx, eax				; ecx: s0
   shufps   xmm3, xmm3, 0x39		; xmm3: [ID, IA, IB, IC]
   movss    [edi + ecx*4], xmm3		; result: IA
   add		ecx, eax				; ecx: s1
   									;  
									; SAVE REAL PART - RIGHT WING
									;  
   movss    [esi + ecx*4], xmm2		; result: RB
   sub 		ecx, eax				; ecx: s0
   shufps   xmm2, xmm2, 0x39		; xmm2: [RB,  -,  -, RA]
   movss    [esi + ecx*4], xmm2		; result: RA
									;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY
   pop ecx						; xmm7: [c1, c2, c1, N]
   mulps    xmm5, xmm7			; xmm5: [ -,  -, u1c1, u1c2]
   mulps    xmm6, xmm7			; xmm6: [ -,  -, u2c1, u2c2]
   shufps   xmm6, xmm6, 0x01	; xmm6: [22, 22, u2c2, u2c1]
   movaps   xmm4, xmm6			; xmm4: [ -,  -, u2c2, u2c1]
   addps    xmm4, xmm5			; xmm4: [ -,  -,  -, OK]
   shufps   xmm4, xmm4, 0x00	; xmm4: [U2, U2, U2, U2] !! 
   subps    xmm5, xmm6			; xmm6: [ -,  -, OK,  -]
   shufps   xmm5, xmm5, 0x55    ; xmm6: [U1, U1, U1, U1]
								; but they are in wrong registers.
   pop ebx						;
   add ecx, 1					;
   movaps    xmm6, xmm4         ; xmm6: U2      
   cmp ecx, ebx					; j < (eax >> 1) ?
   jl for_sub_dft_fwb			;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY SIZE
							;
							;			
   pcmpeqw  xmm3, xmm3		; const 1
   pslld    xmm3, 25		;
   psrld    xmm3, 2			;
   movshdup xmm7, xmm7		; xmm4: - - c1 c1
   addsubps xmm3, xmm7		; xmm3: - -  1+c1  1-c1
   pcmpeqw  xmm0, xmm0		; const 0.5
   pslld    xmm0, 26		;
   psrld    xmm0, 2			;
   mulps    xmm3, xmm0		; 0.5*asdf
   sqrtps   xmm3, xmm3      ; xmm3: sqrt(v) new: - - c1 c2 
   xorps    xmm7, xmm7		; xmm7: 0 0  0   0
   addsubps xmm7, xmm3		; xmm7: - - c1 -c2 (new)
							; 
   ;;;;;;;;;;;;;;;;;;;;;;;;;; END OF INVERSED FREQUENCY DOMAIN SYNTHESIS
                        ;
fw_one_butterfly:		;
                        ;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;  FORWARD PART FIRST STATE	; // state denmark
   ; There are two butterflies. ;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
								; 01 00 01 00
   shufps xmm7, xmm7, 0x44      ; c1 c2 c1 c2
   cvtsi2ss xmm6, edx			; -   -  - n
   movss xmm7, xmm6				; c1 c2 c1 n
   pcmpeqw  xmm3, xmm3			; Load: const 1
   pslld    xmm3, 25			;
   psrld    xmm3, 2				;
   movaps    xmm5, xmm3			;
   xorps	xmm6, xmm6			; xmm6 = [0, 0, 0, 0] // u2
   shufps   xmm5, xmm5, 0x00	; xmm5 = [1, 1, 1, 1] // op_code 0x00 is written in the CODE instruction. Not in DATA!
   mov ebx, eax					;
   shl eax, 1					;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	SIZE OF BUTTERFLY
									;   =================
   xor ecx, ecx						;                  ///                BUTTERFLY SIZE = 2^ecx
for_sub_dft_fw_bbb:					; ecx: J counter   //   1           2                4
   ; Big butterfly					;                  // .-/\-.   .-----/\-----.   .--------/\--------.
									; ebx: l2          //     2  |            4   |                  8   |
									; ebx: counter+ebx //     1  |		      2   |                  4   | 
									; eax: <<= 1       // 1 + 0  | 2 + 0; 2 + 1   | 4+0; 4+1; 4+2; 4+3   | etc..
   push     ebx						; ebx: push        // Save it cuz of loop condition
   push     ecx						; ecx: push        // save it cuz butterfly loop will fuck it up  
   add ebx, ecx						;
									;		BUTTERFLY
									;		=========
									;
									; REAL PART - LEFT WING
									;
   movss    xmm0, [esi + ebx*4]		; xmm0: [ -,  -,  -, Ra]
   movaps   xmm1, xmm5				; xmm1: [u1]
   mulps    xmm1, xmm0				; xmm1: [-, -, -, Ra*u1]
   mulps    xmm0, xmm6				; xmm0: [-, -, -, Ra*u2]
									;
									; IMAGINARY PART - LEFT WING
									;
   movss    xmm2, [edi + ebx*4]		; xmm2: [ -,  -,  -, Ia]
   movaps   xmm3, xmm5				; xmm3: [u1]
   mulps    xmm3, xmm2				; xmm3: [ -,  -, -, Ia*u1]
   mulps    xmm2, xmm6				; xmm2: [ -,  -, -, Ia*u2]
									;
									; BUTTERFLY BODY :) 
									;
   addps    xmm0, xmm3				; xmm0: [Ia*u1] + [Ra*u2] < t2
   subps    xmm1, xmm2				; xmm1: [Ra*u1] - [Ia*u2] < t1
									;
									; REAL PART - RIGHT WING
									;
   movss    xmm2, [esi + ecx*4]		; xmm2: [ -,  -,  -, RA]
   movaps   xmm4, xmm2				;
   subps    xmm4, xmm1				; xmm2: [ -,  -,  -, RA] - t1
									;
									; SAVE REAL PART - LEFT WING
   									;
									;
   divss    xmm4, xmm7				;
   movss    [esi + ebx*4], xmm4		; result: Ra
  									;
									; IMAGINARY PART - RIGHT WING
   									;
   movss    xmm3, [edi + ecx*4]		; xmm3: [ -,  -,  -, IA]
   									;
   movaps   xmm4, xmm3				; xmm4: [ -,  -,  -, IA]
   subps    xmm4, xmm0				; xmm4: [ -,  -,  -, IA] - t2
									;
   									; SAVE IMAGINARY PART - LEFT WING
									;
   divss    xmm4, xmm7				;
   movss    [edi + ebx*4], xmm4		; result: Ia
									; 
   addps    xmm2, xmm1				; xmm2: [RA, RB, RC, RD] + t1 
   addps    xmm3, xmm0				; xmm3: [IA, IB, IC, ID] + t2
									; 
   									;  
									; SAVE REAL PART - RIGHT WING
									;  
   divss    xmm2, xmm7				;
   movss    [esi + ecx*4], xmm2		; result: RB
									;
									; SAVE IMAGINARY PART - RIGHT WING
									;
   divss    xmm3, xmm7				;
   movss    [edi + ecx*4], xmm3		; result: IB
									;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY
								;
   pop ecx						; xmm7: [c1, c2, c1, N]
   shufps   xmm7, xmm7, 0x4E	; xmm7: [c1   N  c1  c2]
   mulps    xmm5, xmm7			; xmm5:				[ -,  -, u1c1, u1c2]
   mulps    xmm6, xmm7			; xmm6:  [ -,  -, u2c1, u2c2]
   shufps   xmm6, xmm6, 0x01	; xmm6:				[x, x,   u2c2, u2c1]
   movaps   xmm4, xmm6			; xmm4: [ -,  -, u2c2, u2c1]
   addps    xmm4, xmm5			; xmm4: [ -,  -,  -, OK]
   shufps   xmm4, xmm4, 0x00	; xmm4: [U2, U2, U2, U2] !! 
   subps    xmm5, xmm6			; xmm6: [ -,  -, OK,  -]
   shufps   xmm5, xmm5, 0x55    ; xmm6: [U1, U1, U1, U1]
								; but they are in wrong registers.
   pop ebx						;
   add ecx, 1					;
   movaps    xmm6, xmm4         ; xmm6: U2      
   shufps   xmm7, xmm7, 0x4E	; xmm7: [N    N  c1  c2]
   cmp ecx, ebx					; j < (eax >> 1) ?
   jl for_sub_dft_fw_bbb		;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF BUTTERFLY SIZE
							;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;
						;
   ;;;;;;;;;;;;;;;;;;;;;;
the_end:
   ;           END CREDITS
   ;           ===========
   ; Directed by        Filip Orsag
   ; Written by         Petr Dvoracek
   ; Produced by        Jack Daniels
   ; Music by           Jack Johnson
   ;                    Jiný Podnik
   ;                    Dave Matthews Band
   ;                    Foo Fighters
   ;                    Nirvana
   ;                    Weezer
   ;					Write in C (let it be cover) 
   ; Assistant director David Herman
   ; 
   ; I hope that this joke enjoyed you. ;)
   ; I wish you a Merry Christmas and Happy New Year!
   }
}
/* End of file */