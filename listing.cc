/**
 * Breanna Chung
 */

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexicalErrors;
static int syntaxErrors;
static int semanticErrors;



static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	if (totalErrors == 0)
	printf("%s\n", "Compiled Successfully!");
	else
	printf("Lexical Errors: %d\nSyntax Errors: %d\nSemantic Errors: %d\n", lexicalErrors, syntaxErrors, semanticErrors);
	return (totalErrors);
}

void appendError(ErrorCategories errorCategory, string message)
{


	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };
		error += messages[errorCategory] + message;
		if (errorCategory == 0)
		{
				lexicalErrors++;
			}
		else if (errorCategory == 1)
		{
				syntaxErrors++;
			}
		else if (errorCategory >= 2 && errorCategory <= 4)
		{
				semanticErrors++;
			}
	totalErrors++;


}

void displayErrors()
{
	if (error != "")
		
			printf("%s\n", error.c_str());

	error = "";


}
