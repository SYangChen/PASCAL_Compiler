%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct symbol {
	char name[16] ;		/* max length 15 character */
	int type ;			/* 1 : int / 2 : real / 3 : string */
	int cc ;			/* char count */
}symbol;

extern char *yytext ;
extern int yyleng ;
extern int yylineno ;
extern int iscorrectgrammer ;
extern int charCount ;

/*------------------------------*/
/*-------- Symbol Table --------*/
symbol *symbolTable ;
int sTableUsed ;
int sTableSize ;

symbol tempsTable[10] ;
int tempUsed = 0 ;
int isDefineNameInterval = 1 ;
int left = 0 ;

void InitSymbolTable() ;
int AddToSymbolTable( symbol s ) ;
int IsDefinedSymbol( char n[16] ) ;
/*-------------------------------*/

int expHas_0ID_1Int_2Real_3String[5] ;
int curVarType = 0 ;
int streamExpType[3] ;
char firstExpOp = 'x' ;

int yylex() ;
void yyerror(const char* message) ;
%}
%union {
    float 	floatVal;
    int 	intVal;
    char 	strVal[20];
}
%start prog
%token LP RP LB RB DOT COMMA SEMI COLON 
%token PLUS MINUS MUL DIV LE GE LT GT EQUAL UNEQUAL ASSIGN
%token T_ABSOLUTE T_AND T_ARRAY T_BEGIN T_BREAK T_CASE T_CONST
%token T_CONTINUE T_DO T_ELSE T_END T_FOR T_FUNCTION T_IF T_MOD
%token T_NIL T_NOT T_OBJECT T_OF T_OR T_PROGRAM T_READ T_THEN 
%token T_TO T_VAR T_WHILE T_WRITE T_WRITELN T_INTEGER T_DOUBLE T_STRING T_FLOAT
%token ANYOTHER DOT2DOT T_EOF
%token <strVal> IDENTIFIER REALVALUE INTVALUE STRINGVALUE

%%

// ---------Any TYPO or Double check the grammer with special token------------
semiTYPO
	:
	| COLON | LP | RP | LB | RB | DOT | DOT2DOT | ASSIGN | ANYOTHER
	;

rpTYPO
	:
	| COLON | SEMI | LP | LB | RB | DOT | DOT2DOT | ASSIGN | ANYOTHER
	;

rbTYPO
	:
	| COLON | SEMI | LP | RP | LB | DOT | DOT2DOT | ASSIGN | ANYOTHER
	;

colonTYPO
	:
	| SEMI | LP | RP | LB | RB | DOT | DOT2DOT | ASSIGN | ANYOTHER
	;

dotTYPO
	: SEMI | LP | RP | LB | RB | COLON | DOT2DOT | ASSIGN | ANYOTHER
	| PLUS | MINUS | MUL | DIV | LE | GE | LT | GT | EQUAL | UNEQUAL
	;

dot2dotTYPO
	:
	| SEMI | LP | RP | LB | COLON | DOT | ASSIGN | ANYOTHER
	| PLUS | MINUS | MUL | DIV | LE | GE | LT | GT | EQUAL | UNEQUAL
	;

semi
	: SEMI
	| semiTYPO { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \";\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; }
	;

lp
	: LP
	| error { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \"(\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; }
	;

rp
	: RP
	| rpTYPO { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \")\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; }
	;

lb
	: LB
	;
	
rb
	: RB
	| rbTYPO { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \"]\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; }
	;

end
	: T_END
	;
	
colon
	: COLON
	| colonTYPO { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \":\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; }
	;
	
then
	: T_THEN
	| { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \"then\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; }
	;
	
if
	: T_IF
	;
	
dot
	: DOT
	| { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \".\" expected but \"end of file\" found\n", yylineno, charCount ) ; }
	| dotTYPO { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \".\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; }
	;
	
dot2dot
	: DOT2DOT
	| dot2dotTYPO { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \"]\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; }
	;
	
begin
	: T_BEGIN { isDefineNameInterval = 0 ; }
	;

id_
	: IDENTIFIER	{
	  // put ID into symbol table buffer in define name interval ( from "var" to "begin" )
	  // or check whether the identifier was defined
						if ( isDefineNameInterval ) {
							/*printf( "aa:%s\n", $1 ) ;*/
							strcpy( tempsTable[tempUsed].name, $1 ) ;
							tempsTable[tempUsed++].cc = charCount-yyleng ;
						}
						else {
							char n[16] ;
							strcpy( n, $1 ) ;
							int tempType ;
							tempType = IsDefinedSymbol( n ) ;
							if ( !tempType ) {
								iscorrectgrammer = 0 ;
								printf( "Line %d, at char %d, \033[0;31mError:\033[0m Identifier not found \"%s\"\n",yylineno, charCount-yyleng, n ) ;
							}
							else {
								// record to current varibale type record
								if ( curVarType == 0 )
									curVarType = tempType ;
								else {
									expHas_0ID_1Int_2Real_3String[tempType] = 1 ;
									if ( !streamExpType[0] ) 
										streamExpType[0] = tempType ;
									else if ( !streamExpType[1] )  
										streamExpType[1] = tempType ; 
								}
							}
						}
					}
	;

// ---------Any TYPO or Double check the grammer with special token------------

prog
	: T_PROGRAM prog_name semi T_VAR dec_list semi begin stmt_list semi end dot T_EOF
	// normal grammer
	| { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \"begin\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; } prog_name semi T_VAR dec_list semi begin stmt_list semi end dot T_EOF
	// loss program
	| T_PROGRAM prog_name semi { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \"begin\" expected but \"%s\" found\n", yylineno, charCount-yyleng, yytext ) ; } dec_list semi begin stmt_list semi end dot T_EOF
	// loss var
	;

prog_name 
	: IDENTIFIER { InitSymbolTable() ; }
	;
	
dec_list
	: dec
	| dec_list semi dec
	;
	
dec
	: id_list colon type
	;

type
	: standtype {
	  // get the type and put the symbol buffer id into symbol table
	  // or check the id is not duplicate
					int i ;
					for ( i = 0 ; i < tempUsed ; ++i ) {
						if ( strcmp( yytext, "integer" ) == 0 )
							tempsTable[i].type = 1 ;
						else if ( strcmp( yytext, "double" ) == 0 )
							tempsTable[i].type = 2 ;
						else if ( strcmp( yytext, "string" ) == 0 )
							tempsTable[i].type = 3 ;
						else
							tempsTable[i].type = 0 ;
						if ( !AddToSymbolTable( tempsTable[i] ) ) {
							iscorrectgrammer = 0 ;
							printf( "Line %d, at char %d, \033[0;31mError:\033[0m Duplicate identifier \"%s\"\n",yylineno, tempsTable[i].cc, tempsTable[i].name ) ;
						}
					}
					tempUsed = 0 ;
				}
	| arraytype
	;

standtype
	: T_INTEGER
	| T_DOUBLE
	| T_STRING
	;
	
arraytype
	: T_ARRAY lb INTVALUE dot2dot INTVALUE rb T_OF standtype 
	  // get the type and put the symbol buffer id into symbol table
	  // or check the id is not duplicate
		{	
			int i ;
			for ( i = 0 ; i < tempUsed ; ++i ) {
				if ( strcmp( yytext, "integer" ) == 0 )
					tempsTable[i].type = 1 ;
				else if ( strcmp( yytext, "double" ) == 0 )
					tempsTable[i].type = 2 ;
				else if ( strcmp( yytext, "string" ) == 0 )
					tempsTable[i].type = 3 ;
				else
					tempsTable[i].type = 0 ;
				if ( !AddToSymbolTable( tempsTable[i] ) ) {
					iscorrectgrammer = 0 ;
					printf( "Line %d, at char %d, \033[0;31mError:\033[0m Duplicate identifier \"%s\"\n",yylineno, tempsTable[i].cc, tempsTable[i].name ) ;
				}
			}
			tempUsed = 0 ;
		}
	;
	
id_list
	: id_
	| id_list COMMA id_
	;
	
arg_list
	: argument
	| arg_list COMMA argument
	;
	
argument
	: varid
	| STRINGVALUE
	;
	
stmt_list
	: stmt
	| stmt_list semi stmt
	;
	
stmt
	: assign {	curVarType = 0 ;
				int i ;
				for ( i = 0 ; i < 4 ; i++ ) 
					expHas_0ID_1Int_2Real_3String[i] = 0 ;
			 }
	| read
	| write
	| for
	| ifstmt
	| writeln
	| exp { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mError:\033[0m Illegal expression\n", yylineno, charCount-yyleng ) ; }
	| error { /*yyerrok;*/ }
	;
	
assign
	: varid ASSIGN { streamExpType[0] = 0 ; streamExpType[1] = 0 ; firstExpOp = 'x' ; } simpexp	
	  // chek the assign action with the type is all correct ( and do the error recovery )	
								{
									if ( expHas_0ID_1Int_2Real_3String[3] && firstExpOp != 'x' ) {
										iscorrectgrammer = 0 ;
										char typeStr[2][10] ;
										int i ;
										for ( i = 0 ; i < 2 ; ++i ) {
											if ( streamExpType[i] == 1 )
												strcpy( typeStr[i], "integer" ) ;
											else if ( streamExpType[i] == 2 )
												strcpy( typeStr[i], "real" ) ;
											else if ( streamExpType[i] == 3 )
												strcpy( typeStr[i], "string" ) ;
											else
												strcpy( typeStr[i], "error" ) ;
										}
										printf( "Line %d, at char %d, \033[0;31mError:\033[0m Operation \"%c\" not supported for types \"%s\" and\"%s\"\n", yylineno, charCount-yyleng, firstExpOp, typeStr[0], typeStr[1] ) ;
									}
									else if ( expHas_0ID_1Int_2Real_3String[3] && !expHas_0ID_1Int_2Real_3String[2] && !expHas_0ID_1Int_2Real_3String[1] ) {
										// only string type in expression but wrong varibale type assign
										if ( curVarType != 3 ) {
											iscorrectgrammer = 0 ;
											char typeStr[10] ;
											if ( curVarType == 1 )
												strcpy( typeStr, "integer" ) ;
											else if ( curVarType == 2 )
												strcpy( typeStr, "real" ) ;
											else
												strcpy( typeStr, "error" ) ;
											printf( "Line %d, at char %d, \033[0;31mError:\033[0m Incompatible types: got \"String\" expected \"%s\"\n", yylineno, charCount-yyleng, typeStr ) ;
										}
									}
									else if ( expHas_0ID_1Int_2Real_3String[3] ) {
										// has string type with any other type in expression
										if ( expHas_0ID_1Int_2Real_3String[2] ) {
											iscorrectgrammer = 0 ;
											printf( "Line %d, at char %d, \033[0;31mError:\033[0m Operator is not overloaded: \"Double\" + \"String\"\n", yylineno, charCount-yyleng ) ;
										}
										else if ( expHas_0ID_1Int_2Real_3String[1] ) {
											iscorrectgrammer = 0 ;
											printf( "Line %d, at char %d, \033[0;31mError:\033[0m Incompatible types: got \"Integer\" expected \"String\"\n", yylineno, charCount-yyleng ) ;
										}
									}
									else { 
										// right statement has no string type
										if ( curVarType == 1 ) {
											if ( expHas_0ID_1Int_2Real_3String[2] ) {
												iscorrectgrammer = 0 ;
												printf( "Line %d, at char %d, \033[0;31mError:\033[0m Incompatible types: got \"Real\" expected \"Integer\"\n", yylineno, charCount-yyleng ) ;
											}
										}
										if ( curVarType == 3 ) {
											if ( expHas_0ID_1Int_2Real_3String[2] ) {
												iscorrectgrammer = 0 ;
												printf( "Line %d, at char %d, \033[0;31mError:\033[0m Incompatible types: got \"Real\" expected \"string\"\n", yylineno, charCount-yyleng ) ;
											}
											else if ( expHas_0ID_1Int_2Real_3String[1] ) {
												iscorrectgrammer = 0 ;
												printf( "Line %d, at char %d, \033[0;31mError:\033[0m Incompatible types: got \"Integer\" expected \"string\"\n", yylineno, charCount-yyleng ) ;
											}
										}
									}
									curVarType = 0 ;
								}
	;
	
ifstmt
	: if lp exp rp then body
	// | T_IF LP exp RP T_THEN body T_ELSE body {printf("abc\n");}
	| LP exp RP then { iscorrectgrammer = 0 ; printf( "Line %d, at char %d, \033[0;31mFatal:\033[0m Syntax error, \";\" expected but \"then\" found\n", yylineno, charCount-4 ) ; } body
	;

exp
	: simpexp
	| exp relop simpexp
	;

relop
	: GT		/*'>'*/
	| LT		/*'<'*/
	| EQUAL		/*'='*/
	| GE		/*">="*/
	| LE		/*"<="*/
	| UNEQUAL	/*"<>"*/
	;
	
simpexp
	: term
	| simpexp PLUS term		/*'+'*/	{ if ( firstExpOp == 'x' ) { streamExpType[0] = streamExpType[1] ; streamExpType[1] = 0 ; } }
	| simpexp MINUS { if ( !left ) { streamExpType[0] = streamExpType[1] ; streamExpType[1] = 0 ; } left = 0 ; } term	/*'-'*/	{ if ( firstExpOp == 'x' ) firstExpOp = '-' ; }
	;

term
	: factor
	| factor MUL factor		/* '*' */ { if ( firstExpOp == 'x' ) { firstExpOp = '*' ; left = 1 ; } }
	| factor DIV factor		/* '/' */ { if ( firstExpOp == 'x' ) { firstExpOp = '/' ; left = 1 ; } }
	| factor T_MOD factor	/* mod */ { if ( firstExpOp == 'x' ) { firstExpOp = 'm' ; left = 1 ; } }
	;
	
factor
	: varid
	| INTVALUE		{ expHas_0ID_1Int_2Real_3String[1] = 1 ;	if ( !streamExpType[0] ) 
																	streamExpType[0] = 1 ;
																else if ( !streamExpType[1] )  
																	streamExpType[1] = 1 ;  }
	| REALVALUE		{ expHas_0ID_1Int_2Real_3String[2] = 1 ; if ( !streamExpType[0] ) 
																	streamExpType[0] = 2 ;
																else if ( !streamExpType[1] )  
																	streamExpType[1] = 2 ; }
	| STRINGVALUE	{ expHas_0ID_1Int_2Real_3String[3] = 1 ; if ( !streamExpType[0] ) 
																	streamExpType[0] = 3 ;
																else if ( !streamExpType[1] )  
																	streamExpType[1] = 3 ; }
	| lp simpexp rp
	;
	
read
	: T_READ lp arg_list rp
	;
	
write
	: T_WRITE lp arg_list rp
	;
	
writeln
	: T_WRITELN
	| T_WRITELN lp arg_list rp
	;
	
for
	: T_FOR index_exp T_DO body
	;
	
index_exp
	: varid ASSIGN simpexp T_TO exp
	;
	
varid
	: id_
	| id_ lb { int i ; for ( i = 0 ; i < 4 ; i++ ) expHas_0ID_1Int_2Real_3String[i] = 0 ; } simpexp rb
								{
									if ( expHas_0ID_1Int_2Real_3String[3] && !expHas_0ID_1Int_2Real_3String[2] && !expHas_0ID_1Int_2Real_3String[1] ) {
										// only string type in expression but wrong varibale type assign
										iscorrectgrammer = 0 ;
										char typeStr[10] ;
										if ( curVarType == 1 )
											strcpy( typeStr, "integer" ) ;
										else if ( curVarType == 2 )
											strcpy( typeStr, "real" ) ;
										else
											strcpy( typeStr, "error" ) ;
										printf( "Line %d, at char %d, \033[0;31mError:\033[0m Incompatible types: got \"String\" expected \"%s\"\n", yylineno, charCount-yyleng, typeStr ) ;
									}
									else if ( expHas_0ID_1Int_2Real_3String[3] ) {
										// has string type with any other type in expression
										if ( expHas_0ID_1Int_2Real_3String[2] ) {
											iscorrectgrammer = 0 ;
											printf( "Line %d, at char %d, \033[0;31mError:\033[0m Operator is not overloaded: \"Double\" + \"String\"\n", yylineno, charCount-yyleng ) ;
										}
										else if ( expHas_0ID_1Int_2Real_3String[1] ) {
											iscorrectgrammer = 0 ;
											printf( "Line %d, at char %d, \033[0;31mError:\033[0m Incompatible types: got \"Integer\" expected \"String\"\n", yylineno, charCount-yyleng ) ;
										}
									}
									else {
										if ( expHas_0ID_1Int_2Real_3String[2] ) {
											iscorrectgrammer = 0 ;
											printf( "Line %d, at char %d, \033[0;31mError:\033[0m Incompatible types: got \"Real\" expected \"Integer\"\n", yylineno, charCount-yyleng ) ;
										}
									}
									int i ;
									for ( i = 0 ; i < 4 ; i++ ) 
										expHas_0ID_1Int_2Real_3String[i] = 0 ;
								}
	;
	
body
	: stmt
	| T_BEGIN stmt_list semi end
	;

%%
int main() {
    yyparse();
    return 0;
}

void InitSymbolTable() {
	symbolTable = ( symbol* )malloc( 10*sizeof( symbol ) ) ;
	sTableUsed = 0 ;
	sTableSize = 10 ;
}
int AddToSymbolTable( symbol s ) {
	/* successful add symbol to table return 1 ;
	 * fail if there is already exist return 0 ;*/
	int i ;
	for ( i = 0 ; i < sTableUsed ; ++i )
		if ( strcmp( s.name, symbolTable[i].name ) == 0 )
			return 0 ;
	if ( sTableUsed == sTableSize ) {
		sTableSize *= 2 ;
		symbolTable = ( symbol* )realloc( symbolTable, sTableSize*sizeof( symbol ) ) ;
	}
	symbolTable[sTableUsed++] = s ;
	// printf( "add to table ( name : \"%s\", type : %d )\n", symbolTable[sTableUsed-1].name, symbolTable[sTableUsed-1].type ) ;
	return 1 ;
}

int IsDefinedSymbol( char n[16] ) {
	int i ;
	for ( i = 0 ; i < sTableUsed ; ++i )
		if ( strcmp( n, symbolTable[i].name ) == 0 )
			return symbolTable[i].type ;
	return 0 ;
}

void yyerror(const char* message) {
    // printf("Error at line : %d\n", yylineno );
}
