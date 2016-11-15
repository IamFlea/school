	
/* c206.c **********************************************************}
** Student: Petr Dvoracek
** Téma: Dvousmìrnì vázaný lineární seznam
**
**                   Návrh a referenèní implementace: Bohuslav Køena, øíjen 2001
**                            Pøepracované do jazyka C: Martin Tuèek, øíjen 2004
**                                            Úpravy: Bohuslav Køena, øíjen 2010
**
** Implementujte abstraktní datový typ dvousmìrnì vázaný lineární seznam.
** U¾iteèným obsahem prvku seznamu je hodnota typu int.
** Seznam bude jako datová abstrakce reprezentován promìnnou
** typu tDLList (DL znamená Double-Linked a slou¾í pro odli¹ení
** jmen konstant, typù a funkcí od jmen u jednosmìrnì vázaného lineárního
** seznamu). Definici konstant a typù naleznete v hlavièkovém souboru c206.h.
**
** Va¹ím úkolem je implementovat následující operace, které spolu
** s vý¹e uvedenou datovou èástí abstrakce tvoøí abstraktní datový typ
** obousmìrnì vázaný lineární seznam:
**
**      DLInitList ...... inicializace seznamu pøed prvním pou¾itím,
**      DLDisposeList ... zru¹ení v¹ech prvkù seznamu,
**      DLInsertFirst ... vlo¾ení prvku na zaèátek seznamu,
**      DLInsertLast .... vlo¾ení prvku na konec seznamu, 
**      DLFirst ......... nastavení aktivity na první prvek,
**      DLLast .......... nastavení aktivity na poslední prvek, 
**      DLCopyFirst ..... vrací hodnotu prvního prvku,
**      DLCopyLast ...... vrací hodnotu posledního prvku, 
**      DLDeleteFirst ... zru¹í první prvek seznamu,
**      DLDeleteLast .... zru¹í poslední prvek seznamu, 
**      DLPostDelete .... ru¹í prvek za aktivním prvkem,
**      DLPreDelete ..... ru¹í prvek pøed aktivním prvkem, 
**      DLPostInsert .... vlo¾í nový prvek za aktivní prvek seznamu,
**      DLPreInsert ..... vlo¾í nový prvek pøed aktivní prvek seznamu,
**      DLCopy .......... vrací hodnotu aktivního prvku,
**      DLActualize ..... pøepí¹e obsah aktivního prvku novou hodnotou,
**      DLSucc .......... posune aktivitu na dal¹í prvek seznamu,
**      DLPred .......... posune aktivitu na pøedchozí prvek seznamu, 
**      DLActive ........ zji¹»uje aktivitu seznamu.
**
** Pøi implementaci jednotlivých funkcí nevolejte ¾ádnou z funkcí
** implementovaných v rámci tohoto pøíkladu, není-li u funkce
** explicitnì uvedeno nìco jiného.
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

#include "c206.h"

int solved;
int errflg;

void DLError() {
/*
** Vytiskne upozornìní na to, ¾e do¹lo k chybì.
** Tato funkce bude volána z nìkterých dále implementovaných operací.
**/	
    printf ("*ERROR* Chyba pøi práci se seznamem.\n");
    errflg = TRUE;             /* globální promìnná -- pøíznak o¹etøení chyby */
    return;
}

void DLInitList (tDLList *L)	{
/*
** Provede inicializaci seznamu L pøed jeho prvním pou¾itím (tzn. ¾ádná
** z následujících funkcí nebude volána nad neinicializovaným seznamem).
** Tato inicializace se nikdy nebude provádìt nad ji¾ inicializovaným
** seznamem, a proto tuto mo¾nost neo¹etøujte. V¾dy pøedpokládejte,
** ¾e neinicializované promìnné mají nedefinovanou hodnotu.
**/
	//assert(L->First != NULL);
	//assert(L->Act != NULL);
	//assert(L->Last != NULL);
	L->First = NULL;
	L->Act = NULL;
	L->Last = NULL;
}

//////
void DLDisposeList (tDLList *L)	{
/*
** Zru¹í v¹echny prvky seznamu L a uvede seznam do stavu, v jakém
** se nacházel po inicializaci. Ru¹ené prvky seznamu budou korektnì
** uvolnìny voláním operace free. 
**/
	tDLElemPtr temp;
	L->Act  = NULL;
	L->Last = NULL;

	// Mazu polozky od prvni polozky seznamu.
	while (L->First != NULL)
	{
		temp = L->First;
		L->First = L->First->rptr;
		free(temp);
	}
}

void DLInsertFirst (tDLList *L, int val)	{
/*
** Vlo¾í nový prvek na zaèátek seznamu L.
** V pøípadì, ¾e není dostatek pamìti pro nový prvek pøi operaci malloc,
** volá funkci DLError().
**/
	tDLElemPtr item = (tDLElemPtr) malloc(sizeof(* item));
	if(item == NULL)
	{	// Nezdarila se alokace
		DLError();
		return;
	}
	
	item->data = val;
	item->lptr = NULL;
	item->rptr = L->First; 	
	// Zpetna vazba seznamu
	if(L->First != NULL)
		L->First->lptr = item;
	else // Pro prazdny seznam (L->FIRST == NULL)
		L->Last = item;
	L->First = item;
} // end DLInsertFirst 

void DLInsertLast(tDLList *L, int val)	{
/*
** Vlo¾í nový prvek na konec seznamu L (symetrická operace k DLInsertFirst).
** V pøípadì, ¾e není dostatek pamìti pro nový prvek pøi operaci malloc,
** volá funkci DLError().
**/ 	
	tDLElemPtr item = (tDLElemPtr)malloc(sizeof(*item));
	if(item == NULL)
	{	// Nezdarila se alokace
		DLError();
		return;
	}
	item->data = val;
	item->lptr = L->Last;
	item->rptr = NULL;

	// Zpetna vazba seznamu
	if(L->Last != NULL)
		L->Last->rptr = item;
	// Pro prazdny seznam:
	else
		L->First = item;
	L->Last = item;
}

void DLFirst (tDLList *L)	{
/*
** Nastaví aktivitu na první prvek seznamu L.
** Funkci implementujte jako jediný pøíkaz (nepoèítáme-li return),
** ani¾ byste testovali, zda je seznam L prázdný.
**/
	L->Act = L->First;	
}

void DLLast (tDLList *L)	{
/*
** Nastaví aktivitu na poslední prvek seznamu L.
** Funkci implementujte jako jediný pøíkaz (nepoèítáme-li return),
** ani¾ byste testovali, zda je seznam L prázdný.
**/
	L->Act = L->Last;	
}

void DLCopyFirst (tDLList *L, int *val)	{
/*
** Vrátí hodnotu prvního prvku seznamu L.
** Pokud je seznam L prázdný, volá funkci DLError().
**/
	if(L->First == NULL)
		DLError();
	else
		*val = L->First->data;
}

void DLCopyLast (tDLList *L, int *val)	{
/*
** Vrátí hodnotu posledního prvku seznamu L.
** Pokud je seznam L prázdný, volá funkci DLError().
**/
	if(L->Last == NULL)
		//assert(L->First != NULL);
		DLError();
	else
		*val = L->Last->data;
}

void DLDeleteFirst (tDLList *L)	{
/*
** Zru¹í první prvek seznamu L. Pokud byl první prvek aktivní, aktivita 
** se ztrácí. Pokud byl seznam L prázdný, nic se nedìje.
**/
	if(L->First == NULL)
		return;

	if(L->Act == L->First)
		L->Act = NULL;

	tDLElemPtr temp = L->First;
	if(L->First == L->Last)	//Jedinz prvek v seznamu -> nastav ukazatele na NULL
	{		
		L->First = NULL;
		L->Last = NULL;
	}
	else	// Normalni prepointrovani;
	{
		L->First = temp->rptr;
		L->First->lptr = NULL;
	}
	free(temp);
}	

void DLDeleteLast (tDLList *L)	{
/*
** Zru¹í poslední prvek seznamu L. Pokud byl poslední prvek aktivní,
** aktivita seznamu se ztrácí. Pokud byl seznam L prázdný, nic se nedìje.
**/ 
	if(L->First == NULL)
		return;
	if(L->Act == L->Last)
		L->Act = NULL;

	tDLElemPtr temp = L->Last;
	if(L->First == L->Last) // Jediny prvek seznamu	
	{
		L->First = NULL;
		L->Last = NULL;
	}
	else
	{	// Odpointrovani prvku
		L->Last = temp->lptr;
		L->Last->rptr = NULL;
	}
	free(temp);
}

void DLPostDelete (tDLList *L)	{
/*
** Zru¹í prvek seznamu L za aktivním prvkem.
** Pokud je seznam L neaktivní nebo pokud je aktivní prvek
** posledním prvkem seznamu, nic se nedìje.
**/
	if((L->Act == L->Last) || (L->Act == NULL))
		return;

	tDLElemPtr temp = L->Act->rptr;
	L->Act->rptr = temp->rptr;
	if(L->Last == temp) // 
		L->Last = L->Act;
	else
		temp->rptr->lptr = L->Act;
	free(temp);
}

void DLPreDelete (tDLList *L)	{
/*
** Zru¹í prvek pøed aktivním prvkem seznamu L .
** Pokud je seznam L neaktivní nebo pokud je aktivní prvek
** prvním prvkem seznamu, nic se nedìje.
**/
	if((L->Act == L->First) || (L->Act == NULL))
		return;

	tDLElemPtr temp = L->Act->lptr;
	L->Act->lptr = temp->lptr;
	if(L->First == temp) // jediny prvek
		L->First = temp->rptr;
	else // vice prvnku
		temp->lptr->rptr = L->Act;
	free(temp);
}

void DLPostInsert (tDLList *L, int val) {
/*
** Vlo¾í prvek za aktivní prvek seznamu L.
** Pokud nebyl seznam L aktivní, nic se nedìje.
** V pøípadì, ¾e není dostatek pamìti pro nový prvek pøi operaci malloc,
** volá funkci DLError().
**/
	if(L->Act == NULL)
		return;
	tDLElemPtr item = (tDLElemPtr) malloc(sizeof(*item));
	if(item == NULL)
	{	// Nezdarila se alokace
		DLError();
		return;
	}
	item->data = val;
	item->lptr = L->Act;
	item->rptr = L->Act->rptr;
	L->Act->rptr = item;
	// Zpetna vazba seznamu
	if(item->rptr != NULL)
		item->rptr->lptr = item;
}

void DLPreInsert (tDLList *L, int val)		{
/*
** Vlo¾í prvek pøed aktivní prvek seznamu L.
** Pokud nebyl seznam L aktivní, nic se nedìje.
** V pøípadì, ¾e není dostatek pamìti pro nový prvek pøi operaci malloc,
** volá funkci DLError().
**/
	if(L->Act == NULL)
		return;
	tDLElemPtr item = (tDLElemPtr)malloc(sizeof(*item));
	if(item == NULL)
	{	// Nezdarila se alokace
		DLError();
		return;
	}
	item->data = val;
	item->rptr = L->Act;
	item->lptr = L->Act->lptr;
	L->Act->lptr = item;
	// Zpetna vazba seznamu
	if(item->lptr != NULL)
		item->lptr->rptr = item;
}

void DLCopy (tDLList *L, int *val)	{
/*
** Vrátí hodnotu aktivního prvku seznamu L.
** Pokud seznam L není aktivní, volá funkci DLError ().
**/
	if(L->Act == NULL)
		DLError();
	else
		*val = L->Act->data;
}

void DLActualize (tDLList *L, int val) {
/*
** Pøepí¹e obsah aktivního prvku seznamu L.
** Pokud seznam L není aktivní, nedìlá nic.
**/
	if(L->Act != NULL)
		L->Act->data = val;		
}

void DLSucc (tDLList *L)	{
/*
** Posune aktivitu na následující prvek seznamu L.
** Není-li seznam aktivní, nedìlá nic.
** V¹imnìte si, ¾e pøi aktivitì na posledním prvku se seznam stane neaktivním.
**/
	if(L->Act != NULL)
		L->Act = L->Act->rptr;	
}


void DLPred (tDLList *L)	{
/*
** Posune aktivitu na pøedchozí prvek seznamu L.
** Není-li seznam aktivní, nedìlá nic.
** V¹imnìte si, ¾e pøi aktivitì na prvním prvku se seznam stane neaktivním.
**/
	if(L->Act != NULL)
		L->Act = L->Act->lptr;	
}

int DLActive (tDLList *L) {		
/*
** Je-li seznam aktivní, vrací true. V opaèném pøípadì vrací false.
** Funkci implementujte jako jediný pøíkaz.
**/
	return(L->Act != NULL);
}

/* Konec c206.c*/
