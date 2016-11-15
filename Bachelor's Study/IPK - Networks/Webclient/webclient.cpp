/**
 * @file   webclient.cpp
 * @author Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * @date   9th February 2013
 * @description 
 *      This program should download everything using HyperText Transfer 
 *      Protocol 1.1.Redirections should work. Cna be used in IPv6.
 */

// Streams
#include <iostream>
#include <fstream>
#include <algorithm>
// Macros: true, false
#include <stdbool.h>
// Regular expression
#include <regex.h>
// for allocating.
#include <string.h>
// Working with BSD socets
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>



////////////////////////////////////////////////////////////////////////////////
// DEFINES AND MACROS
////////////////////////////////////////////////////////////////////////////////
#define MAX_REDIRECT 5    // max redirextions.
//#define WEBCLIENT_IPV6  // IPV6 implemenation
//#define DONT_DWNLOAD_DURING_ERROR // do not download content and exit during error
#define DEFAULT_HTTP_PORT "80" // Default HTTP port



////////////////////////////////////////////////////////////////////////////////
// STREAMS
////////////////////////////////////////////////////////////////////////////////
using namespace std;



////////////////////////////////////////////////////////////////////////////////
// STRUCTS
////////////////////////////////////////////////////////////////////////////////
// Decoding URL
typedef struct {
    const char * symbol;
    const char * encoded;
} t_decode;



////////////////////////////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////////////////////////////

// Look up table for encoding URL. 
t_decode specialChars [] = {   // TODO Add more special chars...
    {" ", "%20"},
    {"!", "%21"}, 
    {"\"","%22"},
    {"#", "%23"}, 
    {"$", "%24"},
    //{"%"}, "%25"}, // It will fuck up URL. DO NOT USE IT!!!!
    {"&", "%26"}, 
    {"'", "%27"}, 
    {"(", "%28"}, 
    {")", "%29"}, 
    {"*", "%2a"}, 
    {"+", "%2b"}, 
    {",", "%2c"}, 
    {"-", "%2d"},
    {"?", "%3f"},
    {NULL, NULL}
};

// HTTP variables.
string protocol = ""; // Scheme
string host = "";     // Connected to host.
string path = "";     // Path
string port = DEFAULT_HTTP_PORT;
string file = "";

int redirected = 0;   // Times redirected.



////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
void printHelp(void);
void errorExit(string);
void parseUrl(char *, int);
void decodeUrl(string *);
void _connect(void); 
void _getResponse(int);
int  recvLine(int, string);
void setLocation(string);

/**
 * Main function. 
 * @param int    Argument count.
 * @param char** Array of strings represent arguments.
 * @return       System based program returns.
 */
int main(int argc, char ** argv)
{ 
    // Check params (arguments)
    if(argc == 1)
    {
        printHelp();
        return EXIT_SUCCESS;
    }
    else if(argc != 2)
        errorExit("Bad params.");

    parseUrl(argv[1], 0);

    // Transform case of protocol
    std::transform(protocol.begin(), protocol.end(), protocol.begin(), ::tolower);
    // Checking protocol
    if (protocol.length() > 0 && protocol != "http") 
        errorExit("Unsupported protocol.");
    
    _connect();
    
    return EXIT_SUCCESS;

}


/**
 * Connects to http server and sends message.
 * Supports IPv6 implementation.
 */
void _connect(void)
{
    // Message.
    string message = "GET " + path + " HTTP/1.1\r\nHost: " + host + "\r\nConnection: close\r\n\r\n";
    // Socket
    int s;
    // Init structutres for Getaddrinfo(). DNS, result, ptr to result.
	struct addrinfo hints, *result, *p_result;
	memset (&hints, 0, sizeof (struct addrinfo));

    // Set DNS socket params.
	hints.ai_family   = AF_UNSPEC;	  // IPv4 or IPv6 or somthing else?
    hints.ai_protocol = IPPROTO_TCP;  // TCP protocol
	hints.ai_socktype = SOCK_STREAM;  // TCP type of stream.

    // Get addres info. 
	if (getaddrinfo(host.c_str(), port.c_str(),  &hints, &result))
        errorExit("Getaddrinfo: " + host + ":" + port);
    p_result = result;                // Save its pointer for later free(). 

    // Check IP protocol.
    while (result != NULL)
    {   
        // IPv6
#ifdef WEBCLIENT_IPV6
        if (result->ai_family == AF_INET6) break;
#endif 
        // IPv4
        if (result->ai_family == AF_INET) break;

        // Last used protocol.
        if (result->ai_next  == NULL)  // TODO check this. 
            errorExit("Unsuppported IP protocol.");
        result = result->ai_next;
    }

    // Creating socket from what we get
    if((s=socket(result->ai_family,result->ai_socktype,result->ai_protocol))<0)
        errorExit("Creating socket.");
   
    // Connect
    if((connect(s, result->ai_addr, result->ai_addrlen)) < 0) 
        errorExit("Connecting socket.");
    
    // Sending msg
	if(send(s, message.c_str(), (message.length() ), 0) < 0)
        errorExit("Sending packet.");

    // Getting response
    _getResponse(s);

    freeaddrinfo(p_result);
}

/**
 * Recv() line ended by \r\n
 * @param int File descriptor OR socket.
 * @param string String that will be filled as new line.
 */
int recvLine(int s, string * msg)
{
	char c[1]   = "";   // Buffer
    char prev_c = 42;   // Previous character.
    int n;              // Recieved chars. 
    msg->clear();       // Clear msg.
    while(1) 
    {
		if((n = recv(s, &c, 1, 0)) < 0)
            errorExit("Receaving");
        else if(n == 0) 
            return 0;
        msg->append(1, c[0]);
        if(prev_c == '\r' && c[0] == '\n')
            return 1;
        prev_c = c[0];
    }
}


// States of FSM
#define S_INIT 1
#define S_REDIRECT 2
#define S_PARSE 3
#define S_PRINT 4
#define S_PRINT2 5
#define S_PRINT3 6
#define S_PASS 7
#define S_ERROR 8

/**
 * Parsing first line in recived message.
 * @param string The message.
 * @return int   Next state in FSM.
 */
int parseHttp(string msg)
{
    regex_t re;
    regmatch_t pmatch[2];
    string tmp = "";
    if(regcomp(&re, "^HTTP/[0-9].[0-9] ([^\r\n]*).*$", REG_EXTENDED) != 0)
        errorExit("Compiling regex.");
    if(regexec(&re, msg.c_str(), 2, pmatch, 0) == 0)
        tmp.append(msg.c_str()+pmatch[1].rm_so, pmatch[1].rm_eo-pmatch[1].rm_so);
    else
        errorExit("Not valid HTTP protocol.");
    if(tmp.substr(0,1) == "2")
        return S_PASS;
    else if (tmp.substr(0,3) == "301" || tmp.substr(0,3) == "302")
        return S_REDIRECT;
    else
        return S_ERROR;
}

/**
 * Processing accepted message.
 * @param int Socket descriptor.
 */
void _getResponse(int s)
{
    int state = S_INIT;   // Init state.
    bool chunked = false; // Chunked data
    ofstream fileHandler; // Stream into file
    string msg;           // Message string. (HEEAD)
    unsigned int i;
    int n;             // Counter for chunked data, tmp var
	char c[1]   = "";     // Buffer
    // FSM
	while(1)
	{
        switch(state){
            // Getting first line.
            case S_INIT:
		        if(! recvLine(s, &msg))
                    errorExit("Your protocol seems wierd.");
                state = parseHttp(msg);
                break;
            // Printing error
            case S_ERROR:
                #ifdef DONT_DWNLOAD_DURING_ERROR
                errorExit(msg);
                #endif
                cerr << msg << endl;
                state = S_PASS;
                break;
            // Checking end of HEAD and checking transfer encoding
            case S_PASS:
                msg.clear();
                if(! recvLine(s, &msg))
                    errorExit("Your protocol seems wierd.");
                // Last: \r\n 
                if(msg.compare("\r\n") == 0)
                    state = S_PRINT;
                // TODO More encodings.
                else if(msg.compare("Transfer-Encoding: chunked\r\n") == 0)
                    chunked = true;
                break;
            // Redirection
            case S_REDIRECT:
		        if(! recvLine(s, &msg))
                    errorExit("Your protocol seems wierd.");
                if(msg.compare(0,10,"Location: ") == 0)
                {
                    setLocation(msg);
                    redirected++;
                    if(redirected > MAX_REDIRECT)
                        errorExit("Max redirects.");
                    _connect();
                    return;
                }
                break;
            // Init printing.
            case S_PRINT:
                fileHandler.open(file.c_str());
                if(! fileHandler.is_open())
                    errorExit("Opening file.");
                if(chunked)
                    state = S_PRINT3;
                else
                    state = S_PRINT2;
                break;
            // Standard printing
            case S_PRINT2:
                if((n = recv(s, &c, 1, 0)) < 0)
                    errorExit("Receaving");
                if(n == 0)
                    return;
                fileHandler << c[0] << flush;
                break;
            // Chunked printing
            case S_PRINT3:
                recvLine(s, &msg);
                sscanf(msg.c_str(), "%x", &i); // convert char* to dec
                while(i != 0)
                {
                    while(i > 0)
                    {
                        if((n = recv(s, &c, 1, 0)) < 0)
                            errorExit("Receaving");
                        if(n == 0)
                        {
                            cerr << "???" <<endl;
                            return;
                        }
                        fileHandler << c[0] << flush;
                        i--;
                    }
                    recvLine(s, &msg); // "\r\n"
                    recvLine(s, &msg);
                    sscanf(msg.c_str(), "%x", &i); // convert char* to dec
                }
                return;
            default:
                errorExit("Uknown");
        }
	}
}

void setLocation(string msg)
{
    regex_t re;
    regmatch_t pmatch[2];
    string tmp = "";
    if(regcomp(&re, "^Location: ([^\r\n]*).*", REG_EXTENDED) != 0)
        errorExit("Compiling regex.");
    if(regexec(&re, msg.c_str(), 2, pmatch, 0) == 0)
        tmp.append(msg.c_str()+pmatch[1].rm_so, pmatch[1].rm_eo-pmatch[1].rm_so);
    else
        errorExit("Not valid HTTP protocol.");
    parseUrl((char *)tmp.c_str(), 1);
}
/**
 * Parsing URL and fill up global vars. 
 * @param char*  String to check.
 * @param int    scheme check.
 */
void parseUrl(char * str, int withoutHttp)
{
    // Regex
    string str_pattern = "^";
    if(withoutHttp)
        str_pattern += "([a-zA-Z0-9+-.]*://)?"; // scheme
    else
        str_pattern += "([a-zA-Z0-9+-.]*)://"; // scheme
    str_pattern += "([^/@?#]*@)?";              // userinfo
    str_pattern += "([^/?#:]+)";                // host
    str_pattern += ":?([0-9]*)";                // port
    str_pattern += "(/[^?#]*)?";                // path
    str_pattern += "(\\?[^#]*)?";               // ?query
    str_pattern += "(#.*)?$";                   // #fragment

    // Init other variables
    regex_t re;
    string portStr = "";
    string protocolStr = "";
    regmatch_t pmatch[8]; 
    const char *pattern = str_pattern.c_str();

    // Clearing every info that was given....
    protocol.clear(); host.clear(); path.clear(); port.clear();

    // Compiling regex. 
    if(regcomp(&re, pattern, REG_EXTENDED) != 0)
        errorExit("Compiling rexex.");

    // Executing regex and filling up global variables. 
    if(regexec(&re, str, 8, pmatch, 0) == 0)
    {
        protocolStr.append (str+pmatch[1].rm_so, pmatch[1].rm_eo-pmatch[1].rm_so);
        host.append(str+pmatch[3].rm_so, pmatch[3].rm_eo-pmatch[3].rm_so);
        portStr.append(str+pmatch[4].rm_so, pmatch[4].rm_eo-pmatch[4].rm_so);
        path.append(str+pmatch[5].rm_so, pmatch[5].rm_eo-pmatch[5].rm_so);
    }
    else
        errorExit("Not valid URL.");
    // Checking if default variables should be set 
    if(portStr.length() < 1) port.append(DEFAULT_HTTP_PORT);
    else                     port.append(portStr);
    if(path.length() < 1)    path.append("/");
    if(protocolStr.length() < 1) protocol.append("http");
    else                         protocol.append(protocolStr);

    regfree(&re);

    // Create filename.
    file.clear();
    if(regcomp(&re, "^.*/(.*)$", REG_EXTENDED) != 0)
        errorExit("Compiling rexex.");
    if(regexec(&re, path.c_str(), 2, pmatch, 0) == 0)
        file.append(path.c_str()+pmatch[1].rm_so, pmatch[1].rm_eo-pmatch[1].rm_so);
    else
        errorExit("Unvalid path");
    if(file.length() == 0)
        file.append("index.html");

    // Decode characters
    decodeUrl(& host);
    decodeUrl(& path);
}

/**
 * Decodes string to URL format
 * Ie. " " (space character) decdodes as %20
 * param string *   str pointer
 */
void decodeUrl(string * str)
{
    // TODO % decodes %25
    // if(find("%", lastfound) >= 0 )
    int j;
    // Iterates through lookup table.
    for (int i=0; specialChars[i].symbol; i++)
        // Replacing found symbols into ecoded values.
        while ((j = str->find(specialChars[i].symbol)) >= 0)
            str->replace(j,1,specialChars[i].encoded);
}

/**
 * Gets filename.
 */
void getFilename(string str)
{
    regex_t re;
    regmatch_t pmatch[2];
    file.clear();
    if(regcomp(&re, "^.*/(.*)$", REG_EXTENDED) != 0)
        errorExit("Compiling rexex.");
    if(regexec(&re, str.c_str(), 2, pmatch, 0) == 0)
        file.append(str.c_str()+pmatch[2].rm_so, pmatch[2].rm_eo-pmatch[2].rm_so);
    else
        errorExit("Not valid HTTP protocol.");
    if(file.length() == 0)
        file.append("index.html");
}
/**
 * Exit the program unsuccessfully and prints the string. 
 */
void errorExit(string str)
{
    cerr << "Error: " << str << endl;
    exit(EXIT_FAILURE);
}

/**
 * Prints help.
 */
void printHelp(void)
{
    cout << "SYNOPSIS" <<endl; 
    cout << "   webclient URL" << endl;
    cout << endl;
    cout << "EXAMPLES" << endl;
    cout << "a) webclient http://www.fit.vutbr.cz" << endl;
    cout << "      Download default page and save it as index.html in actual directory." << endl; 
    cout << "b) webclient http://www.fit.vutbr.cz:80/common/img/fit_logo_cz.gif" << endl;
    cout << "      Download image fit_logo_cz.gif into actual directory." << endl;
    cout << "c) webclient http://www.fit.vutbr.cz/study/courses/IPK/public/some\\ text.txt" << endl;
    cout << "      Download file \"some text.txt\" to file in actual directory." << endl;
    cout << "d) webclient http://www.fit.vutbr.cz/study/courses/IPK/public/test/redir.php" << endl;
    cout << "      Download a redirected file."<< endl;
}
//webclient.cpp
