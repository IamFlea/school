/*
 * File name : server.cpp
 * Author    : Petr Dvoracek; xdvora0n@stud.fit.vutbr.cz
 * Date      : Apr, 2, 2012
 * Project   : Prkelad domenovych jmen
 */


// MAY THE FORCE BE WITH YOU!
// Young jedi! 

#include <string>
#include <cstring>
#include <netdb.h>
#include <unistd.h>
#include <locale.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


// My favourite macros :) 
#define TRUE  1
#define FALSE 0

// Program defines
#define DEFAULT_PORT 10000
#define BAD_PARAMS   -1
#define MAX_PORT_NUMBER 65535
#define MAX_PORT_LENGTH 5

#define IPV4 0
#define IPV6 1
#define THE_ANSWER 42
#define PARSE_ERROR -1

//#define DEBUG

using namespace std;


/**
 * Processing params. Printing help if bad params.
 * Excepting that argv[2] is number.
 *
 * @param argc   Count of params.
 * @param argv   Array of params strings.
 * @return       Port, if bad params PRINT_HELP. 
 */
int processParams(int argc, char** argv)
{
	int result = DEFAULT_PORT; // !!!
	int length;
	if(argc == 3 && strlen(argv[1]) == 2)
	{

		// Was set up -p??
		if(argv[1][0] ==  '-' && argv[1][1] == 'p' && isdigit(argv[2][0]))
		{
			result = atoi(argv[2]);
			length = strlen(argv[2]);

			// Is the port ok?? 
			if(result > MAX_PORT_NUMBER || length > MAX_PORT_LENGTH)
				result = BAD_PARAMS;

			// whole string must be digit
			for(int i = 1; i < length; i++)
			{
				if(! isdigit(argv[2][i]))
					result = BAD_PARAMS;
			}
			
		}
		else
			result = BAD_PARAMS;
	}
	// started with random params..
	else// if(argc != 1)
		result = BAD_PARAMS;
	return result;
}

/**
 * Procedure for printing help.
 */
void printHelp(void)
{
	printf("Synopsis: server [-p PORT_NUMBER]\n");
	printf("\n");
	printf("Modifikacni parametry:\n");
	printf("Parametr      Vyznam\n");
	printf(" -p           Zadano cislo portu, na kterem bude server bezet.\n");
	printf(" PORT_NUMBER  V rozsahu 0-65535.");
	//printf("Server bezi na portu %d, nebyl-li zadan port.", DEFAULT_PORT);
}

/**
 * Parses accepted message from client.
 * @param message
 * @return What to do
 */
int parseMessage(string message, string &domain)
{
	int domainStart, domainEnd;
	domain.clear();
	domain.append(message, 0, message.find_first_of('\n'));
	if (domain.find("IPV4") != string::npos)
	{
		domain.clear();
		domainStart = message.find_first_of('\n') + strlen("\nDomain: ");
		domainEnd = message.find_first_of('\n', domainStart); 
		domain.append(message, domainStart, domainEnd - domainStart);
		
		return IPV4;
	}
	else if(domain.find("IPV6") != string::npos)
	{
		domain.clear();
		domainStart = message.find_first_of('\n') + strlen("\nDomain: ");
		domainEnd = message.find_first_of('\n', domainStart); 
		domain.append(message, domainStart, domainEnd - domainStart);
		
		return IPV6;
	}
	return PARSE_ERROR;
}

/**
 * Get IP from hostname. Saves it in string message.
 * Writing this function was like saberfight against Darth Vader.
 * @param domain   Domain name.
 * @param message  Server message, need to be send!
 * @param vesrsion IP version
 */
void getIP(string domain, string &message, int version)
{
	message.clear();
	struct addrinfo hints, *res;
	char addrstr[254];
	void *ptr;

	memset (&hints, 0, sizeof (hints));
	hints.ai_family = version;	
	hints.ai_flags |= AI_CANONNAME;	
	hints.ai_socktype = SOCK_STREAM;

	if (getaddrinfo (domain.c_str(), NULL, &hints, &res) != 0)
	{
		message = string("42 ERROR\nThe Answer to the Great Question, of Life, the Universe and Everything\n");
		return;
	}

	inet_ntop (res->ai_family, res->ai_addr->sa_data, addrstr, 254);

	switch (res->ai_family)
	{
		case AF_INET:
			ptr = &((struct sockaddr_in *)(res->ai_addr))->sin_addr;
			break;
		case AF_INET6:
			ptr = &((struct sockaddr_in6 *)(res->ai_addr))->sin6_addr;
			break;
	}
	inet_ntop (res->ai_family, ptr, addrstr, 254);
	message = string("1 OK\nSo Long, and Thanks for All the Fish\nIP: ");
	message.append(addrstr);
	message.append("\n\n");
	return;
}


/**
 * Starting server. My death star.
 *
 * @param port  Port on server starts. Maybe alderaan. 
 * @return      FALSE if error occurs, otherwise TRUE.
 */
int startServer (int port)
{
	// Listening.
	int s; // socket
	struct sockaddr_in sin;
	sin.sin_port = htons(port);
	sin.sin_family = PF_INET;
	sin.sin_addr.s_addr = INADDR_ANY;
	socklen_t sinlen;

	// Accepted message. 
	int t; // socket
	char buffer[1] = "";
	int acceptedBytes;
	string message;
	int result;
	string domain;

	#ifdef DEBUG
	printf("Starting server on port: %d \n", port);
	#endif
	signal(SIGCHLD, SIG_IGN); // Delete zombies, they are not in star wars!!


	#ifdef DEBUG
	printf("Creating socket.\n");
	#endif
	if((s = socket(PF_INET, SOCK_STREAM, 0)) < 0)  
	{
		perror("Error on socket");
		return FALSE;
	}

	#ifdef DEBUG
	printf("Binding IP on socket. \n");
	#endif
	if(bind(s, (struct sockaddr *)&sin, sizeof(sin)) < 0 ) 
	{
		perror("Error on bind");
		return FALSE;
	}

	#ifdef DEBUG
	printf("Listening ports.\n"); // Your PC is high. It used drug called socket.. :D
	#endif
	if(listen(s, 5))
	{
		perror("Error on listen");
		return FALSE;
	}


	int pid = 1;
	sinlen = sizeof(sin);
	while (pid != 0)
	{
		message.clear();

		#ifdef DEBUG
		printf("%d Accepting connection.\n", pid);
		#endif
		if((t = accept(s, (struct sockaddr *)&sin, &sinlen)) < 0)  // vytvoreni socketu
		{
			perror("Error on accept");
			return FALSE;
		}

		#ifdef DEBUG
		printf("%d Creating child process.\n", pid);
		#endif
		pid = fork();  // vytvoreni noveho procesu
		if(pid < 0)
		{
			fprintf(stderr, "Error on fork: couldnt make another process. Please contact Darth Vader to fix it. \n");
			kill(0, SIGTERM);
		}
		else if(pid == 0)  // potomek 
		{
			#ifdef DEBUG
			printf("%d: Reading.\n", pid);
			#endif
			while(1)
			{
				if((acceptedBytes = recv(t, &buffer, 1, 0)) < 0)
				{
					perror ("Error on read");
					return TRUE;
				}
				if(acceptedBytes == 0)
					break;
				message.append(1, buffer[0]);
			}
			#ifdef DEBUG
			printf("%d: Accepted message: \n---------------------\n%s\n---------------------\nParsing this message...\n", pid, message.c_str());
			#endif
			
			result = parseMessage(message, domain);
			#ifdef DEBUG
			printf("Done\n");
			#endif

			if(result == IPV4)
				getIP(domain, message, PF_INET);
			else if(result == IPV6)
				getIP(domain, message, PF_INET6);
			else
				message = string("\"The Answer to the Great Question, of Life, the Universe and Everything\"\n\"Forty-two,\" said Deep Thought, with infinite majesty and calm.\n\n");

			if(send(t, message.c_str(), (message.length()+1), 0) < 0)
			{
				perror("Error on write.");
				return 0;
			}
			if(shutdown(t, 1) < 0)
			{
				perror("Error on shutdown writing.");
				return 0;
			}
		} 
	}
	#ifdef DEBUG
	printf("%d: Closing socket\n", pid);
	#endif
	// uzavreni socketu
	if((close(t) < 0) || (close(s) < 0))
	{
		perror("Error on closing socket.");
		return FALSE;
	}

	return TRUE;
}


/**
 * Main function
 */ 
int main (int argc, char** argv)
{	
	int port = processParams(argc, argv);
	
	// Printing help
	if(port == BAD_PARAMS)
		printHelp(); 
	else if(! startServer(port))
		return EXIT_FAILURE;

	return EXIT_SUCCESS;
} // main end

/* End of file client.cpp */
