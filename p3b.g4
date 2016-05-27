grammar p3b2;

@header {
				import java.util.ArrayList;
				}

@parser::members {
									ArrayList funciones = new ArrayList();
									ArrayList<ArrayList<String>> llamadas = new ArrayList<ArrayList<String>>();
									int funcionActual = 0;
									}

/* Simbolo incial de la gramatica: prog */
prog
@after {
				for (int i = 0; i < funciones.size(); i++) {
						System.out.println("\nFuncion: " + funciones.get(i));
						System.out.println("\tLlamadas a funciones: " + llamadas.get(i).size());
						for (int j = 0; j < llamadas.get(i).size(); j++) {
								System.out.println("\t\t" + llamadas.get(i).get(j));
						}
				}
			 }
			 : (macro | var | funcionDec)*
       ;


/* Codigo de control */

sentenciaSelector : 'if' '(' (expresion | funcionCall) ')' (bloque | bloqueItem)
                  | 'if' '(' (expresion | funcionCall) ')' (bloque | bloqueItem) 'else' (bloque | bloqueItem)
                  | 'switch' '(' (expresion | funcionCall) ')' bloque
                  ;
sentenciaIterador : 'while' '(' expresion ')' (bloque | bloqueItem)
                  | 'do' (bloque | bloqueItem) 'while' '(' expresion ')' ';'
									| 'for' '(' ';' ';' ')' (bloque | bloqueItem)
                  | 'for' '(' (var | asignacion | expresion ';'| funcionCall)?  (asignacion | expresion ';'| funcionCall)?  (asignacion | expresion ';'| funcionCall)?? ')' (bloque | bloqueItem)
                  ;
sentenciaSalto    : 'goto' expresion ';'
                  | 'continue' ';'
                  | 'break' ';'
                  | 'return' expresion? ';'
                  ;
sentencia         : var
                  | asignacion
									| expresion
                  | funcionCall
                  | sentenciaSalto
                  ;


/* Variables */
var               : TIPO ID initVar? (',' ID initVar?)* ';'
                  ;
initVar           : OPERADORASIG DIGS
                  ;


/* Funciones */
funcionDec        : ('extern'| 'static')? TIPO? id=ID '(' params? ')' {
																																			if (funciones.contains($id.text)) {
																																					funcionActual = funciones.indexOf($id.text) + 1;
																																			} else {
																																					llamadas.add(new ArrayList<String>());
																																					funciones.add($id.text);
																																					funcionActual = funciones.size();
																																			}
																																			}
									(bloque | ';')
                  ;
params            : TIPO ID (',' TIPO ID)*
                  ;
args              : expresion (',' expresion)*
                  ;
funcionCall       : id=ID {
													 llamadas.get(funcionActual-1).add($id.text);
													}
									'(' args? ')' ';'?
                  ;


/* Asignacion y Expresion */
asignacion        : ID OPERADORASIG expresion ';'?
									| ID OPERADOR ';'?
                  ;
expresion         : valor OPERADOREXPR expresion
									| valor OPERADOR expresion
                  | valor
                  ;
valor             : ID
                  | funcionCall
									| DIG
                  | DIGS
                  | FRAC
                  | FLOAT
									| LET
									| STR
                  ;

/* Bloques de codigo */
bloque            : '{' bloqueItem* '}'
                  ;
bloqueItem        : sentenciaSelector
                  | sentenciaIterador
                  | sentencia
                  ;


/* Macros */
macro				: '#' ID ID
        		;



/*******************************************************************************
*                                  Lexico                                      *
*******************************************************************************/

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
FRAC                  : [.][0-9]+;
FLOAT                 : [0-9]+([.][0-9]+)?;
STR										:	[a-zA-Z_]+;
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
OPERADOR							: '&' | '&&'
 											| '|' | '||'
											| '+' | '++'
											| '-' | '--'
											| '*' | '/'
											| '~' | '!'
											| '^'
											;
