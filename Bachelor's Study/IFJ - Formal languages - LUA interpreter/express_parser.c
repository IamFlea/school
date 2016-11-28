/**
 * 
 *      File: express_parser.c
 * 
 *      Subject: IFJ - formalni jazyky a prekladace
 *      Project: Interpret jazyka IFJ11
 *      Part: Precedencni syntakticky analyzator
 *      Team members: Kantor Jiří, xkanto08@stud.fit.vutbr.cz
 *                 Dvořáček Petr, xdvora0n@stud.fit.vutbr.cz
 *                 Kendra Matej, xkendr00@stud.fit.vutbr.cz
 *                 Kyloušek Josef, xkylou00@stud.fit.vutbr.cz
 *                 Čáslava Martin , xcasla03@stud.fit.vutbr.cz
 *      Author: Dvořáček Petr, xdvora0n@stud.fit.vutbr.cz
 */

#include "express_parser.h"
#include "parser.h"
#ifndef RETURN_IF_ERROR
#define RETURN_IF_ERROR if(result!=NO_ERROR){return result;}
#endif

#ifndef RETURN_IF_LEX_ERROR 
#define RETURN_IF_LEX_ERROR if(currentToken.type == T_LEX_ERROR ){return LEX_ERROR;}
#endif

#define RETURN_EXPRESS_SYNTAX_ERR   {printErrorMessage(PRINT_NORMAL, "Error on line %d: Expression expected but \'%s\' was found.\n", currentLine, tokenStrings[op]); return SYNTAX_ERROR;}
#define RETURN_OPERATOR_SYNTAX_ERR  {printErrorMessage(PRINT_NORMAL, "Error on line %d: Operator expected but \'%s\' was found.\n",   currentLine, tokenStrings[op]); return SYNTAX_ERROR;}
#define RETURN_LITERAL_SYNTAX_ERR   {printErrorMessage(PRINT_NORMAL, "Error on line %d: Literal or identifier expected but \'%s\' was found.\n",   currentLine, tokenStrings[op]); return SYNTAX_ERROR;}
// I am not sure that this part of code is death code... 
#define RETURN_INDENT_SYNTAX_ERR    {printErrorMessage(PRINT_NORMAL, "Error on line %d: Start of expression expected but \'%s\' was found.\n", currentLine, tokenStrings[stackTopType(s)]); return SYNTAX_ERROR;}
#define RETURN_LEFT_PAR_SYNTAX_ERR  {printErrorMessage(PRINT_NORMAL, "Error on line %d: Left parenthesis expected but \'%s\' was found.\n",   currentLine, tokenStrings[stackTopType(s)]); return SYNTAX_ERROR;}
#define RETURN_RIGHT_PAR_SYNTAX_ERR {printErrorMessage(PRINT_NORMAL, "Error on line %d: Right parenthesis expected but \'%s\' was found.\n",   currentLine, tokenStrings[stackTopType(s)]); return SYNTAX_ERROR;}
#define RETURN_ID_SYNTAX_ERRROR     {printErrorMessage(PRINT_NORMAL, "Error on line %d: Identifier expected but \'%s\' was found.\n",   currentLine, tokenStrings[stackTopType(s)]); return SYNTAX_ERROR;}

/*  Express parsing states. */
enum expParseStates {
    // Parsing states
    R , // Reduce from stack
    S , // Shift
    P , // Special shift

    // Error states. 
    E0 = -5 , // UNKNOWN ERROR
    E1 = -4 , // Missing right parenthesis: ).
    E2 = -3 , // Missing operator.
    E3 = -2 // Missing left parenthesis: (.

};

/* Terminals used in the table... */
enum terminals {
    TT_ERROR = -1 , // ...except this one. It's an error terminal.
    TT_PLUS_MINUS = 0 ,
    TT_MULT_DIV_MOD ,
    TT_POW ,
    TT_CONCAT ,
    TT_UNARY_OPERATOR ,
    TT_EQU ,
    TT_AND ,
    TT_OR ,
    TT_LEFT_PAREN ,
    TT_RIGHT_PAREN ,
    TT_COMMA ,
    TT_ID ,
    TT_END_OF_EXPRESSION ,
    TT_SIZE_OF_TABLE // used as size of parseTable
};


/* Look up table 
 * I have small screen, sorry I cant do table sized 50x50...
 * And I think this solution is better to understand.
 * Some operations (i. e. multiply and divide) are similar. They have same
 * priority and they are binary operators...
 * 
 * I look in this table (array) on an index which stands some TokenType.
 * The result is used as an argument in the parse table. :)
 * If I explain this situation bad, please ask me...
 */
const int lookUpTable [] = {
    // TERMINALS          TOKEN TYPE
    // -----------------------------------
    // End of file token
    TT_ERROR , // T_EOF = 0,

    //Operators
    TT_PLUS_MINUS , // T_PLUS,
    TT_PLUS_MINUS , // T_MINUS,
    TT_MULT_DIV_MOD , // T_MULT,
    TT_MULT_DIV_MOD , // T_DIV,
    TT_MULT_DIV_MOD , // T_MOD,
    TT_POW , // T_POW,
    TT_CONCAT , // T_CONCAT,
    TT_EQU , // T_EQU,
    TT_EQU , // T_NOT_EQU,
    TT_EQU , // T_LESS,
    TT_EQU , // T_GREATER,
    TT_EQU , // T_LESS_EQU,
    TT_EQU , // T_GREATER_EQU,
    TT_ERROR , // T_ASSIGN,

    //Various symbols
    TT_LEFT_PAREN , // T_LEFT_PAREN,
    TT_RIGHT_PAREN , // T_RIGHT_PAREN,
    TT_ERROR , // T_SEMICOLON,
    TT_COMMA , // T_COMMA,

    //Literals
    TT_ID , // T_NUMBER,
    TT_ID , // T_STRING,
    TT_ID , // T_TRUE,
    TT_ID , // T_FALSE,

    //Identifier
    TT_ID , // T_ID,

    //Keywords and reserved words
    TT_ERROR , // T_IF,
    TT_ERROR , // T_THEN,
    TT_ERROR , // T_ELSE,
    TT_ERROR , // T_ELSEIF,
    TT_ERROR , // T_WHILE,
    TT_ERROR , // T_DO,
    TT_ERROR , // T_FUNCTION,
    TT_ERROR , // T_RETURN,
    TT_ERROR , // T_END,

    TT_ERROR , // T_LOCAL,
    TT_ID , // T_NIL,
    TT_ERROR , // T_READ,
    TT_ERROR , // T_WRITE,

    TT_AND , // T_AND,
    TT_OR , // T_OR,
    TT_UNARY_OPERATOR , // T_NOT,
    TT_END_OF_EXPRESSION , // T_END_OF_EXPRESSION
    TT_ERROR , // T_INDENT
    TT_UNARY_OPERATOR , // T_UNARY_MINUS
    TT_ERROR , // T_EXPRESSION
    TT_ERROR // T_FUNCTION_ARGUMENTS // it is an expression! 
}; // lookUpTable

/* Decide which state will be via this parsing table. 
 * Size of table is defined as TT_END_OF_EXPRESSION + 1 = TT_SIZE_OF_TABLE
 */
const int parseTable [TT_SIZE_OF_TABLE] [TT_SIZE_OF_TABLE] = {
    /* STACK /                    INPUT TOKEN                 */
    /*       /  +-  *%/ ^   ..  Uop ==  and or  (   )   ,   i   $ */
    /* +-   */
    {R , S , S , R , S , R , R , R , S , R , R , S , R } ,
    /* *%/  */
    {R , R , S , R , S , R , R , R , S , R , R , S , R } ,
    /* ^    */
    {R , R , S , R , R , R , R , R , S , R , R , S , R } ,
    /* ..   */
    {S , S , S , R , S , R , R , R , S , R , R , S , R } ,
    /* Uop  */
    {R , R , S , R , S , R , R , R , S , R , R , S , R } ,
    /* ==   */
    {S , S , S , S , S , R , R , R , S , R , R , S , R } ,
    /* AND  */
    {S , S , S , S , S , S , R , R , S , R , R , S , R } ,
    /* OR   */
    {S , S , S , S , S , S , S , R , S , R , R , S , R } ,
    /* (    */
    {S , S , S , S , S , S , S , S , S , P , S , S , E1 } ,
    /* )    */
    {R , R , R , R , R , R , R , R , E2 , R , R , E2 , R } ,
    /* ,    */
    {S , S , S , S , S , S , S , S , S , R , S , S , E1 } ,
    /* i    */
    {R , R , R , R , R , R , R , R , P , R , R , E2 , R } ,
    /* $    */
    {S , S , S , S , S , S , S , S , S , E3 , E3 , S , E0 }
};

/**
 * This function uses some predefined rule on operator.
 * There are four rules. 
 *   1] Literals + identifier:          E = id
 *      Exchanges id for an expression E.
 *      BTW: op in my code means identifier too.
 * 
 *   2] Unary operators:                E = op E
 *      Exchange "op E" for an expression E.
 * 
 *   3] Binary operators:               E = E op E
 *      Exchange "E op E" for an expression E.
 * 
 *   4] Special rule for parenthesis:   E = ( E )
 *      Exchange "( E )" for an expression E.
 *      
 *   5] Function rules:                 E = id()
 *                                      E = id(E)
 *                                      E = id(L)
 *                                      L = E , E 
 *                                      L = E , L
 * 
 * Used rule is written in the rightParse as a token for later usage.
 * If the rule was the parenthesis, it is written in rightParse as token that type is T_LEFT_PARENTHESIS.
 * 
 * @param s             stack
 * @param t             operator token
 * @param rightParse    Used rules.
 * @return              Errors if occur.
 */
int reduce( Stack* s , Token t , Stack* rightParse ) {
#ifdef EXPRESS_PARSER_INTEGRATION
    char c;
#endif
    int result;
    int expressType;
    int op = t.type;

    static int paramsParsed = 0;

    LocalSymbolPtr var = NULL;
    FunctionPtr fun = NULL;

    switch( op ) {
            // LITERALS + IDENTIFIER
        case T_ID:
        case T_STRING:
        case T_NUMBER:
        case T_FALSE:
        case T_TRUE:
        case T_NIL:

            switch( t.type ) {
                case T_ID:
                    if( ( var = localTableSearch( currentFunction -> localSyms , t.attribute.id ) ) == NULL && ( fun = funcTableSearch( globalSymTable , t.attribute.id ) ) == NULL ) {
                        printErrorMessage( PRINT_NORMAL , "Error on line %d: Undeclared identifier \'%s\'.\n" , currentLine , stringGet( t.attribute.id ) );
                        return SEMANTIC_ERROR;
                    }

                    if( var != NULL ) {
                        result = generateInstruction( I_VARS_TO_COUNT , var -> index , 0 );
                        RETURN_IF_ERROR;
                        stringFree( &( t.attribute.id ) );
                    }
                    break;
                default:
                    result = listAddConstant( constsList , &t );
                    RETURN_IF_ERROR;
                    result = generateInstruction( I_CONST_TO_COUNT , listGetCurrentIndex( constsList ) , 0 );
                    RETURN_IF_ERROR;
                    break;

            }


            if( stackTopType( s ) == op ) // Is on the top operator?
                stackPop( s ); // Pop it.
            else
                RETURN_LITERAL_SYNTAX_ERR;

            if( stackTopIndent( s ) ) // Is on the top indent?
                stackTopChangeIndentForExpress( s ); // Change it.
            else
                RETURN_INDENT_SYNTAX_ERR;

            result = stackPush( rightParse , t ); // Add used rule
            RETURN_IF_ERROR;

            break;

            // UNARY OPERATORS
        case T_NOT:
        case T_UNARY_MINUS: // Unary_minus == - 

            if( op == T_NOT ) {
                result = generateInstruction( I_NOT , 0 , 0 );
                RETURN_IF_ERROR;
            } else {
                result = generateInstruction( I_NEG , 0 , 0 );
                RETURN_IF_ERROR;
            }

            if( stackTopType( s ) == T_EXPRESSION ) // Is on the top expression?
                stackPop( s ); // Pop it.
            else
                RETURN_EXPRESS_SYNTAX_ERR;

            if( stackTopType( s ) == op ) // Is on the top operator?
                stackPop( s ); // Pop it.
            else
                RETURN_OPERATOR_SYNTAX_ERR;

            if( stackTopIndent( s ) ) // Is on the top an indent?
                stackTopEditIndent( s , T_EXPRESSION ); // Change it for an expression.
            else
                RETURN_INDENT_SYNTAX_ERR;
            result = stackPush( rightParse , t ); // Add used rule
            RETURN_IF_ERROR;

            break;

            // Stack: binary operators
        case T_AND:
        case T_CONCAT:
        case T_DIV:
        case T_EQU:
        case T_GREATER:
        case T_GREATER_EQU:
        case T_LESS:
        case T_LESS_EQU:
        case T_MINUS:
        case T_MOD:
        case T_MULT:
        case T_NOT_EQU:
        case T_OR:
        case T_PLUS:
        case T_POW:
            switch( op ) {
                case T_AND:
                    result = generateInstruction( I_AND , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_CONCAT:
                    result = generateInstruction( I_CONC , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_DIV:
                    result = generateInstruction( I_DIV , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_EQU:
                    result = generateInstruction( I_EQU , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_GREATER:
                    result = generateInstruction( I_GR , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_GREATER_EQU:
                    result = generateInstruction( I_GR_EQU , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_LESS:
                    result = generateInstruction( I_LESS , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_LESS_EQU:
                    result = generateInstruction( I_LESS_EQU , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_MINUS:
                    result = generateInstruction( I_SUB , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_MOD:
                    result = generateInstruction( I_MOD , 0 , 0 );
                    RETURN_IF_ERROR;                    
                    break;
                case T_MULT:
                    result = generateInstruction( I_MUL , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_NOT_EQU:
                    result = generateInstruction( I_NEQU , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_OR:
                    result = generateInstruction( I_OR , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_PLUS:
                    result = generateInstruction( I_ADD , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
                case T_POW:
                    result = generateInstruction( I_POW , 0 , 0 );
                    RETURN_IF_ERROR;
                    break;
            }

            if( stackTopType( s ) == T_EXPRESSION ) // Is on the top Expression?
                stackPop( s ); // Pop it
            else
                RETURN_EXPRESS_SYNTAX_ERR;

            if( stackTopType( s ) == op ) // Is on the top operator?
                stackPop( s ); // Pop it
            else
                RETURN_OPERATOR_SYNTAX_ERR;

            if( stackTopType( s ) == T_EXPRESSION ) // Is on the top Expression?
                stackPop( s ); // Pop it
            else
                RETURN_EXPRESS_SYNTAX_ERR;

            if( stackTopIndent( s ) )
                stackTopEditIndent( s , T_EXPRESSION ); // Change it for an expression.
            else
                RETURN_INDENT_SYNTAX_ERR;


            result = stackPush( rightParse , t ); // Add used rule
            RETURN_IF_ERROR;
            break;

            // EXPRESSIONS IN FUNCTIONS
        case T_COMMA:
            expressType = stackTopType( s ); // Temp variable.

            result = generateInstruction( I_COUNT_TO_PARAMS , 0 , 0 );
            RETURN_IF_ERROR;

            paramsParsed++;

            if( expressType == T_EXPRESSION ) { // Is on the top Expression?
                stackPop( s ); // Pop it
            } else if( expressType == T_FUNCTION_ARGUMENTS ) { // This is an expression too. But those Expressions were used during 
                stackPop( s );
            } else
                RETURN_EXPRESS_SYNTAX_ERR;

            if( stackTopType( s ) == T_COMMA ) { // Operator
                stackPop( s );
            } else
                RETURN_OPERATOR_SYNTAX_ERR;

            if( stackTopType( s ) == T_EXPRESSION ) { // Is on the top Expression?
                stackPop( s ); // Pop it
            } else
                RETURN_EXPRESS_SYNTAX_ERR;


            if( stackTopIndent( s ) ) {
                stackTopEditIndent( s , T_FUNCTION_ARGUMENTS ); // Change it for an expression.
            } else
                RETURN_INDENT_SYNTAX_ERR;



            result = stackPush( rightParse , t ); // Add used rule....
            // There are two situations!!! I DO NOT MAKE A DIFFERENCE!
            // Semantic analyze should do!....
            // E, E => L
            // E, L => E
            // viz top of this case
            RETURN_IF_ERROR;

            break;

            // PARENTHESIS
            // There are few different types of usage of parenthesis
            //
            // EXPRESSION
            // Stack:
            // BOT>+---+---+---+---+<TOP
            //     | < | ( | E | ) | 
            //     +---+---+---+---+
            //
            // EMPTY FUNCTIONS  (Function with ε rule)
            // Stack:
            // BOT>+---+----+---+---+<TOP
            //     | < | id | ( | ) | 
            //     +---+----+---+---+
            // 
            // FUNCTIONS WITH ONE ARGUMENT
            // Stack:
            // BOT>+---+----+---+---+---+<TOP
            //     | < | id | ( | E | ) |
            //     +---+----+---+---+---+
            // 
            // FUNCTIONS WITH TWO OR MORE ARGUMENTS
            // Stack:
            // BOT>+---+----+---+---+---+<TOP
            //     | < | id | ( | L | ) |
            //     +---+----+---+---+---+
            // 

        case T_RIGHT_PAREN:
            /*
            printf("RIGHTPAREN\n");
            while(! stackTopIndent(s))
                stackPop(s);

            stackTopChangeIndentForExpress(s);
             */
            // 1 token
            if( stackTopType( s ) == T_RIGHT_PAREN ) // Is on the top right parenthesis?
                stackPop( s ); // Pop it
            else
                RETURN_RIGHT_PAR_SYNTAX_ERR;

            // 2 token            
            bool call = stackTopType( s ) != T_EXPRESSION;
            
            if( stackTopType( s ) >= T_EXPRESSION ) // Is on the top expression?
                stackPop( s ); // Pop it
            else if( stackTopType( s ) == T_LEFT_PAREN )
                stackPop( s );
            else
                RETURN_EXPRESS_SYNTAX_ERR

                    // 3 token
                if( stackTopType( s ) == T_LEFT_PAREN ) // Is on the top left parenthesis?
                stackPop( s ); // Pop it
            else if( stackTopType( s ) == T_ID ) {
                stackTop( s , &t ); //Its a function name so we save it.    
                stackPop( s );
            } else if( lookUpTable[stackTopType( s )] == TT_ID )
                RETURN_ID_SYNTAX_ERRROR
            else
                RETURN_LEFT_PAR_SYNTAX_ERR

                if( stackTopIndent( s ) ) // There is an indent.
            {

                if( call ) {
                    if( ( fun = funcTableSearch( globalSymTable , t.attribute.id ) ) == NULL ) {
                        
                        if( stringCompareConst( t.attribute.id , "type" ) == 0 ) {
                            result = generateInstruction( I_TYPE , paramsParsed , 0 );
                            RETURN_IF_ERROR;                            
                        } else if( stringCompareConst( t.attribute.id , "substr" ) == 0 ) {
                            result = generateInstruction( I_SUBSTR , paramsParsed , 0 );
                            RETURN_IF_ERROR;                            
                        } else if( stringCompareConst( t.attribute.id , "find" ) == 0 ) {
                            result = generateInstruction( I_FIND , paramsParsed , 0 );
                            RETURN_IF_ERROR;                            
                        } else if( stringCompareConst( t.attribute.id , "sort" ) == 0 ) {
                            result = generateInstruction( I_SORT , paramsParsed , 0 );
                            RETURN_IF_ERROR;                            
                        } else {
                            if( localTableSearch( currentFunction -> localSyms , t.attribute.id ) ) {
                                printErrorMessage( PRINT_NORMAL , "Error on line %d: '%s', which is a variable, is being called.\n" , currentLine , stringGet( t.attribute.id ) );
                            } else {
                                printErrorMessage( PRINT_NORMAL , "Error on line %d: Identifier '%s' undeclared.\n" , currentLine , stringGet( t.attribute.id ) );
                            }
                            return SEMANTIC_ERROR;
                        }
                    } else {
                        result = generateInstruction( I_CALL , fun -> index , paramsParsed );
                        RETURN_IF_ERROR;
                    }
                    stringFree( &( t.attribute.id ) );
                    paramsParsed = 0;
                }

                stackTopChangeIndentForExpress( s ); // Change it with express.

                //result = stackPush(rightParse, t);// Add used rule
                //RETURN_IF_ERROR;                  // Don't need to use rule because the parse right should be OK... :))
            } else { // Maybe it is a function!!
                if( ( !stackEmpty( s ) ) && stackTopType( s ) == T_ID ) { // Hmm, that is nice!
                    stackTop( s , &t ); // Save an id 
                    stackPop( s ); // Pop it!
                    if( stackTopIndent( s ) ) // There is an indent.
                    {

                        result = generateInstruction( I_COUNT_TO_PARAMS , 0 , 0 );
                        paramsParsed++;
                        if( ( fun = funcTableSearch( globalSymTable , t.attribute.id ) ) == NULL ) {
                            if( stringCompareConst( t.attribute.id , "type" ) == 0 ) {
                                result = generateInstruction( I_TYPE , paramsParsed , 0 );
                                RETURN_IF_ERROR;                            
                            } else if( stringCompareConst( t.attribute.id , "substr" ) == 0 ) {
                                result = generateInstruction( I_SUBSTR , paramsParsed , 0 );
                                RETURN_IF_ERROR;                            
                            } else if( stringCompareConst( t.attribute.id , "find" ) == 0 ) {
                                result = generateInstruction( I_FIND , paramsParsed , 0 );
                                RETURN_IF_ERROR;                            
                            } else if( stringCompareConst( t.attribute.id , "sort" ) == 0 ) {
                                result = generateInstruction( I_SORT , paramsParsed , 0 );
                                RETURN_IF_ERROR;                            
                            } else {
                                if( localTableSearch( currentFunction -> localSyms , t.attribute.id ) ) {
                                    printErrorMessage( PRINT_NORMAL , "Error on line %d: '%s', which is a variable, is being called.\n" , currentLine , stringGet( t.attribute.id ) );
                                } else {
                                    printErrorMessage( PRINT_NORMAL , "Error on line %d: Identifier '%s' undeclared.\n" , currentLine , stringGet( t.attribute.id ) );
                                }
                                return SEMANTIC_ERROR;
                            }
                        } else {
                            result = generateInstruction( I_CALL , fun -> index , paramsParsed );
                            RETURN_IF_ERROR;
                        }
                        stringFree( &( t.attribute.id ) );
                        paramsParsed = 0;

                        stackTopChangeIndentForExpress( s );
                    } else
                        RETURN_INDENT_SYNTAX_ERR;
                } else {
                    printErrorMessage( PRINT_NORMAL , "Error on line %d: Identifier expected but \"%s\" was found." , currentLine , tokenStrings[stackTopType( s )] );
                    return SYNTAX_ERROR;
                }
            }
            break;

        default:
            printErrorMessage( PRINT_PERROR , "Unknown error - run away!" );
            return SYSTEM_ERROR;
            break;
    }/* switch */

    return NO_ERROR;
}/* function */

/**
 * Add indent before the topmost terminal. Not before an expression!
 * Pushes a token into the stack and reads next toke from queue.
 * 
 * @param q     queue
 * @param s     stack
 * @param a     input token
 * @return      system errors if occurs, true if OK
 */
int shift( TokenQueue* q , Stack *s , Token *a ) {
    Token t;
    int result;

    result = stackPushIndent( s ); // Add < (indent)
    RETURN_IF_ERROR;

    result = stackPush( s , *a ); // Push a type of token
    RETURN_IF_ERROR;

    if( !tokenQueueEmpty( q ) ) { // Is queue empty?
        t = tokenQueuePop( q ); // Read next token in queue
        a->type = t.type;
        switch( t.type ) {
            case T_ID:
                a->attribute.id = t.attribute.id;
                break;
            case T_NUMBER:
                a->attribute.num_value = t.attribute.num_value;
                break;
            case T_STRING:
                a->attribute.string = t.attribute.string;
                break;
            default:
                break;
        }
    } else
        a->type = T_END_OF_EXPRESSION; // $

    return NO_ERROR;
}

/**
 * Pushes a token into the stack and reads next token from queue.
 * This function is similar to shift()
 * 
 * @param q     queue
 * @param s     stack
 * @param a     token
 * @return      system error if occurs
 */
int specialShift( TokenQueue* q , Stack *s , Token* a ) {
    Token t;
    int result;

    result = stackPush( s , *a ); // Push a type of token
    RETURN_IF_ERROR;

    if( !tokenQueueEmpty( q ) ) { // Is queue empty?
        t = tokenQueuePop( q ); // Read next token in queue
        a->type = t.type;
        switch( t.type ) {
            case T_ID:
                a->attribute.id = t.attribute.id;
                break;
            case T_NUMBER:
                a->attribute.num_value = t.attribute.num_value;
                break;
            case T_STRING:
                a->attribute.string = t.attribute.string;
                break;
            default:
                break;
        }
    } else
        a->type = T_END_OF_EXPRESSION; // $

    return NO_ERROR;
}


/**
 * Operator-Precedence parsing
 * @param Token *T              Array of Tokens
 * @param char *rightParse      Array of Used rules
 * @return                      error_type, true if success
 */
int _parseExpression( Stack* s , TokenQueue* q , Stack* rightParse ) {

    int a_table , b_table , result;
    Token a; // INPUT TOKEN
    Token b; // STACK TOPMOST TERMINAL TOKEN

    result = stackInit( s );
    RETURN_IF_ERROR;

    a.type = T_END_OF_EXPRESSION; // Push END OF EXPRESSION into the stack 
    result = stackPush( s , a );
    RETURN_IF_ERROR;

    a = tokenQueuePop( q ); // Read first input token

    while( 1 ) {
        stackTopmostTerminal( s , &b ); // B = stack top terminal
        a_table = lookUpTable[a.type]; // Look in the table for a;
        b_table = lookUpTable[b.type]; // Look in the table for b;

        //assert(b_table != TT_ERROR);    // Because token a is input token that is saving into the stack later... 
        if( a_table == TT_ERROR ) { // And in the stack are not error tokens :)
            printErrorMessage( PRINT_NORMAL , "Error on line %d: Unexpected token \"%s\"\n" , currentLine , tokenStrings[a.type] );
            return SYNTAX_ERROR;
        }

        switch( parseTable[b_table] [a_table] ) { // Wise table, tell me what to do?
                // SHIFTING??
            case S:
                result = shift( q , s , &a );
                RETURN_IF_ERROR;
                break;

                // SPECIAL SHIFT??
            case P:
                result = specialShift( q , s , &a );
                RETURN_IF_ERROR;
                break;

                // REDUCING??
            case R:
                result = reduce( s , b , rightParse );
                RETURN_IF_ERROR;
                break;
                // ERRORS? 
            case E1:
                printErrorMessage( PRINT_NORMAL , "Error on line %d: Missing right parenthesis \")\" in expression.\n" , currentLine );
                return SYNTAX_ERROR;
                break;

            case E2:
                printErrorMessage( PRINT_NORMAL , "Error on line %d: Missing operator in expression.\n" , currentLine );
                return SYNTAX_ERROR;
                break;

            case E3:
                printErrorMessage( PRINT_NORMAL , "Error on line %d: Missing left parenthesis \"(\" in expression.\n" , currentLine );
                return SYNTAX_ERROR;
                break;

            default:
                printErrorMessage( PRINT_NORMAL , "Unknown error.\n" );
                return SYSTEM_ERROR;
                break;
        } // end switch


        stackTopmostTerminal( s , &b ); // B = stack top terminal

        a_table = lookUpTable[a.type]; // Look in the table for a;
        b_table = lookUpTable[b.type]; // Look in the tabel for b;
        if( a_table == -1 || b_table == -1 ) {
            printErrorMessage( PRINT_NORMAL , "Error on line %d: Unexpected token %s.\n" , currentLine , tokenStrings[a.type] );
            return SYNTAX_ERROR;
        }

        if( a_table == TT_END_OF_EXPRESSION && b_table == TT_END_OF_EXPRESSION ) // This condition is without comment :)
            break;
    } // end while(1)
    return NO_ERROR;
} /* end of function int _expressParse() */

/**
 * Operator-Precedence parsing
 * @param endToken      Until which token do u want to parse?
 * @return              error_code 
 */
int parseExpression( int endToken1 , int endToken2 ) {
    Stack s;
    Stack rightParse;
    int result;
    //int temp;           // For TT_LITERAL
    int previousTokenType = T_END_OF_EXPRESSION; // Neco to musi byt... 
    TokenQueue q = {
        .first = NULL ,
        .last = NULL
    };
    int depth = 0;
    Token currentToken;

    while( 1 ) {
        currentToken = getNextToken( );
        RETURN_IF_LEX_ERROR;

        if( ( currentToken.type == endToken1 || currentToken.type == endToken2 ) && depth <= 0 ) {
            returnToken( currentToken );
            break;
        } else if( currentToken.type == T_EOF ) {
            printErrorMessage( PRINT_NORMAL , "Error on line %d: Unexpected end of file.\n" , currentLine );
            return SYNTAX_ERROR;
        } else if( currentToken.type == T_MINUS ) {
            previousTokenType = lookUpTable[previousTokenType];
            if( previousTokenType != TT_ID && previousTokenType != TT_RIGHT_PAREN )
                currentToken.type = T_UNARY_MINUS;
        } else if( currentToken.type == T_LEFT_PAREN ) {
            depth++;
        }
        else if( currentToken.type == T_RIGHT_PAREN ) {
            depth--;
        } else if( currentToken.type == T_WRITE ) {
            currentToken.type = T_ID;
            stringInit( &( currentToken.attribute.id ) );
            stringCopyConst( currentToken.attribute.id , "write" );
        }

        result = tokenQueuePush( &q , currentToken );
        RETURN_IF_ERROR;
        previousTokenType = currentToken.type;
    }

    if( tokenQueueEmpty( &q ) ) {
        printErrorMessage( PRINT_NORMAL , "Error on line %d: Expression expected but \'%s\' found.\n" , currentLine , tokenStrings[ currentToken.type ] );
        return SYNTAX_ERROR;
    }
    result = stackInit( &rightParse );
    RETURN_IF_ERROR;
    result = _parseExpression( &s , &q , &rightParse );
    RETURN_IF_ERROR;
  
    stackDispose( &s );
    stackDispose( &rightParse );
    disposeTokenQueue( &q );
    return result; // finished
}
