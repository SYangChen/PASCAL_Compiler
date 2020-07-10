%{
#include<stdio.h>
#include<string.h>
unsigned charCount = 1,lineCount = 1;
int ispnsymbol = 0 ;
void print_char();
void PrintMsg( int lineNum, int charNum, char *text, int catogory ) ;
void PrintErrMsg( int lineNum, int charNum, char *text, int catogory ) ;

%} 
resword_absolute	[Aa][Bb][Ss][Oo][Ll][Uu][Tt][Ee]
resword_and			[Aa][Nn][Dd]
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
resword_then		[Tt][Hh][Ee][Nn]
resword_to			[Tt][Oo]
resword_var			[Vv][Aa][Rr]
resword_while		[Ww][Hh][Ii][Ll][Ee]
resword_read		[Rr][Ee][Aa][Dd]
resword_array		[Aa][Rr][Rr][Aa][Yy]
resword_integer		[Ii][Nn][Tt][Ee][Gg][Ee][Rr]
resword_double		[Dd][Oo][Uu][Bb][Ll][Ee]
resword_write		[Ww][Rr][Ii][Tt][Ee]
resword_writeln		[Ww][Rr][Ii][Tt][Ee][Ll][Nn]
resword_string		[Ss][Tt][Rr][Ii][Nn][Gg]
resword_float		[Ff][Ll][Oo][Aa][Tt]
reservedword		({resword_absolute}|{resword_and}|{resword_begin}|{resword_break}|{resword_case}|{resword_const}|{resword_continue}|{resword_do}|{resword_else}|{resword_end}|{resword_for}|{resword_function}|{resword_if}|{resword_mod}|{resword_nil}|{resword_not}|{resword_object}|{resword_of}|{resword_or}|{resword_program}|{resword_then}|{resword_to}|{resword_var}|{resword_while}|{resword_read}|{resword_array}|{resword_integer}|{resword_double}|{resword_write}|{resword_writeln}|{resword_string}|{resword_float})
whitespace			[ \t]+
symbol_2char		[:<>=]=
symbol_1char		[;:()><=\[\]+\-*/,\.]
symbol				({symbol_2char}|{symbol_1char})
integer				[+-]?(0|[1-9][0-9]*)
identifier			[_a-zA-Z][_a-zA-Z0-9]*
id_error			[^_a-zA-Z \t\n\r;:()><=\[\]+\-*/,\.']+[_a-zA-Z]+[^;:()><=\[\]+\-*/,\. \n\r]*
qstring_errorS		'[^';:()><=\[\]+\-*/,\. \n\r]*
qstring_errorE		[^';:()><=\[\]+\-*/,\. \n\r]*'
qstring_error		({qstring_errorS}|{qstring_errorE})
error_int			[+-]?0[0-9]+
error_real_1		[+-]?{error_int}([.][0-9]+)?([Ee][+-](0|[1-9][0-9]*))?
error_real_2		[+-]?(0|[1-9][0-9]*)\.[0-9]*0[0]+([Ee][+-](0|[1-9][0-9]*))?
error_real_3		\.[0-9]*
error_real_4		[0-9]*\.
error_real_5		[+-]?(0|[1-9][0-9]*)([.][0-9]+)?[Ee]{error_int}
error_real_6		[+-]?({error_int}|(0|[1-9][0-9]*))((\.[0-9]*0[0]+)|([.][0-9]+))?([Ee](([+-](0|[1-9][0-9]*))|({error_int})))?
error_real			({error_real_3}|{error_real_4}|{error_real_6})
real				[+-]?(0|[1-9][0-9]*)([.]([0-9]|([0-9]*[1-9][0-9])))?([Ee][+-](0|[1-9][0-9]*))?
quotedstring		'([^'\n\r]*('')*[^'\n\r]*)*'
comment				\(\*([^*]|[\r\n]|(\*+([^*\)]|[\r\n])))*\*+\)
error_commentS		\(\*([^*\n\r \t]|(\*+[^*\)]))*
error_commentE		([^\(\n\r \t]|(\(+[^\(*]))*\*\)
error_comment		{error_commentS}|{error_commentE}
eol					\n

%%
{reservedword}	{ ispnsymbol = 0 ; PrintMsg( lineCount, charCount, yytext, 1  ) ; charCount += yyleng ; }
{whitespace}	{ charCount += yyleng ; }
{integer}		{ 
				  if ( ispnsymbol ) {
				  	  ispnsymbol = 0 ;
				  	  yyless(1) ;
				  	  PrintMsg( lineCount, charCount, yytext, 3  ) ;
				  	  charCount += yyleng ; 
				  }
				  else {
					  ispnsymbol = 1 ; 
					  PrintMsg( lineCount, charCount, yytext, 4  ) ; 
					  charCount += yyleng ; 
				  }
				}
{error_int}		{ PrintErrMsg( lineCount, charCount, yytext, 4 ) ; charCount += yyleng ; }
{real}			{ if ( ispnsymbol ) {
				  	  ispnsymbol = 0 ;
				  	  yyless(1) ;
				  	  PrintMsg( lineCount, charCount, yytext, 3  ) ;
				  	  charCount += yyleng ; 
				  }
				  else {
					  ispnsymbol = 1 ; 
					  PrintMsg( lineCount, charCount, yytext, 5  ) ; 
					  charCount += yyleng ; 
				  }
				}
{error_real}	{ PrintErrMsg( lineCount, charCount, yytext, 5 ) ; charCount += yyleng ; }
{identifier}	{ ispnsymbol = 1 ;
				  if ( yyleng > 15 )
					  PrintErrMsg( lineCount, charCount, yytext, 2 ) ;
				  else
					  PrintMsg( lineCount, charCount, yytext, 2  ) ; 
				  charCount += yyleng ; 
				}
{id_error}		{ ispnsymbol = 0 ; PrintErrMsg( lineCount, charCount, yytext, 2 ) ; charCount += yyleng ; }
{qstring_error}	{ ispnsymbol = 0 ; PrintErrMsg( lineCount, charCount, yytext, 6 ) ; charCount += yyleng ; }
{quotedstring}	{ ispnsymbol = 1 ;
				  if ( yyleng > 30 )
					  PrintErrMsg( lineCount, charCount, yytext, 6 ) ;
				  else
					  PrintMsg( lineCount, charCount, yytext, 6  ) ; 
				  charCount += yyleng ;
				}
{comment}		{ ispnsymbol = 0 ;
				  PrintMsg( lineCount, charCount, yytext, 7  ) ;
				  charCount += yyleng ;
				  char *str = malloc( sizeof(char)*yyleng+1 ) ;
				  strcpy( str, yytext ) ;
				  int i, len ;
				  for ( i = 0 ; i < yyleng ; ++i ) {
					  if ( str[i] == '\n' ) {
						  ++lineCount ;
						  len = yyleng-i ;
					  }
				  }
				  charCount = len ;
				}
{error_comment}	{ ispnsymbol = 0 ; PrintErrMsg( lineCount, charCount, yytext, 7  ) ; charCount += yyleng ; }
{symbol}		{ ispnsymbol = 0 ; PrintMsg( lineCount, charCount, yytext, 3  ) ; charCount += yyleng ; }
{eol}			{ ispnsymbol = 0 ; lineCount++ ; charCount = 1 ; }
%%

int main()
{
	yylex(); 	
	return 0;
}

void print_char()
{
	printf("[In print_char]Symbol:\'%s\'\n",yytext);charCount++;
}

void PrintMsg( int lineNum, int charNum, char *text, int catogory ) {
	
	char cat[] = "abcdefghijklmnop" ;
	switch ( catogory ) {
		case 1 :
			strcpy( cat, "reserved word" ) ;
			break ;
		case 2 :
			strcpy( cat, "ID" ) ;
			break ;
		case 3 :
			strcpy( cat, "symbol" ) ;
			break ;
		case 4 :
			strcpy( cat, "integer" ) ;
			break ;
		case 5 :
			strcpy( cat, "real" ) ;
			break ;
		case 6 :
			strcpy( cat, "string" ) ;
			break ;
		case 7 :
			strcpy( cat, "comment" ) ;
			break ;
		default :
			strcpy( cat, "error" ) ;
			break ;
	}
	printf( "Line: %d, 1st char: %d, \"%s\" is a \"%s\".\n", lineNum, charNum, text, cat ) ;

}

void PrintErrMsg( int lineNum, int charNum, char *text, int catogory ) {
	
	char cat[] = "abcdefghijklmnop" ;
	switch ( catogory ) {
		case 1 :
			strcpy( cat, "reserved word" ) ;
			break ;
		case 2 :
			strcpy( cat, "ID" ) ;
			break ;
		case 3 :
			strcpy( cat, "symbol" ) ;
			break ;
		case 4 :
			strcpy( cat, "integer" ) ;
			break ;
		case 5 :
			strcpy( cat, "real" ) ;
			break ;
		case 6 :
			strcpy( cat, "string" ) ;
			break ;
		case 7 :
			strcpy( cat, "comment" ) ;
			break ;
		default :
			strcpy( cat, "error" ) ;
			break ;
	}
	printf( "Line: %d, 1st char: %d, \"%s\" is an \033[0;31minvalid\033[0m \"%s\".\n", lineNum, charNum, text, cat ) ;

}
