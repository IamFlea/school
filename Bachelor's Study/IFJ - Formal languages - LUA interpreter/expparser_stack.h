/**
 * 
 *      File: expparser_stack.h
 * 
 *      Subject: IFJ - formalni jazyky a prekladace
 *      Project: Interpret jazyka IFJ11
 *      Part: Zasobnik pro precencni syntakticky analyzator
 *      Team members: Kantor Jiří, xkanto08@stud.fit.vutbr.cz
 *                 Dvořáček Petr, xdvora0n@stud.fit.vutbr.cz
 *                 Kendra Matej, xkendr00@stud.fit.vutbr.cz
 *                 Kyloušek Josef, xkylou00@stud.fit.vutbr.cz
 *                 Čáslava Martin , xcasla03@stud.fit.vutbr.cz
 *      Author: Dvořáček Petr, xdvora0n@stud.fit.vutbr.cz
 * 
 */

//#define STACK_UNIT_TEST                 // Do you want to turn on tests? 
//#define SHOW_ATTRIBUTE                // Do you want show attributes during testing?


#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include "main.h"
#include "string.h"
#include "scanner.h"
#include "error.h"

typedef struct {
    int top;
    int length;
    Token* arrTkn;
} Stack;

//#define STACK_UNIT_TEST
//#define SHOW_ATTRIBUTE


#define INITIAL_MALLOC_SIZE 8

////
// For description of functions please visit: stack.c 
// Main functions for work with stack.
int   stackInit(Stack *s);
void  stackDispose(Stack *s);
int   stackEmpty(Stack *s);
int   stackFull(Stack *s);
int   stackPush(Stack *s, Token t);
void  stackPop(Stack *s);
void  stackTop(Stack *s, Token* t);

// Additional useful functions.
int   stackTopType(Stack *s);
void  stackTopEdit(Stack *s, Token t);
int   stackTopIndent(Stack *s);
void  stackTopChangeIndentForExpress(Stack *s);
int   stackTopExpression(Stack *s);
void  stackTopmostTerminal(Stack *s, Token *Type);
int   stackPushIndent(Stack *s);
int   stackPushExpression(Stack *s);
void  stackTopEditIndent(Stack* s, int type);

// Function for debugging. 
void  stackPrint(Stack *s);
