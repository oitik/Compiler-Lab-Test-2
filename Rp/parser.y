%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
    int offset;
%}

%union
{
    char str_val[100];
    int int_val;
}

%token PRINT SCAN
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN ELSE 
%token<str_val> ID
%token<int_val> ICONST
%token<int_val> INT
%token<int_val> IF
%token<int_val> WHILE

%left LT GT /*LT GT has lowest precedence*/
%left ADDOP 
%left MULOP /*MULOP has lowest precedence*/

// %type<int_val> exp assignment_print_scan

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);}
code: statements;

statements: statements statement | ;

statement:  l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11;

l1: INT ID SEMI{
    insert($2,$1);
};
l2: ID ASSIGN ICONST SEMI{
    gen_code(LD_INT,$3);
    gen_code(STORE,idcheck($1));
};
l3: IF LPAREN ID LT ICONST RPAREN{
    $1 = gen_label();
    offset = $1;
    gen_code(LD_VAR,idcheck($3));
    gen_code(LD_INT,$5);
    gen_code(LT_OP, gen_label());
    gen_code(IF_START,$1)
};
l4:LBRACE;
l5: PRINT LPAREN ID RPAREN SEMI{
    gen_code(PRINT_INT_VALUE,idcheck($3));
};
l6: RBRACE;
l7: ELSE{
    gen_code(ELSE_START,offset);
};
l8: LBRACE;
l9: ID ASSIGN ID ADDOP ICONST SEMI{
    gen_code(LD_VAR,idcheck($3));
    gen_code(LD_INT,$5);
    gen_code(ADD,-1);
    gen_code(STORE,idcheck($1));
};
l10: RBRACE{
    gen_code(ELSE_END,offset);
};
l11: PRINT LPAREN ID RPAREN SEMI;

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