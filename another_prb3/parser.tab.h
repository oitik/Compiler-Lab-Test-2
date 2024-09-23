/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IF = 258,
     ELSE = 259,
     WHILE = 260,
     CONTINUE = 261,
     BREAK = 262,
     PRINT = 263,
     DOUBLE = 264,
     CHAR = 265,
     INPUT = 266,
     ELIF = 267,
     COLON = 268,
     DISP_STRING = 269,
     FLOAT = 270,
     SCAN = 271,
     IS = 272,
     ADDOP = 273,
     SUBOP = 274,
     MULOP = 275,
     DIVOP = 276,
     EQUOP = 277,
     LT = 278,
     GT = 279,
     LPAREN = 280,
     RPAREN = 281,
     LBRACE = 282,
     RBRACE = 283,
     SEMI = 284,
     ASSIGN = 285,
     ID = 286,
     ICONST = 287,
     INT = 288
   };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define WHILE 260
#define CONTINUE 261
#define BREAK 262
#define PRINT 263
#define DOUBLE 264
#define CHAR 265
#define INPUT 266
#define ELIF 267
#define COLON 268
#define DISP_STRING 269
#define FLOAT 270
#define SCAN 271
#define IS 272
#define ADDOP 273
#define SUBOP 274
#define MULOP 275
#define DIVOP 276
#define EQUOP 277
#define LT 278
#define GT 279
#define LPAREN 280
#define RPAREN 281
#define LBRACE 282
#define RBRACE 283
#define SEMI 284
#define ASSIGN 285
#define ID 286
#define ICONST 287
#define INT 288




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 13 "parser.y"
{
    char str_val[100];
    int int_val;
}
/* Line 1529 of yacc.c.  */
#line 120 "parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

