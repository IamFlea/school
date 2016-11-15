/*****************************************************************************/
/*          Text compression using Borrows-wheeler transformation            */
/* File: main.c                                                              */
/* Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>                         */
/* Date: No. Girls don't want to date with me. 29. 4.                        */
/* Description: This file and all my code is so messy. So please  don't  try */
/*     to figure out what some variable stands for. Just continue  `reading` */
/*     THis file is written in C language. God bless  Dennis  Ritchie.  Well */
/*     the code belong here should do communication between user and bwted.h */
/*     library.                                                              */
/*****************************************************************************/

#include "bwted.h"
#include <stdlib.h>
#include <stdio.h>
#include <getopt.h>

#define F_ENCODE 0x01
#define F_DECODE 0x02

void printHelp();
/**
 * Main function
 * @param argc Argument count.
 * @param argv Arguments.
 */
int main(int argc, char** argv){
    int flag = 0;   // Says that it is encoding or decoding.
    int c;          // For getopt. 
    int result = 0; // Result of coding/decoding.

    // Filename strings.
    char *logFilename = NULL;
    char *inputFilename = NULL;
    char *outputFilename = NULL;
    
    // File pointers
    FILE *fInput  = NULL;
    FILE *fOutput = NULL;
    FILE *fLog    = NULL;
    
    // Something for record
    tBWTED record;

    // Get params.
    while((c = getopt(argc, argv, "cxhi:o:l:")) != -1){
        switch(c){
            case 'i':
                inputFilename = optarg;
                break;
            case 'o':
                outputFilename = optarg;
                break;
            case 'l':
                logFilename = optarg;
                break;
            case 'c':
                flag |= F_ENCODE;
                break;
            case 'x':
                flag |= F_DECODE;
                break;
            default:
                printHelp();
                return EXIT_SUCCESS;
        }
    }
#ifdef DEBUG
    fprintf(stdout, "Input: %s\n", inputFilename);
    fprintf(stdout, "Output: %s\n", outputFilename);
    fprintf(stdout, "Log: %s\n", logFilename);
    fprintf(stdout, "Flag: %d\n", flag);
#endif
    // Check params
    if(flag == 0 || (flag == (F_ENCODE | F_DECODE)) || inputFilename == NULL || outputFilename == NULL){
        fprintf(stderr, "Bad params; run this program with param -h.\n");
        return EXIT_FAILURE;
    }

    // Start coding/encoding
    fInput = fopen(inputFilename, "r");
    fOutput = fopen(outputFilename, "w");
    if(fInput && fOutput){
        if(flag & F_ENCODE)
            result = BWTEncoding(&record, fInput, fOutput);
        else if(flag & F_DECODE)
            result = BWTDecoding(&record, fInput, fOutput);
    } else {
        fprintf(stderr, "Error on open file.\n");
        return EXIT_FAILURE;
    }
    fclose(fInput);
    fclose(fOutput);
    
    // Write into log
    if(logFilename && result == BWTED_OK){
        fLog = fopen(logFilename, "w");
        if(fLog){
            fprintf(fLog, "login = xdvora0n\n");
            fprintf(fLog, "uncodedSize = %d\n", (int) record.uncodedSize);
            fprintf(fLog, "codedSize = %d\n", (int) record.codedSize);
            fclose(fLog);
        } else {
            fprintf(stderr, "Error on open file.\n");
            return EXIT_FAILURE;
        }
    }

    return result;
}

void printHelp(){
    printf("usage: bwted [-option] [-i inputFile] [-o outputFile] [-l logFilename]\n");
    printf("Option have to be \"-c\" for compression xor \"-d\" for decompression.\n");
    printf("XOR means that you can't combine both parameters together and you have to\n");
    printf("run program with only one this parameter. [[xdvora0n]]\n");
    //printf("You shall not pass.\n");
}
// bye