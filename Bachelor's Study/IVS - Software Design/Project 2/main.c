/***********************************************************************
 * Soubor: main.c                                                      *
 * Autor: Petr Dvoracek                                                *
 * Predmet: IVS                                                        *
 * Projekt: 3. - git, knihovny, make, debugging profiling, dokumentace *
 * Popis: zpracovani parametru                                         *
 ***********************************************************************/
/**
 * @file	main.c
 * @author 	Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * @version	0.3
 * @section DESCRIPTION
 *
 * Zpracovani parametru.
 */

#include <stdio.h> 
#include <stdlib.h>
#include "parity.h"
/**
 * Tisk napovedy.
 */
void print_help()
{
	printf("Vypocet parity\n");
	printf("\n");
	printf("Pouziti:\n");
	printf("  ./xlogin00 URL1 FILE1 URL2 FILE2 ...\n");
	printf("    URL je url souboru, který má být stažen a uložen do souboru\n");
	printf("    FILE. Pro každý stažený soubor je na standardní výstup\n");
	printf("    vypsána parita tohoto souboru (0 nebo 1).\n");
	printf("\n");
	printf("  ./xlogin00 FILE\n");
	printf("    Pokud bude předán pouze jeden argument, považuje se za\n");
	printf("    soubor, pro který se spočítá parita.\n");
} // Tisk napovedy.

// Pozn pro ucitele: dle meho nazoru argc a argv jsou velmi zrejme a pouzivane prametry. Tudiz neni potreba je zahrnovat do @param...
/**
 * Zpracovani parametru prikazove radky.
 * @return Vraci 0 pri bezchybne cinnosti programu, jinak vraci chybovou hodnotu.
 */
int main (int argc, char **argv)
{	

	int i; // Pocitadlo zpracovanych parametru	
	int pb;
	if (argc == 1)
		print_help();
	else if (argc == 2)
	{
		if((pb = parityf(argv[1])) == -1)
		{// Nepodarilo se otevrit soubor.
			printf("Chyba.");
			return 0;
		}
		printf("%d", pb);
	}
	else
	{
		if((argc % 2) == 0)
			printf("Vynechavam posledni parametr: %s\n", argv[argc-1]);
		for(i = 1; i < argc; i+=2)
		{
			download(argv[i], argv[i+1]);
			pb = parityf(argv[i+1]);
			if(pb != -1)
				printf("%d", pb);
		}
	}
	printf("\n");
	return 0;
} // Main.
/* Konec souboru main.c */
