%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
}

%token IF ELSE WHILE CONTINUE BREAK PRINT DOUBLE CHAR INPUT ELIF COLON DISP_STRING FLOAT SCAN AS DIM
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN

%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT

%left LT GT /*LT GT has lowest precedence*/
%left ADDOP 
%left MULOP /*MULOP has lowest precedence*/

// %type<int_val> exp assignment_print_scan

%start program

%%

program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements;

statements: statements statement | ;

statement: declarations | input | output;
declarations: DIM ID AS INT
{
	insert($2, $4);
};
input: ID ASSIGN SCAN LPAREN RPAREN
{
	int address = idcheck($1);
	if(address != -1)
	{
		gen_code(SCAN_INT_VALUE, address);
		gen_code(STORE, address);
	}

};
output: PRINT LPAREN ID ADDOP
ID RPAREN{
	int address1 = idcheck($3);
	int address2 = idcheck($5);
	if (address1 != -1 && address2 != -1)
	{
		gen_code(LD_VAR, address1);
		gen_code(LD_VAR, address2);
		gen_code(ADD, -1);
		gen_code(STORE, address2);
		gen_code(PRINT_INT_VALUE, address2);
	}

	
} ;


%%

void yyerror ()
{
	printf("Syntax error at line %d\n", lineno);
	exit(1);
}

int main (int argc, char *argv[])
{
	yyparse();
	printf("Parsing finished!\n");

    printf("============= INTERMEDIATE CODE===============\n");
    print_code();

    printf("============= ASM CODE===============\n");
    print_assembly();

	return 0;
}
