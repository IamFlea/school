// DOTAZ: Proc se ma vysledny soubor jmenovat barbers, kdyz je tu jen jeden holic? :)
// UPOZORNENI: Tento zdrojovy kod obsahuje komentare.




/**
 * @file	barbers.c
 * @author 	Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * @version	1.0
 * @section DESCRIPTION
 *
 * Implementace problému spícího holiče.
 */

#include <stdio.h>	// Vstup, výstup
#include <stdlib.h>	// Zakladni knihovna jazyka C.
#include <string.h> 	// Prace se stringy.
#include <stdbool.h>	// Booleovske typy. (True, false)
#include <errno.h> 	// Chybove kody.
#include <limits.h>	// Limity datovych typu.
#include <ctype.h>	// Isdigit

// fork, semafory time(), srand(), sdilena pamet etc.
#include <sys/types.h>	//fork
#include <unistd.h>	

#include <time.h>	//time() v srand()
#include <sys/wait.h>
#include <semaphore.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <sys/stat.h>
#include <fcntl.h>

////
// V ZADNEM PRIPADE NEMENIT HODNOTY!! 
// Slouzi jen a pouze k zvyseni prehlednosti. 
// pouzivam pole semaforu :) 
#define BARBER 0
#define CUSTOMER 1
#define SM 2
#define DOORS 3
#define THANKS 4
#define CUTTING 5
#define CUT 6

/** Stavové kódy programu */
enum tstates
{
	CHELP,		/**< zobrazeni napovedy */
	CBARBERS,	/**< bezna cinost - filozofove */
};

/** Chybove kody programu */
enum tecodes
{
	EOK = 1,	/**< zadna chyba			*/
	EFILE,		/**< neotevrel se soubor		*/
	ESHAREDMEMORY,	/**< nepodarilo se alokovat pamet	*/
	ESEMAPHORE,	/**< semafory jsou chybne		*/
	EFORK,		/**< fork zesilel			*/
	EPARAMS,	/**< chybne paramtery			*/
	EUNKNOWN,	/**< neznama chyba			*/
};
//enum tecodes



/** Chybova hlaseni, ktere odpovidaji chybovym kodum. */
const char *ECODEMSG[] =
{
	//NOTHING
	"ARE YOU KIDDING ME?\n",
	// EOK 
	"Vse v poradku.\n",
	// EFILE
	"Nepodarilo se otevrit soubor!\n",
	// ESHAREDMEMORY
	"Nepodarilo se alokovat sdilenou pamet!\n",
	// ESEMAPHORE
	"Nepodarilo se vytvorit semafory!\n",
	// EFORK
	"Chyba pri vytvareni podprocesu!\n",
	// EPARAMS
	"Chybne zadane parametry!\n",
	// EUNKNOWN
	"Nastala nepredvidana chyba!\n",
}; 
// chybova hlaseni

/** Napoveda. */
const char *HELPMSG =
  "Problem spiciho holice\n"
  "======================\n"
  "Tento program slouzi k simulaci, stejnojmenneho problemu souvicejiho\n"
  "se synchronizaci procesu v systemu.\n"
  "Pouziti:\n"
  "  ./barbers Q, GenC, GenB, N, F\n"
  "  Q    - pocet zidli\n"
  "  GenC - rozsah pro generovani zakazniku [ms]\n"
  "  GenB - rozsah pro generovani doby zakazniku [ms]\n"
  "  N    - pocet zakazniku\n"
  "  F    - jmeno souboru, do ktereho se bude generovat vysledek, pokud bude\n"
  "         misto nazvu znak -, budou se informace vypisovat na standardni vystup\n"
  "\n";
// napoveda 


/** Nazvy pojmenovanych semaforu */
const char *semafory[] =
{
	// beztak to neni podle pravdy... musi se najak jmenovat... 
	"/xdvora0n_barber",		// jeden pro holice
	"/xdvora0n_customers",		// kruhovy objezd pro zakazniky
	"/xdvora0n_sm",			// pristup do sdilene pameti, vetsinou inkrementace promenny
	"/xdvora0n_doors",		// volne sedacky
	"/xdvora0n_thanks",		// pro podekovani
	"/xdvora0n_start_cutting",	// jestli zacal strihat
	"/xdvora0n_cut",		// zda byl zakaznik ostrihan
};

/** Struktura pro sdilenou pamet */
typedef struct sharedvariable
{
	unsigned int id;		/**< Id procesu. */
	unsigned int process_done;	/**< Pocet probehlych procesu. */
	unsigned int free_chairs;	/**< Pocet volnych zidli. */
	unsigned int id_customer;	/**< Pocet vytvorenych zakazniku. */
//	bool finished;			/**< Finished? */
} TSharedVariables;


/** Struktura obsahujici hodnoty parametru prikazoveho radku */
typedef struct params
{
	unsigned int Q;		/**< pocet zidli v cekarne. Maximalni pocet procesu, ktere cekaji na holeni. */
	unsigned int GenC;	/**< rozsah pro generovani zakazniku. */
	unsigned int GenB;	/**< rozash pro generovani doby obsluhy */
	unsigned int N;		/**< pocet zakazniku, (procesu) */
	char *filename;		/**< nazev souboru*/
	int ecode;		/**< chybovy kod programu odpovidajici vyctu tecodes. */
	int state;		/**< stavovy kod programu odpovidajici vyctu tstates. */
} TParams;

/**
 * Zpracovani argumentu prikazoveho radku, ulozeni do struktury
 * @param argc Pocet argumentu.
 * @param argv Pole textových retezcu s argumenty.
 * @return Vraci analyzovane argumenty prikazoveho radku ve strukture params.
 */
TParams getParams(int argc, char *argv[])
{ 
	// inicializace struktury
	TParams result = { 
		.Q		= 0,		// pocet zidli
		.GenC		= 0,		// doba gen. zakazniku
		.GenB		= 0,		// doba obsluhy
		.N		= 0,		// pocet zakazniku
		.filename	= "",		// nazev souboru
		.ecode		= EOK,		// tecode
		.state		= CBARBERS,	// tstate
	};
	char *endptr = NULL;	/**< ukazatel na posledni znak v textovem retezci argumentu*/
	// zadny nebo jeden argument, v tomto pripade tisk napovedy
	if (argc == 1)
		result.state = CHELP;
	else if (argc == 2)
  	{
		if (strcmp("-h", argv[1]) == 0) // zadan parametr -h
			result.state = CHELP;
		else
			result.ecode = EPARAMS;
	}
	else if (argc == 6)
	{

		/*** Q ***/ 
		if(isdigit(*argv[1]))
		{
			endptr = NULL;
			errno = 0;
			// prevod stringu na cislo, ulozeni do struktury,
			result.Q = strtoul(argv[1], &endptr, 10);
			// osetreni chyb
			if((*endptr != '\0') || (errno == ERANGE) || (result.Q > UINT_MAX))
				result.ecode = EPARAMS;
		}
		else
			result.ecode = EPARAMS;

		/*** GenC ***/
		if(isdigit(*argv[2]))
		{
			endptr = NULL;
			errno = 0;
			// prevod stringu na cislo, ulozeni do struktury
			// musim to trosku navysit protoze usleep je v mikrosekundach
			result.GenC = 1000 * strtoul(argv[2], &endptr, 10);
			// osetreni chyb 
			if((*endptr != '\0') || (errno == ERANGE) || (result.GenC > UINT_MAX))
				result.ecode = EPARAMS;
		}
		else
			result.ecode = EPARAMS;

		/*** GenB ***/
		if(isdigit(*argv[3]))
		{
			endptr = NULL;
			errno = 0;
			//prevod stringu na cislo, ulozeni do struktury
			// musim to trosku navysit protoze usleep je v mikrosekundach
			result.GenB = 1000 * strtoul(argv[3], &endptr, 10);
			// osetreni chyb
			if((*endptr != '\0') || (errno == ERANGE) || (result.GenB > UINT_MAX))
				result.ecode = EPARAMS;

		}
		else
			result.ecode = EPARAMS;
 
		/*** N ***/
		if(isdigit(*argv[4]))
		{
			endptr = NULL;
			errno = 0;
			// prevod stringu na cislo, ulozeni do struktury
			result.N = strtoul(argv[4], &endptr, 10);
			// osetreni chyb
			if((*endptr != '\0') || (errno == ERANGE) || (result.N > UINT_MAX))
				result.ecode = EPARAMS;
		}
		else
			result.ecode = EPARAMS;

		/*** filename ***/
		result.filename = argv[5];
	}
	else
	{
		// spatny pocet argumentu
		result.ecode = EPARAMS;
	}
  return result;
} // getParams()

/**
 * Tisk chyboveho hlaseni, ktere odpovida chybovemu kodu.
 * @param ecode kod chyby programu, viz tecodes
 */
void printECode(int ecode)
{
 	if (ecode < EOK || ecode > EUNKNOWN)
		ecode = EUNKNOWN;
	fprintf(stderr, "%s", ECODEMSG[ecode]);
}


////////////////////////////////////////////////////////////////////////////////



/**
 * Holici, synchornizace procesu.
 *
 * Rozdelim dedicne procesy na proces holice a proces zakaznika.
 * Holic je osoba cislo 0. 
 * Zakaznici jsou osoby s cislem vetsim nez 1.
 * 
 *
 * @param params		  Argumenty prikazoveho radku
 * @param f			  Otevreny soubor
 * @param id_addr		  Struktura sdilene pameti
 * @return chybovy kod
 */
int __barbers(TParams *params, FILE *f, TSharedVariables *shared)
{
	sem_t *sem[6];			/**< Definovani semaforu */
	pid_t pid_customers;		/**< procesy zakazniku	*/
	pid_t pid_barber;		/**< proces holice	*/
	unsigned int i = 0;		/**< Pocitadlo aktualniho semaforu, zakaznika */
	unsigned int id_cust = 0;	/**< skutecne cislo zakaznika */
	int result = EOK;		/**< Chybovy kod */
	
	// inicializace semaforu
	if((sem[DOORS]  = sem_open(semafory[DOORS], O_CREAT, S_IRUSR | S_IWUSR, 1)) == SEM_FAILED) 
		return ESEMAPHORE;
	if((sem[SM] = sem_open(semafory[SM], O_CREAT, S_IRUSR | S_IWUSR, 1)) == SEM_FAILED) 
		return ESEMAPHORE;
	if((sem[CUSTOMER] = sem_open(semafory[CUSTOMER], O_CREAT, S_IRUSR | S_IWUSR, 0)) == SEM_FAILED) 
		return ESEMAPHORE;
	if((sem[THANKS] = sem_open(semafory[THANKS], O_CREAT, S_IRUSR | S_IWUSR, 0)) == SEM_FAILED) 
		return ESEMAPHORE;
	if((sem[CUTTING] = sem_open(semafory[CUTTING], O_CREAT, S_IRUSR | S_IWUSR, 0)) == SEM_FAILED) 
		return ESEMAPHORE;
	if((sem[BARBER] = sem_open(semafory[BARBER], O_CREAT, S_IRUSR | S_IWUSR, 0)) == SEM_FAILED) 
		return ESEMAPHORE;

	// generuju pseudonahodna cisla
	srand(time(NULL));
	// FORK IT
	pid_barber = fork();
	// neco spatne
	if(pid_barber == -1)
		result = EFORK;
	if(pid_barber == 0)
	{
		// Pokud nekoupil kadernik zidle
		if(params->Q == 0)
			// cyklime a cekame nez zakaznici zjisti ze tu fakt nejsou zidlicky :)
			while (shared->process_done != params->N)
				asm("nop;"); // Miloval jsem asembler :D 
		else
		{
			// cyklime nez obslouzime ci neobslouzime vsechny ale opravdu vsechny zakazniky
			while (shared->process_done != params->N)
			{
				// tato sekvence kodu se casto opakuje....
				// je tu kvuli tomu, aby sdilenou pamet opravdu pouzival jen JEDEN konkretni proces
				// reknu ze chci zapisovat
				sem_wait(sem[SM]);
				// navysim pocitadlo procesu
				shared->id = shared->id + 1;
				// splachnu, refreshuju buffer na vypis do souboru
				fflush(f); 
				// vytisknu pozadovanou cast
				fprintf(f, "%u: barber: checks\n", shared->id);
				// reknu ze koncim se zapisem
				sem_post(sem[SM]);
				// toto je konec casti kodu, ktery se tu casto opakuje.... :)				
				
				// pockam nez se posadi do cekarny nejaky zakaznik
				sem_wait(sem[CUSTOMER]);
				// otevru dvere od cekarny, obdobne jak u semaforu sem[SM]
				sem_wait(sem[DOORS]);
				// navysim pocitadlo volnych zidli
				shared->free_chairs = shared->free_chairs + 1;
				// zapisu na vystup, ze je holic pripraveny SEBRAT nejakeho RANDOM zakaznika
				sem_wait(sem[SM]);
				shared->id = shared->id + 1;
				fflush(f); 
				fprintf(f, "%u: barber: ready\n", shared->id);
				sem_post(sem[SM]);
				// zavru dvere
				sem_post(sem[DOORS]);
				// holic da vedet, ze je pripraven strihat
				sem_post(sem[BARBER]);
				// pocka nez zakaznik zarve ze je ready
				sem_wait(sem[CUTTING]);		// pocka nez zakaznik upresni jak chce byt strihan....  
				// strihame
				if(params->GenB != 0) // if GenB == 0 then holi rychlosti svetla
					usleep(rand() % params->GenB);
				// vypiseme ze kadernik dokoncil strih.... 
				sem_wait(sem[SM]);
				shared->id = shared->id + 1;
				fflush(f); 
				fprintf(f, "%u: barber: finished\n", shared->id);
				sem_post(sem[SM]);
				// mrkne na zakaznika, aby rekl ze je obslouzen
				sem_post(sem[THANKS]);
				// zdvorile pocka nez zakaznik odejde... 
				// aby nahodou necekal na imaginarniho zakaznika :)
				sem_wait(sem[CUTTING]);
			}
		}
		// treba vypnout holice, 
		exit(EXIT_SUCCESS);
	}
	else
	{	
	/////////////////////////////
	//// rodicovksy proces holice
		// vytvorim nekolik zakazniku
		for(i=1; i <= params->N; i++)
		{
			// ty procesy jsou nejake divne... k vytvoreni ditete potrebuji vidlicku, nikoliv partnerku...
			// tak je tedy rozdelime 
			pid_customers = fork();
			
			// neco se porouchalo, vypnout semafory
			if(pid_customers == -1)
			{
				for(i = 0; i < 6; i++)
				{
					sem_close(sem[i]);
					sem_unlink(semafory[i]); 
				}
				return EFORK;
			}
			////////
			/// proces zakazniku
			if(pid_customers == 0)
			{
				// v nahodnem intervalu uspim zakaznika
				if(params->GenC != 0)
					usleep(rand() % params->GenC);

				// navysim pocitadlo zakaznika a dam mu KONKRETNI poradove cislo ze sdilene pameti...
				// aby to vypadalo ze se vytvari postupne, jenze ty procesy si opravdu delaji co chteji :)
				// takze vystup by vypadal: costumer 1 created, costumer 2 created  etc... 
				// kdyby to tu nebylo vypadalo by to nahodne: costumer 2 created, costumer 1 created....  coz muze odpovidat predchozimu prikaldu
				sem_wait(sem[SM]);				
				shared->id = shared->id + 1;
				shared->id_customer = shared->id_customer + 1;
				id_cust = shared->id_customer;
				fflush(f);
				 
				fprintf(f, "%u: customer %u: created\n", shared->id, id_cust);
				sem_post(sem[SM]);
				sem_wait(sem[DOORS]);

				// zakaznik vstupuje do dveri cekarny
				sem_wait(sem[SM]);				
				shared->id = shared->id + 1;
				fflush(f); 
				fprintf(f, "%u: customer %u: enters\n", shared->id, id_cust);
				sem_post(sem[SM]);

				// Z zjisti stav cekarny
				if (shared->free_chairs > 0)
				{	// jestli v cekarne je misto, zabere ho
					shared->free_chairs = shared->free_chairs - 1;
					sem_post(sem[DOORS]);
					// Z rekne holicovi ze tam ma nejakeho zakaznika
					sem_post(sem[CUSTOMER]);
					// pokud holic je zaneprazdnen, Z ceka, nez je prijat
					sem_wait(sem[BARBER]);
					// Z zarve ze je prijaty
					sem_wait(sem[SM]);
					shared->id = shared->id + 1;
					fflush(f); 
					fprintf(f, "%u: customer %u: ready\n", shared->id, id_cust);
					sem_post(sem[SM]);
					// Z rekne holici jak chce strihat
					sem_post(sem[CUTTING]); //uz jo
					// Z ceka nez mu holic rekne ze byl obslouzen
					sem_wait(sem[THANKS]);
					// aby rekl holicovi ze byl obslouzen
					sem_wait(sem[SM]);
					shared->id = shared->id + 1;
					// !! jo proces je u konce... 
					// navysim pocitadlo procesu, aby holic vedel jestli ma dal pokracovat nebo ne
					shared->process_done = shared->process_done + 1;
					fflush(f); 
					fprintf(f, "%u: customer %u: served\n", shared->id, id_cust);
					sem_post(sem[SM]);
					// rekne zakaznikovi, ze muze jit na dalsiho pana na holeni
					sem_post(sem[CUTTING]);
					//end successfull
				}
				else
				{	// cekarna je plna, Z triskne dverma.
					// zacne brecet ze je refused
					sem_post(sem[DOORS]);
					sem_wait(sem[SM]);
					shared->id = shared->id + 1;
					// navisim pocitadlo protoze holic dopredu vedel kolik mu tam prijde zakazniku....
					// a tento mu tam neprisel
					shared->process_done = shared->process_done + 1;
					fflush(f); 
					fprintf(f, "%u: customer %u: refused\n", shared->id, id_cust);
					sem_post(sem[SM]);					
				}
				// zabit zakaznika
				exit(EXIT_SUCCESS);
			}
			// bez rodice
		}
		// uspim hlavni proces, probudim jej az vsechny podprocesy se ukonci.
		while(1)
			if(wait(NULL) == -1)
				break;
		
						
	}
		
	// skoncilo to radeni v kadernictvi, 
	// vypnu semafory	
	for(i = 0; i < 6; i++)
	{
		sem_close(sem[i]);
		sem_unlink(semafory[i]); 
	}
	return result;
} // __barbers  // + semafory

/** Holici - Alokace sdilene pameti (struktury) */
int _barbers(TParams *params, FILE *f)
{
	int result = EOK;	/***< Chybovy kod */
	// Alokace sdilene pameti, baby.
	key_t key;
	key = ftok(getenv("HOME"),'A');
	int sm_id = shmget(key, sizeof(TSharedVariables), IPC_CREAT | 0666);
	// Overime zda byla alokovana pamet
	if (sm_id < 0)
		return ESHAREDMEMORY;
	// Ukazatel do sdilene pameti	
	TSharedVariables *shared = shmat(sm_id,NULL,0);	
	shared->id = 0;
	shared->free_chairs = params->Q;
	shared->process_done = 0;
	shared->id_customer = 0;
	//shared->finished = false;
	result = __barbers(params, f, shared);
	// Ukonceni pripojeni a uvolneni sdilene pameti
	shmdt(shared);
        shmctl(sm_id, IPC_RMID, NULL);
	return result;
} //_barbers //sdilena pamet

/** Holici - otevreni souboru */
int barbers(TParams *params)
{
	int result = EOK;	/**< Chybovy kod */
	FILE *f;		/**< Ukazatel na soubor */
	if (params->filename[0] != '-')
	{
		f = fopen(params->filename, "w");
		setbuf(f, NULL); // Pokazde vyprazdnit buffer, bo to skarde blbne... stdout nejsou oci koukajci na terminal...
		if (! f)
			return EFILE;
	}
	else
		f = stdout;
	result = _barbers(params, f); 		
	fclose(f);
	return result;
} //barbers //soubor

////////////////////////////////////////////////////////////////////////////////

/** 
 * Hlavni funkce
 * @param argc Pocet argumentu.
 * @param argv Pole textových retezcu s argumenty.
 * @return Vraci chybovy kod.
 */
int main(int argc, char **argv)
{
	int ok = 1;	/**< pokud vse ok */
	// Zpracovani argumentu prikazove radky.
	TParams params = getParams(argc, argv);
	// Pokud chyba, ukonci program
	if (params.ecode != EOK)
	{ 
		printECode(params.ecode);
		return EXIT_FAILURE;
	}
	// Tisk napovedy
	if (params.state == CHELP)
		printf("%s", HELPMSG);
	// Holic
	if (params.state == CBARBERS)
		ok = barbers(&params);
	if (! ok)
	{
		printECode(ok);
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}
/*** Konec souboru barbers.c ***/
