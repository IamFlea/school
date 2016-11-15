
/* c201.c **********************************************************************
** Téma: Jednosmìrný lineární seznam
** Student: Petr Dvoracek (xdvora0n)
**
**                     Návrh a referenèní implementace: Petr Pøikryl, øíjen 1994
**                                          Úpravy: Andrea Nìmcová listopad 1996
**                                                   Petr Pøikryl, listopad 1997
**                                Pøepracované zadání: Petr Pøikryl, bøezen 1998
**                                  Pøepis do jazyka C: Martin Tuèek, øíjen 2004
**	                                      Úpravy: Bohuslav Køena, øíjen 2010
**                                 
**
** Implementujte abstraktní datový typ jednosmìrný lineární seznam.
** U¾iteèným obsahem prvku seznamu je celé èíslo typu int.
** Seznam bude jako datová abstrakce reprezentován promìnnou typu tList.
** Definici konstant a typù naleznete v hlavièkovém souboru c201.h.
** 
** Va¹ím úkolem je implementovat následující operace, které spolu s vý¹e
** uvedenou datovou èástí abstrakce tvoøí abstraktní datový typ tList:
**
**  X   InitList ...... inicializace seznamu pøed prvním pou¾itím, 
**  X   DisposeList ... zru¹ení v¹ech prvkù seznamu,	
**  X   InsertFirst ... vlo¾ení prvku na zaèátek seznamu,
**  X   First ......... nastavení aktivity na první prvek,
**  X   CopyFirst ..... vrací hodnotu prvního prvku,
**  X   DeleteFirst ... zru¹í první prvek seznamu,
**  X   PostDelete .... ru¹í prvek za aktivním prvkem,
**  X   PostInsert .... vlo¾í nový prvek za aktivní prvek seznamu,
**  X   Copy .......... vrací hodnotu aktivního prvku,
**  X   Actualize ..... pøepí¹e obsah aktivního prvku novou hodnotou,
**  X   Succ .......... posune aktivitu na dal¹í prvek seznamu,
**  X   Active ........ zji¹»uje aktivitu seznamu.
**
** Pøi implementaci funkcí nevolejte ¾ádnou z funkcí implementovaných v rámci
** tohoto pøíkladu, není-li u funkce explicitnì uvedeno nìco jiného.
**
** Nemusíte o¹etøovat situaci, kdy místo legálního ukazatele na seznam 
** pøedá nìkdo jako parametr hodnotu NULL.
**
** Svou implementaci vhodnì komentujte!
**
** Terminologická poznámka: Jazyk C nepou¾ívá pojem procedura.
** Proto zde pou¾íváme pojem funkce i pro operace, které by byly
** v algoritmickém jazyce Pascalovského typu implemenovány jako
** procedury (v jazyce C procedurám odpovídají funkce vracející typ void).
**/

// Vase komentare jsem hodil pred funkce. Me komentare zacinaji takhle //

#include "c201.h"

int solved;
int errflg;

/*
** Vytiskne upozornìní na to, ¾e do¹lo k chybì.
** Tato funkce bude volána z nìkterých dále implementovaných operací.
**/	
void Error()
{
    printf ("*ERROR* Chyba pøi práci se seznamem.\n");
    errflg = TRUE;                      /* globální promìnná -- pøíznak chyby */
}

/*
** Provede inicializaci seznamu L pøed jeho prvním pou¾itím (tzn. ¾ádná
** z následujících funkcí nebude volána nad neinicializovaným seznamem).
** Tato inicializace se nikdy nebude provádìt nad ji¾ inicializovaným
** seznamem, a proto tuto mo¾nost neo¹etøujte. V¾dy pøedpokládejte,
** ¾e neinicializované promìnné mají nedefinovanou hodnotu.
**/
void InitList (tList *L)
{
	//assert(L->First != NULL);
	//assert(L->Act != NULL); 
	L->First = NULL;
	L->Act = NULL;
}

/*
** Zru¹í v¹echny prvky seznamu L a uvede seznam L do stavu, v jakém se nacházel
** po inicializaci. V¹echny prvky seznamu L budou korektnì uvolnìny voláním
** operace free.
***/
void DisposeList (tList *L)
{
	tElemPtr item;
	L->Act = NULL;
	// Mazu prvni prvky v seznamu do te doby, nez nemam co mazat.
	while (L->First != NULL)
	{
		item = L->First;
		L->First = L->First->ptr;
		free(item);
	}
}

/*
** Vlo¾í prvek s hodnotou val na zaèátek seznamu L.
** V pøípadì, ¾e není dostatek pamìti pro nový prvek pøi operaci malloc,
** volá funkci Error().
**/
void InsertFirst (tList *L, int val)
{
	tElemPtr item = (tElemPtr) malloc(sizeof(*item));
	if(item == NULL)
	{ 	// Nepodarilo se alkovoat pamet.
		Error();
		return;
	}

	item->data = val;
	item->ptr  = L->First;
	L->First   = item;
}

/*
** Nastaví aktivitu seznamu L na jeho první prvek.
** Funkci implementujte jako jediný pøíkaz, ani¾ byste testovali,
** zda je seznam L prázdný.
**/
void First (tList *L)
{
	L->Act = L->First;
}

/*
** Vrátí hodnotu prvního prvku seznamu L.
** Pokud je seznam L prázdný, volá funkci Error().
**/
void CopyFirst (tList *L, int *val)
{
	if(L->First != NULL)	
		*val = L->First->data;
	else
		Error();
}

/*
** Ru¹í první prvek seznamu L. Pokud byl ru¹ený prvek aktivní, aktivita seznamu
** se ztrácí. Pokud byl seznam L prázdný, nic se nedìje!
**/
void DeleteFirst (tList *L)
{
	if(L->First == NULL)
		return;
	if(L->Act == L->First)
		L->Act = NULL;
	tElemPtr item = L->First;
	L->First = item->ptr;
	free(item);
}

/* 
** Ru¹í prvek seznamu L za aktivním prvkem. Pokud není seznam L aktivní
** nebo pokud je aktivní poslední prvek seznamu L, nic se nedìje!
**/
void PostDelete (tList *L)
{
	if(L->Act == NULL || L->Act->ptr == NULL)
		return;
	tElemPtr item = L->Act->ptr;
	L->Act->ptr = L->Act->ptr->ptr;
	free(item);
}

/*
** Vlo¾í prvek s hodnotou val za aktivní prvek seznamu L.
** Pokud nebyl seznam L aktivní, nic se nedìje!
** V pøípadì, ¾e není dostatek pamìti pro nový prvek pøi operaci malloc,
** zavolá funkci Error().
**/
void PostInsert (tList *L, int val)
{
	if(L->Act == NULL)
		return;
	tElemPtr item = (tElemPtr) malloc(sizeof(*item));
	if(item == NULL) // Nepodarilo se alkovoat pamet.
	{
		Error();
		return;
	}
	item->data = val;
	item->ptr = L->Act->ptr;
	L->Act->ptr = item;
}

/*
** Vrátí hodnotu aktivního prvku seznamu L.
** Pokud seznam není aktivní, zavolá funkci Error().
**/
void Copy (tList *L, int *val)
{
	if(L->Act != NULL)
		*val = L->Act->data;
	else
		Error();
}

/*
** Pøepí¹e data aktivního prvku seznamu L.
** Pokud seznam L není aktivní, nedìlá nic!
**/
void Actualize (tList *L, int val)	{
	if(L->Act != NULL)
		L->Act->data = val;
} 

/*
** Posune aktivitu na následující prvek seznamu L.
** V¹imnìte si, ¾e touto operací se mù¾e aktivní seznam stát neaktivním.
** Pokud seznam L není aktivní, nedìlá nic!
**/
void Succ (tList *L)
{
	if(L->Act != NULL)
		L->Act = L->Act->ptr;
}

/*
** Je-li seznam L aktivní, vrací True. V opaèném pøípadì vrací false.
** Tuto funkci implementujte jako jediný pøíkaz return. 
**/
int Active (tList *L)
{	
	return (L->Act != NULL); 
}

/* Konec c201.c */
