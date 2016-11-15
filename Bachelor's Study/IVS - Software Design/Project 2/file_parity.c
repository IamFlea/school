/***********************************************************************
 * Soubor: file_parity.c                                               *
 * Autor: Petr Dvoracek                                                *
 * Predmet: IVS                                                        *
 * Projekt: 3. - git, knihovny, make, debugging profiling, dokumentace *
 * Popis: otevreni souboru                                             *
 ***********************************************************************/
/**
 * @file	file_parity.c
 * @author 	Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * @version	0.2.1
 * @section DESCRIPTION
 *
 * Tento program spocita paritu souboru, predavaneho stringem.
 */
#include <stdio.h>
#include "parity.h"

/**
 * Zjisti paritni bit jednoho znaku 
 *
 * @param char c	dany znak
 * @return	Bud paritni bit, nebo zapornou hodnotu pri neuspechu.
 */
int parity_char(unsigned char c)
{
	int dec_number = c;
	int result = 0; // vysledek
	if(dec_number < 0) // Predpokladam bezznamenkove 
		return -1;
	else
	{
		while (dec_number > 0)
		{	//nasli jsme jednickovy bit	
			if ((dec_number % 2) == 1)
			{
				if (result == 0)
					result = 1;
				else
					result = 0;
			}	
			dec_number /= 2;
		}
	}
	return result;
} //parity_char

/**
 * Projde soubor znak po znaku a pomoci toho zjisti paritu souboru.
 *
 * @param FILE f	Otevreny soubor
 * @return 	Paritni bit, -1 pri prazdnem souboru
 */
int parity_file(FILE *f)
{
	char c;
	char c_swp;
	// Pokud je prazdny soubor
	if((c = fgetc(f)) == EOF)
		return -1;
	while((c_swp = fgetc(f)) != EOF)
		c ^= c_swp;
	return parity_char(c);
} //parity_file


/**
 * Otevre soubor.
 *
 * @param char *filename Jmeno souboru.
 * @return paritni bit. V chybovych situacich vraci zapornou hodnotu.
 */
int parityf (char *filename)
{
	int result;
	FILE *f;
	if((f = fopen(filename, "r")) == NULL)
	{
		printf("Nepodarilo se otevrit soubor.\n");
		return -1;
	}
	result = parity_file(f);
	fclose(f);
	if(result == -1)
		printf("Soubor je prazdny.");
	return result;
} //parityf

/* Konec souboru file_parity.c */
