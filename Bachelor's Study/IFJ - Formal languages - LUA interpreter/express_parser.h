/**
 * 
 *      File: express_parser.h
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

#ifndef EXPRESS_PARSER_H
#define	EXPRESS_PARSER_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

#include "error.h"      // Printing errors
#include "main.h"       // Token types
#include "queue.h"      // Input queue
#include "expparser_stack.h"      
#include "string.h"

/**
 * The description of this algorithm would be hard. So I made an easy example 
 * of this.
 * 
 * EXAMPLE OF ALGORITHM
 * ====================
 * Lets id and n are literals, + and * operators, $ define end of expression.
 * E is expression.
 * 
 * a means INPUT TOKEN. 
 * b means TOPMOST OPERATOR IN STACK! Expression is not an operator!
 * State is determined in parseTable[a][b]
 * 
 * What the fuck is the left bracket in the stack "[" ???
 * It is an indent added during state of shit, I meant shift... It's added 
 * before an operator. Expression is not an operator! 
 * 
 * Ok, lets see
 * There is an expression: id + id * n
 * 
 * Iter. |    Input      | Stack           | a   |  b  | state  |    Rule
 * ------+---------------+-----------------+-----+-----+--------+-------------
 * 1st   | id + id * n $ | $               | id  | $   | shift  |
 * 2nd   | + id * n $    | $[ id           | +   | id  | reduce | id  -> E
 * 3rd   | + id * n $    | $ E             | +   | $   | shift  |
 * 4th   | id * n $      | $[ E +          | id  | +   | shift  |
 * 5th   | * n $         | $[ E +[ id      | *   | id  | reduce | id  -> E
 * 6th   | * n $         | $[ E + E        | *   | +   | shift  |
 * 7th   | n $           | $[ E +[ E *     | n   | *   | shift  |
 * 8th   | $             | $[ E +[ E *[ n  | $   | id  | reduce | id  -> E
 * 9th   | $             | $[ E +[ E * E   | $   | *   | reduce | mul -> E * E
 * 10th  | $             | $[ E + E        | $   | +   | reduce | add -> E + E
 * 11th  | $             | $ E             | $   | $   | end    |
 * 
 * 
 * 
 * Special shift
 * 
 * There is another expression: (id + id) * n
 * 
 * Iter. |    Input      | Stack           | a   |  b  | state   |    Rule
 * ------+---------------+-----------------+-----+-----+---------+-------------
 * 1st   | (id + id)*n $ | $               | (   | $   | shift   |
 * 2nd   | id + id)*n $  | $[ (            | id  | (   | shift   |
 * 3rd   | + id) * n $   | $[ ([ id        | +   | id  | reduce  | id     -> E
 * 4th   | + id) * n $   | $[ ( E          | +   | (   | shift   |
 * 5th   | id) * n $     | $[ ([ E +       | id  | +   | shift   |
 * 6th   | ) * n $       | $[ ([ E +[ id   | )   | id  | reduce  | id     -> E
 * 7th   | ) * n $       | $[ ([ E + E     | )   | +   | reduce  | E + E  -> E
 * 8th   | ) * n $       | $[ ( E          | )   | (   | special |
 * 9th   | * n $         | $[ ( E )        | *   | )   | reduce  | ( E )  -> E
 * 10th  | * n$          | $ E             | *   | $   | shift   |
 * 11th  | n $           | $[ E *          | n   | n   | shift   |
 * 12th  | $             | $[ E * [ n      | $   | n   | reduce  | id     -> E
 * 13th  | $             | $[ E * E        | $   | *   | reduce  | E * E  -> E
 * 14th  | $             | $ E             | $   | $   | end     |
 * 
 * 
 * 
 * 
 * 
 * 
 * VIZ IFJ 8TH LECTURE
 * 
 * @param endToken      Until which token I gotta read an expression.
 * @return              Errors if occurs (SYNTAX, SYSTEM || NO_ERROR)
 */
int parseExpression( int endToken1 , int endToken2 );

#endif	/* EXPRESS_PARSER_H */

