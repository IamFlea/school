/***********************************************************************
 * Soubor: get_url.c                                                   *
 * Autor: Petr Dvoracek                                                *
 * Predmet: IVS                                                        *
 * Projekt: 3. - git, knihovny, make, debugging profiling, dokumentace *
 * Popis: stahnuti souboru, ulozeni na dane misto                      *
 ***********************************************************************/
/**
 * @file	get_url.c
 * @author 	Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * @version	0.2
 * @section DESCRIPTION
 *
 * Tento program stahne soubory do daneho adresare.
 */
#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>
#include <curl/types.h>
#include <curl/easy.h>
#include <string.h>

/**
 * Napisu do souboru.
 */

size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    return fwrite(ptr, size, nmemb, stream);
}

/**
 * Stazeni souboru
 * @param char *url webova adresa
 * @param char *outfilename do jakeho souboru se to ma zapsat
 * @return Jestli vse probehlo v poradku, tak 0.
 */
int download(char *url, char *filename) {
    CURL *curl;
    FILE *fp;
    CURLcode res;
    fp = fopen(filename,"wb");
    if(! fp)
        return 0;
    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
        res = curl_easy_perform(curl);
        /* always cleanup */
        curl_easy_cleanup(curl);
        fclose(fp);
        return 1;
    }
    return 0;
}
/* Konec souboru get_url.c */
