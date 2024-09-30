%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
	struct lbs *global_labels;
    struct lbs *global_labels2;

%}

%union
{
    char str_val[100];
    int int_val;
    struct lbs *lbls;
}


%token SUBT MAIN LPAREN RPAREN DIM AS END ASSIGN ADDOP SEMI
%token NEXT TO THEN GT PRINT
%token<str_val> ID 
%token<int_val> ICONST
%token<int_val> INT
%token<int_val> FOR
%token<int_val> IF
%token<int_val> SINGLE

%left LT GT /*LT GT has lowest precedence*/
%left ADDOP SUBOP 
%left MULOP /*MULOP has lowest precedence*/

// %type<int_val> exp assignment_print_scan

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);};

code: statements;

statements: statements statement | ;
statement: l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12;

l1: SUBT MAIN LPAREN RPAREN;
l2: DIM ID AS SINGLE
{
    insert($2, $4);
};
l3: DIM ID AS INT
{
    insert($2, $4);
};
l4: ID ASSIGN ICONST ID ASSIGN ICONST{
    gen_code(LD_INT, $3);
    gen_code(STORE, idcheck($1));

    gen_code(LD_INT, $6);
    gen_code(STORE, idcheck($4));
};
l5: ID ASSIGN ID ADDOP ID ADDOP ICONST SEMI
{
    gen_code(LD_VAR, idcheck($3));
    gen_code(LD_VAR,idcheck($5));
    gen_code(ADD, -1);
    gen_code(LD_INT, $7);
    gen_code(ADD, -1);
    gen_code(STORE, idcheck($1));
};
l6: FOR ID ASSIGN ICONST TO  ICONST
{
    global_labels = (struct lbs *) newlblrec(); 
	global_labels->for_goto = gen_label();
    gen_code(LD_VAR, idcheck($2));
    gen_code(LD_INT, $6);
    gen_code(LT_OP, -1);

    global_labels->for_jmp_false = reserve_loc();


};
l7: ID ASSIGN ID ADDOP ICONST
{
    gen_code(LD_VAR, idcheck($3));
    gen_code(LD_INT, $5);
    gen_code(ADD, -1);
    gen_code(STORE, idcheck($1));
};
l8: NEXT ID
{
    gen_code(LD_INT, 1);
    gen_code(LD_VAR, idcheck($2));
    gen_code(ADD, -1);
    gen_code(STORE, idcheck($2));
    gen_code(GOTO, global_labels->for_goto);
}

;
l9: IF ID GT ICONST THEN
{
    back_patch( global_labels->for_jmp_false, JMP_FALSE, gen_label() );

    global_labels2 = (struct lbs *) newlblrec(); 
    gen_code(LD_VAR, idcheck($2));
    gen_code(LD_INT, $4);
    gen_code(GT_OP, -1);
    global_labels2->for_jmp_false = reserve_loc();

}
;
l10: PRINT LPAREN ID RPAREN
{
    gen_code(PRINT_INT_VALUE, idcheck($3));
    global_labels2->for_goto = reserve_loc();
}
;
l11: END IF
 {
    back_patch( global_labels2->for_jmp_false, JMP_FALSE, gen_label() );
    back_patch(global_labels2->for_goto, GOTO, gen_label());

};
l12:END SUBT;

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

    printf("============= RUN CODE IN VIRTUAL MACHINE ===============\n");
    vm();

	return 0;
}
