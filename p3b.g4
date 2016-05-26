grammar p3b;


/*En un programa C solo puede haber funciones, variables, macros, comentarios y definicion de
 *las funciones.
 */

prog: (func|var|macro|coment|def|'\n')*;


/*Funciones:*/

func: TIPO ' '+ ID ' '* '(' ID ')' ' '* '{'cont'}'  ;

cont: (llamada|var|control|asig|ret|'\n')*;
llamada: ID ' '? '(' ID ')' ' '* ';' ;
ret: 'return' ID ';' ;
asig: ID '=' ID ';' ;
control: ID ' '* '('OPERADOREXPR ')' ' '* '{'cont'}';

/*Variables*/
/*hay que mejorar esto*/
var: TIPO ' ' ID (' '* '=' ' '* ID)? (' '* ',' ID (' '* '=' ' '* ID)? )* ' '* ';';


/*Macros*/
macro: '#' ID ID ;


/*Comentarios*/
/*meter formula de comentarios*/
coment: '/*' ID '*/';


/*Definiciones de funciones*/
def: TIPO ' ' ID ' '* '(' ID ')'';';

/*****************************************************************************************************
 *                                           LEXICO                                                  *
 *****************************************************************************************************/

TIPO                  : ('void')
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
                			| 'struct ' ID
                			;
LET                   :	[a-zA-Z_];
DIG                   :	[0-9];
DIGS                  :	DIG+;
SIGN                  :	'+' | '-';
ID                    :	LET ( LET | DIG )*;
IDLIST                :	ID
                      |	ID ',' IDLIST
                      ;
WS                    :	[ \t\n\r]+ -> skip;
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

