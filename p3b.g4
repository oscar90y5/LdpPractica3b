grammar p3b;


/* En un programa C hay funciones, variables, macros, comentarios y espacios en blanco */
prog  : (macro | var | funcionDec)*
      ;

expresion         : ID OPERADOREXPR ID
                  | ID
                  ;
asignacion        : ID OPERADORASIG DIGS ';'
                  ;

/* Macros */
macro   : '#' ID ID
        ;


/* Declaracion de variables */

var               : TIPO ID initVar? (',' ID initVar?)* ';'
                  ;
initVar           : OPERADORASIG DIGS
                  ;

/* Funciones */
/* func: PAL ' '+ tres=PAL ' '* '('params')' ' '* bloque  {System.out.println("funcion: "+$tres.text);} ; */

funcionDec        : funcionProto ';'
                  | funcionDef
                  ;
funcionDef        : funcionProto bloque
                  ;
funcionProto      : ('extern'| 'static')? TIPO? ID '(' params? ')' ';'
                  ;

params            : TIPO ID (',' TIPO ID)*
                  ;
args              : ID (',' ID)*
                  ;

funcionCall       : ID '(' args? ')'
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




/******************************************************************************************
*                                        Lexico                                           *
******************************************************************************************/

TIPO			        : 'void'
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
			            ;
ID                    :	[a-zA-Z_] ( [a-zA-Z_] | [0-9] )*;
DIGS                  :	[0-9]+;
LET                   :	[a-zA-Z_];
DIG                   :	[0-9];
SIGN                  :	'+' | '-';

WS                    :	[ \t\n\r]+ -> skip;
BCOMENT               :	'/*' .*? '*/' -> skip;
LCOMENT               :	'//' ~[\r \n]* -> skip;

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
