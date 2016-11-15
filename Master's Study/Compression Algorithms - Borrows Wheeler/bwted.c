/*****************************************************************************/
/* Text compression using Borrows-wheeler transformation                     */
/* File: bwted.c                                                             */
/* Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>                        */
/* Date: No. Girls don't want to date with me. 29. 4.                        */
/* Description: This is file written in C. This file should do BWT encode or */
/*         decode. I am using here some kind of dark magic. There are planty */
/*         of numbers with no meaning for stranger.                          */
/*****************************************************************************/
#include "bwted.h"
#include <sys/types.h>


int64_t indexBuffer[BLOCK_SIZE];    // For merge sort. Index array.
int64_t indexBufferTmp[BLOCK_SIZE]; // For merge sort. Index array tmp.

/**
 * Torus string comparation. This function gets two strings from main string.
 * First one starts with offset a. Second one starts with offset b. 
 * Both strings are compared.
 * @param string The torus string.
 * @param size Size of torus
 * @param a Starting index of the first string
 * @param b Starting index of the second string
 * @return a < b then 1, a = b then 0, else -1
 */
int cmpStr(int8_t* string, int64_t size, int64_t a, int64_t b){
    for(int64_t i = 0; i < size; i++, a = (a+1) % size, b = (b+1) % size){
        if(string[a] < string[b])
            return 1;
        if(string[a] > string[b])
            return -1;
    }
    return 0;
}
 
/**
 * Merging function.
 * @param array Array of indexes for sorting 
 * @param aux Temporary array for sorting with same length as array.
 * @param left Left boundary / First index that I can sort.
 * @param right Right boundary / Last index that I can sort.
 * @param string The torus which is compared.
 * @param size The length of the torus.
 */
void merge(int64_t *array, int64_t *aux, int64_t left, int64_t right, int8_t * string, int64_t size) {
    int64_t middleIndex = (left + right)/2;
    int64_t leftIndex = left;
    int64_t rightIndex = middleIndex + 1;
    int64_t auxIndex = left;
    while(leftIndex <= middleIndex && rightIndex <= right) {
        if (cmpStr(string, size, array[leftIndex], array[rightIndex]) >= 0) {
            aux[auxIndex] = array[leftIndex++];
        } else {
            aux[auxIndex] = array[rightIndex++];
        }
        auxIndex++;
    }
    while (leftIndex <= middleIndex) {
        aux[auxIndex] = array[leftIndex++];
        auxIndex++;
    }
    while (rightIndex <= right) {
        aux[auxIndex] = array[rightIndex++];
        auxIndex++;
    }
}

/**
 * Sorting via merging.
 * @param array Array of indexes for sorting 
 * @param aux Temporary array for sorting with same length as array.
 * @param left Left boundary / First index that I can sort.
 * @param right Right boundary / Last index that I can sort.
 * @param string The torus which is compared.
 * @param size The length of the torus.
 */
void mergeSort(int64_t *array, int64_t *aux, int64_t left, int64_t right, int8_t * string, int64_t size) {
    if(left == right) return;
    int64_t middleIndex = (left + right)/2;
    mergeSort(array, aux, left, middleIndex, string, size);
    mergeSort(array, aux, middleIndex + 1, right, string, size);
    merge(array, aux, left, right, string, size);
    for (int64_t i = left; i <= right; i++) {
        array[i] = aux[i];
    }
}   

/**
 * This function transform input string to output string using Burrows-Wheeler
 * algorithm. This function is used for CODER.
 * @param input Input data.
 * @param output Output data.
 * @param size Length of input data.
 * @return Start index of decode
 */
int64_t BWT(int8_t* input, int8_t* output, int64_t size){
    // Init index array with valid values.
    int64_t i, result = 0;
    for(i = 0; i < size; i++)
        indexBuffer[i] = i;
    // Sort this potato
    mergeSort(indexBuffer, indexBufferTmp, 0, size - 1, input, size); // We can't sort via quick sort. It is not natural sorting.
    // Write it back
    for(i = 0; i < size; i++){
        output[i] = input[(indexBuffer[i] + size - 1) % size];
        if(indexBuffer[i] == 0)
            result = i;
    }
    output[i] = 0; // Troll
    return result;
}

/**
 * Inverse Burrows-wheeler is used for DECODER.
 * @param input Input data
 * @param output Output data
 * @param size Length of input data
 * @param startIndex Start index of decoding.
 */
void BWTinverse(int8_t* input, int8_t* output, int64_t size, int64_t startIndex){
    // Init index array.
    int64_t i; // Counter
    for(i = 0; i < size; i++)
        indexBuffer[i] = i;
    // Sort
    mergeSort(indexBuffer, indexBufferTmp, 0, size - 1, input, 1);
    for(i = 0; i < size; i++){
        startIndex = indexBuffer[startIndex];
        output[i] = input[startIndex];
    }
    output[i] = 0;
}

/**
 * Move to front - element of list.
 */
typedef struct{
    int8_t val; // Value
    struct tMTFElement* ptr; // Petr
} tMTFElement;

/**
 * Move to front - the list.
 */
typedef struct{
    tMTFElement* first; // First element in the list
    tMTFElement* active; // Current / active element in the list.
} tMTFList;

/**
 * Freedom for the elements in list.
 */ 
void MTF_freeList(tMTFList *list){
    // Iterate through the list and free elements.
    list->active = (tMTFElement*) list->first->ptr;
    while(list->active != NULL){
        free(list->first);
        list->first = list->active;
        list->active = (tMTFElement*) list->first->ptr;
    }
    // Don't forget to free last one.
    free(list->first);
}

/**
 * Initiate the list with values in set {0, 1, 2, 3, ... 254, 255}
 * @param list MTF list
 * @return 1 on success, 0 on failure
 */
int MTF_initList(tMTFList *list){
    tMTFElement *element = (tMTFElement *) malloc(sizeof(tMTFElement));
    // Check if we allocated structures.
    if(list == NULL || element == NULL){
        fprintf(stderr, "Not enough memory.\n");
        return 0;
    }
    
    // Set element variables
    element->val = 0;
    element->ptr = NULL;
    
    // Set list on the first element.
    list->first = element;
    list->active = element;

    // Fill up whole MTF list
    for(int16_t i = 0; i < 255; i++){
        element = (tMTFElement *) malloc(sizeof(tMTFElement));
        // Check if we allocated element.
        if(element == NULL){
            MTF_freeList(list);
            fprintf(stderr, "Not enough memory.\n");
            return 0;
        }
        // Fill with variables
        element->val = i+1;
        element->ptr = NULL;
        list->active->ptr = (struct tMTFElement*) element;
        list->active = element;
    }
    // Set active on start.
    list->active = list->first;
    return 1;
}

/**
 * Uses a dictionary to use move to front algorithm.
 * Recently read values are in the begining of the dictionary.
 * We fill output string with the indexes of values in the dictionary. 
 * Let we have dictionrary = {A,B,C..Z} 
 * Then string [BANANAAA] is transformed to seq of numbers: [1 1 13 1 1 0 0]
 * @param input Input data.
 * @param output Coded data.
 * @param dictionary Used dictionary.
 * @param inputLen Length of input data
 */
void MTF(int8_t *input, int8_t *output, tMTFList *dictionary, int64_t inputLen){
    int64_t i;
    int32_t result;
    tMTFElement *tomato; // Beeedooo beedooo, banana?
    for(i = 0; i < inputLen; i++){
        result = 0;
        tomato = NULL;
        // Iterate through list
        dictionary->active = dictionary->first;
        while(dictionary->active->val != input[i]){
            result++;
            tomato = dictionary->active;
            dictionary->active = (tMTFElement *) dictionary->active->ptr;
        }
        // Move to front
        if(tomato){ // and not potato
            tomato->ptr = dictionary->active->ptr;
            dictionary->active->ptr = (struct tMTFElement*) dictionary->first;
            dictionary->first = (tMTFElement *) dictionary->active;
        }
        output[i] = result;
    }
}

/**
 * Inverted function to MFT. See previous function.
 * Using input value in dictionary to get output value. 
 * @param input Array of input data
 * @param output Arya Stark chapter
 * @param dictionary List of racently used values.
 * @param inputLen Length of the input in this function.
 */
void MTF_invert(int8_t *input, int8_t *output, tMTFList *dictionary, int64_t inputLen){
    int64_t i;
    int32_t result;
    tMTFElement *tomato; // Pointer on tomato. Why not potato?
    // For each byte in input string do this:
    for(i = 0; i < inputLen; i++){
        result = 0;
        tomato = NULL; // Nothing
        dictionary->active = dictionary->first;
        // Find the value in dictionary (iterate through list) ..
        while(result != input[i]){
            result++;
            tomato = dictionary->active;
            dictionary->active = (tMTFElement *) dictionary->active->ptr;
        }
        // Move to front.
        if(tomato){ // Throw tomato.
            tomato->ptr = dictionary->active->ptr;
            dictionary->active->ptr = (struct tMTFElement*) dictionary->first;
            dictionary->first = (tMTFElement *) dictionary->active;
        }
        output[i] = dictionary->first->val;
    }
}

/**
 * RLE 
 * From text like this: AAAHHHOOOJJJJ\VOLE!
 * We will get text like this: \3A\3H\3O\4J\\VOLE!
 * @param input Input data.
 * @param output Output data.
 * @param inputLen Length of input data.
 * @return Length of outputdata.
 */
int64_t RLE(int8_t* input, int8_t* output, int64_t inputLen){
    int64_t i, j = 0;
    uint8_t len = 1;
    // Iterate through input array.
    for(i = 1; i < (inputLen+1); i++){
        if(i != inputLen && input[i-1] == (int8_t) input[i]){
            len++;
            if(len !=  0xfe) continue; 
            // Overflow happened.
            output[j++] = (int8_t) 0xff;
            output[j++] = len;
            output[j++] = input[i-1];       // evil pointers
            len = 1;
            i++;
            continue;
        }
        if(len > 2){
            // Print: [special char, length, char]
            output[j++] = (int8_t) 0xff;    // evil casting
            output[j++] = len;
            output[j++] = input[i-1];
        } else {
            // Is it duplicate?
            if(len > 1){
                // print it one more time
                if(input[i-1] == (int8_t) 0xff) 
                    output[j++] = (int8_t) 0xff;
                output[j++] = input[i-1];
            }
            if(input[i-1] == (int8_t) 0xff) 
                output[j++] = (int8_t) 0xff;
            output[j++] = input[i-1];
        }
        len = 1;
    } // for char in input
    return j;
}

/**
 * Inverted RLE. 
 * From text like this: \3A\3H\3O\4J\\VOLE!
 * We will get input like this: AAAHHHOOOJJJJ\VOLE!
 * @param input Input data.
 * @param output Output data.
 * @param inputLen Length of input data.
 * @return Length of output data.
 */
int64_t RLE_invert(int8_t* input, int8_t* output, int64_t inputLen){
    int64_t i, j;
    uint8_t repeat;
    j = 0;
    for(i = 0; i < inputLen; i++){
        if(input[i] == (int8_t) 0xff){
            i++;
            if(input[i] == (int8_t) 0xff){
                output[j++] = input[i];
                continue;
            }
            repeat = input[i++];
            while(repeat--)
                output[j++] = input[i];
        }else{
            output[j++] = input[i];
        }
    }
    return j;
}

/**
 * Static Huffman, struct for an item in table. [sorry for misspelled varibles]
 */
typedef struct{
    int8_t size;     // Depth of huff tree.
    u_int16_t coded; // Coded value. 
} tHuffTable;

/**
 * Free memory.
 */
void freeTable(int8_t** decode){
    for(int i = 0; i < 8; i++){
        if(decode[i] != NULL)
            free(decode[i]);
        else
            break;
    }
}

/**
 * Init tables for coding and for decoding;
 * @param table For coding
 * @param decode For decoding
 * @return 1 on success, otherwise 0
 */
int initTable(tHuffTable* table, int8_t** decode);

/**
 * This function encode input via Huffamn coding table. It is saved bit by bit
 * in memory. The output block is 
 * ended with 15 ones in a row. 
 * @param input Input array block.
 * @param output OUtput array block.
 * @param inputLength Lenght of input array.
 * @param table Inited Huffman table.
 * @return Output length.
 */
int64_t huffman(int8_t* input, int8_t* output, int64_t inputLength, tHuffTable* table){
    /*
    printf("----ENCODE----\n");
input[0]=(uint8_t) 124;
input[1]=(uint8_t) 125;
input[2]=(uint8_t) 126;
input[3]=(uint8_t) 3;
input[4]=(uint8_t) 4;
input[5]=(uint8_t) 5;
input[6]=(uint8_t) 0xfc;

    printf("Input huff: %x%x%x%x%x%x\n", (uint8_t)input[0],(uint8_t)input[1], (uint8_t)input[2], (uint8_t)input[3], (uint8_t)input[4], (uint8_t)input[5]);
    */
    int64_t i, j; // input idx, output idx
    int8_t k;
    tHuffTable item;
    uint8_t roll = 0x80;
    j = 0;
    output[0] = 0;
    item = table[(uint8_t) input[0]];
    for(i = 0; i < inputLength; i++){
        item = table[(uint8_t) input[i]];
        for(k = item.size; k >= 0; k--){
            if(((u_int16_t) item.coded) & (1<<k)){
                output[j] |= roll;
            }

            roll = roll >> 1;
            if(roll == 0){
                roll = 0x80;
                j++;
                output[j] = 0;
            }
        }
    }
    for(k = 14; k >= 0; k--){
        output[j] |= roll;
        roll = roll >> 1;
        if(roll == 0){
            roll = 0x80;
            j++;
            output[j] = 0;
        }
    }
    
    return j;
}

/**
 * 
 */
int64_t huffmanInverse(int8_t* input, int8_t* output, int64_t inputLength, int8_t** table){
    int64_t i, j;
    uint8_t roll;
    uint8_t countOfOnes = 0;
    j = 0;
    uint8_t readBitCnt = 0;
    uint8_t readShift = 0;
    uint8_t codedByte = 0;
    // Masks = 0b1111110, 0b111110, 0b11110, 0b1110, 0b110, 0b10, 0b0
    int8_t masks[7] = {/* 0xfe,*/ 0x7e, 0x3e, 0x1e, 0x0e, 0x06, 0x02, 0x00}; // Mozna to nevyuzivam
    for(i = 0; i < inputLength; i++){
        // Read bit by bit..
        for(roll = (uint8_t) 0x80; roll != 0; roll=roll>>1){
            // Cteme jednicky
            if(!readBitCnt){
                if(roll & (uint8_t)input[i]){
                    countOfOnes++;
                    // Narazili jsme na konec?!
                    if(countOfOnes == 15){
                        return j;                                          // RETURN
                    }
                    continue;
                }

                // Narazili jsme na nulu

                // 14 jednicek --> tiskni hodnotu, a cti dalsi jednicky
                if(countOfOnes == 14){
                    countOfOnes = 0;
                    output[j++] = (uint8_t) 0xFD;
                    //printf("printing %x\n", 0xFD);
                    continue;
                }

                // 13 jednicek --> precti jeste jeden bit.
                if(countOfOnes == 13){
                    readBitCnt = 1;
                    codedByte = 0;
                // 6 az 12  jednicek --> precti 12-pocet bitu
                }else if(countOfOnes >= 6){
                    readBitCnt = 12-countOfOnes;
                    codedByte = masks[readBitCnt]; // Uloz si masku.
                // 0 az 5 jednicek --> precti 1 az 6 bitu...
                }else{
                    readBitCnt = countOfOnes + 1;
                    codedByte = 0;
                }
                readShift = 0;

            // Cteme posledni bity
            } else{
                if(roll & ((uint8_t) input[i])){
                    // Precetli jsme Jednicku 
                    codedByte = codedByte << 1;
                    codedByte |= 1;
                }else{
                    // precetli jsme nulu
                    codedByte = codedByte << 1;
                }
                readBitCnt--;

                // Precetli jsme cely zakodovany "slovo"?
                if(! readBitCnt){
                    // Uprava pointeru do Gandalfovy tabulky
                    if(countOfOnes >= 13) countOfOnes = 7;
                    else if(countOfOnes >= 6) countOfOnes = 6;

                    // Zapiseme
                    output[j++] = (uint8_t)table[countOfOnes][codedByte];

                    // A ulozime 
                    countOfOnes = 0;
                }
                readShift++;
            }
        }
    }//*/
    return -1;
}
/**
 * Encoding function
 * @param bwted record of coding
 * @param inputFile Tyrion chapter from Game of Thrones
 * @param outputFile Compressed text.
 * @return 0 ok; -1 error during encoding
 */
int BWTEncoding(tBWTED *bwted, FILE *inputFile, FILE *outputFile){
    //fprintf(stderr, "Started encoding. Hell yeah\n");
    //fprintf(stderr, "Block size: %d\n", BLOCK_SIZE);

    int8_t buff_a[BLOCK_SIZE*2];
    int8_t buff_b[BLOCK_SIZE*2];
 
    bwted->uncodedSize = 0;
    bwted->codedSize = 0;
    int64_t readSize;
    int64_t rleSize;

    int64_t lastIndex;

    tMTFList dictionary = {NULL, NULL};
    if(! MTF_initList(&dictionary))
        return BWTED_FAIL;

    tHuffTable table[256];
    int8_t* decodeHuff[8];
    if(! initTable(table, (int8_t**)decodeHuff))
        return BWTED_FAIL;
    
    while(!feof(inputFile)){
        readSize = fread(buff_a, 1, BLOCK_SIZE-1, inputFile);
        bwted->uncodedSize += readSize;
        buff_a[readSize] = 0x00;

        lastIndex = BWT(buff_a, buff_b, readSize);
        MTF(buff_b, buff_a, &dictionary, readSize);
        rleSize = RLE(buff_a, buff_b, readSize);
        int64_t length = huffman(buff_b, buff_a, rleSize, table) + 1;
        bwted->codedSize += length + 2*(sizeof(int64_t));
        
        fwrite(&lastIndex, sizeof(int64_t), 1, outputFile);
        fwrite(&length, sizeof(int64_t), 1, outputFile);
        fwrite(buff_a, 1, length, outputFile); //mk
    }   
    MTF_freeList(&dictionary);
    freeTable(decodeHuff);
    return BWTED_OK;
}

/**
 * Decoding function
 * @param bwted record of coding
 * @param inputFile Compressed text.
 * @param outputFile Tyrion chapter from Game of Thrones
 * @return 0 ok; -1 error during decoding
 */
int BWTDecoding(tBWTED *bwted, FILE *inputFile, FILE *outputFile){
    // *
    int8_t buff_a[BLOCK_SIZE];
    int8_t buff_b[BLOCK_SIZE];

    bwted->uncodedSize = 0;
    bwted->codedSize = 0;
    int64_t readSize;
    int64_t rleSize;
    int64_t length;

    int64_t lastIndex;

    tMTFList dictionary = {NULL, NULL};
    if(! MTF_initList(&dictionary))
        return BWTED_FAIL;

    tHuffTable table[256];
    int8_t* decodeHuff[8];
    if(! initTable(table, (int8_t**)decodeHuff))
        return BWTED_FAIL;    
    //swm siisss
    while(!feof(inputFile)){
        fread(&lastIndex, sizeof(int64_t), 1, inputFile);
        fread(&length, sizeof(int64_t), 1, inputFile);
        if(length >= BLOCK_SIZE*2){
            fprintf(stderr, "Error -- Probably bad input file.\n");
            return BWTED_FAIL;
        }
        fread(buff_a, 1, length, inputFile);

        rleSize = huffmanInverse(buff_a, buff_b, length, decodeHuff);
        
        bwted->codedSize += length + 2*(sizeof(int64_t));
        
        readSize = RLE_invert(buff_b, buff_a, rleSize);
        //printf("READ: %d\n", readSize);
        MTF_invert(buff_a, buff_b, &dictionary, readSize);
        BWTinverse(buff_b, buff_a, readSize, lastIndex);
        
        fwrite(buff_a, 1, readSize, outputFile);
        bwted->uncodedSize += readSize;
        if(BLOCK_SIZE != (readSize+1))
            break;
    }
    freeTable(decodeHuff);
    MTF_freeList(&dictionary);
    // */
    return BWTED_OK;
}


/*****************************************************************************/
/*                                                                           */
/*                  YOU SHALL NOT PASS! DEEP MAGIC IS BELOW!                 */
/*                                                                           */
/*****************************************************************************/
/*                                 _,-                                       */
/*         (\                  _,-','                                        */
/*          \\              ,-"  ,'                                          */
/*           \\           ,'   ,'                                            */
/*            \\        _:.----__.-."-._,-._                                 */
/*             \\    .-".:  `:::::.:.:'     `-.                              */
/*              \\   `. ::  .::::::'`-._       :                             */
/*               \\    ":::::::'  `-.   `-_  _,'                             */
/*                \\.._/_`:::,' `.     .  `-:                                */
/*                :" _   "\"" `-_    .    `  `.                              */
/*                 "\\"":--\     `-.__ ` .     `.                            */
/*                   \\'::  \    _-"__`--.__ `  . `.     _,--..-             */
/*                    \\ ::  \_-":)(        ""-._ ` `.-''                    */
/*                     \\`:`-":::/ \\ .   .      `-.  :                      */
/*                     :\\:::::::'  \\     `    .   `. :                     */
/*                      :\\:':':'  . \\           `,  : :                    */
/*                      : \\     .    \\      .       `. :       ,-          */
/*                     __`:\\      .   \\ .   `  ,'    ,: :   ,-'            */
/*              _,---""  :  \\ '        \\  .          :-"  ,'               */
/*          ,-""        :    \\:  .  :   \\  `  '     ,'   /                 */
/*         '            :  :  \       .   \\   .   _,'  ,-'                  */
/*                     :  .   '       :   :`   `,-' ,--'                     */
/*                     :     :   :      ,'-._,' ,-'                          */
/*                       :     :        : :  ,--'                            */
/*                        `-._,'-._.__-""' ,'                                */
/*                                   ,----'                                  */
/*                            _.----'                                        */
/*                     __..--""                                              */
/*                   ""                       http://ascii.co.uk/art/gandalf */
/*****************************************************************************/

/**
 * Init Huffman static binary tree in array. Format of tree:
 *   2 leaves in depth 2 [0x00, 0x01]
 *   4 leaves in depth 4 [0x02, 0x03, 0x04, 0x0A] 
 *                       # 0x0A has bigger probabilty in reference text
 *   8 leaves in depth 6 [0x05, 0x06, 0x07, 0x08, 0x09, 0x0B, 0x0C, 0xFF]
 *                       # 0xFF is special char in RLE. 
 *  16 leaves in depth 8 [0x0D, 0x0E, 0x0F, 0x10, .. 0xFE]
 *                       # 0xFE is overflow in RLE.
 *  32 leaves in depth 10 analogy
 *  64 leaves in depth 12
 * 127 leaves in depth 13
 *   4 leaves in depth 15 + one contains end of block 0x7fff
 */
// /*
int initTable(tHuffTable* table, int8_t** decode){
    // I told you... MAGIC!
    table[0].size = 2; table[0].coded=0;
    table[1].size = 2; table[1].coded=1;
    table[2].size = 4; table[2].coded=8;
    table[3].size = 4; table[3].coded=9;
    table[4].size = 4; table[4].coded=10;
    table[10].size = 4; table[10].coded=11;
    table[6].size = 6; table[6].coded=48;
    table[7].size = 6; table[7].coded=49;
    table[8].size = 6; table[8].coded=50;
    table[9].size = 6; table[9].coded=51;
    table[5].size = 6; table[5].coded=52;
    table[11].size = 6; table[11].coded=53;
    table[12].size = 6; table[12].coded=54;
    table[255].size = 6; table[255].coded=55;
    table[13].size = 8; table[13].coded=224;
    table[14].size = 8; table[14].coded=225;
    table[15].size = 8; table[15].coded=226;
    table[16].size = 8; table[16].coded=227;
    table[17].size = 8; table[17].coded=228;
    table[18].size = 8; table[18].coded=229;
    table[19].size = 8; table[19].coded=230;
    table[20].size = 8; table[20].coded=231;
    table[21].size = 8; table[21].coded=232;
    table[22].size = 8; table[22].coded=233;
    table[23].size = 8; table[23].coded=234;
    table[24].size = 8; table[24].coded=235;
    table[25].size = 8; table[25].coded=236;
    table[26].size = 8; table[26].coded=237;
    table[27].size = 8; table[27].coded=238;
    table[254].size = 8; table[254].coded=239;
    table[28].size = 10; table[28].coded=960;
    table[29].size = 10; table[29].coded=961;
    table[30].size = 10; table[30].coded=962;
    table[31].size = 10; table[31].coded=963;
    table[32].size = 10; table[32].coded=964;
    table[33].size = 10; table[33].coded=965;
    table[34].size = 10; table[34].coded=966;
    table[35].size = 10; table[35].coded=967;
    table[36].size = 10; table[36].coded=968;
    table[37].size = 10; table[37].coded=969;
    table[38].size = 10; table[38].coded=970;
    table[39].size = 10; table[39].coded=971;
    table[40].size = 10; table[40].coded=972;
    table[41].size = 10; table[41].coded=973;
    table[42].size = 10; table[42].coded=974;
    table[43].size = 10; table[43].coded=975;
    table[44].size = 10; table[44].coded=976;
    table[45].size = 10; table[45].coded=977;
    table[46].size = 10; table[46].coded=978;
    table[47].size = 10; table[47].coded=979;
    table[48].size = 10; table[48].coded=980;
    table[49].size = 10; table[49].coded=981;
    table[50].size = 10; table[50].coded=982;
    table[51].size = 10; table[51].coded=983;
    table[52].size = 10; table[52].coded=984;
    table[53].size = 10; table[53].coded=985;
    table[54].size = 10; table[54].coded=986;
    table[55].size = 10; table[55].coded=987;
    table[56].size = 10; table[56].coded=988;
    table[57].size = 10; table[57].coded=989;
    table[58].size = 10; table[58].coded=990;
    table[59].size = 10; table[59].coded=991;
    table[60].size = 12; table[60].coded=3968;
    table[61].size = 12; table[61].coded=3969;
    table[62].size = 12; table[62].coded=3970;
    table[63].size = 12; table[63].coded=3971;
    table[64].size = 12; table[64].coded=3972;
    table[65].size = 12; table[65].coded=3973;
    table[66].size = 12; table[66].coded=3974;
    table[67].size = 12; table[67].coded=3975;
    table[68].size = 12; table[68].coded=3976;
    table[69].size = 12; table[69].coded=3977;
    table[70].size = 12; table[70].coded=3978;
    table[71].size = 12; table[71].coded=3979;
    table[72].size = 12; table[72].coded=3980;
    table[73].size = 12; table[73].coded=3981;
    table[74].size = 12; table[74].coded=3982;
    table[75].size = 12; table[75].coded=3983;
    table[76].size = 12; table[76].coded=3984;
    table[77].size = 12; table[77].coded=3985;
    table[78].size = 12; table[78].coded=3986;
    table[79].size = 12; table[79].coded=3987;
    table[80].size = 12; table[80].coded=3988;
    table[81].size = 12; table[81].coded=3989;
    table[82].size = 12; table[82].coded=3990;
    table[83].size = 12; table[83].coded=3991;
    table[84].size = 12; table[84].coded=3992;
    table[85].size = 12; table[85].coded=3993;
    table[86].size = 12; table[86].coded=3994;
    table[87].size = 12; table[87].coded=3995;
    table[88].size = 12; table[88].coded=3996;
    table[89].size = 12; table[89].coded=3997;
    table[90].size = 12; table[90].coded=3998;
    table[91].size = 12; table[91].coded=3999;
    table[92].size = 12; table[92].coded=4000;
    table[93].size = 12; table[93].coded=4001;
    table[94].size = 12; table[94].coded=4002;
    table[95].size = 12; table[95].coded=4003;
    table[96].size = 12; table[96].coded=4004;
    table[97].size = 12; table[97].coded=4005;
    table[98].size = 12; table[98].coded=4006;
    table[99].size = 12; table[99].coded=4007;
    table[100].size = 12; table[100].coded=4008;
    table[101].size = 12; table[101].coded=4009;
    table[102].size = 12; table[102].coded=4010;
    table[103].size = 12; table[103].coded=4011;
    table[104].size = 12; table[104].coded=4012;
    table[105].size = 12; table[105].coded=4013;
    table[106].size = 12; table[106].coded=4014;
    table[107].size = 12; table[107].coded=4015;
    table[108].size = 12; table[108].coded=4016;
    table[109].size = 12; table[109].coded=4017;
    table[110].size = 12; table[110].coded=4018;
    table[111].size = 12; table[111].coded=4019;
    table[112].size = 12; table[112].coded=4020;
    table[113].size = 12; table[113].coded=4021;
    table[114].size = 12; table[114].coded=4022;
    table[115].size = 12; table[115].coded=4023;
    table[116].size = 12; table[116].coded=4024;
    table[117].size = 12; table[117].coded=4025;
    table[118].size = 12; table[118].coded=4026;
    table[119].size = 12; table[119].coded=4027;
    table[120].size = 12; table[120].coded=4028;
    table[121].size = 12; table[121].coded=4029;
    table[122].size = 12; table[122].coded=4030;
    table[123].size = 12; table[123].coded=4031;
    table[124].size = 13; table[124].coded=8064;
    table[125].size = 13; table[125].coded=8065;
    table[126].size = 13; table[126].coded=8066;
    table[127].size = 13; table[127].coded=8067;
    table[128].size = 13; table[128].coded=8068;
    table[129].size = 13; table[129].coded=8069;
    table[130].size = 13; table[130].coded=8070;
    table[131].size = 13; table[131].coded=8071;
    table[132].size = 13; table[132].coded=8072;
    table[133].size = 13; table[133].coded=8073;
    table[134].size = 13; table[134].coded=8074;
    table[135].size = 13; table[135].coded=8075;
    table[136].size = 13; table[136].coded=8076;
    table[137].size = 13; table[137].coded=8077;
    table[138].size = 13; table[138].coded=8078;
    table[139].size = 13; table[139].coded=8079;
    table[140].size = 13; table[140].coded=8080;
    table[141].size = 13; table[141].coded=8081;
    table[142].size = 13; table[142].coded=8082;
    table[143].size = 13; table[143].coded=8083;
    table[144].size = 13; table[144].coded=8084;
    table[145].size = 13; table[145].coded=8085;
    table[146].size = 13; table[146].coded=8086;
    table[147].size = 13; table[147].coded=8087;
    table[148].size = 13; table[148].coded=8088;
    table[149].size = 13; table[149].coded=8089;
    table[150].size = 13; table[150].coded=8090;
    table[151].size = 13; table[151].coded=8091;
    table[152].size = 13; table[152].coded=8092;
    table[153].size = 13; table[153].coded=8093;
    table[154].size = 13; table[154].coded=8094;
    table[155].size = 13; table[155].coded=8095;
    table[156].size = 13; table[156].coded=8096;
    table[157].size = 13; table[157].coded=8097;
    table[158].size = 13; table[158].coded=8098;
    table[159].size = 13; table[159].coded=8099;
    table[160].size = 13; table[160].coded=8100;
    table[161].size = 13; table[161].coded=8101;
    table[162].size = 13; table[162].coded=8102;
    table[163].size = 13; table[163].coded=8103;
    table[164].size = 13; table[164].coded=8104;
    table[165].size = 13; table[165].coded=8105;
    table[166].size = 13; table[166].coded=8106;
    table[167].size = 13; table[167].coded=8107;
    table[168].size = 13; table[168].coded=8108;
    table[169].size = 13; table[169].coded=8109;
    table[170].size = 13; table[170].coded=8110;
    table[171].size = 13; table[171].coded=8111;
    table[172].size = 13; table[172].coded=8112;
    table[173].size = 13; table[173].coded=8113;
    table[174].size = 13; table[174].coded=8114;
    table[175].size = 13; table[175].coded=8115;
    table[176].size = 13; table[176].coded=8116;
    table[177].size = 13; table[177].coded=8117;
    table[178].size = 13; table[178].coded=8118;
    table[179].size = 13; table[179].coded=8119;
    table[180].size = 13; table[180].coded=8120;
    table[181].size = 13; table[181].coded=8121;
    table[182].size = 13; table[182].coded=8122;
    table[183].size = 13; table[183].coded=8123;
    table[184].size = 13; table[184].coded=8124;
    table[185].size = 13; table[185].coded=8125;
    table[186].size = 13; table[186].coded=8126;
    table[187].size = 13; table[187].coded=8127;
    table[188].size = 13; table[188].coded=8128;
    table[189].size = 13; table[189].coded=8129;
    table[190].size = 13; table[190].coded=8130;
    table[191].size = 13; table[191].coded=8131;
    table[192].size = 13; table[192].coded=8132;
    table[193].size = 13; table[193].coded=8133;
    table[194].size = 13; table[194].coded=8134;
    table[195].size = 13; table[195].coded=8135;
    table[196].size = 13; table[196].coded=8136;
    table[197].size = 13; table[197].coded=8137;
    table[198].size = 13; table[198].coded=8138;
    table[199].size = 13; table[199].coded=8139;
    table[200].size = 13; table[200].coded=8140;
    table[201].size = 13; table[201].coded=8141;
    table[202].size = 13; table[202].coded=8142;
    table[203].size = 13; table[203].coded=8143;
    table[204].size = 13; table[204].coded=8144;
    table[205].size = 13; table[205].coded=8145;
    table[206].size = 13; table[206].coded=8146;
    table[207].size = 13; table[207].coded=8147;
    table[208].size = 13; table[208].coded=8148;
    table[209].size = 13; table[209].coded=8149;
    table[210].size = 13; table[210].coded=8150;
    table[211].size = 13; table[211].coded=8151;
    table[212].size = 13; table[212].coded=8152;
    table[213].size = 13; table[213].coded=8153;
    table[214].size = 13; table[214].coded=8154;
    table[215].size = 13; table[215].coded=8155;
    table[216].size = 13; table[216].coded=8156;
    table[217].size = 13; table[217].coded=8157;
    table[218].size = 13; table[218].coded=8158;
    table[219].size = 13; table[219].coded=8159;
    table[220].size = 13; table[220].coded=8160;
    table[221].size = 13; table[221].coded=8161;
    table[222].size = 13; table[222].coded=8162;
    table[223].size = 13; table[223].coded=8163;
    table[224].size = 13; table[224].coded=8164;
    table[225].size = 13; table[225].coded=8165;
    table[226].size = 13; table[226].coded=8166;
    table[227].size = 13; table[227].coded=8167;
    table[228].size = 13; table[228].coded=8168;
    table[229].size = 13; table[229].coded=8169;
    table[230].size = 13; table[230].coded=8170;
    table[231].size = 13; table[231].coded=8171;
    table[232].size = 13; table[232].coded=8172;
    table[233].size = 13; table[233].coded=8173;
    table[234].size = 13; table[234].coded=8174;
    table[235].size = 13; table[235].coded=8175;
    table[236].size = 13; table[236].coded=8176;
    table[237].size = 13; table[237].coded=8177;
    table[238].size = 13; table[238].coded=8178;
    table[239].size = 13; table[239].coded=8179;
    table[240].size = 13; table[240].coded=8180;
    table[241].size = 13; table[241].coded=8181;
    table[242].size = 13; table[242].coded=8182;
    table[243].size = 13; table[243].coded=8183;
    table[244].size = 13; table[244].coded=8184;
    table[245].size = 13; table[245].coded=8185;
    table[246].size = 13; table[246].coded=8186;
    table[247].size = 13; table[247].coded=8187;
    table[248].size = 13; table[248].coded=8188;
    table[249].size = 13; table[249].coded=8189;
    table[250].size = 13; table[250].coded=8190;
    table[251].size = 15; table[251].coded=32764;
    table[252].size = 15; table[252].coded=32765;
    table[253].size = 15; table[253].coded=32766;
    // Zmateni nepritele size je o jednicku vetsi nez jsem chtel
    for(int64_t i = 0; i < 256; i++)
        table[i].size--; 
        

    for(int i = 0; i < 8; i++){
        decode[i]= NULL; // projistotu
        decode[i]= (int8_t*) malloc(256);
        if(decode[i] == NULL){
            freeTable(decode);
            return 0;
        }
    }
    decode[0][0]=0;
    decode[0][1]=1;

    decode[1][0]=2;
    decode[1][1]=3;
    decode[1][2]=4;
    decode[1][3]=10;
    
    decode[2][0]=6;
    decode[2][1]=7;
    decode[2][2]=8;
    decode[2][3]=9;
    decode[2][4]=5;
    decode[2][5]=11;
    decode[2][6]=12;
    decode[2][7]=(uint8_t)255;

    decode[3][0]=13;
    decode[3][1]=14;
    decode[3][2]=15;
    decode[3][3]=16;
    decode[3][4]=17;
    decode[3][5]=18;
    decode[3][6]=19;
    decode[3][7]=20;
    decode[3][8]=21;
    decode[3][9]=22;
    decode[3][10]=23;
    decode[3][11]=24;
    decode[3][12]=25;
    decode[3][13]=26;
    decode[3][14]=27;
    decode[3][15]=(uint8_t)254;

    decode[4][0]=28;
    decode[4][1]=29;
    decode[4][2]=30;
    decode[4][3]=31;
    decode[4][4]=32;
    decode[4][5]=33;
    decode[4][6]=34;
    decode[4][7]=35;
    decode[4][8]=36;
    decode[4][9]=37;
    decode[4][10]=38;
    decode[4][11]=39;
    decode[4][12]=40;
    decode[4][13]=41;
    decode[4][14]=42;
    decode[4][15]=43;
    decode[4][16]=44;
    decode[4][17]=45;
    decode[4][18]=46;
    decode[4][19]=47;
    decode[4][20]=48;
    decode[4][21]=49;
    decode[4][22]=50;
    decode[4][23]=51;
    decode[4][24]=52;
    decode[4][25]=53;
    decode[4][26]=54;
    decode[4][27]=55;
    decode[4][28]=56;
    decode[4][29]=57;
    decode[4][30]=58;
    decode[4][31]=59;

    decode[5][0]=60;
    decode[5][1]=61;
    decode[5][2]=62;
    decode[5][3]=63;
    decode[5][4]=64;
    decode[5][5]=65;
    decode[5][6]=66;
    decode[5][7]=67;
    decode[5][8]=68;
    decode[5][9]=69;
    decode[5][10]=70;
    decode[5][11]=71;
    decode[5][12]=72;
    decode[5][13]=73;
    decode[5][14]=74;
    decode[5][15]=75;
    decode[5][16]=76;
    decode[5][17]=77;
    decode[5][18]=78;
    decode[5][19]=79;
    decode[5][20]=80;
    decode[5][21]=81;
    decode[5][22]=82;
    decode[5][23]=83;
    decode[5][24]=84;
    decode[5][25]=85;
    decode[5][26]=86;
    decode[5][27]=87;
    decode[5][28]=88;
    decode[5][29]=89;
    decode[5][30]=90;
    decode[5][31]=91;
    decode[5][32]=92;
    decode[5][33]=93;
    decode[5][34]=94;
    decode[5][35]=95;
    decode[5][36]=96;
    decode[5][37]=97;
    decode[5][38]=98;
    decode[5][39]=99;
    decode[5][40]=100;
    decode[5][41]=101;
    decode[5][42]=102;
    decode[5][43]=103;
    decode[5][44]=104;
    decode[5][45]=105;
    decode[5][46]=106;
    decode[5][47]=107;
    decode[5][48]=108;
    decode[5][49]=109;
    decode[5][50]=110;
    decode[5][51]=111;
    decode[5][52]=112;
    decode[5][53]=113;
    decode[5][54]=114;
    decode[5][55]=115;
    decode[5][56]=116;
    decode[5][57]=117;
    decode[5][58]=118;
    decode[5][59]=119;
    decode[5][60]=120;
    decode[5][61]=121;
    decode[5][62]=122;
    decode[5][63]=123;

    decode[6][0]=124;
    decode[6][1]=125;
    decode[6][2]=126;
    decode[6][3]=127;
    decode[6][4]=(uint8_t)128;
    decode[6][5]=(uint8_t)129;
    decode[6][6]=(uint8_t)130;
    decode[6][7]=(uint8_t)131;
    decode[6][8]=(uint8_t)132;
    decode[6][9]=(uint8_t)133;
    decode[6][10]=(uint8_t)134;
    decode[6][11]=(uint8_t)135;
    decode[6][12]=(uint8_t)136;
    decode[6][13]=(uint8_t)137;
    decode[6][14]=(uint8_t)138;
    decode[6][15]=(uint8_t)139;
    decode[6][16]=(uint8_t)140;
    decode[6][17]=(uint8_t)141;
    decode[6][18]=(uint8_t)142;
    decode[6][19]=(uint8_t)143;
    decode[6][20]=(uint8_t)144;
    decode[6][21]=(uint8_t)145;
    decode[6][22]=(uint8_t)146;
    decode[6][23]=(uint8_t)147;
    decode[6][24]=(uint8_t)148;
    decode[6][25]=(uint8_t)149;
    decode[6][26]=(uint8_t)150;
    decode[6][27]=(uint8_t)151;
    decode[6][28]=(uint8_t)152;
    decode[6][29]=(uint8_t)153;
    decode[6][30]=(uint8_t)154;
    decode[6][31]=(uint8_t)155;
    decode[6][32]=(uint8_t)156;
    decode[6][33]=(uint8_t)157;
    decode[6][34]=(uint8_t)158;
    decode[6][35]=(uint8_t)159;
    decode[6][36]=(uint8_t)160;
    decode[6][37]=(uint8_t)161;
    decode[6][38]=(uint8_t)162;
    decode[6][39]=(uint8_t)163;
    decode[6][40]=(uint8_t)164;
    decode[6][41]=(uint8_t)165;
    decode[6][42]=(uint8_t)166;
    decode[6][43]=(uint8_t)167;
    decode[6][44]=(uint8_t)168;
    decode[6][45]=(uint8_t)169;
    decode[6][46]=(uint8_t)170;
    decode[6][47]=(uint8_t)171;
    decode[6][48]=(uint8_t)172;
    decode[6][49]=(uint8_t)173;
    decode[6][50]=(uint8_t)174;
    decode[6][51]=(uint8_t)175;
    decode[6][52]=(uint8_t)176;
    decode[6][53]=(uint8_t)177;
    decode[6][54]=(uint8_t)178;
    decode[6][55]=(uint8_t)179;
    decode[6][56]=(uint8_t)180;
    decode[6][57]=(uint8_t)181;
    decode[6][58]=(uint8_t)182;
    decode[6][59]=(uint8_t)183;
    decode[6][60]=(uint8_t)184;
    decode[6][61]=(uint8_t)185;
    decode[6][62]=(uint8_t)186;
    decode[6][63]=(uint8_t)187;
    decode[6][64]=(uint8_t)188;
    decode[6][65]=(uint8_t)189;
    decode[6][66]=(uint8_t)190;
    decode[6][67]=(uint8_t)191;
    decode[6][68]=(uint8_t)192;
    decode[6][69]=(uint8_t)193;
    decode[6][70]=(uint8_t)194;
    decode[6][71]=(uint8_t)195;
    decode[6][72]=(uint8_t)196;
    decode[6][73]=(uint8_t)197;
    decode[6][74]=(uint8_t)198;
    decode[6][75]=(uint8_t)199;
    decode[6][76]=(uint8_t)200;
    decode[6][77]=(uint8_t)201;
    decode[6][78]=(uint8_t)202;
    decode[6][79]=(uint8_t)203;
    decode[6][80]=(uint8_t)204;
    decode[6][81]=(uint8_t)205;
    decode[6][82]=(uint8_t)206;
    decode[6][83]=(uint8_t)207;
    decode[6][84]=(uint8_t)208;
    decode[6][85]=(uint8_t)209;
    decode[6][86]=(uint8_t)210;
    decode[6][87]=(uint8_t)211;
    decode[6][88]=(uint8_t)212;
    decode[6][89]=(uint8_t)213;
    decode[6][90]=(uint8_t)214;
    decode[6][91]=(uint8_t)215;
    decode[6][92]=(uint8_t)216;
    decode[6][93]=(uint8_t)217;
    decode[6][94]=(uint8_t)218;
    decode[6][95]=(uint8_t)219;
    decode[6][96]=(uint8_t)220;
    decode[6][97]=(uint8_t)221;
    decode[6][98]=(uint8_t)222;
    decode[6][99]=(uint8_t)223;
    decode[6][100]=(uint8_t)224;
    decode[6][101]=(uint8_t)225;
    decode[6][102]=(uint8_t)226;
    decode[6][103]=(uint8_t)227;
    decode[6][104]=(uint8_t)228;
    decode[6][105]=(uint8_t)229;
    decode[6][106]=(uint8_t)230;
    decode[6][107]=(uint8_t)231;
    decode[6][108]=(uint8_t)232;
    decode[6][109]=(uint8_t)233;
    decode[6][110]=(uint8_t)234;
    decode[6][111]=(uint8_t)235;
    decode[6][112]=(uint8_t)236;
    decode[6][113]=(uint8_t)237;
    decode[6][114]=(uint8_t)238;
    decode[6][115]=(uint8_t)239;
    decode[6][116]=(uint8_t)240;
    decode[6][117]=(uint8_t)241;
    decode[6][118]=(uint8_t)242;
    decode[6][119]=(uint8_t)243;
    decode[6][120]=(uint8_t)244;
    decode[6][121]=(uint8_t)245;
    decode[6][122]=(uint8_t)246;
    decode[6][123]=(uint8_t)247;
    decode[6][124]=(uint8_t)248;
    decode[6][125]=(uint8_t)249;
    decode[6][126]=(uint8_t)250;

    decode[7][0]=(uint8_t)251;
    decode[7][1]=(uint8_t)252;
    decode[7][2]=(uint8_t)253;

    return 1;

}//decode;
// */