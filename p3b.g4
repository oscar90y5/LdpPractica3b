grammar p3b;


/* En un programa C hay funciones, variables, macros, comentarios y espacios en blanco */
prog  : (macro | var | funcionDec)*
      ;



/* Codigo variado */

sentenciaSelector : 'if' '(' expresion ')' (bloque | bloqueItem)
                  | 'if' '(' expresion ')' (bloque | bloqueItem) 'else' (bloque | bloqueItem)
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

sentencia         : var
                  | asignacion
                  | funcionCall
                  | sentenciaSalto
                  ;



/* Declaracion de variables */

var               : TIPO ID initVar? (',' ID initVar?)* ';'
                  ;
initVar           : OPERADORASIG DIGS
                  ;

/* Funciones */
/* func: PAL ' '+ tres=PAL ' '* '('params')' ' '* bloque  {System.out.println("funcion: "+$tres.text);} ; */

funcionDec        : ('extern'| 'static')? TIPO? ID '(' params? ')' (bloque | ';')
                  ;

params            : TIPO ID (',' TIPO ID)*
                  ;
args              : ID (',' ID)*
                  ;

funcionCall       : ID '(' args? ')' ';'?
                  ;


/* otros */
expresion         : ID OPERADOREXPR ID
                  | ID
                  ;
asignacion        : ID OPERADORASIG DIGS ';'
                  ;

bloque            : '{' bloqueItem* '}'
                  ;

bloqueItem        : sentenciaSelector
                  | sentenciaIterador
                  | sentencia
                  ;




/* Macros */
macro   : '#' ID ID
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
