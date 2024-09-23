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

%token IF ELSE WHILE CONTINUE BREAK PRINT DOUBLE CHAR INPUT ELIF COLON DISP_STRING FLOAT SCAN IS
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

statement: l1 | l2 | l3 | l4;
l1: ID IS INT ASSIGN SCAN LPAREN RPAREN SEMI
{
	insert($1, $3);
	int addr = idcheck($1);
	if(addr != -1)
	{
		gen_code(SCAN_INT_VALUE, addr);
	}
};
l2: ID IS INT ASSIGN SCAN LPAREN RPAREN SUBOP ID ADDOP ICONST SEMI
{
	insert($1, $3);
	int addrb = idcheck($1);
	int addra = idcheck($9);
	if(addra != -1 && addrb != -1)
	{
		gen_code(SCAN_INT_VALUE, addrb);
		gen_code(LD_VAR, addrb);
		gen_code(LD_VAR, addra);
		gen_code(SUB, -1);
		gen_code(LD_INT, $11);
		gen_code(ADD, -1);
		gen_code(STORE, addrb);
	}
};
l3: PRINT LPAREN ID RPAREN SEMI
{
	int address = idcheck($3);
    if(address != -1)
    {
        gen_code(PRINT_INT_VALUE, address);
    }
};
l4: PRINT LPAREN ICONST RPAREN SEMI
{
	insert("tmp", INT);
	int addr = idcheck("tmp");
	if(addr != -1)
	{
		gen_code(LD_INT, $3);
		gen_code(STORE, addr);
		gen_code(PRINT_INT_VALUE, addr);
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
