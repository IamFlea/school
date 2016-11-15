/*****************************************************************************/
/* Text compression using Borrows-wheeler transformation                     */
/* File: bwted.h                                                             */
/* Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>                        */
/* Date: No. Girls don't want to date with me. 29. 4.                        */
/* Description: This is header file.                                         */
/*****************************************************************************/


#ifndef __BWTED_H__
#define __BWTED_H__

#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define BWTED_OK 0
#define BWTED_FAIL -1


// Data-type of record
typedef struct{
    int64_t uncodedSize;
    int64_t codedSize;
} tBWTED;

typedef u_int8_t uint8_t;

/**
 * Encoding function
 * @param bwted record of coding
 * @param inputFile Shakespear's life-work
 * @param outputFile Compressed text.
 * @return 0 ok; -1 error during encoding
 */
int BWTEncoding(tBWTED *bwted, FILE *inputFile, FILE *outputFile);

/**
 * Decoding function
 * @param bwted record of coding
 * @param inputFile Compressed text.
 * @param outputFile Shakespear's life-work
 * @return 0 ok; -1 error during decoding
 */
int BWTDecoding(tBWTED *bwted, FILE *inputFile, FILE *outputFile);

#endif