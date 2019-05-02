/* Compiler Theory and Design
 *  Breanna Chung
 */

/* This file contains flex input file */


%{
#include <cstdio>
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap



ws		[ \t\r]+
comment ("//"|"--").*\n
real    {digit}+\.{digit}*([Ee][+-]?{digit}+)?
line		[\n]
digit		[0-9]
id		[A-Za-z][A-Za-z_0-9]*
int		{digit}+
punc		[\(\),:;]

%%


{ws}		{ ECHO; }
{real}    { ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"   { ECHO; yylval.oper = LESS; return(RELOP); }
"<="  {ECHO; yylval.oper = LESSEQ; return(RELOP); }
">"   {ECHO; yylval.oper = GREATER; return(RELOP); }
">=" {ECHO; yylval.oper = GREATEREQ; return(RELOP); }
"=" {ECHO; yylval.oper = EQUAL; return(RELOP); }
"/=" {ECHO; yylval.oper = NOTEQUAL; return(RELOP);}
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
rem		{ ECHO; yylval.oper = REMAINDER; return(REMOP); }
"**"		{ ECHO; yylval.oper = EXPONENT; return(EXPOP); }
"=>"		{ ECHO; return(ARROW); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
true    {ECHO; yylval.value = 1; return(BOOL_LITERAL);}
false   {ECHO; yylval.value = 0; return(BOOL_LITERAL);}
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
if		{ ECHO; return(IF); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL);}
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
or		{ ECHO; return(OROP); }
not   { ECHO; return(NOTOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1);
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }

.		{ ECHO; appendError(LEXICAL, yytext); }



%%
