/**
 * 
 *      File: expparser_stack.c
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
#include "expparser_stack.h"

////////////////////////////////////////////////////////////////////////////////
// Main functions.

/**
 * Initialization stack of tokens.
 * The stack will be ready to use after call this function.
 * Allocate memory of INITAL_MALLOC_SIZE byte for an array tokens. 
 * @param s     Stack
 * @return      Errors
 */
int   stackInit(Stack *s) {
    s->top    = -1;
    s->length = INITIAL_MALLOC_SIZE;
    s->arrTkn = NULL;
    
    Token *temp = (Token *) malloc (s->length * sizeof(Token));
    if (temp == NULL) {
        printErrorMessage(PRINT_PERROR , "Allocation error");
        return SYSTEM_ERROR;
    }
    s->arrTkn = temp;

    return NO_ERROR;
}

/**
 * Disposes the stack.
 * This function frees allocated memory. You can not work with the stack after 
 * call... Only thing that you can do is call stackInit(Stack* s);
 * @param s Stack
 */
void  stackDispose(Stack *s) {
    free(s->arrTkn);
    s->arrTkn = NULL;
} 

/**
 * Is stack empty?
 * @param s     Stack
 * @return      True if does, otherwise false.
 */
int   stackEmpty(Stack *s) {
    return(s->top == -1);
}

/**
 * Is stack Full?
 * @param s     Stack
 * @return      True if does, otherwise false.
 */
int   stackFull(Stack *s) {
    return(s->top == (s->length - 1));
}

/**
 * Stack data reallocation.
 * Usage of this function is only at this file. It is a private function.
 * Reallocate array of tokens. The memory of allocated place will be increased 
 * double time.
 * @param s     stack
 * @return      errors
 */
int   stackRealloc(Stack* s) {
    s->length = s->length * 2; // Double time bigger
    s->arrTkn = (Token *) realloc (s->arrTkn, s->length * sizeof(Token));
    
    if(s->arrTkn == NULL) {
        free(s->arrTkn);
        printErrorMessage(PRINT_PERROR , "Allocation error");
        return SYSTEM_ERROR;
    }
    return NO_ERROR; 
}

/**
 * It pushes the token into the stack.
 * If the stack is full, calls for stack reallocation. 
 * @param s     stack
 * @param t     token
 * @return      true if success; false if allocation error;
 */
int   stackPush(Stack *s, Token t) {
    int result = NO_ERROR;
    if(stackFull(s))
        result = stackRealloc(s);
    
    
    if(result == NO_ERROR) {
        s->top++;   // Increment top
        // Write data into the stack... This is really messy... :(
        // Do not blame to me... I don't have scanner part. :)
        // But never mind. 
        (s->arrTkn[s->top]).type                 = t.type;
        (s->arrTkn[s->top]).attribute            = t.attribute;
    }
    return result;
}

/**
 * This function pop the stack. 
 * It decrements stack's top. 
 * Warning: Stack can't be empty!
 * @param s
 */
void  stackPop(Stack *s) {
    s->top--;
}

/**
 * Saves token type from stack top.
 * Warning: Stack can't be empty!
 * @param s     stack
 * @param t     token with saved type
 */
void  stackTop(Stack *s, Token* t) {
    t->type                  = (s->arrTkn[s->top]).type;
    t->attribute             = (s->arrTkn[s->top]).attribute;
}



////////////////////////////////////////////////////////////////////////////////
// Additional functions used in: express_parser.c

/**
 * What type of token is on the stack top?
 * @param s     stack
 * @return      type of token
 */
int   stackTopType(Stack *s) {
    return ((s->arrTkn[s->top]).type);
}

/**
 * Is on the stack top an indent?
 * @param s     stack
 * @return      true if does
 */
int   stackTopIndent(Stack* s){
    return (stackTopType(s) == T_INDENT);
    
}
/**
 * Edit the token on the top of stack.
 * @param s     Stack
 * @param t     Token that will be on the top
 */
void  stackTopEdit(Stack *s, Token t) {
    (s->arrTkn[s->top]).type                 = t.type;
    (s->arrTkn[s->top]).attribute            = t.attribute;

}


/**
 * What is the type of top terminal in the stack?
 * @param s     stack
 * @param t     returned type
 */
void  stackTopmostTerminal(Stack *s, Token *t) {
    int i = s->top;
    while(i >= 0) {
        // Expression and indent are not Terminals!
        if((s->arrTkn[i]).type != T_EXPRESSION && (s->arrTkn[i]).type != T_INDENT && (s->arrTkn[i]).type != T_FUNCTION_ARGUMENTS) {
            t->type                     = (s->arrTkn[i]).type; 
            t->attribute                = (s->arrTkn[i]).attribute;
            return;
        }
        i--;    // Decrement counter of while.
    }
    
}

/**
 * Edit top of stack. There will be expression instead of indent.
 * If there is not an indent, do nothing.
 * @param s     Stack
 */
void stackTopChangeIndentForExpress(Stack *s) {
    Token t = {
        .type = T_EXPRESSION
    };
    
    if(stackTopIndent(s))
        stackTopEdit(s, t);
}

/**
 * Pushes the expression into the stack.
 * @param s     Stack
 * @return      true if success, false if allocation error
 */
int   stackPushExpression(Stack *s) {
    Token t = {
        .type = T_EXPRESSION
    };
    return stackPush(s, t);
}

/**
 * Pushes an indent into the stack. Skip Expression if occurs.
 * Input  stack: $ E
 * Output stack: $[ E
 * Explanation is in the express_parser.c
 * @param s     Stack
 * @return      errors;
 */
int   stackPushIndent(Stack *s) {
    Token t = {
        .type = T_INDENT
    };
    if(stackTopType(s) != T_EXPRESSION)
        return stackPush(s, t);
    else {
        stackTopEdit(s, t);                 // There is an expression...
        return stackPushExpression(s);
    }
}

/**
 * Changes on the stack top an indent for an expression.
 * Indent -> EXP
 * @param s             Stack
 * @param type          Type of expression
 */
void stackTopEditIndent(Stack* s, int type){
    Token tmp;
    tmp.type = type;
    stackTopEdit(s, tmp);
}
