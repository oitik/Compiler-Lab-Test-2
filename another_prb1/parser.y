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

%token IF ELSE WHILE CONTINUE BREAK PRINT DOUBLE CHAR INPUT ELIF COLON DISP_STRING FLOAT SCAN AS SUPS
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

statement: l1 | l2 | l3 | l4 | l5;

l1: SUPS ID  AS INT SEMI
{
	insert($2, $4);
};

l2: ID ASSIGN SCAN LPAREN RPAREN SEMI
{
	int addr = idcheck($1);
	if(addr != -1)
	{
		gen_code(SCAN_INT_VALUE, addr);
	}
};
l3: ID ASSIGN ID SUBOP SUBOP SEMI
{
	int addr = idcheck($1);
	if(addr != -1)
	{
		gen_code(LD_VAR, addr);
		gen_code(LD_INT, 1);
		gen_code(SUB, -1);
		gen_code(STORE, addr);
	}

};
l4: SUPS ID AS INT ASSIGN ID SUBOP ICONST SEMI
{
	insert($2, $4);
	int addr = idcheck($6);
	int addr1 = idcheck($2);
	if(addr != -1 && addr1 != -1)
	{
		gen_code(LD_VAR, addr);
		gen_code(LD_INT, $8);
		gen_code(SUB, -1);
		gen_code(STORE, addr1);
	}



};
l5: PRINT LPAREN ID RPAREN SEMI
{
	int address = idcheck($3);
    if(address != -1)
    {
        gen_code(PRINT_INT_VALUE, address);
    }
};

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
