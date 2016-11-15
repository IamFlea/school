/*
 * File name : client.cpp
 * Author    : Petr Dvoracek; xdvora0n@stud.fit.vutbr.cz
 * Date      : Apr 2, 2012
 * Project   : Prkelad domenovych jmen
 */


// MAY THE FORCE BE WITH YOU!


#include <string>
#include <cstring>
#include <netdb.h>
#include <unistd.h>
#include <locale.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <assert.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define DEFAULT_PORT 10000
//#define DEBUG

#define IPV4 0
#define IPV6 1

#define OK 1
#define BAD_PARAMS   0
#define MAX_PORT_NUMBER 65535
#define MAX_PORT_LENGTH 5

using namespace std;

// Global variables for params...
int flagIPv4 = 0;
int flagIPv6 = 0;
int currentIP = 42;
string hostAddress;
int    hostPort;
string domainName;

/**
 * Procedure for printing help.
 */
void printHelp(void)
{
	printf("Synopsis: client HOST:PORT [-4] [-6] DOMAIN_NAME\n");
	printf("\n");
	printf("Modifikacni parametry:\n");
	printf("Parametr  Vyznam\n");
	printf(" -4       vraci IPv4 adresu\n");
	printf(" -6       vraci IPv6 adresu\n");
}

/**
 * Parse first param.
 * domain - da first param
 * return true if ok
 */
int parseHost(string &domain)
{
	int portStart, len;
	string temp;
	
	#ifdef DEBUG
	printf("PARSING DOMAIN\n");
	printf("%s\n", domain.c_str());
	#endif

	portStart = domain.find_last_of(':');
	
	if(portStart == -1)
	{
		//hostAddress = domain;
		//hostPort = DEFAULT_PORT;
		return 0;
	}
	else
	{
		temp.assign(domain, portStart + 1, domain.length() - portStart - 1);
		len = temp.length();
		if(len == 0 || len > MAX_PORT_LENGTH)
			return 0;


		// PORT CAN CONTAIN ONLY NUMBERS
		for(int i = 0; i<len; i++)
			if(! isdigit(temp.c_str()[i]))
				return 0;
		hostPort = atoi(temp.c_str());
		if(hostPort > MAX_PORT_NUMBER)
			return 0;
		hostAddress.assign(domain, 0, portStart);
	}
	if(hostAddress.length() == 0)
		return 0;

	#ifdef DEBUG
	printf("Address: %s \n", hostAddress.c_str());
	printf("Port:    %d \n\n", hostPort);
	#endif
	return 1;
}


/**
 * Processing params. Printing help if bad params.
 * Excepting that argv[2] is number.
 *
 * @param argc   Count of params.
 * @param argv   Array of params strings.
 * @return       If bad params PRINT_HELP. 
 */
int processParams(int argc, char** argv)
{
	int result = OK;
	string tmp;
	// Process 4 params.. 
	// Example: 
	//    client HOST:PORT [-4||-6] DOMAIN_NAME  == 4 veci v argv
	//
	if(argc == 4)
	{
		// Size of 2nd  param must be 2!
		if(argv[2][0] != '-' || strlen(argv[2]) != 2)
			result = BAD_PARAMS;

		if(argv[2][1] == '4')
			flagIPv4 = 1;
		else if(argv[2][1] == '6')
			flagIPv6 = 1;
		else
			result = BAD_PARAMS;
	}

	// Process 5 params...
	// Example:
	//    client HOST:PORT [-4] [-6] DOMAIN_NAME
	//
	else if(argc == 5)
	{
		// Size of 2nd [-4] or 3rd [-6] param must be 2!
		if(strlen(argv[2]) != 2 || strlen(argv[3]) != 2)
			result = BAD_PARAMS;

		if(argv[2][0] != '-' || argv[3][0] != '-')
			result = BAD_PARAMS;

		// They cant be swapped first -6 then -4
		if(argv[2][1] == '4')
		{
			flagIPv4 = 1;
			if(argv[3][1] == '6')
				flagIPv6 = 2;
			else
				result = BAD_PARAMS;
		}
		else if(argv[2][1] == '6')
		{
			flagIPv6 = 1;
			if(argv[3][1] == '4')
				flagIPv4 = 2;
			else
				result = BAD_PARAMS;
		}
		else
			result = BAD_PARAMS;
	}
	else
		result = BAD_PARAMS;
	if(result != BAD_PARAMS)
	{
		tmp = string(argv[1]);
		if (! parseHost(tmp))
			result = BAD_PARAMS;
		domainName = string(argv[argc-1]);
	}
	return result;
}



/**
 * Get flags via message();
 */
void getFlags(string &message, int ip)
{
	message.clear();
	if(ip == IPV4)
		message = string("IPV4");
	else if(ip == IPV6)
		message = string("IPV6");
	else
		message = string("THE_ANSWER");
}

#define M_ERROR_PARSE {fprintf(stderr, "Err42: Nesu spatne zpravy. Nedokazu je rozparsrovat.\n"); return 1;}
/**
 * Parses the message.
 */
int parseMessage(string message)
{
	string temp, tmp;
	int size = 0;
	int newLine = message.find_first_of('\n');
	if(newLine == string::npos)
		M_ERROR_PARSE;

	temp.append(message, 0, newLine);
	if(temp.find("42 ERROR") != string::npos)
		fprintf(stderr, "Err%d: Nenalezeno.\n", currentIP);
	else if(temp.find("1 OK") != string::npos)
	{
		size = strlen("1 OK\nSo Long, and Thanks for All the Fish\nIP: "); // laziness... 
		if(message.length() < size)
			M_ERROR_PARSE;
		temp.clear();
		temp.append(message, size, message.length() - size);
		size = temp.find_first_of('\n');
		tmp.append(temp, 0, size);
		printf("%s\n", tmp.c_str());
	}
	else
		M_ERROR_PARSE;
	return 1;
}


/**
 * THIS IS MAGIC FUNCTION...
 * It does everything! It connects to server. Communicate with it. 
 * Printing result. Maybe it calls another functions...
 *
 * NOTE
 * Flags are in global variables... I love global variables... 
 *
 * @param host   Name of the server.
 * @param port   Port on the server. 
 * @param domain Message for server.
 * @return       Success OR failure.
 */
int clientDomain(int ipVersion)
{
	char c[1] = "";
	int s, n, i, result;
	struct sockaddr_in sin;
	struct hostent *hptr;
	string message, address, path, temp, flags;

	// set protocols to internet, set port
	i = 0;
	
	sin.sin_family = PF_INET;
	message.clear();
	sin.sin_port   = htons(hostPort);
	
	getFlags(flags, ipVersion);
	// Content of message
	message.append(flags);
	message.append(" TTP/1.0\n");// TROLL TRANSFER PROTOCOL
	message.append("Domain: ");
	message.append(domainName);
	message.append("\n\n");
	
	// create socket
	//
	#ifdef DEBUG
	printf("Crating socket\n");
	#endif
	if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0)
	{
		perror("Error on socket");
		return 0;
	}
		
	// hostname	
	#ifdef DEBUG
	printf("Getting hostname\n");
	#endif
	if((hptr = gethostbyname(hostAddress.c_str())) == NULL)
	{
		perror("Get hostname error");
		return 0;
	}
	
	memcpy(&sin.sin_addr, hptr->h_addr, hptr->h_length);

	#ifdef DEBUG
	printf("Connecting\n");
	#endif

	// pripoj se
	if(connect(s, (struct sockaddr *)&sin, sizeof(sin)) < 0)
	{
		perror("Error on connect.");
		return 0;
	}

	#ifdef DEBUG
	printf("Sending %s\n", message.c_str());
	#endif
	// posli serveru message
	if(send(s, message.c_str(), (message.length() + 1), 0) < 0)
	{
		perror("Error on write.");
		return 0;
	}
	if(shutdown(s, 1) < 0)
	{
		perror("Error on shutdown writing.");
		return 0;
	}
	message.clear();
	// a on ti necim odpovi
	// nebo taky ne :D
		
	#ifdef DEBUG
	printf("Reading\n");
	#endif
	while(1)
	{
		if((n = recv(s, &c, 1, 0)) < 0)
		{
			perror ("Error on read");
			return 0;
		}
		if(n == 0)
			break;
		message.append(1, c[0]);
	}

	#ifdef DEBUG
	printf("Clsoing socket\n");
	#endif
	if (close(s) < 0)
	{
		perror("Error on close");
		return 0;
	}
	#ifdef DEBUG
	printf("Zprava:\n%s\n", message.c_str());
	#endif

	#ifdef DEBUG
	printf("----------------\n");
	#endif
	return parseMessage(message);
}








/**
 * Main function
 */ 
int main (int argc, char** argv)
{	

	// Printing help
	if(processParams(argc, argv) == BAD_PARAMS)
	{
		printHelp();
		return EXIT_SUCCESS;
	}

	assert(flagIPv4 != flagIPv6);

	currentIP = 4;
	if(flagIPv4 == 1 && (! clientDomain(IPV4)))
		return EXIT_FAILURE;
	currentIP = 6;
	if(flagIPv6 == 1 && (! clientDomain(IPV6)))
		return EXIT_FAILURE;
	currentIP = 4;
	if(flagIPv4 == 2 && (! clientDomain(IPV4)))
		return EXIT_FAILURE;
	currentIP = 6;
	if(flagIPv6 == 2 && (! clientDomain(IPV6)))
		return EXIT_FAILURE;


	return EXIT_SUCCESS;
} // main end

/* End of file client.cpp */
