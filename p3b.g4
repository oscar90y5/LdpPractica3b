grammar p3b;

@header {
				import java.io.BufferedWriter;
				import java.io.FileWriter;
				import java.io.IOException;
				import java.util.ArrayList;
				}

@parser::members {
									private static ArrayList funciones = new ArrayList();
									private static ArrayList<String> globVar = new ArrayList<String>();
									private static ArrayList<ArrayList<String>> llamadas = new ArrayList<ArrayList<String>>();
									private static ArrayList<ArrayList<String>> variables = new ArrayList<ArrayList<String>>();
									private static int funcionActual = 0;
									private final static String NOMBRE_FICHERO = "salida";

									/**
									 * Realiza la escritura del fichero de salida.
									 */
									public static void salidaFichero() {
												BufferedWriter bw = null;
												try {
														bw = new BufferedWriter(new FileWriter(NOMBRE_FICHERO));
														int i, j;
														bw.write("Variables globales:\n");
														for (i = 0; i < globVar.size(); i++) {
																bw.write("\t" + globVar.get(i)+"\n");
														}
														for (i = 0; i < funciones.size(); i++) {
																bw.write("\nFuncion: " + funciones.get(i)+"\n");
																bw.write("\tLlamadas a funciones: " + llamadas.get(i).size()+"\n");
																for (j = 0; j < llamadas.get(i).size(); j++) {
																		bw.write("\t\t" + llamadas.get(i).get(j)+"\n");
																}
																bw.write("\tVariables locales: " + variables.get(i).size()+"\n");
																for (j = 0; j < variables.get(i).size(); j++) {
																		bw.write("\t\t" + variables.get(i).get(j)+"\n");
																}
														}
												} catch (IOException ex) {
														System.err.println("Error al crear fichero de salida.");
												} finally {
														try {
																bw.close();
														} catch (IOException ex) {
																System.err.println("Error al crear fichero de salida.");
														}
												}
										}
										//Fin
									}

/* Simbolo incial de la gramatica: prog */
prog
@after {
				salidaFichero();
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
var               : TIPO id=ID initVar?
																				{
																					if (funcionActual == 0) {
																							globVar.add($id.text);
																					} else {
																							variables.get(funcionActual - 1).add($id.text);
																					}
																				}
										(',' id=ID initVar?
																				{
																					if (funcionActual == 0) {
																	            globVar.add($id.text);
																	        } else {
																	            variables.get(funcionActual - 1).add($id.text);
																	        }
																				}
										)* ';'
                  ;
initVar           : OPERADORASIG valor
                  ;


/* Funciones */
funcionDec        : ('extern'| 'static')? TIPO? id=ID '(' params? ')' {
																																				if (funciones.contains($id.text)) {
																																						funcionActual = funciones.indexOf($id.text) + 1;
																																				} else {
																																						llamadas.add(new ArrayList<String>());
																																						variables.add(new ArrayList<String>());
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
macro			: '#' ID ID
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
STR	       	:	[a-zA-Z_]+;
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
OPERADOR	: '&' | '&&'
 		| '|' | '||'
		| '+' | '++'
		| '-' | '--'
		| '*' | '/'
		| '~' | '!'
		| '^'
		;
