/***********************************************************************
 * Soubor: parity.h                                                    *
 * Autor: Petr Dvoracek                                                *
 * Predmet: IVS                                                        *
 * Projekt: 3. - git, knihovny, make, debugging profiling, dokumentace *
 * Popis: vypocet parity                                               *
 ***********************************************************************/
/**
 * @file	parity.h
 * @author 	Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * @version	0.3
 * @section DESCRIPTION
 *
 * Vypocet parity
 */
#ifndef PARITY_H
#define PARITY_H

int download(char *url, char *filename);
int parity_file(FILE *f);
int parityf(char *filename);
#endif
