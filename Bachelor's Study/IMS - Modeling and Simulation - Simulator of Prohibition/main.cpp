/**
 * File:    main.cpp
 * Project: Simulation of prohibition. Godfather
 * Authors: Petr  Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 *          Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
 * Date:    Dec 2012
 *
 * FIXME please.
 * You must be drunk, then the system is valid... 
 */
#include <simlib.h> // Simlib library
#include <time.h>   // For ranodm()
#include <string>   // Parsing file || params
#include <stdio.h>
#include <stdlib.h>
#include <list> 
#include <iostream> // working with streams
#include <sstream> // working with streams
#include <fstream>
#include <iomanip> // working with streams
#include <math.h>   // Maths
using namespace std;

////////////////////////////////////////////////////////////////////////////////
// DEBUG
#define DEBUG
//#define DEBUG_RNDLOG
//#define DEBUG_BATCH
//#define DEBUG_LAST_YEAR
//#define DEBUG_IMPORT_TIME
#define POLLING
Histogram batchHistogram("DEBUG", 0, 1, 500);
Histogram lastYearHistogram("DEBUG", 0, 1, 500);
Histogram itHistogram("DEBUG", 0, 0.00069, 100);

int first = true;


////////////////////////////////////////////////////////////////////////////////
// Definitions

// Size of buffer for interval
#define MAX_BUFFER_INT 10

// Error codes of program
#define E_OK     0x0000
#define E_PARAMS 0x0001
#define E_FILE   0x0002

// Companies
#define P_UNKNOWN    0x00
#define P_DISTILLERY 0x01
#define P_BIG_SHOP   0x02 // CZ VELKOOBCHOD
#define P_SHOP       0x04
#define P_PUB        0x08

// If we were on Mars... 
#define DAY     1
#define HOUR    1.0/24.0
#define MINUTE  1.0/(24.0*60.0)
//#define DAY  24*60
//#define HOUR 60 
//#define MINUTE 1

// Average batch has 4626 bottles
#define AVERAGE_BATCH 4626

// Injected methanol (for one distillery)
#define INJECTED_METHANOL 0.5

////////////////////////////////////////////////////////////////////////////////
// Structs & typedefs

typedef double TPercent;

// Interval
typedef struct{
    int a;  // From
    int b;  // To
} TInterval;

// Companies
typedef struct{
    int       c_type;         // Type of shop. Viz Companies definition
    int       c_sum;          // Count of companies
    TInterval c_bottles;      // Count of bottles in interval
    TPercent  c_BLastYear;    // Produced last year
    TPercent  c_BImport;      // Imprted bottles this year
    TPercent  c_BMethanol;    // Chance for methanol bottle (second solution)
} TCompany;

// Bottles
typedef struct{
    long long b_sum;          // Sum of bottles
    long long b_lastYear;     // Whiskey produced last year
    long long b_imported;     // Imported whiskey
    long long b_methanol;     // Methanol ones
    long long b_notChecked;   // Not checked bottles
} TBottles;

// Labs
typedef struct{
    int lab_sum;              // Sum of labs
    int lab_price;            // Price for test in the lab (CZK)
    TInterval lab_speed;      // Speed of labs.
} TLabs;



////////////////////////////////////////////////////////////////////////////////
// Functions 
double    MyNormal(double, double);
void      printGeneratedAlcohol(void);
void      printHelp (void);
void      printError(int);
int       printComp(void);
void      printPrices(void);
void      getParams(int, char**);
TInterval parseInterval(string);
void      parseFile(string);



////////////////////////////////////////////////////////////////////////////////
// Global vars

// Max of 4 companies TYPE          SUM    ALCOHOL      %LastY %Import %Methanol
TCompany gCompany1 = {P_DISTILLERY, 300,{20000, 50000}, 0.000, 0.000, 0.002};
TCompany gCompany2 = {P_BIG_SHOP,   186,{10000, 30000}, 0.075, 0.112, 0.000001};
TCompany gCompany3 = {P_SHOP,     10000,{200, 500},     0.075, 0.011, 0.001};
TCompany gCompany4 = {P_PUB,      49223,{60, 110},      0.075, 0.005, 0.001};

// Price of gas in CZK
TInterval gPriceGass = {15, 20};    // Price of gass

// Labs
TLabs gLab1 = {15,  1000, {9, 11}}; // Chromatograph
TLabs gLab2 = {100, 20,  {1, 1}};   // Spektrometer
int   gLengthToLab      = 25; // Mean lenght
int   gMethanolInjected = false;// Was methanol added in distillery
int   gMethBottlesFound = false;// Methanol bottles found
int   g_CH3OH_Bottles = 0;    // How much methanol bottlesve been found 
// Sum of bottles of every company
TBottles gBottles = {0, 0, 0, 0, 0};

// Simulation
double gLengthSim = 60*DAY;   // Length of simulation
int    gDay       = 0;        // Day of simulation
bool   gFoundMethanol = false;// Methanol
int    gCompleted = 0;        // Completed companies
long long gAllB = 0;          // ALl bottles

// User defined variables
int    flag_ss       = 0;     // Another solution
int    flag_n        = 0;     // Normalized percents
int    flag_net      = 0;     // Normalized percents
int    flag_l        = 0;     // Normalized last year only
int    flag_i        = 0;     // Normalized import only
int    flag_w        = 0;     // Wait() simlib
int    flag_p        = 0;     // Printing: CH3OH dealer found 
int    flag_d        = 0;
int    flag_r        = 0;     // ROvnomerne
double importTime    = HOUR;  // How long takes doing import things...
int    gPhoneCall    = 3;     // How long takes doing phone call
int    gPhonePrice   = 5;     // Phone price
int    gCert         = 3;     // Price of paper
TPercent perDist     = 0.20;  // How much % is imported from Czech distillery
TPercent perBadBadge = 0.33;  // How much % isn't found 



////////////////////////////////////////////////////////////////////////////////
// Simulations vars...
Queue gQDist;
Queue gQShop;
Queue gQPhone; 

Queue gQLab; // Queue for both labs
Store Lab1("Chromatograph (slow)", gLab1.lab_sum);
Store Lab2("Spectrometer  (fast)", gLab2.lab_sum);

// Stats - Bottles
//Stat sBBottles("Bottles - sum");
//Stat sBLastYear("Bottles - last year");
//Stat sBMethanol("Bottles - methanol");

// Stats - price
Stat sPPubs("Costs - pubs (CZK)");
Stat sPBigShop("Costs - big shops (CZK)");
Stat sPShop("Costs - shops (CZK)");
Stat sPDistillery("Costs - distillery (CZK)");

TBottles gCmp1 = {0,0,0,0,0};
TBottles gCmp2 = {0,0,0,0,0};
TBottles gCmp3 = {0,0,0,0,0};
TBottles gCmp4 = {0,0,0,0,0};

////////////////////////////////////////////////////////////////////////////////
// Company class
class Company : public Process
{
    int      type;            // Type of comp.
    TPercent perLastYear;     // Specific % of last year destialtes
    TPercent perImport;       // Imported % destialtes this year
    TPercent perMethanol;     // % destialtes that contain methanol
    TBottles bottles;         // Bottles of alcohol 
    int      costs;           // Price (CZK)
    int      batch;           // (po cesky: sarze) 
    int      batchNotChecked; // not checked batches
    int      wasInLab;        // Was in lab??

    /**
     * Randogarithm (Random + Logarithm)
     * Two "logarithmic" functions with random selection in it
     * Usage batches and bottles....
     *
     * y         yMax
     * ^       ,->
     * |    ,-'
     * |   /       ,-> 
     * |  /__,----'  yMin
     * |.'
     * +--------------------> x
     * Sorry for random magic numbers..
     *
     * @param  int x
     * @return int y -- random number between yMin and yMax
     */
    int Randogarithm(int x)
    {
        double yMin, yMax;
        if(x <= 0)
            return 0;
        if(x <= 3)
            return x;
        if(x <= 10)
        {
            // I know this sucks, but meh...  abs() meh... 
            // Nobody likes math... 
            yMin = (int) ((2.0/7.0) * (double) (x - 3) + 3);
            yMax = x;
        }
        else if(x <= 100)
        {
            yMin = ((5.0/90.0) * (double) (x - 10) + 5);
            yMax = ((5.0/90.0) * (double) (x - 10) + 10);
        }
        else if(x <= 1000)
        {
            yMin = ((15.0/900.0) * (double) (x - 100) + 10);
            yMax = ((30.0/900.0) * (double) (x - 100) + 30);
        }
        else if(x <= 10000)
        {
            yMin = ((25.0/9000.0) * (double) (x - 1000) + 25);
            yMax = ((190.0/9000.0) * (double) (x - 1000) + 60);
        }
        else 
        {
            yMin = ((50.0/90000.0) * (double) (x - 10000) + 50);
            yMax = ((250.0/90000.0) * (double) (x - 10000) + 250);
        }
        return (int) Uniform(yMin, yMax);
    }



public:
    /**
     * This is constructor. 
     * If you dont know what constructor do.... Do facepalm. Thanks.
     */
    Company(int f, int t, double i, double l, double m)
    {
        bottles.b_notChecked = 0;
        bottles.b_sum = 0;
        bottles.b_lastYear = 0;
        bottles.b_methanol = 0;
        bottles.b_imported = 0;
        bottles.b_sum        = f;
        bottles.b_notChecked = f;
        type                 = t;

        perImport            = i;
        perLastYear          = l;
        perMethanol          = m;

        wasInLab = false;

        double yMin = 0;
        double yMax = 0;

        // Hide alcohol from desks etc.
        // If there is Big shop (velkoobchod) with alcohol, it is just closed.
        // Same as distillery
        if(type >= P_SHOP)
            costs =  f / 10;
        else
            costs = 0;

        // Create batches from bottles
        if(type == P_DISTILLERY)
        {
            batch++;
            batch += f / AVERAGE_BATCH;
        }
        else
            batch = Randogarithm(f);
        batchNotChecked = batch;
#ifdef DEBUG_BATCH
        batchHistogram(batch);
#endif
    }

    /**
     * Computes bottles we dont need
     */
    void LastYear()
    {
        bottles.b_lastYear    = perLastYear * bottles.b_sum;
        bottles.b_notChecked -= bottles.b_lastYear;
        gAllB += bottles.b_lastYear; 
        int b = batch * bottles.b_lastYear / bottles.b_sum;

        if(bottles.b_lastYear)
        {
            if(!( perLastYear > 0.0))
                b = 1;
        }
        else
            b = 0;
        batchNotChecked -= b;
#ifdef DEBUG_LAST_YEAR
        lastYearHistogram(b);
#endif
        return;
    }

    /**
     * Arrival to lab
     */
    void Arrival()
    {
        double lengthToLab = Exponential(gLengthToLab);
        if (lengthToLab <= 1) 
            lengthToLab = 1;
        if (lengthToLab > 100) 
            lengthToLab = 100;

        // We are going there and back Thats why 2.
        int a = 2 * gPriceGass.a * lengthToLab;
        int b = 2 * gPriceGass.b * lengthToLab;
        costs = Uniform(a, b);
    }


    /**
     * Calculate import
     */
    void Import()
    {
        bottles.b_imported    = perImport * bottles.b_notChecked;
        bottles.b_notChecked -= bottles.b_imported;
        gAllB += bottles.b_imported; 
        int b = batchNotChecked * bottles.b_imported / bottles.b_notChecked;
        if(bottles.b_imported)
        {
            if(! ( perImport > 0.0))
                b = 1;
        }
        else
            b = 0;
        batchNotChecked -= b;
        if(b != 0)
        {
            if(flag_w)
                Wait(importTime*b);
            //cout << "b" << b <<"it"<<importTime << " " <<flush;
#ifdef DEBUG_IMPORT_TIME
            itHistogram(importTime*b);
#endif
        }
        return;
    }
    
    double mUniform(double a, double b)
    {
        if(a==b)
            return a*MINUTE;
        else
            return Uniform(a*MINUTE, b*MINUTE);
    }

    /**
     * Check in lab
     * @param int oneCheck.. if not equal 0, only one cycle is completed.
     */
    void CheckInOneLab(int oneCheck)
    {
        wasInLab = true;
        int methanol;
        while(batchNotChecked)
        {
            Enter(Lab1, 1);
            if(flag_w)
                Wait(mUniform(gLab1.lab_speed.a, gLab1.lab_speed.b));
            costs += gLab1.lab_price; 
            Lab1.Leave(1);

            // Creating protocol about methanol
            methanol = bottles.b_notChecked / batchNotChecked;
            bottles.b_notChecked -= methanol;
            gAllB += methanol; 
            if(Random() < perMethanol)
                bottles.b_methanol += methanol;
            else
                costs += gCert;
            batchNotChecked--;
             
            if(oneCheck)
                break;
        }

    }

    /**
     * Get birth certification... 
     * Checks if the whiskey is ok.
     */
    void GetBirthCert()
    {
        if(type == P_DISTILLERY) return;
        Queue *q;
        Entity * comp;
        int served = true;
        int methanol;
        while(batchNotChecked)
        {
            // Served
            if(served)
            {
                served = false;
                if(P_BIG_SHOP) 
                    q = gQDist;
                else
                {
                    if(Random() < perDist)
                        q = gQDist;
                    else
                        q = gQShop;
                }
            }
#ifdef POLLING
            if(q->Empty())
            {
                // Wait a bit
                if(flag_w)
                    Wait(HOUR/4);

                if(flag_net)
                {
                    // Found birth certificate on the internet
                    if(Random() < 0.05)
                        goto getCert; 
                }
            }
            else
#endif
            {
#ifdef POLLING
                // Calling on the Bigshop or distillery phone 
                comp = q->GetLast();
                if(flag_w)
                    Wait(gPhoneCall*MINUTE);
                costs += gPhonePrice;
                //meth = ((Company *)comp)->bottles.b_methanol;
                q->Insert(comp);
#else
                // Calling on some bigshop NOT POLLING
                if(flag_w)
                    Wait(MINUTE);
                costs += gPhonePrice;
#endif
                // They dont have this badge. 
                if(Random() < perBadBadge) 
                {
                    // Check this one in lab
                    if(type != P_PUB && Random() < 0.005)
                        CheckInOneLab(true);
                    // OR continue... 
                    continue;
                }
               
getCert:
                // Remove methanol 
                methanol = bottles.b_notChecked / batchNotChecked;
                bottles.b_notChecked -= methanol;
                gAllB += methanol; 
                if(Random() < perMethanol)
                    bottles.b_methanol += methanol;
                else
                    costs += gCert;
                batchNotChecked--;
                served = true;
            }
        }
        return;
    }

    /**
     * Birth certification
     */
    void BetterSolution()
    {
        LastYear();
        Import();
        if (type == P_DISTILLERY)
            CheckInOneLab(0);
        else
        {
            if(flag_w)
                Wait(5*HOUR);
            GetBirthCert();
        }
        return;
    }

    /**
     * Checking bottle by bottle... 
     *
     * - Found CH3OH
     *    y]  1% LAB1 // Cant be served in LAB2
     *       99% LAB2 // Faster cheaper etc.
     *    n] PRIORITY_LAB2 // faster cheaper
     *       LAB1 
     *       QueueForBothLabs
     * - Check methanol
     *    notFound CH3OH dealer -> FOUND HIM
     */
    void CheckBottleByBottle()
    {
        int again = true;
        if (gMethBottlesFound)
        {   // DEAD CODE BEGIN
            // Uses "faster" and "cheaper" solution
            //  But unfornetly queue for both doesnt work... 
foundCH3OH:
            // In 1% is needed to use slower lab. Spektrometer isnt good enough
            if(Random() < 0.01)
            {
                Enter(Lab1, 1);
                bottles.b_notChecked--;
                costs += gLab1.lab_price;
                Wait(mUniform(gLab1.lab_speed.a, gLab1.lab_speed.b));
                Lab1.Leave(1);
            }
            // Else 99% we are using faster lab
            else
            {
                Enter(Lab2, 1);
                bottles.b_notChecked--;
                costs += gLab2.lab_price;
                Wait(mUniform(gLab2.lab_speed.a, gLab2.lab_speed.b));
                Lab2.Leave(1);
            }
            // DEAD CODE END
        }
        else 
        {
            // Using slow 
            while(again == true)
            {
                // Store with priority
                if(Lab2.Free())
                {
                    Enter(Lab2, 1);
                    bottles.b_notChecked--;
                    costs += gLab2.lab_price;
                    Wait(mUniform(gLab2.lab_speed.a, gLab2.lab_speed.b));
                    Lab2.Leave(1);
                    again = false;
                } 
                // Secundary store
                else if(Lab1.Free())
                {
                    Enter(Lab1, 1);
                    bottles.b_notChecked--;
                    costs += gLab1.lab_price;
                    Wait(mUniform(gLab1.lab_speed.a, gLab1.lab_speed.b));
                    Lab1.Leave(1);
                    again = false;
                }
                // Passivate prcess and save it into 
                else
                {
                    gQLab.InsFirst((Process *) this);
                    Passivate();
                    if(gMethBottlesFound)
                        goto foundCH3OH;
                }
            }

            // Kick the sleeping process
            if(! gQLab.Empty())
                (gQLab.GetFirst())->Activate();
        }
        if(perMethanol > Random())
        {
            bottles.b_methanol++;
            g_CH3OH_Bottles++; 
            // n BOTTLES CONTAINS METHANOL (CH3OH)
            // 
            // We found methanol dealer
            if(! gMethBottlesFound && g_CH3OH_Bottles >= 10 && flag_p)
            {
                gMethBottlesFound = true;
                if(flag_p)
                {
                    cout << "Found methanol dealer at: " 
                         << (int) Time << "d "
                         << "("<<Time<<" model time)"
                         << endl;
                }
                // Kick them all
                // int i = 0;
                //while(! gQLab.Empty() &&  flag_d)
                //{
                    //(gQLab.GetFirst())->Activate();
                    //i++;
                //}
            }
        }
    }

    /**
     * Bruteforce checking of every bottle
     * It is not good as all, but there is some enchanting magic...
     */
    void GoodSolution()
    {
        LastYear();
        // There are only 60 years old whiskeys
        if(bottles.b_notChecked == 0)
            return;

        // Arrival to place
        Arrival();

        do {
            CheckBottleByBottle(); 
            gAllB++;
        }while(bottles.b_notChecked);
    }


    /**
     * Behavior of process.
     */
    void Behavior()
    {
        // Sum of bottles
        if(type & P_SHOP)      gCmp1.b_sum += bottles.b_sum;
        if(type & P_PUB)       gCmp2.b_sum += bottles.b_sum;
        if(type & P_BIG_SHOP)  gCmp3.b_sum += bottles.b_sum;
        if(type & P_DISTILLERY)gCmp4.b_sum += bottles.b_sum;

        ////
        // Behavior start 
        if(flag_ss)
            GoodSolution();
        else
            BetterSolution();

        ///
        // Put it into stats.
        if(flag_w)
        {
            if(Time > gDay)
            {
                cerr << gDay << flush;
                gDay++;
            }
            cerr << "." << flush;
        }

        // Completed company
        gCompleted++;

        // Fill stats
        if(type & P_SHOP)       
        {
            sPShop(costs);
            gCmp1.b_methanol   += bottles.b_methanol;
            gCmp1.b_imported   += bottles.b_imported;
            gCmp1.b_lastYear   += bottles.b_lastYear;
            gCmp1.b_notChecked += bottles.b_notChecked;
        }
        if(type & P_PUB)        
        {
            sPPubs(costs);
            gCmp2.b_methanol   += bottles.b_methanol;
            gCmp2.b_imported   += bottles.b_imported;
            gCmp2.b_lastYear   += bottles.b_lastYear;
            gCmp2.b_notChecked += bottles.b_notChecked;
        }
        if(type & P_BIG_SHOP)   
        {
            sPBigShop(costs);
            gCmp3.b_methanol   += bottles.b_methanol;
            gCmp3.b_lastYear   += bottles.b_lastYear;
            gCmp3.b_imported   += bottles.b_imported;
            gCmp3.b_notChecked += bottles.b_notChecked;
#ifdef POLLING
            // Put it into Queue. For Pubs and shops
            gQShop.Insert(this);
            Passivate();
#endif
        }
        if(type & P_DISTILLERY) 
        {
            sPDistillery(costs);
            gCmp4.b_methanol   += bottles.b_methanol;
            gCmp4.b_lastYear   += bottles.b_lastYear;
            gCmp4.b_imported   += bottles.b_imported;
            gCmp4.b_notChecked += bottles.b_notChecked;
#ifdef POLLING
            // Put it into Queue. For pubs and shops and bigshops. 
            gQDist.Insert(this);
            Passivate();
#endif
        }
    }
};

/**
 * Generating bottles!
 * @param TCompany  What do we know bout companies
 */
class Generator : public Event {
    TCompany company;         // Company
    int      generatedComp;   // Generated companies
public: 
    /**
     * Constructor
     */
    Generator (TCompany k)
    {
        company = k;
        generatedComp = 0;
    }

    /**
     * Behavior of company
     */
    void Behavior()
    {
        int      bottles;     // Count of generated bottles (random number)
        TPercent perLastYear; // % last year
        TPercent perImport;   // % imported
        TPercent perMethanol; // % methanol chance

        int    interval = company.c_bottles.b - company.c_bottles.a;
        int    mid      = (double) interval / 2.0 + (double)company.c_bottles.a;
        int    variance = interval/6; // >> 3; // div by 8

        int    end;
        if(flag_r)
            end = company.c_sum / gLengthSim;
        else
            end = company.c_sum;
       
        ///////////////////////////////////
        // Create bottles for every company
        for(int i = 0; i < end; i++)
        {
            // Create bottles and cut it to interval
            do {
                bottles = Normal(mid, variance);
            } while(bottles < 0);
            
            // Create percentage for last year and cut it to interval
            if(flag_n | flag_l)
            {
                if(company.c_BLastYear > 0)
                {
                    perLastYear = Normal(company.c_BLastYear, 0.1);
                    if (perLastYear < 0) perLastYear = 0;
                    if (perLastYear > 1) perLastYear = 1;
                }
                else
                    perLastYear = 0;
            }
            else
                perLastYear = company.c_BLastYear;

            // Create percentage for import and cut it to interval
            if(flag_n | flag_i)
            {
                if(company.c_BImport > 0)
                {
                    perImport = Normal(company.c_BImport, 0.1);
                    if (perImport < 0) perImport  = 0;
                    if (perImport > 1) perImport  = 1;
                }
                else
                    perImport = 0;
            }
            else
                perImport = company.c_BImport;
            
            // Create methanol bottles
            if(company.c_type == P_DISTILLERY)
            {
                perMethanol = 0;
                if(!gMethanolInjected && Random() < company.c_BMethanol)
                {
                    perMethanol = INJECTED_METHANOL;
                    gMethanolInjected = true;
                }
            }
            // Create new company
            (new Company(bottles, company.c_type, perImport, perLastYear, 
                         company.c_BMethanol))->Activate();

            generatedComp++;
        }
        // For bruteforce solution
        if(generatedComp < company.c_sum)
            Activate(Time + 1);

        return;
    }
};


/**
 * Main function
 * @param int    argc -- count of arguments
 * @param char** argv -- array of strings
 */
int main(int argc, char** argv)
{
    // Russian roulette
    RandomSeed(time(NULL));

    getParams(argc, argv);
    

    // Simulation
    Init(0, gLengthSim);
    //Generate whiskey
#ifdef DEBUG
    cerr << "Generating companies." << endl;
#endif
    (new Generator(gCompany1))->Activate(); // Distillery
    (new Generator(gCompany2))->Activate(); // Big shop
    (new Generator(gCompany3))->Activate(); // shop
    (new Generator(gCompany4))->Activate(); // Pub
#ifdef DEBUG
    cerr << "Simulation has begun!" << endl;
#endif
    Run();

    // Graphical fix
    if(flag_w)
        cerr << endl;
#ifdef DEBUG
    cerr << "Finished!" << endl << endl;
#endif
#ifdef DEBUG_RNDLOG
    debugHistogram.Output();
#endif
#ifdef DEBUG_BATCH
    batchHistogram.Output();
#endif
#ifdef DEBUG_LAST_YEAR
    lastYearHistogram.Output();
#endif
#ifdef DEBUG_IMPORT_TIME
    itHistogram.Output();
#endif
    printGeneratedAlcohol();
    cout << "Checked bottles: " << gAllB << "l" << endl;
    int tmp = printComp();         
    printPrices();
    if(! tmp)
        cerr << "!!! DIDNT CHECK ALL THE BOTTTLES !!!" << endl;
    return 0;
}// main



///////////////////////////////////////////////////////////////////////////////
// Other functions
void printGeneratedAlcohol()
{
    cout << "=================" << endl;
    cout << "Generated alcohol" << endl;
    cout << "=================" << endl;
    cout << "TYPE         "
        << "GENERATED  "
#ifdef DEBUG_NOTCHCK
        << "NOT_CHECK  "
#endif
        << "LAST_YEAR   IMPORTED   METHANOL" << endl;
    cout << "Shop:       " 
             << setw(8) << setfill(' ') << gCmp1.b_sum << " l "
#ifdef DEBUG_NOTCHCK
             << setw(8) << setfill(' ') << gCmp1.b_notChecked << " l "
#endif
             << setw(8) << setfill(' ') << gCmp1.b_lastYear << " l "
             << setw(8) << setfill(' ') << gCmp1.b_imported << " l " 
             << setw(8) << setfill(' ') << gCmp1.b_methanol << " l " 
             << endl
         << "Pub:        " 
             << setw(8) << setfill(' ') << gCmp2.b_sum << " l "
#ifdef DEBUG_NOTCHCK
             << setw(8) << setfill(' ') << gCmp2.b_notChecked << " l "
#endif
             << setw(8) << setfill(' ') << gCmp2.b_lastYear << " l "
             << setw(8) << setfill(' ') << gCmp2.b_imported << " l "
             << setw(8) << setfill(' ') << gCmp2.b_methanol << " l " 
             << endl
         << "Big shop:   " 
             << setw(8) << setfill(' ') << gCmp3.b_sum << " l "
#ifdef DEBUG_NOTCHCK
             << setw(8) << setfill(' ') << gCmp3.b_notChecked << " l "
#endif
             << setw(8) << setfill(' ') << gCmp3.b_lastYear << " l "
             << setw(8) << setfill(' ') << gCmp3.b_imported << " l "
             << setw(8) << setfill(' ') << gCmp3.b_methanol << " l " 
             << endl
         << "Distillery: " 
             << setw(8) << setfill(' ') << gCmp4.b_sum << " l "
#ifdef DEBUG_NOTCHCK
             << setw(8) << setfill(' ') << gCmp4.b_notChecked << " l "
#endif
             << setw(8) << setfill(' ') << gCmp4.b_lastYear << " l "
             << setw(8) << setfill(' ') << gCmp4.b_imported << " l "
             << setw(8) << setfill(' ') << gCmp4.b_methanol << " l " 
             << endl;
    cout << "------------------------------------------------------------------"
         << endl;
    gBottles.b_notChecked = gCmp1.b_notChecked + 
                            gCmp2.b_notChecked + 
                            gCmp3.b_notChecked + 
                            gCmp4.b_notChecked;
    gBottles.b_sum = gCmp1.b_sum + 
                     gCmp2.b_sum + 
                     gCmp3.b_sum + 
                     gCmp4.b_sum;
    gBottles.b_lastYear = gCmp1.b_lastYear + 
                     gCmp2.b_lastYear + 
                     gCmp3.b_lastYear + 
                     gCmp4.b_lastYear;
    gBottles.b_methanol = gCmp1.b_methanol + 
                     gCmp2.b_methanol + 
                     gCmp3.b_methanol + 
                     gCmp4.b_methanol;
    gBottles.b_imported = gCmp1.b_imported + 
                     gCmp2.b_imported + 
                     gCmp3.b_imported + 
                     gCmp4.b_imported;
    cout << "SUM:        " 
             << setw(8) << setfill(' ') << gBottles.b_sum << " l "
#ifdef DEBUG_NOTCHCK
             << setw(8) << setfill(' ') << gBottles.b_notChecked << " l "
#endif
             << setw(8) << setfill(' ') << gBottles.b_lastYear << " l " 
             << setw(8) << setfill(' ') << gBottles.b_imported << " l " 
             << setw(8) << setfill(' ') << gBottles.b_methanol << " l " << endl;
    cout << endl;
}

/**
 * Printing outputs from Stats simlib/src/stat.cpp
 */
void printPrices()
{
    cout << endl;
    sPDistillery.Output();
    cout << endl;
    sPBigShop.Output();
    cout << endl;
    sPShop.Output();
    cout << endl;
    sPPubs.Output();
    cout << endl;

}

/**
 * Print companies. 
 */
int printComp()
{
    long long sum = 0;
    sum = gCompany1.c_sum + gCompany2.c_sum + gCompany3.c_sum + gCompany4.c_sum;
    cout << "========="<<endl;
    cout << "COMPANIES"<<endl;
    cout << "========="<<endl;
    cout << "Shop:       "<< setw(8) << setfill(' ') << gCompany3.c_sum << endl;
    cout << "Pub:        "<< setw(8) << setfill(' ') << gCompany4.c_sum << endl;
    cout << "Big shop:   "<< setw(8) << setfill(' ') << gCompany2.c_sum << endl;
    cout << "Distillery: "<< setw(8) << setfill(' ') << gCompany1.c_sum << endl;
    cout << "--------------------" << endl;
    cout << "SUM:        " << setw(8) << setfill(' ') << sum << endl;
    cout << "--------------------" << endl;
    cout << "Completed: " << gCompleted << endl << endl;

    if(gCompleted != sum)
    {
        cerr << "!!! DIDNT CHECK ALL THE BOTTTLES !!!" << endl;
        return false;
    }
    return true;
}

/**
 * Printing help
 */
void printHelp(void)
{
    cout << "Synopsis: model [-ss | -r | -n | -l | -i | -w | -p | -net | -d] [-import number] [-phoneCall number] [-phonePrice number] [-cert number] [-pDist PERCENT] [-pBadge PERCENT] [-t number] [filename]" << endl;
    cout << endl;
    cout << "OPTIONS" << endl;
    cout << "  -h   Prints this help and exit program" << endl;
    cout << "  -ss  Start brute force solution" << endl;
    cout << "  -r   Uniform generating companies." << endl;
    cout << "  -n   Percents for last year and imported "
        << "alcohol are using Gauss probability" << endl;
    cout << "  -i   Gauss probability for imported alcohol" << endl;
    cout << "  -l   Gauss probability for last year alcohol" << endl;
    cout << "  -net NOT BF - Using internet to found badges" << endl;
    cout << "  -w   NOT BF - Using simlib Wait()." << endl;
    cout << "       Care it takes long time for computes this." << endl;
    cout << "  -p   Printing methanol dealer found at time..." << endl;
    cout << "  -t [day]          simulation lenghth (in days)" << endl;
    cout << "  -import [HOURS]   How long takes to check Imported alcoh."<<endl;
    cout << "  -phoneCall [MINS] How long is takes phone call" << endl;
    cout << "  -phonePrice [int] Price of phone" << endl;
    cout << "  -cert [int]       price of paper" << endl;
    cout << "  -pDist [double]   What is the \% imported alc. from czech"<<endl;
    cout << "                    distillery to normal shop" << endl;
    cout << "  -pBadge [double]  What is the \% that dist. doesnt have the badge"<<endl;
    cout << "  filename [string] File with info about labs and companies" << endl;
    cout << "                    If not entred with this param there are used default variables" << endl;
    cout << endl;
    cout << "EXAMPLES OF START" << endl;
    cout << "  $ ./model" << endl;
    cout << "  $ ./model -ss file" << endl;
    cout << "  $ ./model -l -import 4 -pBadges 42 -w -t 8 file" << endl;
    cout << endl;
    cout << "FILE CONTENT" << endl;
    cout << "Format of companies" << endl;
    cout << "  sum bottles produced_last_year imported contains_methanol"<<endl;
    cout << "  [INT] [RANGE] [%] [%] [%]" << endl;
    cout << "Format of labs" << endl;
    cout << "  sum price speed_in_minutes"<<endl;
    cout << "  [INT] [INT] [RANGE]" << endl;
    cout << "Format of file by lines" << endl;
    cout << "1-4 line - info about companies" << endl;
    cout << "  1 line - Distillery" << endl;
    cout << "  2 line - Big shop  " << endl;
    cout << "  3 line - Shop      " << endl;
    cout << "  4 line - Pub       " << endl;
    cout << "5 line   - empty or comment" << endl;
    cout << "6-7 line - info about labs" << endl;
    cout << "  6 line - Lab1      " << endl;
    cout << "  7 line - Lab2      " << endl;
    cout << endl;
    cout << "EXAMPLES OF FILES" << endl;
    cout << "a) Used only companies" << endl;
    cout << "  42 10000-20000 39 0 39" << endl;
    cout << "  12 10000 1 1 0.0001" << endl;
    cout << "  100 100-300 1 1 1" << endl;
    cout << "  100 100 1 1 1" << endl;
    cout << "b) Used with labs" << endl;
    cout << "  42 10000-20000 39 0 39" << endl;
    cout << "  12 10000 1 1 0.0001" << endl;
    cout << "  100 100-300 1 1 1" << endl;
    cout << "  100 100 1 1 1" << endl;
    cout << endl;
    cout << "  42 200 39-40" << endl;
    cout << "  12 100 1" << endl;
    exit(0);
    // TL;DR
}

/**
 * Printing errors and exit this... 
 */
void printError(int err)
{
    if(err & E_PARAMS)
        cerr << "Error: Bad params" << endl;
    if(err & E_FILE)
        cerr << "Error: File" << endl;
    exit(-1);
}

/**
 * Zpracovani parametru;
 */
void getParams(int argc, char **argv)
{
    int file = false;
    // Zpracovani parametru
    for(int i = 1; i < argc; i++)
    {
        if(string(argv[i]) == "-ss")
            flag_ss = true;
        else if(string(argv[i]) == "-n")
            flag_n = true;
        else if(string(argv[i]) == "-h")
            printHelp();
        else if(string(argv[i]) == "-l")
            flag_l = true;
        else if(string(argv[i]) == "-i")
            flag_i = true;
        else if(string(argv[i]) == "-w")
            flag_w = true;
        else if(string(argv[i]) == "-p")
            flag_p = true;
        else if(string(argv[i]) == "-d")
            flag_d = true;
        else if(string(argv[i]) == "-r")
            flag_r = true;
        else if(string(argv[i]) == "-net")
            flag_net = true;
        else if(string(argv[i]) == "-t")
        {
            if((gLengthSim = DAY * (atoi(argv[++i]))) <= 0) 
                printError(E_PARAMS);
        }
        else if(string(argv[i]) == "-import" && 1+i < argc)
        {
            if((importTime = HOUR * atof(argv[++i])) <= 0)
                printError(E_PARAMS);
        }
        else if(string(argv[i]) == "-phoneCall" && 1+i < argc)
        {
            if((gPhoneCall = atoi(argv[++i])) <= 0)
                printError(E_PARAMS);
        }
        else if(string(argv[i]) == "-phonePrice" && 1+i < argc)
        {
            if((gPhonePrice = atoi(argv[++i])) < 0)
                printError(E_PARAMS);
        }
        else if(string(argv[i]) == "-cert" && 1+i < argc)
        {
            if((gCert = atoi(argv[++i])) < 0)
                printError(E_PARAMS);
        }
        else if(string(argv[i]) == "-pDist" && 1+i < argc)
        {
            if((perDist = atof(argv[++i]) / 100) < 0)
                printError(E_PARAMS);
        }
        else if(string(argv[i]) == "-pBadge" && 1+i < argc)
        {
            if((perBadBadge = atof(argv[++i]) / 100) < 0)
                printError(E_PARAMS);
        }
        else if(! file)
        {
            parseFile(argv[i]);
            file = true;
        }
        else
            printError(E_PARAMS);
    }
}

/**
 * Vyparsruje vstupni interval ci cislo pro maloobchod etc.
 */
TInterval parseInterval(string str)
{
    char buffer [MAX_BUFFER_INT];
    char buffer2 [MAX_BUFFER_INT];
    TInterval result = {
         0,
                 0
    };
    
    int k = 1; // Index prvniho bufferu
    int l = 0; // Index druheho bufferu

    int state = 1; // Stav KA
    for(unsigned int i=0; i < str.length(); i++)
    {
        // Prvni stav ocekava cislo
        if(state == 1)
        {
            if(isdigit(str[i]))
                buffer[0] = str[i]; 
            else
                printError(E_PARAMS);
            state++;

        }
        // Druhy stav ocekava cislo nebo pomlcku nebo konec
        else if(state == 2)
        {
            if(isdigit(str[i]))
                buffer[k] = str[i];
            else if(str[i] == '-')
                state++;
            else
                printError(E_PARAMS);
            k++;
            if(k >= MAX_BUFFER_INT - 1)
                printError(E_PARAMS);
        }
        // Treti stav ocekava cislo
        else if(state == 3)
        {
            if(isdigit(str[i]))
                buffer2[l] = str[i];
            else
                printError(E_PARAMS);
            l++;
            if(l >= MAX_BUFFER_INT - 1)
                printError(E_PARAMS);
        }
    }//for

    // Ukoncit retezec
    buffer[k]  = '\0';
    buffer2[l] = '\0';

    // Prevod do struktury
    result.a = atoi(buffer);
    if(state == 3)
        result.b = atoi(buffer2);
    else
        result.b = result.a;
    if(result.b < result.a)
        printError(E_PARAMS);
    return result;
}// Parse interval

/**
 * Parse lajne
 */
void parseLineCompany(string line, TCompany *comp)
{
    string sub;
    int state = 0;
    for(int i = 0; ; i++)
    {
        if(line[i] != ' ' && line[i] != '\0')
        {
            sub = sub + line[i];
            continue;
        }
        if(state == 0)
            comp->c_sum = atoi(sub.c_str());
        else if(state == 1)
            comp->c_bottles = parseInterval(sub.c_str());
        else if(state == 2 && comp->c_type )
            comp->c_BLastYear = ((double) atof(sub.c_str()))/100;
        else if(state == 3 && comp->c_type != P_DISTILLERY)
            comp->c_BImport = ((double) atof(sub.c_str()))/100;
        else if(state == 4)
        {
            comp->c_BMethanol = ((double) atof(sub.c_str()))/100;
            break;
        }
        sub = "";
        state++;
        if(line[i] == '\0')
            break;
    }
}

/**
 * Parse line
 */
void parseLineLab(string line, TLabs *L)
{
    string sub;
    int state = 0;
    for(int i = 0; ; i++)
    {
        if(line[i] != ' ' && line[i] != '\0')
        {
            sub = sub + line[i];
            continue;
        }
        if(state == 0)
            L->lab_sum   = atoi(sub.c_str());
        else if(state == 1)
            L->lab_price = atoi(sub.c_str());
        else if(state == 2)
            L->lab_speed = parseInterval(sub.c_str());
        sub = "";
        state++;
        if(line[i] == '\0')
            break;
    }
}

/**
 * Parsing file
 */
void parseFile(string filename)
{
    string line;
    int state = 0;
    ifstream file (filename.c_str());
    if(file.is_open())
    {
        while(file)
        {
            getline (file,line);
            if(state == 0)
                parseLineCompany(line, &gCompany1);
            else if(state == 1)
                parseLineCompany(line, &gCompany2);
            else if(state == 2)
                parseLineCompany(line, &gCompany3);
            else if(state == 3)
                parseLineCompany(line, &gCompany4);
            else if(state == 4);
            else if(state == 5)
                parseLineLab(line, &gLab1);
            else if(state == 6)
                parseLineLab(line, &gLab2);
            state++;
        }
    }
    else
        printError(E_FILE);
}
// EOF main.cpp
