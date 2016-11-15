/**
 * @file   server.cpp
 * @author Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
 * @date   22nd February 2013
 * @description 
 *      Server using some strange protocol that I invented.. 
 *      Give him some data... 
 */

// Streams
#include <iostream>
#include <fstream>
#include <sstream>
#include <algorithm>
// Macros: true, false
#include <stdbool.h>
// Regular expression
#include <regex.h>
// For allocating.
#include <string.h>
// For singals..
#include <signal.h>
// For fork()
#include <unistd.h>
#include <stdlib.h>
// Variable errno
#include <errno.h>
// Working with BSD socets
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


//#define IPV6 // not supported
#define MAX_BACKLOG 5  // listen(int s, int baclog);
#define LOGIN_X 1
#define UID_X 2

using namespace std;

void parseMessage(string, string*);
void exitError(string);
void printHelp(void);
void parseFile(string, string *);
int getPort(char *);
string flags = "";
int qflag = 0;

/**
 * Main function
 */ 
int main (int argc, char** argv)
{	
    int ch;
    // Processing params
    if(argc == 1)
    {
        printHelp();
        return EXIT_SUCCESS; 
    }
    int port = 0;
    while((ch = getopt(argc, argv, "p:")) != -1)
    {
        switch(ch)
        {
            case 'p':
                port = getPort(optarg);
                break;
            default:
                exitError("Program options.");
        }
    }


    //cout << "Starting server on port: " << port << endl;

	// Listening vars;
	int s, t; // Sockets
	struct sockaddr_in sin;
	sin.sin_port = htons(port);
	sin.sin_family = PF_INET;
	sin.sin_addr.s_addr = INADDR_ANY;
	socklen_t sinlen;

	// Accepted message vars;
	char buffer[1] = "";
	int acceptedBytes;
	string message;
	string domain;

	signal(SIGCHLD, SIG_IGN); // Ignore signal sigchld 

	if((s = socket(PF_INET, SOCK_STREAM, 0)) < 0)  
        exitError("Creating socket");

	if(bind(s, (struct sockaddr *)&sin, sizeof(sin)) < 0 ) 
        exitError("Binding");

	if(listen(s, MAX_BACKLOG))
        exitError("Listening");


	int pid = 1;
    char prevc = 42;
	sinlen = sizeof(sin);
    //message.clear();
	while (pid != 0)
	{
        // Child process do not loop. Parent do.
		if((t = accept(s, (struct sockaddr *)&sin, &sinlen)) < 0)  // vytvoreni socketu
            exitError("Accepting");

		pid = fork();  // vytvoreni noveho procesu
		if(pid < 0)
		{
            cerr << "Cannoct creat child process."<< endl;
			kill(0, SIGTERM);
            exitError("fork()");
		}
		else if(pid == 0)  // potomek 
		{
            //cout << "waiting" << endl;
			while(1)
			{
				if((acceptedBytes = recv(t, &buffer, 1, 0)) < 0)
                    exitError("recv()");
				if(acceptedBytes == 0)
					break;
                if(prevc == '\n' && buffer[0] == '\n')
                    break;
                prevc = buffer[0];
				message.append(1, buffer[0]);
			}
            string result = "";
			parseMessage(message, &result);

			if(send(t, result.c_str(), (result.length()), 0) < 0)
                exitError("Sending");
			if(shutdown(t, 1) < 0)
                exitError("Shutdowning.");
		} 
	}
    return EXIT_SUCCESS;
} // main end

/**
 * Parsing message to get result.
 * @param string  Message
 * @param int     Flags
 */
void parseMessage(string msg, string * result)
{
    //if(login.length()) string message = "MTP "+ flag + " login\n"+ login +"\n\n";
    //else               string message = "MTP "+ flag + " uid\n"+ uid +"\n\n";
    regex_t re;
    regmatch_t pmatch[4];
    string dimension = "";
    string query = ""; 
    if(regcomp(&re, "^MTP ([LUGNHS]+)\n(.+) (.+)$", REG_EXTENDED) != 0)
    {
        result->append("0Error: compling regex.\n");
        return;
    }

    if(regexec(&re, msg.c_str(), 4, pmatch, 0) == 0)
    {
        flags.append    (msg.c_str()+pmatch[1].rm_so, pmatch[1].rm_eo-pmatch[1].rm_so);
        dimension.append(msg.c_str()+pmatch[2].rm_so, pmatch[2].rm_eo-pmatch[2].rm_so);
        query.append    (msg.c_str()+pmatch[3].rm_so, pmatch[3].rm_eo-pmatch[3].rm_so);
    }
    else
    {
        result->append("0Error:bad protocol..\n");
        return;
    }
    if(dimension == "login")
        qflag = LOGIN_X;
    else if(dimension == "uid")
        qflag = UID_X;
    else 
    {
        result->append("0Error:bad protocol..\n");
        return;
    }
    
    // check
    string tmp ="" ; 
    string q ="" ; 
    if(query[query.length() - 1] == '\n')
        q = query.substr(0, query.length() - 1);
    //query = query.substr
    istringstream handler(q);
    while(handler.good())
    {
        getline(handler, tmp, ':');
        parseFile(tmp, result);
    }
}

void parseFile(string param, string * result)
{   
    int ok = 0;
    regex_t re;
    string user  = "";
    string uid   = "";
    string gid   = "";
    string uname = "";
    string udir  = "";
    string shell = "";
    regmatch_t pmatch[7]; 
    // Compiling regex. 
    //                 User :pass :  uid  :  gid  : uname :  udir : interpret
    if(regcomp(&re, "^([^:]*):[^:]*:([^:]*):([^:]*):([^:]*):([^:]*):(.*)$", REG_EXTENDED) != 0)
    {
        result->append("0Error: compling regex.\n");
        return;
    }
    ifstream file("/etc/passwd");
    string line;
    if(file.is_open())
    {
        while(file.good())
        {
            getline(file, line);
            // Executing regex and filling up global variables. 
            uid.clear(); user.clear(); gid.clear(); uname.clear(); udir.clear(); shell.clear();
            if(regexec(&re, line.c_str(), 7, pmatch, 0) == 0)
            {
                user.append (line.c_str()+pmatch[1].rm_so, pmatch[1].rm_eo-pmatch[1].rm_so);
                if(qflag == LOGIN_X && user != param)
                    continue;
                uid.append  (line.c_str()+pmatch[2].rm_so, pmatch[2].rm_eo-pmatch[2].rm_so);
                if(qflag == UID_X && uid != param)
                    continue;
                gid.append  (line.c_str()+pmatch[3].rm_so, pmatch[3].rm_eo-pmatch[3].rm_so);
                uname.append(line.c_str()+pmatch[4].rm_so, pmatch[4].rm_eo-pmatch[4].rm_so);
                udir.append (line.c_str()+pmatch[5].rm_so, pmatch[5].rm_eo-pmatch[5].rm_so);
                shell.append(line.c_str()+pmatch[6].rm_so, pmatch[6].rm_eo-pmatch[6].rm_so);
                int printSpace = 0;
                for(unsigned int i = 0; i < flags.length(); i++)
                {
                    if(printSpace) 
                        result->append(" ");
                    else
                        result->append("1");
                    printSpace = 1;
                    if(flags[i] == 'L')
                        result->append(user);
                    else if(flags[i] == 'U')
                        result->append(uid);
                    else if(flags[i] == 'G')
                        result->append(gid);
                    else if(flags[i] == 'N')
                        result->append(uname);
                    else if(flags[i] == 'H')
                        result->append(udir);
                    else if(flags[i] == 'S')
                        result->append(shell);
                }
                result->append("\n");
                ok = true;
            }
        }
    }
    regfree(&re);
    file.close();
    if(!ok)
    {
        if(qflag == LOGIN_X)
            result->append("0Error: user "+param+" was not found.\n");
        else
            result->append("0Error: user with uid "+param+" was not found.\n");
    }
    regfree(&re);
    file.close();
    return;
}

/**
 * Getting port from C string.
 * @param char * String
 * @return int   Port
 */
int getPort(char* str)
{
    int result, length;
    // Was set up -p??
    if(isdigit(str[0]))
    {
        length = strlen(str);
        result = atoi(str);

        // Is the port ok?? 
        if(result > 65535 || length > 5)
            exitError("Your port seems wierd.");

        // Whole string must be digit
        for(int i = 1; i < length; i++)
        {
            if(! isdigit(str[i]))
                exitError("Your port seems wierd.");
        }
    }
    else
        exitError("Your port seems wierd.");
    return result;
}

/**
 * Exit the program unsuccessfully and prints the string. 
 */
void exitError(string str)
{
    cerr << "Error: " << str << endl;
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
    cout << "   server –p port" << endl;
    cout << endl;
}
//server.cpp
