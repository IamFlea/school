/******************************************************************************
 * Projekt - Zaklady pocitacove grafiky - IZG
 * spanel@fit.vutbr.cz
 *
 * $Id: student.c 217 2012-02-28 17:10:06Z spanel $
 */

#include "student.h"
#include "transform.h"

#include <memory.h>


/*****************************************************************************
 * Funkce vytvori vas renderer a nainicializuje jej */

S_Renderer * studrenCreate()
{
    S_StudentRenderer * renderer = (S_StudentRenderer *)malloc(sizeof(S_StudentRenderer));
    IZG_CHECK(renderer, "Cannot allocate enough memory");

    /* inicializace default rendereru */
    renInit(&renderer->base);

    /* nastaveni ukazatelu na vase upravene funkce */
    renderer->base.projectTriangleFunc = studrenProjectTriangle;
    renderer->base.calcReflectanceFunc = studrenPhongReflectance;

    return (S_Renderer *)renderer;
}

/****************************************************************************
 * Funkce vyhodnoti Phonguv osvetlovaci model pro zadany bod
 * a vraci barvu, kterou se bude kreslit do frame bufferu
 * point - souradnice bodu v prostoru
 * normal - normala k povrchu v danem bode */
S_RGBA studrenPhongReflectance(S_Renderer *pRenderer, const S_Coords *point, const S_Coords *normal)
{
    S_Coords    lvec;
    double      diffuse, r, g, b;
    S_RGBA      color;

    IZG_ASSERT(pRenderer && point && normal);

    /* vektor ke zdroji svetla */
    lvec = makeCoords(pRenderer->light_position.x - point->x,
                      pRenderer->light_position.y - point->y,
                      pRenderer->light_position.z - point->z);
    coordsNormalize(&lvec);

    /* ambientni cast */
    r = pRenderer->light_ambient.red * pRenderer->mat_ambient.red;
    g = pRenderer->light_ambient.green * pRenderer->mat_ambient.green;
    b = pRenderer->light_ambient.blue * pRenderer->mat_ambient.blue;

    /* difuzni cast */
    diffuse = lvec.x * normal->x + lvec.y * normal->y + lvec.z * normal->z;
    if( diffuse > 0 )
    {
        r += diffuse * pRenderer->light_diffuse.red * pRenderer->mat_diffuse.red;
        g += diffuse * pRenderer->light_diffuse.green * pRenderer->mat_diffuse.green;
        b += diffuse * pRenderer->light_diffuse.blue * pRenderer->mat_diffuse.blue;
    }
    
    /* spekularni cast */     
    S_Coords velkeV = makeCoords(0 - point->x, 0 - point->y, -pRenderer->camera_dist - point->z);
    coordsNormalize(&velkeV);
    S_Coords velkeR = makeCoords(2*diffuse*normal->x - lvec.x, 2*diffuse*normal->y - lvec.y, 2*diffuse*normal->z - lvec.z);
    coordsNormalize(&velkeR);

    double spekular = velkeR.x * velkeV.x + velkeR.y * velkeV.y + velkeR.z * velkeV.z;
    if( spekular > 0 )
    {
        r += spekular * pRenderer->light_specular.red * pRenderer->mat_specular.red;
        g += spekular * pRenderer->light_specular.green * pRenderer->mat_specular.green;
        b += spekular * pRenderer->light_specular.blue * pRenderer->mat_specular.blue;
    }

    /* saturace osvetleni*/
    r = MIN(1, r);
    g = MIN(1, g);
    b = MIN(1, b);

    /* kreslici barva */
    color.red = ROUND2BYTE(255 * r);
    color.green = ROUND2BYTE(255 * g);
    color.blue = ROUND2BYTE(255 * b);
    return color;
}

/****************************************************************************
 * Nova fce pro rasterizace trojuhelniku do frame bufferu
 * vcetne interpolace z souradnice a prace se z-bufferem
 * a interpolaci normaly pro Phonguv osvetlovaci model
 * v1, v2, v3 - ukazatele na vrcholy trojuhelniku ve 3D pred projekci
 * n1, n2, n3 - ukazatele na normaly ve vrcholech ve 3D pred projekci
 * x1, y1, ... - vrcholy trojuhelniku po projekci do roviny obrazovky */
//#define DEBUGDRAW

void studrenDrawTriangle(S_Renderer *pRenderer,
                         S_Coords *v1, S_Coords *v2, S_Coords *v3,
                         S_Coords *n1, S_Coords *n2, S_Coords *n3,
                         int x1, int y1,
                         int x2, int y2,
                         int x3, int y3
                         )
{
#ifdef DEBUGDRAW
    printf("[%d, %d]\n[%d, %d]\n[%d, %d]\n", x1, y1, x2, y2, x3, y3);
#endif
    S_Coords vPoint, nPoint;
    // Vypocet vektoru trojuhelniku...
    int x, y;
    int hrana1_x = x2 - x1;
    int hrana1_y = y2 - y1;
    int hrana2_x = x3 - x2;
    int hrana2_y = y3 - y2;
    int hrana3_x = x1 - x3;
    int hrana3_y = y1 - y3;

#ifdef DEBUGDRAW
    printf("%d, %d, %d, %d, %d, %d\n", hrana1_x, hrana2_x, hrana3_x, hrana1_y, hrana2_y,hrana3_y );
#endif

    int mostRight  = MAX(x2, MAX(x3, x1));
    int mostLeft   = MIN(x2, MIN(x3, x1));
    int mostTop    = MAX(y2, MAX(y3, y1));
    int mostBottom = MIN(y2, MIN(y3, y1));
    if(mostLeft < 0) 
        mostLeft = 0;
    if(mostBottom < 0)
        mostBottom = 0;
    // Kvuli bufferu
    if(mostRight >= pRenderer->frame_w)
        mostRight = pRenderer->frame_w - 1;
    if(mostTop >= pRenderer->frame_h)
        mostTop = pRenderer->frame_h - 1;
    int first   = (mostLeft - 1 - x1)*hrana1_y - (mostTop + 1 - y1)*hrana1_x;
    int second  = (mostLeft - 1 - x2)*hrana2_y - (mostTop + 1 - y2)*hrana2_x;
    int third   = (mostLeft - 1 - x3)*hrana3_y - (mostTop + 1 - y3)*hrana3_x;
    int denominatorLbd = (y2-y3)*(x1-x3) + (x3-x2)*(y1-y3);
    double lambda1, lambda2, lambda3, z;
    if(denominatorLbd == 0)
	return; 

    // Zleva Doprava
/*
Ei(x+1,y)=Ei(x,y)+dyi
Ei(x-1,y)=Ei(x,y)-dyi
Ei(x,y+1)=Ei(x,y)   -  dxi
Ei(x,y-1)=Ei(x,y)   +   dxi
*/
    for (y = mostTop; y >= mostBottom; y -= 1)
    {
	first  += hrana1_x;
	second += hrana2_x;
	third  += hrana3_x;
    	for (x = mostLeft; x <= mostRight; x += 1)
    	{
	    first  += hrana1_y;
	    second += hrana2_y;
	    third  += hrana3_y;
#ifdef DEBUGDRAW
	    printf("[%d, %d] (%3d,%3d,%3d) ", x, y, first, second, third);
#endif
            if (first >= 0 && second >= 0 && third >= 0)
	    {
                lambda1 = ((y2-y3)*(x-x3) + (x3-x2)*(y-y3))/ (double) denominatorLbd;
                lambda2 = ((y3-y1)*(x-x3) + (x1-x3)*(y-y3))/ (double) denominatorLbd;
                lambda3 = 1 - lambda1 - lambda2;
                z = v1->z * lambda1 + v2->z * lambda2 + v3->z * lambda3;
		if(DEPTH(pRenderer, x, y) > z)
		{
 			nPoint = makeCoords(n1->x * lambda1 + n2->x * lambda2 + n3->x * lambda3,
					    n1->y * lambda1 + n2->y * lambda2 + n3->y * lambda3,
					    n1->z * lambda1 + n2->z * lambda2 + n3->z * lambda3);
			coordsNormalize(&nPoint);
 			vPoint = makeCoords(v1->x * lambda1 + v2->x * lambda2 + v3->x * lambda3,
					    v1->y * lambda1 + v2->y * lambda2 + v3->y * lambda3,
					    z);

                	PIXEL(pRenderer, x, y) = pRenderer->calcReflectanceFunc(pRenderer, &vPoint, &nPoint);  
			DEPTH(pRenderer, x, y) = z;
		}
#ifdef DEBUGDRAW
		printf("1 ");
            }
	    else
	    {
		printf("0 ");
#endif		
	    }
        }
#ifdef DEBUGDRAW
	    printf("\n");
#endif
	y--;
        if(y < mostBottom)
            break;
	first  += hrana1_x;
	second += hrana2_x;
	third  += hrana3_x;
        first  += hrana1_y;
	second += hrana2_y;
	third  += hrana3_y;
    	for (x = mostRight; x >= mostLeft; x -= 1)
    	{
	    first  -= hrana1_y;
	    second -= hrana2_y;
	    third  -= hrana3_y;
#ifdef DEBUGDRAW
	    printf("[%d, %d] (%3d,%3d,%3d) ", x, y, first, second, third);
#endif
            if (first >= 0 && second >= 0 && third >= 0)
	    {
                lambda1 = ((y2-y3)*(x-x3) + (x3-x2)*(y-y3))/ (double) denominatorLbd;
                lambda2 = ((y3-y1)*(x-x3) + (x1-x3)*(y-y3))/ (double) denominatorLbd;
                lambda3 = 1 - lambda1 - lambda2;
                z = v1->z * lambda1 + v2->z * lambda2 + v3->z * lambda3;
		if(DEPTH(pRenderer, x, y) > z)
		{
 			nPoint = makeCoords(n1->x * lambda1 + n2->x * lambda2 + n3->x * lambda3,
					    n1->y * lambda1 + n2->y * lambda2 + n3->y * lambda3,
					    n1->z * lambda1 + n2->z * lambda2 + n3->z * lambda3);
			coordsNormalize(&nPoint);
 			vPoint = makeCoords(v1->x * lambda1 + v2->x * lambda2 + v3->x * lambda3,
					    v1->y * lambda1 + v2->y * lambda2 + v3->y * lambda3,
					    z);

			DEPTH(pRenderer, x, y) = z;
                	PIXEL(pRenderer, x, y) = pRenderer->calcReflectanceFunc(pRenderer, &vPoint, &nPoint);  
		}
#ifdef DEBUGDRAW
		printf("1 ");
            }
	    else
	    {
		printf("0 ");
#endif		
	    }
        }
#ifdef DEBUGDRAW
	printf("\n");
#endif
	first  -= hrana1_y;
	second -= hrana2_y;
        third  -= hrana3_y;

    }
#ifdef DEBUGDRAW
	    printf("\n");
	    printf("\n");
#endif
    
}

/*****************************************************************************
 * Vykresli i-ty trojuhelnik modelu
 * Pred vykreslenim aplikuje na vrcholy a normaly trojuhelniku
 * aktualne nastavene transformacni matice!
 * i - index trojuhelniku */

void studrenProjectTriangle(S_Renderer *pRenderer, S_Model *pModel, int i)
{
    S_Coords    aa, bb, cc;             /* souradnice vrcholu po transformaci ve 3D pred projekci */
    S_Coords    nn, n1, n2, n3;         /* normala trojuhelniku po transformaci */
    int         u1, v1, u2, v2, u3, v3; /* souradnice vrcholu po projekci do roviny obrazovky */
    
    S_Triangle  * triangle;

    IZG_ASSERT(pRenderer && pModel && i >= 0 && i < trivecSize(pModel->triangles));

    /* z modelu si vytahneme trojuhelnik */
    triangle = trivecGetPtr(pModel->triangles, i);

    /* transformace vrcholu matici model */
    trTransformVertex(&aa, cvecGetPtr(pModel->vertices, triangle->v[0]));
    trTransformVertex(&bb, cvecGetPtr(pModel->vertices, triangle->v[1]));
    trTransformVertex(&cc, cvecGetPtr(pModel->vertices, triangle->v[2]));

    /* promitneme vrcholy trojuhelniku na obrazovku */
    trProjectVertex(&u1, &v1, &aa);
    trProjectVertex(&u2, &v2, &bb);
    trProjectVertex(&u3, &v3, &cc);

    /* transformace normaly trojuhelniku matici model */
    trTransformVector(&nn, cvecGetPtr(pModel->trinormals, triangle->n));
    trTransformVector(&n1, cvecGetPtr(pModel->normals, triangle->v[0]));
    trTransformVector(&n2, cvecGetPtr(pModel->normals, triangle->v[1]));
    trTransformVector(&n3, cvecGetPtr(pModel->normals, triangle->v[2]));
    
    /* normalizace normaly */
    coordsNormalize(&nn);
    coordsNormalize(&n1);
    coordsNormalize(&n2);
    coordsNormalize(&n3);

    /* je troj. privraceny ke kamere, tudiz viditelny? */
    if( !renCalcVisibility(pRenderer, &aa, &nn) )
    {
        /* odvracene troj. vubec nekreslime */
        return;
    }

    /* rasterizace celeho trojuhelniku */
    studrenDrawTriangle(pRenderer,
                    &aa, &bb, &cc, &n1,&n2,&n3,
                    u1, v1, u2, v2, u3, v3
                    );
}

/*****************************************************************************
 *****************************************************************************/
