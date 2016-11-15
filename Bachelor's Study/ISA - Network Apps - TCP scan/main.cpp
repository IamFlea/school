/* File name : main.cpp
 * Author    : Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * Date      : Nov, 2012
 * Project   : Seznam bezicich sluzeb ma zadanych PCs.
 */

// FIXME unused libraries
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstring>
#include <list>
#include <stdlib.h>
#include <netdb.h>
#include <fcntl.h>
#include <unistd.h>
#include <poll.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <stdio.h>
using namespace std;

// Defines
    //#define POLL_IMPLEMENTATION         // Comment this if u want to TEST SELECT()
#define MAX_PORT_NUMBER 65535
#define DEFAULT_TIMEOUT 10

// Error Codes
#define E_OK            0x0000
#define E_PARAMS        0x0001
#define E_PORTS         0x0002
#define E_FILE_OPEN     0x0004
#define E_IP            0x0008
#define E_SOCKET_CREATE 0x0010
#define E_BAD_TIME      0x0020

// FSM for parsing ports
#define S_DIGIT     0
#define S_DIGIT_END 1 

// Global vars
list <int>   ports;
list <string> addresses; 
int  aflag; // Same timeout for connection

// Functions
void printError(int);
void printHelp(void);
int  parsePorts(string strPorts);
int  parseFile(string filename);
void parseStdin(int);
int  tcpSearch(int);
int  _tcpSearchSocket(int, string, int);
int  __tcpSearchConnect(int, int, int, struct addrinfo *);
void ___tcpSearchGetBanner(int, int, int);
void printRecvData(char*, int);
int  addrType(string);
string intToStr(int);
///////////////////////////////////////////////////////////////////////////////



/**
 * Process params from command line and start searching TCP ports.
 * @param  <int argc>    argument count
 * @param  <char **argv> array of argument strings
 * @return <int>         error code, zero if success
 */
int main(int argc, char **argv)
{
    int    errorFlag = E_OK;// Return variable
    int    timeout   = DEFAULT_TIMEOUT * 1000;   // Timeout
    string strPorts;        // Ports
    string filename = ""; // Filename
    aflag            = 0;   // Timeout enabled for connection
 
    // Printing help
    if(argc == 2)
    {
        if(string(argv[1]) == "-h")
        {
            printHelp();
            return EXIT_SUCCESS;
        }
    }

    // Porcess params
    for(int i = 1; i < argc; i++)
    {
        if(string(argv[i]) == "-p" && 1+i < argc)
            strPorts = argv[++i];
        else if(string(argv[i]) == "-t" && ++i < argc)
        {
            if((timeout = atoi(argv[i])) <= 0)
                errorFlag |= E_BAD_TIME;
            timeout *= 1000; // Couse it is in ms
        }
        else if(string(argv[i]) == "-a")
            aflag = 1;
        else if(filename.empty())
            filename = argv[i];
        else
        {
            printError(E_PARAMS);
            return E_PARAMS;
        }
    }
    
    // Bad combo
    if(aflag == 1 && timeout == 0)
        errorFlag |= E_PARAMS;

    // Missing required variables.
    if(strPorts.empty() || filename.empty())
    {
        printError(E_PARAMS);
        return E_PARAMS;
    }

    // Parse ports
    errorFlag |= parsePorts(strPorts);

    // Parse addresses from file || stdin
    if(filename == "-")
    {
        // Have search in it
        parseStdin(timeout);
    }
    else
    {
        errorFlag |= parseFile(filename);
        

        // Start searching 
        if(! errorFlag)
            errorFlag |= tcpSearch(timeout);
    }

    // Errors occured
    if(errorFlag)
        printError(errorFlag);

    return errorFlag; 
}



/**
 * Iterate through params and addresses
 * @param <int>     timeout
 * @return <int>    error code
 */
int tcpSearch(int timeout)
{
    list<int>::iterator p;
    string address;
    char addr[128];
    void *ptr;
	struct addrinfo hints, *result;

    // Lists are inited bad
    if(addresses.empty())
        return E_FILE_OPEN;
    if(ports.empty())
        return E_PORTS;

    // Iterate through addresses
    while(! addresses.empty())
    {
        address = addresses.front();
        // Get address type - ipv6 or ipv4
        if(! addrType(address))
        {
            // It was domain name
            memset (&hints, 0, sizeof (hints));
	        hints.ai_family =  AF_UNSPEC;	  // IPv4 or IPv6 or somthing else
            hints.ai_flags |= AI_CANONNAME;	
            hints.ai_socktype = SOCK_STREAM;
            // Getting IP from DnS maybe?
            if (getaddrinfo (address.c_str(), NULL,  &hints, &result))
            {
                cerr << "Error: Getaddrinfo: "<<address  << endl;
                addresses.pop_front();
                continue;
            }
            // Checking if returned IP was IPv4 or IPv6
            if (result->ai_family == AF_INET)
                ptr = &((struct sockaddr_in *)(result->ai_addr))->sin_addr;
            else if (result->ai_family == AF_INET6)
                ptr = &((struct sockaddr_in6 *)(result->ai_addr))->sin6_addr;
            else
            {
                addresses.pop_front();
                continue;
            }
	        inet_ntop (result->ai_family, ptr, addr, 128);
            // Printing result
            cout << addr << " (" << address << ")" << endl;
        }
        else
            cout << address << endl;

        // Iterate through ports
        for(p = ports.begin(); p != ports.end(); p++)
            _tcpSearchSocket(timeout, address, *p);
        addresses.pop_front();
    }
    return E_OK;
}



/**
 * Create socket from meh meh address and port. 
 * @param <int>     timeout, max waiting time for banner || connect
 * @param <string>  address, domain name || address 
 * @return <int>    error code
 */
int _tcpSearchSocket(int timeout, string address, int port)
{
	struct addrinfo hints, *result; // getaddrinfo()
    int s;                          // Socket

    // Create socket params
	memset (&hints, 0, sizeof (struct addrinfo));
	hints.ai_family =  AF_UNSPEC;	  // IPv4 or IPv6 or somthing else
    hints.ai_protocol = IPPROTO_IP;   // TCP protocol
	hints.ai_socktype = SOCK_STREAM;  // TCP type
	if (getaddrinfo (address.c_str(), intToStr(port).c_str(),  &hints, &result))
	{
        cerr << "Error: Getaddrinfo: "<<address  << endl;
        return E_OK;
	}

    // Creating socket from what we get
    s = socket(result->ai_family, result->ai_socktype, result->ai_protocol);
    if(s < 0)
    {
        cerr << "Error during creating socket."<< s << endl;
        return E_SOCKET_CREATE;
    }

    // Do it 
    __tcpSearchConnect(timeout, s, port, result);

    // Close socket
    close(s);
    freeaddrinfo(result);
    return E_OK;
}



/**
 * Connect to socket, close the socket
 * @param <int>     timeout
 * @param <s>       socket
 * @return          random integer
 */
int __tcpSearchConnect(int timeout, int s, int port, struct addrinfo *result)
{
    int resultPoll;                 // Returns from  poll()
    int timeoutConnect = (aflag == 1) ? timeout : -1;
    //  IF POLL is enabled
    struct pollfd pfd; // For connect to server

    // Set socket on nonblocking I/O, if timeout set
    if(aflag)
    {
        int flags = fcntl(s, F_GETFL, 0);
        if(flags < 0)
            cerr << "Error: fcntl()" << endl;
        else if((fcntl(s, F_SETFL, flags | O_NONBLOCK)) < 0)
            cerr << "Error: fcntl()" << endl;
    }
    
    // Connect to server
    if((connect(s, result->ai_addr, result->ai_addrlen)) < 0) 
    {
        if(errno == EINPROGRESS)
        {
            // NONBLOCKING MODE
            pfd.fd = s;                     // Init Socket descriptor
            pfd.events = POLLIN | POLLOUT;  // I and O ports. Maybe just OUTPUT ports.
            resultPoll = poll(&pfd, 1, timeoutConnect);
            if (resultPoll == 1)
            {
                int optval;
                socklen_t optlen = sizeof(optval);
                if ((getsockopt(s, SOL_SOCKET, SO_ERROR, &optval, &optlen)) == 0) 
                {
                    if(optval == 0)
                        ___tcpSearchGetBanner(timeout, s, port);
                    else
                        cerr << "Couldn't connect on port " << port << endl;
                }
            }
            else if (resultPoll == 0)
                cerr << "Connection timed out on port " << port <<endl;
            else
                cerr << "Error: poll()" << endl;
        }
        else
            cerr << "Couldn't connect on port " << port << endl;
    }
    else
        ___tcpSearchGetBanner(timeout, s, port);
    return E_OK;
}



/**
 * Get banner from socket
 * @param <int>     timeout
 * @param <int>     socket
 * @param <int>     port
 * @return  Black hole
 */
#ifdef POLL_IMPLEMENTATION
void ___tcpSearchGetBanner(int timeout, int s, int port)
{
    cout << port << endl;
    // Recv from
    struct sockaddr addr;           // recvFrom()
    socklen_t fromlen = sizeof addr;// --''--
    char buffer[8192];              // Buffer 8kB
    int recvedData;                 // Length of recved data

    struct pollfd bfd;  // File descriptor for getting banner
    int resultPoll;
    bfd.fd = s;         // Set the socket
    bfd.events = POLLIN | POLLRDNORM;// we are just reding here

    // There is no error, we connected successfully
    resultPoll = poll(&bfd, 1, timeout);    // poll again
    if(resultPoll == 0)
    {
        // Timeout
        cout << endl; // print new line and error
        cerr << "Timeout during reading banner on port: " 
             << port << endl;
    }
    else if(resultPoll == 1)
    {
        // Read data until timeout.
        recvedData = recvfrom(s, buffer, sizeof buffer, 0, &addr, &fromlen);
        printRecvData(buffer, recvedData);
    }
    else
        cerr << "Error: poll()" << endl;
}
#else // SELECT IMPLEMENTATION
void ___tcpSearchGetBanner(int timeout, int s, int port)
{
    cout << port << endl;
    
    struct sockaddr addr;           // recvFrom()
    socklen_t fromlen = sizeof addr;// --''--
    char buffer[8192];              // Buffer 8kB
    int recvedData;                 // Length of recved data

    fd_set fds;                     // Select SET
    struct timeval tv;              // Timeout struct
    tv.tv_sec = timeout/1000;            //   seconds
    tv.tv_usec = 0;                 //   useconds

    FD_ZERO(&fds);
    FD_SET(s, &fds);

    int result = -1;
    if(timeout > 0)
        result = select(s + 1, &fds, NULL, NULL, &tv);
    else
        result = select(s + 1, &fds, NULL, NULL, NULL);

    if(result < 0)
        cerr << "Error: select()" << endl;
    else if(result == 0)
    {
        cerr << "Timeout during getting banner" << endl;
        cout << endl;
    }
    else // result > 0
    {

        if(timeout)
        {
            // Set it as non block
            int flags = fcntl(s, F_GETFL, 0);
            if(flags < 0)
            {
                cerr << "Error: fcntl()" << endl;
                return;
            }
            else if(fcntl(s, F_SETFL, flags | O_NONBLOCK) < 0)
            {
                cerr << "Error: fcntl()" << endl;
                return;
            }
        }
        recvedData = recvfrom(s, buffer, sizeof buffer, 0, &addr, &fromlen);
        printRecvData(buffer, recvedData);
    }
}
#endif


/**
 * Print recved data from buffer
 * @param char*     buffer
 * @param int       length of buffer 
 */
void printRecvData(char* buffer, int length)
{
    if(length == -1)
    {
        cerr << "Error: recvfrom()" << endl;
        return;
    }
    for(int i = 0 ; i < length; i++)
        cout << buffer[i];
    cout <<endl;
}



/**
 * Converts an integer to string
 * @param  <int>    the integer
 * @return <string> the string
 */
string intToStr(int number)
{
    stringstream ss;
    ss << number;// adds number to string;
    return ss.str();
}



/**
 * Gets IP version of address. 
 * @param  <string> address
 * @return <int>    AF_INET OR AF_INET6 OR 0 if address is not in IP format
 */
int addrType(string address)
{
    struct in6_addr result;

    if (inet_pton(AF_INET6, address.c_str(), &result) == 1)
        return AF_INET6;
    else if(inet_pton(AF_INET, address.c_str(), &result) == 1)
        return AF_INET;
    else
        return 0;
}



/**
 * Parse line
 */
void parseLine(string line)
{
    int foundSpace;
    // Line should be in this format
    // [Address] [BLANK] [comment]
    // [Address]
    // Delete rest of line.
    foundSpace = line.find(" "); 
    if(foundSpace != (int)string::npos)
        line.erase(foundSpace, line.length() - foundSpace);
    foundSpace = line.find('\t'); 
    if(foundSpace !=(int) string::npos)
        line.erase(foundSpace, line.length() - foundSpace);
    // Push it into list
    if(line.length())
        addresses.push_back(line);
}



/**
 * Parsring from stdin
 * @return <int>    error code
 */
void parseStdin(int timeout)
{
    string line;
    while(cin)
    {
        getline (cin,line);
        parseLine(line);
        tcpSearch(timeout);
    }
}



/**
 * Parsring from file
 * @param <string>  filename
 * @return <int>    error code
 */
int parseFile(string filename)
{
    string line;
    ifstream file (filename.c_str());
    if(file.is_open())
    {
        while(file)
        {
            getline (file,line);
            parseLine(line);
        }
        return E_OK;
    }
    else
        return E_FILE_OPEN;
}



/**
 * Parsing ports. Saves them into global list var.
 * @param <string>  string of ports
 * @return <int>    error code
 */
int parsePorts(string strPorts)
{
    // Grammars
    int  state = S_DIGIT;
    bool interval = false;
    int  a = 0; // interval begin
    int  b = 0; // interval end

    char buffer [10];
    int  k = 0;       // Buffer index
    
    for(unsigned int i=0; i < strPorts.length(); i++)
    {
        // Expect DIGIT!
        if(state == S_DIGIT)
        {
            if(isdigit(strPorts[i]))
            {
                buffer[0] = strPorts[i]; 
                k         = 1;
                state     = S_DIGIT_END;
            }
            else
                return E_PORTS;

        }
        else if(state == S_DIGIT_END)
        {
            if(isdigit(strPorts[i]) && k < 9)
            {
                buffer[k] = strPorts[i];
                k++;
            }
            else if(strPorts[i] == ',')
            {
                buffer[k] = '\0'; // end buffer str
                b = atoi(buffer);
                if(b > MAX_PORT_NUMBER) return E_PORTS;
                if(b <= 0) return E_PORTS;
                // Pushing interval
                if(interval == true)
                {
                    // First number of interval is bigger -> error
                    if(a > b) return E_PORTS;
                    for(int j = a; j <= b; j++)
                        ports.push_back(j);
                    interval = false;
                }
                else
                    ports.push_back(b);
                state = S_DIGIT;
                
            }
            else if(strPorts[i] == '-' && interval == false)
            {
                interval = true;
                buffer[k] = '\0'; // end string
                a = atoi(buffer);
                if(a > MAX_PORT_NUMBER) return E_PORTS;
                if(a <= 0) return E_PORTS;
                state = S_DIGIT;
            }
            else
                return E_PORTS;
        }
    }//for

    // Save last port
    if(state == S_DIGIT_END)
    {
        buffer[k] = '\0'; // end buffer str
        b = atoi(buffer);
        if(b <= 0) return E_PORTS;
        if(b > MAX_PORT_NUMBER) return E_PORTS;
        if(interval == true)
        {
            // First number of interval is bigger -> error
            if(a > b) return E_PORTS;
            for(int j = a; j <= b; j++) ports.push_back(j);
            interval = false;
        }
        else
            ports.push_back(b);
    }
    else
        return E_PORTS;

    // Delete duplicates
    ports.unique();
    return E_OK;
}// Parse ports



/**
 * Printing errors if occured 
 * @param  <int flag> hexdec flag
 * @return <void>
 */
void printError(int flag)
{
    if(flag & E_PARAMS)
        cerr << "Error: bad params" << endl;
    if(flag & E_PORTS)
        cerr << "Error: bad ports." << endl;
    if(flag & E_FILE_OPEN)
        cerr << "Error: couldn't open input file" << endl;
    if(flag & E_IP)
        cerr << "Warning: one of your IPv4 is in bad format and you should feel bad." << endl;
}



/**
 * Printing help
 */
void printHelp(void)
{
    using namespace std;
    cout << "Synopsis: tcpsearch [-t seconds] -p ports file" << endl;
    cout << endl;
    cout << "Options:" << endl;
    cout << "  -t seconds   banner timeout" << endl;
    cout << "  -p ports     list of ports and port intervals" << endl;
    cout << "  -h           prints this help" << endl;
    cout << "  -a           same timeout for connect to server" <<endl;
    cout << "  file         if file is named  -  stdin is used input file" << endl;
    cout << "               format: <ip | domain name> <comment>"<<endl;
    cout << endl;
    cout << "Examples:" << endl;
    cout << "  tcpsearch -t 10 input_file -p 1-80,873" << endl;
    cout << "  tcpsearch input_file -p 22,80,1024-1028,6666-6669" << endl;
    cout << endl;
    cout << "Example of file content:" << endl;
    cout << "2001:67c:1220:8b0::93e5:b013 IPv6" << endl;
    cout << "147.229.13.162 IPv4" << endl;
    cout << "merlin.fit.vutbr.cz" << endl;

}
