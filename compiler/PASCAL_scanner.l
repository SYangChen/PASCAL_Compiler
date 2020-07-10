%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
char text[100] ;
int ispnsymbol = 0 ;
int iscorrectgrammer = 1 ;
int hascomment = 0 ;
int charCount = 1 ;
%}
resword_absolute	[Aa][Bb][Ss][Oo][Ll][Uu][Tt][Ee]
resword_and			[Aa][Nn][Dd]
resword_array		[Aa][Rr][Rr][Aa][Yy]
resword_begin		[Bb][Ee][Gg][Ii][Nn]
resword_break		[Bb][Rr][Ee][Aa][Kk]
resword_case		[Cc][Aa][Ss][Ee]
resword_const		[Cc][Oo][Nn][Ss][Tt]
resword_continue	[Cc][Oo][Nn][Tt][Ii][Nn][Uu][Ee]
resword_do			[Dd][Oo]
resword_else		[Ee][Ll][Ss][Ee]
resword_end			[Ee][Nn][Dd]
resword_for			[Ff][Oo][Rr]
resword_function	[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]
resword_if			[Ii][Ff]
resword_mod			[Mm][Oo][Dd]
resword_nil			[Nn][Ii][Ll]
resword_not			[Nn][Oo][Tt]
resword_object		[Oo][Bb][Jj][Ee][Cc][Tt]
resword_of			[Oo][Ff]
resword_or			[Oo][Rr]
resword_program		[Pp][Rr][Oo][Gg][Rr][Aa][Mm]
resword_read		[Rr][Ee][Aa][Dd]
resword_then		[Tt][Hh][Ee][Nn]
resword_to			[Tt][Oo]
resword_var			[Vv][Aa][Rr]
resword_while		[Ww][Hh][Ii][Ll][Ee]
resword_write		[Ww][Rr][Ii][Tt][Ee]
resword_writeln		[Ww][Rr][Ii][Tt][Ee][Ll][Nn]
resword_integer		[Ii][Nn][Tt][Ee][Gg][Ee][Rr]
resword_double		[Dd][Oo][Uu][Bb][Ll][Ee]
resword_string		[Ss][Tt][Rr][Ii][Nn][Gg]
resword_float		[Ff][Ll][Oo][Aa][Tt]

integer				[+-]?(0|[1-9][0-9]*)
real				[+-]?(0|[1-9][0-9]*)([.]([0-9]|([0-9]*[1-9][0-9])))?([Ee][+-](0|[1-9][0-9]*))?
quotedstring		'([^'\n\r]*('')*[^'\n\r]*)*'
dot2dot				\.\.
identifier			[_a-zA-Z][_a-zA-Z0-9]*
NEWLINE 			\n
r					\r
BLANK 				" "|"\t"
comment				\(\*([^*]|[\r\n]|(\*+([^*\)]|[\r\n])))*\*+\)
anyother			.
%%
{resword_absolute}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_ABSOLUTE ; }
{resword_and}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_AND ; }
{resword_array}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_ARRAY ; }
{resword_begin}		{ charCount += yyleng ;  ispnsymbol = 0 ;strcat( text, yytext ) ; return T_BEGIN ; }
{resword_break}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_BREAK ; }
{resword_case}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_CASE ; }
{resword_const}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_CONST ; }
{resword_continue}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_CONTINUE ; }
{resword_do}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_DO ; }
{resword_else}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_ELSE ; }
{resword_end}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_END ; }
{resword_for}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_FOR ; }
{resword_function}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_FUNCTION ; }
{resword_if}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_IF ; }
{resword_mod}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_MOD ; }
{resword_nil}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_NIL ; }
{resword_not}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_NOT ; }
{resword_object}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_OBJECT ; }
{resword_of}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_OF ; }
{resword_or}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_OR ; }
{resword_program}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_PROGRAM ; }
{resword_read}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_READ ; }
{resword_then}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_THEN ; }
{resword_to}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_TO ; }
{resword_var}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_VAR ; }
{resword_while}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_WHILE ; }
{resword_write}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_WRITE ; }
{resword_writeln}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_WRITELN ; }
{resword_integer}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_INTEGER ; }
{resword_double}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_DOUBLE ; }
{resword_string}	{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_STRING ; }
{resword_float}		{ charCount += yyleng ;  ispnsymbol = 0 ; strcat( text, yytext ) ; return T_FLOAT ; }

{dot2dot}			{ charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return DOT2DOT ; }

{identifier}		{	
						charCount += yyleng ; 					
						ispnsymbol = 1 ; 
						strcat( text, yytext ) ; 
						/*lower(yytext);*/ 
						sscanf(yytext, "%s", &yylval.strVal);
						return IDENTIFIER ; 
					}
{integer}			{	if ( ispnsymbol && ( yytext[0] == '+' || yytext[0] == '-' ) ) {
							ispnsymbol = 0 ;
							yyless(1) ;
							charCount += yyleng ; 
							strcat( text, yytext ) ; 
							if ( yytext[0] == '+' )
								return PLUS ;
							else
								return MINUS ;
							/*charCount += yyleng ;*/
						}
						else {
							ispnsymbol = 1 ; 
							charCount += yyleng ; 
							strcat( text, yytext ) ;
							return INTVALUE ; 
							/*charCount += yyleng ;*/
						}
					}
{real}				{  if ( ispnsymbol && ( yytext[0] == '+' || yytext[0] == '-' ) ) {
					  	  ispnsymbol = 0 ;
					  	  yyless(1) ;
					  	  charCount += yyleng ; 
					  	  strcat( text, yytext ) ;
					  	  if ( yytext[0] == '+' )
					  		  return PLUS ;
					  	  else
					  		  return MINUS ;
					  	  /*charCount += yyleng ;*/
					  }
					  else {
						  ispnsymbol = 1 ; 
						  charCount += yyleng ; 
						  strcat( text, yytext ) ; 
						  return REALVALUE; 
						  /*charCount += yyleng ;*/
					  }
					}
{quotedstring}		{	
						charCount += yyleng ; 
						ispnsymbol = 1 ;
						strcat( text, yytext ) ; 
						sscanf(yytext, "%s", &yylval.strVal);
						return STRINGVALUE ; 
					}
"(" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return LP; }
")" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return RP; }
"[" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return LB; }
"]" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return RB; }
"." { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return DOT; }
"," { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return COMMA; }
";" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return SEMI; }
":" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return COLON; }
"+" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return PLUS; }
"-" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return MINUS; }
"*" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return MUL; }
"/" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return DIV; }
"<=" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return LE; }
">=" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return GE; }
"<" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return LT; }
">" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return GT; }
"=" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return EQUAL; }
"<>" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return UNEQUAL; }
":=" { charCount += yyleng ; ispnsymbol = 0 ; strcat( text, yytext ) ; return ASSIGN; }

{comment}	{
				iscorrectgrammer = 0 ;
				hascomment = 1 ;
				ispnsymbol = 0 ;
				charCount += yyleng ;
				char *str = malloc( sizeof(char)*yyleng+1 ) ;
				strcpy( str, yytext ) ;
				int i, len ;
				for ( i = 0 ; i < yyleng ; ++i ) {
					if ( str[i] == '\n' ) {
						++yylineno ;
						len = yyleng-i ;
					}
				}
				charCount = len ;
			}
{NEWLINE} { 
			charCount = 1 ;
			ispnsymbol = 0 ;
			int i ;
			for ( i = 0 ; i < strlen( text ) && hascomment ; ++i )
				if ( text[i] != ' ' && text[i] != '\t' )
					iscorrectgrammer = 1 ;
			for ( i = 0 ; i < strlen( text ) ; ++i )
				if ( text[i] != ' ' && text[i] != '\t' )
					break ;
			if ( i == strlen( text ) )
				iscorrectgrammer = 0 ;
			if ( iscorrectgrammer )
				printf( "\033[0;37mLine %d: %s\033[0m\n", yylineno, text ) ;
			memset(text, 0, 100); ++yylineno; 
			iscorrectgrammer = 1 ;
			hascomment = 0 ;
		  }
{BLANK} { charCount += yyleng ; strcat( text, yytext ) ; }
{r}		{}
{anyother}	{ispnsymbol = 0 ; return ANYOTHER;}
<<EOF>>		{	charCount = 1 ;
				ispnsymbol = 0 ;
				int i ;
				for ( i = 0 ; i < strlen( text ) && hascomment ; ++i )
					if ( text[i] != ' ' && text[i] != '\t' )
						iscorrectgrammer = 1 ;
				for ( i = 0 ; i < strlen( text ) ; ++i )
					if ( text[i] != ' ' && text[i] != '\t' )
						break ;
				if ( i == strlen( text ) )
					iscorrectgrammer = 0 ;
				if ( iscorrectgrammer )
					printf( "\033[0;37mLine %d: %s\033[0m\n", yylineno, text ) ;
				memset(text, 0, 100); ++yylineno; 
				iscorrectgrammer = 1 ;
				hascomment = 0 ;
				return T_EOF ;
			}
%%
