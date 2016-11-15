/**
 * @file   client.cpp
 * @author Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * @date   22nd February 2013
 * @description 
 *      Connect to server using some strange protocol that I invented... 
 */


//#define IPV6          // Use IPv6 protocol on internet layer.

// Streams
#include <iostream>
#include <fstream>
#include <algorithm>
// Macros: true, false
#include <stdbool.h>
#include <unistd.h>
#include <stdlib.h>
// Regular expression
#include <regex.h>
// For allocating.
#include <string.h>
// Variable errno
#include <errno.h>
// Working with BSD socets
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

// STREAMS
using namespace std;

// Functions declaration.
void _connect(void);
void exitError(string);
void printHelp(void);

// Global variables
string host  = "";
string port  = "";
string flag  = "";
string query = "";

int qflag = 0;

#define LOGIN_X 1
#define UID_X 2
/**
 * Main funciton. 
 * @param int      Argument count.
 * @param char **  Array of strings.
 */
int main(int argc, char ** argv)
{
    //int ch;
    if(argc == 1)
    {
        printHelp();
        return EXIT_SUCCESS;
    }
    string queryTmp = "" ;
    for(int i = 1; i < argc; i++) // skipping first argument
    {   
        // Getting parameter
        if(argv[i][0] == '-')
        {
            if(argv[i][1] == 'h' && i+1 < argc)
                host.append(argv[++i]);
            else if(argv[i][1] == 'p' && i+1 < argc)
                port.append(argv[++i]);
            else if(argv[i][1] == 'l')
                qflag = LOGIN_X;
            else if(argv[i][1] == 'u')
                qflag = UID_X;
            else if(argv[i][1] != '\0')
                flag.append(&(argv[i][1]));
            else
                exitError("Error: Bad param.");

        }
        // Getting query
        else
        {
            queryTmp.append(argv[i]);
            queryTmp.append(":");
        }
    }
    /* BSD don't parse LUGNHS params correctly
    for((ch = getopt(argc, argv, "h:p:luLUGNHS")) != -1)
    {
        switch(ch)
        {
            case 'h':
                host.append(optarg);
                break;
            case 'p':
                port.append(optarg);
                break;
            case 'l':
                qflag = LOGIN_X;
                break;
            case 'u':
                qflag = UID_X;
                break;
            case 'L':
                flag.append("L");
                break;
            case 'U':
                flag.append("U");
                break;
            case 'G':
                flag.append("G");
                break;
            case 'N':
                flag.append("N");
                break;
            case 'H':
                flag.append("H");
                break;
            case 'S':
                flag.append("S");
                break;
            case '?':
                exitError("Program options.");
            default:
                break;
        }
    }

    string tmp = "";
    for (int index = optind; index < argc; index++)
    {
        tmp.append(argv[index]);
        tmp.append(":");
    }
    */
    if(queryTmp.length() == 0)
        exitError("params - query search was not set!");
    query = queryTmp.substr(0, queryTmp.size()-1);
    
    // Check everyhing
    if(host.length() == 0)
        exitError("params - host was not set!");
    if(port.length() == 0)
        exitError("params - port was not set!");

    _connect();
    return EXIT_SUCCESS; 
}

/**
 * Connects to server, sends msg, recv msg. 
 */
void _connect(void)
{
    // Socket
    int s;
    // Recv();
    int n;            // Length of recieved data. 
    char c[1] = "";   // Lazy buffer..
    char prev_c = 42; // Previous accepted character.

    // Message.
    string msg = ""; 
    if(qflag == LOGIN_X)
        msg = "MTP "+ flag + "\nlogin "+ query +"\n\n";
    else if(qflag == UID_X)
        msg = "MTP "+ flag + "\nuid "  + query +"\n\n";
    else
        exitError("Query not specificed");

    // Init structutres for Getaddrinfo(). DNS, result, ptr to result.
	struct addrinfo hints, *result, *p_result;
	memset (&hints, 0, sizeof (struct addrinfo));

    // Set DNS socket params.
	hints.ai_family   = AF_UNSPEC;	  // IPv4 or IPv6 or somthing else?
    hints.ai_protocol = IPPROTO_TCP;  // TCP protocol
	hints.ai_socktype = SOCK_STREAM;  // TCP type of stream.
    
    // Get addres info. 
	if (getaddrinfo(host.c_str(), port.c_str(),  &hints, &result))
        exitError("Getaddrinfo: " + host + ":" + port);
    p_result = result;                // Save its pointer for later free(). 

    // Check IP protocol.
    while (result != NULL)
    {   
#ifdef IPV6
        // IPv6
        if (result->ai_family == AF_INET6) break;
#endif 
        // IPv4
        if (result->ai_family == AF_INET) break;

        // Last used protocol.
        if (result->ai_next  == NULL)  // TODO check this. 
            exitError("Unsuppported IP protocol.");
        result = result->ai_next;
    }

    // Creating socket from what we get from previous DNS resolve
    if((s=socket(result->ai_family,result->ai_socktype,result->ai_protocol))<0)
        exitError("Creating socket.");
    // Connect to Server.
    if((connect(s, result->ai_addr, result->ai_addrlen)) < 0) 
        exitError("Connecting.");
    // Sending msg
	if(send(s, msg.c_str(), msg.length(), 0) < 0)
        exitError("Sending.");
    // Close sending msg
    if(shutdown(s, SHUT_WR) < 0)
        exitError("Shutdown.");

    string tmp = "";
    int check_stdout = 1;
    int out = 0;
    // Getting response
    while(1) 
    {
		if((n = recv(s, &c, 1, 0)) < 0)
            exitError("Receaving");
        else if(n == 0) 
            break;
        if(prev_c == '\n' && c[0] == '\n')
            break;
        if(check_stdout)
        {
            if(c[0] == '0')
                out = 0;
            else
                out = 1;
            /*
            else if(c[0] == '1')
                out = 1;
            else
                cerr << "Error: Unexpected character." << endl;
            */
            check_stdout = 0;
            continue;
        }
        if(out == 0)
            cerr << c[0] << flush;
        if(out == 1)
            cout << c[0] << flush;
        prev_c = c[0];
        if(c[0] == '\n')
        {
            tmp.clear();
            check_stdout = 1;
            continue;
        }
    }
    freeaddrinfo(p_result);
}


/**
 * Exit the program unsuccessfully and prints the string. 
 */
void exitError(string str)
{
    cerr << str << endl;
    if(errno)
        perror("Error");
    exit(EXIT_FAILURE);
}

/**
 * Prints help.
 */
void printHelp(void)
{
    cout << "SYNOPSIS" <<endl; 
    cout << "   client –h hostname –p port –l login ... –u uid ... –L –U –G –N –H –S" << endl;
    cout << endl;
    cout << endl;
}
//client.cpp
