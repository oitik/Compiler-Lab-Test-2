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

%token IF ELSE WHILE CONTINUE BREAK PRINT DOUBLE CHAR INPUT ELIF COLON DISP_STRING FLOAT SCAN
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

statement: p1 | p2 | print;
p1: INT ID ASSIGN SCAN LPAREN RPAREN ADDOP ICONST
{
    insert($2, $1);
    int address = idcheck($2);
    if(address!= -1)
    {
        gen_code(SCAN_INT_VALUE, address);
        gen_code(LD_VAR, address);
        gen_code(LD_INT, $8);
        gen_code(ADD, -1);
        gen_code(STORE, address);
    }
};
p2: INT ID ASSIGN SCAN LPAREN RPAREN SUBOP ID
{
    insert($2, $1);
    int address1 = idcheck($2);
    int address0 = idcheck($8);
    if(address1!= -1 && address0!= -1)
    {
		gen_code(SCAN_INT_VALUE, address1);
        gen_code(LD_VAR, address1);
		gen_code(LD_VAR, address0);
        gen_code(SUB, -1);
        gen_code(STORE, address1);
    }
};
print: PRINT LPAREN ID RPAREN
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
