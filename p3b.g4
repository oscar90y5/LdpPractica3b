grammar p3b;


/* En un programa C hay funciones, variables, macros, comentarios y espacios en blanco */
prog  : ( funcionDec | var | macro | coment | WS)*
      ;


coment            : BCOMENT
                  | LCOMENT
                  ;
expresion         : ID OPERADOREXPR ID
                  | ID
                  ;
asignacion        : ID OPERADORASIG ID ';'
                  ;


/* Funciones */
/* func: PAL ' '+ tres=PAL ' '* '('params')' ' '* bloque  {System.out.println("funcion: "+$tres.text);} ; */

funcionDec        : funcionProto ';'
                  | funcionProto bloque
                  ;
funcionProto      : ('extern'| 'static')? ' ' TIPO ID '(' params ')'
                  ;
funcionCall       : ID '(' args ')' ';'
                  ;

params            : TIPO ID
                  | TIPO ID (',' params)*
                  ;
args              : IDLIST
                  ;

/* Declaracion de variables */

var               : varDec var ';'
                  | varDef var ';'
                  ;
varDec            : TIPO ID (',' TIPO ID)*
                  | TIPO IDLIST
                  ;
varDef            : TIPO ID initVar (',' TIPO ID initVar)*
                  | TIPO ID initVar (',' ID initVar)*
                  ;
initVar           : OPERADORASIG ID
                  ;


/* Codigo variado */
bloque            : '{' bloqueItem* '}'
                  ;

bloqueItem        : sentencia
                  | sentenciaSelector
                  | sentenciaIterador
                  ;
sentencia         : var
                  | asignacion
                  | funcionCall
                  | sentenciaSalto
                  ;

sentenciaSelector : 'if' '(' expresion ')' bloque
                  | 'if' '(' expresion ')' bloque 'else' bloque
                  | 'if' '(' expresion ')' bloque 'else' sentenciaSelector
                  | 'switch' '(' expresion ')' bloque
                  ;
sentenciaIterador : 'while' '(' expresion ')' bloque
                  | 'do' bloque 'while' '(' expresion ')' ';'
                  | 'for' '(' expresion? ';' expresion? ';' expresion? ')' bloque
                  ;

sentenciaSalto    : 'goto' ID ';'
                  | 'continue' ';'
                  | 'break' ';'
                  | 'return' expresion? ';'
                  ;

/* Macros */

macro   : '#' ID ' ' ID
        ;



/******************************************************************************************
*                                        Lexico                                           *
******************************************************************************************/

PAL                   : [a-zA-Z]+;
LET                   :	[a-zA-Z_];
DIG                   :	[0-9];
DIGS                  :	DIG+;
SIGN                  :	'+' | '-';
ID                    :	LET ( LET | DIG )*;
IDLIST                :	ID
                      |	ID ',' IDLIST
                      ;
WS                    :	[ \t\n\r]+ -> skip;
BCOMENT               :	'/*' .*? '*/' -> skip;
LCOMENT               :	'//' ~[\r\n]* -> skip;

OPERADORASIG          : '=' | '*='
                      | '/='| '%='
                      | '+='| '-='
                      | '<<='| '>>='
                      | '&=' | '^='
                      | '|='
                      ;
OPERADOREXPR          : '<' | '>'
                      | '==' | '!='
                      | '<=' | '>='
                      ;

TIPO                  : 'void'
                			| 'char'
                			| 'short'
                			| 'int'
                			| 'long'
                			| 'float'
                			| 'double'
                			| 'signed'
                			| 'unsigned'
                			| '_Bool'
                			| '_Complex'
                			| ID
                			;
