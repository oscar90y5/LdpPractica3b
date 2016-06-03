grammar p3b;

@header {
				import java.io.BufferedWriter;
				import java.io.FileWriter;
				import java.io.IOException;
				import java.util.ArrayList;
				}

@parser::members {
									//Array funciones -> guarda el nombre de todas las funciones definidas.
									private static ArrayList funciones = new ArrayList();

									//Array globVar -> guarda el nombre de todas las variables globales.
									private static ArrayList<String> globVar = new ArrayList<String>();

									//Array llamadas -> guarda un Array por cada funcion definida con todas las llamadas a otras funciones que realiza.
									private static ArrayList<ArrayList<String>> llamadas = new ArrayList<ArrayList<String>>();

									//Array variables -> guarda un Array por cada funcion definida con todas las variables locales.
									private static ArrayList<ArrayList<String>> variables = new ArrayList<ArrayList<String>>();

									//Array param -> guarda un Array por cada funcion definida con todos sus parametros.
									private static ArrayList<ArrayList<String>> param = new ArrayList<ArrayList<String>>();

									//funcionActual -> guarda el numero de la funcion en la que estamos. Este valor se le da por el orden en el que se definen.
									private static int funcionActual = 0;

									// enFuncion -> true si nos encontramos dentro de una funcion.
									private static boolean enFuncion = false;
									private final static String NOMBRE_FICHERO = "salida";

									/**
									 * Realiza la escritura del fichero de salida.
									 */
									public static void salidaFichero() {
												BufferedWriter bw = null;
												try {
														bw = new BufferedWriter(new FileWriter(NOMBRE_FICHERO));
														int i, j;
														bw.write("Variables globales: "+globVar.size()+"\n");
														for (i = 0; i < globVar.size(); i++) {
																bw.write("\t" + globVar.get(i)+"\n");
														}
														for (i = 0; i < funciones.size(); i++) {
																bw.write("\nFuncion: " + funciones.get(i)+"\n");
																bw.write("\tParametros: " + param.get(i).size()+"\n");
																for (j = 0; j < param.get(i).size(); j++) {
																		bw.write("\t\t" + param.get(i).get(j)+"\n");
																}
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
var               : tipo=TIPO id=ID initVar?
																				/*Si no se encuentra en una funcion se añade a la lista de globales,
																				 *sino en la lista de variables locales en la posicion de la funcion actual.
																				 */
																				{
																					if (enFuncion == false) {
																							globVar.add($id.text+" ("+$tipo.text+")");
																					} else {
																								variables.get(funcionActual - 1).add($id.text+" ("+$tipo.text+")");
																					}
																				}
										(',' id=ID initVar?
																				{
																					if (enFuncion == false) {
																	            globVar.add($id.text+" ("+$tipo.text+")");
																	        } else {
																	            variables.get(funcionActual - 1).add($id.text+" ("+$tipo.text+")");
																	        }
																				}
										)* ';'
                  ;
initVar           : OPERADORASIG valor
                  ;


/* Funciones */
funcionDec        : ('extern'| 'static')? TIPO? id=ID  {
																																				if (funciones.contains($id.text)) {
																																						funcionActual = funciones.indexOf($id.text) + 1;
																																				} else {
																																						llamadas.add(new ArrayList<String>());
																																						variables.add(new ArrayList<String>());
																																						param.add(new ArrayList<String>());
																																						funciones.add($id.text);
																																						funcionActual = funciones.size();
																																				}
																																				enFuncion=true;
																																			}
										'(' params? ')'(bloque | ';')  {
																		 enFuncion=false;
																		}
                	;
params            : tipo=TIPO id=ID {
																	param.get(funcionActual-1).add($id.text+" ("+$tipo.text+")");
																}(',' tipo=TIPO id=ID{
																								param.get(funcionActual-1).add($id.text+" ("+$tipo.text+")");
																							})*
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
									| CHAR
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
SIGN                  :	'+' | '-';
STR	       						:	[a-zA-Z_]+ ;
CHAR									: ( [a-zA-Z_] | [0-9] );
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
