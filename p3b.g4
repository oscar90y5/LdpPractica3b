grammar p3b;


/ *En un programa C hay funciones, variables, macros, comentarios y espacios en blanco */
prog  : ( funcionDec | var | macro | coment | ws)*
      ;


coment            : bcoment
                  | lcoment
                  ;
expresion         : id ['<''>''==''!=''<=''>='] id
                  | id
                  ;
asignacion        : id operadorAsig id ';'
                  ;


/* Funciones */
/* func: PAL ' '+ tres=PAL ' '* '('params')' ' '* bloque  {System.out.println("funcion: "+$tres.text);} ; */

funcionDec        : funcionProto ';'
                  | funcionProto bloque
                  ;
funcionProto      : ('extern'| 'static')? ' ' tipo id '(' params ')'
                  ;
funcionCall       : id '(' args ')' ';'
                  ;

params            : tipo id
                  | tipo id (',' params)*
                  ;
args              : idList
                  ;

/* Declaracion de variables */

var               : varDec var ';'
                  | varDef var ';'
                  ;
varDec            : tipo id (',' tipo id)*
                  | tipo idList
                  ;
varDef            : tipo id initVar (',' tipo id initVar)*
                  | tipo id initVar (',' id initVar)*
                  ;
initVar           : operadorAsig id
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
                  | setenciaSalto
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

sentenciaSalto    : 'goto' id ';'
                  | 'continue' ';'
                  | 'break' ';'
                  | 'return' expresion? ';'
                  ;

/* Macros */

macro   : '#' id ' ' id
        ;



/******************************************************************************************
*                                        Lexico                                           *
******************************************************************************************/

PAL                   : [a-zA-Z]+;
let                   :	[a-zA-Z_];
dig                   :	[0-9];
digs                  :	dig+;
sign                  :	'+' | '-';
id                    :	let ( let | dig )*;
idList                :	id
                      |	idList ',' id
                      ;
ws                    :	[ \t\n\r]+ -> skip;
bcoment               :	'/*' .*? '*/' -> skip;
lcoment               :	'//' ~[\r\n]* -> skip;

operadorAsig          : '=' | '*='
                      | '/='| '%='
                      | '+='| '-='
                      | '<<='| '>>=''
                      | '&=' | '^='
                      | '|='
                      ;

tipo                  : 'void'
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
                			| id
                			;
