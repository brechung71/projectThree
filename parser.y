/* Compiler Theory and Design
   Breanna Chung */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols <int> symbols;

int result;
double * args;
int count;



%}

%error-verbose

%union
{
  CharPtr iden;
  Operators oper;
  int value;

}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL
%token <value> REAL_LITERAL
%token <value> BOOL_LITERAL


%token <oper> ADDOP MULOP RELOP EXPOP REMOP
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS CASE ELSE ARROW

%token ENDCASE ENDIF IF OTHERS REAL THEN WHEN

%type <value> body statement_ statement reductions expression relation term
	factor primary conjuct power negation
%type <oper> operator

%%

function:
	function_header optional_variable body {result = $3;} ;

function_header:
	FUNCTION IDENTIFIER optional_parameter RETURNS type ';' ;

optional_variable:
	optional_variable variable |
	;

variable:
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;


optional_parameter:
    parameters  |
    %empty ;

parameters:
    parameter ',' parameters  |
    parameter ;

parameter:
  IDENTIFIER ':' type {symbols.insert($1, args[count]); count++;} ;


type: INTEGER | REAL |
      BOOLEAN ;


body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;

statement_:
    	statement ';' |
    	error ';' {$$ = 0;} ;

statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
  IF expression THEN statement_ ELSE statement_ ENDIF |
  CASE expression IS optional_cases OTHERS ARROW statement_ ENDCASE  ;


optional_cases:
	optional_cases case  |
  ;

case:
  WHEN INT_LITERAL ARROW statement_ ;

operator:
  RELOP |
  ADDOP |
  MULOP REMOP |
  EXPOP ;

reductions:
    reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
  	{$$ = $<oper>0 == ADD ? 0 : 1;} ;


expression:
  expression OROP conjuct {$$ = $1 ||  $3;}  |
	conjuct;

conjuct:
    conjuct ANDOP relation {$$ = $1 && $3;} |
    relation;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;

factor:
	factor MULOP power {$$ = evaluateArithmetic($1, $2, $3);} |
  factor REMOP power {$$ = evaluateArithmetic($1, $2, $3);} |
  power ;

power:
  negation EXPOP power {$$ = evaluateArithmetic($1, $2, $3);}|
  negation ;

negation:
  NOTOP primary {$$ =!($2);} |
  primary;

primary:
	'(' expression ')'  {$$ = $2;}  |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);};

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])
{
  args = new double[argc-1];
  count = 0;

  for (int j = 0; j < argc-1; j++)
  {
    args[j] = atof(argv[j + 1]);
  }

	firstLine();
	yyparse();
  if (lastLine() == 0)
    cout << "Result = " << result << endl;
	return 0;
}
