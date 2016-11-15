/*
 * MM.cpp    CLA Parallel binnary adder
 *
 * Ach jo ja se tech scitacek tento semestr nezbavim.
 *
 * Petr Dvoracek  <xdvora0n@stud.fit.vutbr.cz>
 */

#include <mpi.h>
#include <math.h>
#include <sys/time.h>
#include <iostream>
#include <fstream>

using namespace std;

#define TAG      4
#define TAG_A    8
#define TAG_B   15

#define STATE_P 16
#define STATE_G 23
#define STATE_S 42

double time_diff(struct timeval x , struct timeval y)
{
    double x_ms , y_ms , diff;
    x_ms = (double)x.tv_sec*1000000 + (double)x.tv_usec;
    y_ms = (double)y.tv_sec*1000000 + (double)y.tv_usec;
    diff = (double)y_ms - (double)x_ms;
    return diff;
}

int main(int argc, char *argv[])
{
    int numprocs; // pocet procesoru
    int myid;     // rank cpu
    MPI_Status stat;            //struct- obsahuje kod- source, tag, error

    MPI_Init(&argc,&argv);                          // inicializace MPI
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);       // zjistíme, kolik procesů běží
    MPI_Comm_rank(MPI_COMM_WORLD, &myid);           // zjistíme id svého procesu

    int my_x = -2;
    int my_y = -2;
    int my_op;

    // Zasadime Smrcku na poli.
    int my_parent = (myid != 0) ? (myid - 1)/2 : myid;
    int my_son_a  = 2*myid + 1;
    int my_son_b  = 2*myid + 2;
    if(my_son_a >= numprocs || my_son_b >= numprocs){
        my_son_a = myid;
        my_son_b = myid;
    }

    int leavesProcsCnt   = (numprocs + 1)/2;   // pocet listovych procesoru
    int leavesProcsStart = leavesProcsCnt - 1; // pocatek listovych procesoru
    // Nacteni hodnot ze souboru.
    if(myid == 0) { 
        char input[]= "numbers";  //jmeno souboru
        fstream fin;              

        // Zjisteni delky retezce binarniho cisla
        fin.open(input, ios::in);
        int number_size = 0;
        char nextinput;
        int number;
        while(fin.get() != '\n')
            number_size++; 
        fin.close(); // Ano je to skarede, ale nejsme v IZP.
        
        // Poslani hodnot listum -- znovu otevreni souboru
        fin.open(input, ios::in);
        // Pokud je retezec delsi nez pocet procesru, preskoci nejvyznamnejsi bity.
        for(int i = 0; i < (number_size - leavesProcsCnt); i++){ 
            nextinput = fin.get();
        }
        // Ctu ze souboru
        for(int i = leavesProcsStart; i < (leavesProcsStart + leavesProcsCnt); i++){

            // Pokud je ale pocet procesoru vetsi nez delka retezce, posilam nuly
            if((number_size+i-leavesProcsStart) < leavesProcsCnt) {
                //cout << "hi" << endl;
                number = 0;
                MPI_Send(&number, 1, MPI_INT, i, TAG_A, MPI_COMM_WORLD);
                continue;
            }

            nextinput = fin.get();
            if(nextinput == '0')
                number = 0;
            else if(nextinput == '1')
                number = 1;
            else
                number = -1;
            //cout << "sending cpu"<< i << " " << number << endl;
            MPI_Send(&number, 1, MPI_INT, i, TAG_A, MPI_COMM_WORLD);
        }
        
        nextinput = fin.get();
        if(nextinput != '\n')
            cerr << "Neco spatne." << endl;

        // Pokud je retezec delsi nez pocet procesru, preskoci nejvyznamnejsi bity.
        for(int i = 0; i < (number_size - leavesProcsCnt); i++){ 
            nextinput = fin.get();
        }
        // Ctu ze souboru
        for(int i = leavesProcsStart; i < (leavesProcsStart + leavesProcsCnt); i++){
            // Pokud je ale pocet procesoru vetsi nez delka retezce, posilam nuly
            if((number_size+i-leavesProcsStart) < leavesProcsCnt) {
                number = 0;
                MPI_Send(&number, 1, MPI_INT, i, TAG_B, MPI_COMM_WORLD);
                continue;
            }

            nextinput = fin.get();
            //cout << nextinput << endl;
            if(nextinput == '0')
                number = 0;
            else if(nextinput == '1')
                number = 1;
            else
                number = -1;
            //cout << "sending cpu"<< i << " " << number << endl;
            MPI_Send(&number, 1, MPI_INT, i, TAG_B, MPI_COMM_WORLD);
        }
        fin.close();
    } else if(myid >= leavesProcsStart){
        MPI_Recv(&my_x, 1, MPI_INT, 0, TAG_A, MPI_COMM_WORLD, &stat); 
        MPI_Recv(&my_y, 1, MPI_INT, 0, TAG_B, MPI_COMM_WORLD, &stat); 
    }
    //cerr << "CPU" << myid << " x: " << my_x << " y:"<< my_y << " Parent: " << my_parent <<" Son a:" << my_son_a << " Son b:"<< my_son_b << endl;

struct timeval before , after;
if(myid == 0)
    gettimeofday(&before , NULL);

    // Inicializace promenne D
    int my_d;
    if(my_x == 1 && my_y == 1){
        my_d = STATE_G;
    }else if(my_x == 0 && my_y == 0){
        my_d = STATE_S;
    }else{
        my_d = STATE_P;
    }
    
    // Upsweep
    int my_a, my_b;
    for(int j = 0; j <= log2(leavesProcsCnt); j++){
        // Uzel neni Koren-ek Smrcky
        if(myid != 0)
            MPI_Send(&my_d, 1, MPI_INT, my_parent, TAG, MPI_COMM_WORLD);

        // Jehlici (listy) stromu nic neprijimaji
        if(myid != my_son_a || myid != my_son_b){
            MPI_Recv(&my_a, 1, MPI_INT, my_son_a, TAG, MPI_COMM_WORLD, &stat);
            MPI_Recv(&my_b, 1, MPI_INT, my_son_b, TAG, MPI_COMM_WORLD, &stat);
            if(my_a == STATE_S)
                my_d = STATE_S;
            else if(my_a == STATE_G)
                my_d = STATE_G;
            else
                my_d = my_b;
        }
    }

    // Korenovy uzel neutralizujeme (priradime neutralni prvek)
    if(myid == 0){
        if(my_d == STATE_G)
            cout << /*beer*/ "overflow" << endl; // skoda kapky ktera padne vedle
        my_d = STATE_P; // Dle tabulky na slajdech je P neutralni
    }

    // Downsweep 
    for(int j = 0; j <= log2(leavesProcsCnt); j++){
        if(myid != 0)
            MPI_Recv(&my_d, 1, MPI_INT, my_parent, TAG, MPI_COMM_WORLD, &stat);

        if(myid != my_son_a && myid != my_son_b){
            int tmp;
            if(my_b == STATE_S)
                tmp = STATE_S;
            else if(my_b == STATE_G)
                tmp = STATE_G;
            else
                tmp = my_d;

            MPI_Send(&tmp, 1, MPI_INT, my_son_a, TAG, MPI_COMM_WORLD);
            MPI_Send(&my_d, 1, MPI_INT, my_son_b, TAG, MPI_COMM_WORLD);
        }
    }

    int carry = 0;
    if(my_d == STATE_G)
        carry = 1;

    if(myid == my_son_a || myid == my_son_b)
        cout << myid << ":" << (my_x ^ my_y ^ carry) << endl;

if(myid == 0){
    gettimeofday(&after , NULL);
    cerr << "Elapsed time: " << time_diff(before, after) << " us"<<endl;
}
    MPI_Finalize();
    return 0;
}//main

