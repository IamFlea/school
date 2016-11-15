/*
 * LINEAR ENUMERATION SORT
 * Petr Dvoracek  <xdvora0n@stud.fit.vutbr.cz>
 */

#include <mpi.h>
#include <iostream>
#include <fstream>
#include <sys/time.h>

using namespace std;

#define TAG 0
#define TAG_A 1
#define TAG_B 1
#define PROC_CNT 16  // maximalne 2^16 procesoru, z duvodu "konkatenace" pri stejnych hodnotach

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
  int numprocs;               //pocet procesoru
  int myid;                   //muj rank
  MPI_Status stat;            //struct- obsahuje kod- source, tag, error

  int tmp;         // pomocna promenna
  int ptr = 0;     // pocitadlo, kolik znaku bylo precteno .. toto konkatenujeme.
  int my_c = 0;    // hodnota C pocet prvku mensich nez x
  int my_x = -1;   // hodnota X
  int my_y = -1;   // hodnota Y
  int my_z = -1;   // hodnota Z

  char input[]= "numbers";  //jmeno souboru
  fstream fin;              
  fin.open(input, ios::in); // cteni ze souboru.

  //MPI INIT
  MPI_Init(&argc,&argv);                          // inicializace MPI
  MPI_Comm_size(MPI_COMM_WORLD, &numprocs);       // zjistíme, kolik procesů běží
  MPI_Comm_rank(MPI_COMM_WORLD, &myid);           // zjistíme id svého procesu
struct timeval before , after;
if(myid == 0)
    gettimeofday(&before , NULL);
  // Prolog, nastavime inicializacni hodnotu
  my_c  = 0; // nastaveni pocatecni hodnoty c.. 

  // Radime. (Mysleno jako sorting nikoli rioting.)
  for(int k = 0; k<2*numprocs; k++){
      int h = ((k < numprocs) ? 0 : k-numprocs);
      if((myid >= h) && (my_x > my_y) && ((my_x != -1)&&(my_y != -1))){
          my_c++;
      }
      if(myid >= h) {
          if(myid != (numprocs - 1)) { 
            MPI_Send(&my_y, 1, MPI_INT, myid+1, TAG, MPI_COMM_WORLD); //buffer,velikost,typ,rank prijemce,tag,komunikacni skupina
          }
          if(myid > h) {
            MPI_Recv(&tmp, 1, MPI_INT, myid-1, TAG, MPI_COMM_WORLD, &stat); //buffer,velikost,typ,rank odesilatele,tag, skupina, stat
            my_y = (tmp == -1) ? my_y : tmp; // byla-li poslana inicializacni hodnota.. zahodime ji
          }
      }
      if(k < numprocs){
          /*
          int nextinput;
          if(fin.good()){
              ptr++;
              nextinput = fin.get();
              if(myid == 0) cout << nextinput << " "; // tisk neserazenych hodnot na std out oddelenych mezerou pouze pro jeden proces!
              nextinput = (nextinput << PROC_CNT) | ptr; // nase slavna konkatenace
          } else { // Nebulo nic precteon
              cerr << "Neplatny soubor. !@#$%"<<endl; // Tisk chyby s vulgarni nadavkou
              return 1;
          }
          if(myid == 0) my_y = nextinput;
          if(myid == k) my_x = nextinput;
          */
          if(myid == 0) {
              int nextinput;
              if(fin.good()){
                  ptr++;
                  nextinput = fin.get();
                  if(myid == 0) cout << nextinput << " "; // tisk neserazenych hodnot na std out oddelenych mezerou pouze pro jeden proces!
                  nextinput = (nextinput << PROC_CNT) | ptr; // nase slavna konkatenace
              } else { // Nebulo nic precteon
                  cerr << "Neplatny soubor. !@#$%"<<endl; // Tisk chyby s vulgarni nadavkou
                  return 1;
              }
              my_y = nextinput;
              MPI_Send(&nextinput, 1, MPI_INT, ptr-1, TAG_B, MPI_COMM_WORLD); // posleme to co mame
          }
          if(myid == k) {
              MPI_Recv(&my_x, 1, MPI_INT, 0, TAG_B, MPI_COMM_WORLD, &stat); // a cekame na prijem odkudkoli
          }
      } else {
          int K = k-numprocs;
          if(K == myid){
              MPI_Send(&my_x, 1, MPI_INT, my_c, TAG_A, MPI_COMM_WORLD); // posleme to co mame
              MPI_Recv(&my_z, 1, MPI_INT, MPI_ANY_SOURCE, TAG_A, MPI_COMM_WORLD, &stat); // a cekame na prijem odkudkoli
          }
      }
  }
  if(myid == 0) cout << endl; // vytisknuti noveho radku
  // Epilogue - tisk uz serazenych hodnot, nepouziva se sbernice
  for(int k = 0; k < numprocs; k++) {
        if(0 == myid) 
            cout << (my_z >> PROC_CNT) << endl;
        if(myid > 0) 
            MPI_Send(&my_z, 1, MPI_INT, myid-1, TAG, MPI_COMM_WORLD); //buffer,velikost,typ,rank prijemce,tag,komunikacni skupina
        if(myid != (numprocs - 1))
            MPI_Recv(&my_z, 1, MPI_INT, myid+1, TAG, MPI_COMM_WORLD, &stat); //buffer,velikost,typ,rank odesilatele,tag, skupina, stat
  }
if(myid == 0){
    gettimeofday(&after , NULL);
    cerr << "Elapsed time: " << time_diff(before, after) << " us"<<endl;
}
  MPI_Finalize();
  return 0;
}//main

