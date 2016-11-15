
/* c201.c **********************************************************************
** T�ma: Jednosm�rn� line�rn� seznam
** Student: Petr Dvoracek (xdvora0n)
**
**                     N�vrh a referen�n� implementace: Petr P�ikryl, ��jen 1994
**                                          �pravy: Andrea N�mcov� listopad 1996
**                                                   Petr P�ikryl, listopad 1997
**                                P�epracovan� zad�n�: Petr P�ikryl, b�ezen 1998
**                                  P�epis do jazyka C: Martin Tu�ek, ��jen 2004
**	                                      �pravy: Bohuslav K�ena, ��jen 2010
**                                 
**
** Implementujte abstraktn� datov� typ jednosm�rn� line�rn� seznam.
** U�ite�n�m obsahem prvku seznamu je cel� ��slo typu int.
** Seznam bude jako datov� abstrakce reprezentov�n prom�nnou typu tList.
** Definici konstant a typ� naleznete v hlavi�kov�m souboru c201.h.
** 
** Va��m �kolem je implementovat n�sleduj�c� operace, kter� spolu s v��e
** uvedenou datovou ��st� abstrakce tvo�� abstraktn� datov� typ tList:
**
**  X   InitList ...... inicializace seznamu p�ed prvn�m pou�it�m, 
**  X   DisposeList ... zru�en� v�ech prvk� seznamu,	
**  X   InsertFirst ... vlo�en� prvku na za��tek seznamu,
**  X   First ......... nastaven� aktivity na prvn� prvek,
**  X   CopyFirst ..... vrac� hodnotu prvn�ho prvku,
**  X   DeleteFirst ... zru�� prvn� prvek seznamu,
**  X   PostDelete .... ru�� prvek za aktivn�m prvkem,
**  X   PostInsert .... vlo�� nov� prvek za aktivn� prvek seznamu,
**  X   Copy .......... vrac� hodnotu aktivn�ho prvku,
**  X   Actualize ..... p�ep�e obsah aktivn�ho prvku novou hodnotou,
**  X   Succ .......... posune aktivitu na dal�� prvek seznamu,
**  X   Active ........ zji��uje aktivitu seznamu.
**
** P�i implementaci funkc� nevolejte ��dnou z funkc� implementovan�ch v r�mci
** tohoto p��kladu, nen�-li u funkce explicitn� uvedeno n�co jin�ho.
**
** Nemus�te o�et�ovat situaci, kdy m�sto leg�ln�ho ukazatele na seznam 
** p�ed� n�kdo jako parametr hodnotu NULL.
**
** Svou implementaci vhodn� komentujte!
**
** Terminologick� pozn�mka: Jazyk C nepou��v� pojem procedura.
** Proto zde pou��v�me pojem funkce i pro operace, kter� by byly
** v algoritmick�m jazyce Pascalovsk�ho typu implemenov�ny jako
** procedury (v jazyce C procedur�m odpov�daj� funkce vracej�c� typ void).
**/

// Vase komentare jsem hodil pred funkce. Me komentare zacinaji takhle //

#include "c201.h"

int solved;
int errflg;

/*
** Vytiskne upozorn�n� na to, �e do�lo k chyb�.
** Tato funkce bude vol�na z n�kter�ch d�le implementovan�ch operac�.
**/	
void Error()
{
    printf ("*ERROR* Chyba p�i pr�ci se seznamem.\n");
    errflg = TRUE;                      /* glob�ln� prom�nn� -- p��znak chyby */
}

/*
** Provede inicializaci seznamu L p�ed jeho prvn�m pou�it�m (tzn. ��dn�
** z n�sleduj�c�ch funkc� nebude vol�na nad neinicializovan�m seznamem).
** Tato inicializace se nikdy nebude prov�d�t nad ji� inicializovan�m
** seznamem, a proto tuto mo�nost neo�et�ujte. V�dy p�edpokl�dejte,
** �e neinicializovan� prom�nn� maj� nedefinovanou hodnotu.
**/
void InitList (tList *L)
{
	//assert(L->First != NULL);
	//assert(L->Act != NULL); 
	L->First = NULL;
	L->Act = NULL;
}

/*
** Zru�� v�echny prvky seznamu L a uvede seznam L do stavu, v jak�m se nach�zel
** po inicializaci. V�echny prvky seznamu L budou korektn� uvoln�ny vol�n�m
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
** Vlo�� prvek s hodnotou val na za��tek seznamu L.
** V p��pad�, �e nen� dostatek pam�ti pro nov� prvek p�i operaci malloc,
** vol� funkci Error().
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
** Nastav� aktivitu seznamu L na jeho prvn� prvek.
** Funkci implementujte jako jedin� p��kaz, ani� byste testovali,
** zda je seznam L pr�zdn�.
**/
void First (tList *L)
{
	L->Act = L->First;
}

/*
** Vr�t� hodnotu prvn�ho prvku seznamu L.
** Pokud je seznam L pr�zdn�, vol� funkci Error().
**/
void CopyFirst (tList *L, int *val)
{
	if(L->First != NULL)	
		*val = L->First->data;
	else
		Error();
}

/*
** Ru�� prvn� prvek seznamu L. Pokud byl ru�en� prvek aktivn�, aktivita seznamu
** se ztr�c�. Pokud byl seznam L pr�zdn�, nic se ned�je!
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
** Ru�� prvek seznamu L za aktivn�m prvkem. Pokud nen� seznam L aktivn�
** nebo pokud je aktivn� posledn� prvek seznamu L, nic se ned�je!
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
** Vlo�� prvek s hodnotou val za aktivn� prvek seznamu L.
** Pokud nebyl seznam L aktivn�, nic se ned�je!
** V p��pad�, �e nen� dostatek pam�ti pro nov� prvek p�i operaci malloc,
** zavol� funkci Error().
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
** Vr�t� hodnotu aktivn�ho prvku seznamu L.
** Pokud seznam nen� aktivn�, zavol� funkci Error().
**/
void Copy (tList *L, int *val)
{
	if(L->Act != NULL)
		*val = L->Act->data;
	else
		Error();
}

/*
** P�ep�e data aktivn�ho prvku seznamu L.
** Pokud seznam L nen� aktivn�, ned�l� nic!
**/
void Actualize (tList *L, int val)	{
	if(L->Act != NULL)
		L->Act->data = val;
} 

/*
** Posune aktivitu na n�sleduj�c� prvek seznamu L.
** V�imn�te si, �e touto operac� se m��e aktivn� seznam st�t neaktivn�m.
** Pokud seznam L nen� aktivn�, ned�l� nic!
**/
void Succ (tList *L)
{
	if(L->Act != NULL)
		L->Act = L->Act->ptr;
}

/*
** Je-li seznam L aktivn�, vrac� True. V opa�n�m p��pad� vrac� false.
** Tuto funkci implementujte jako jedin� p��kaz return. 
**/
int Active (tList *L)
{	
	return (L->Act != NULL); 
}

/* Konec c201.c */
