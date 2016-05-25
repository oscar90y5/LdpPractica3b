grammar p3b;


/*En un programa C solo puede haber funciones, variables, macros, comentarios y definicion de
 *las funciones.
 */

prog: (func|var|macro|coment|def|'\n')*;

/*cosas que valen para todo el programa:*/
PAL: [a-zA-Z]+;
EXP: PAL ['<''>''==''!=''<=''>='] PAL ;

/*Funciones:*/
func: PAL ' '+ tres=PAL ' '* '('PAL ')' ' '* '{'cont'}'   {System.out.println("funcion: "+$tres.text);} ;

cont: (llamada|var|control|asig|ret|'\n')*;
llamada: PAL ' '? '(' PAL ')' ' '* ';' ;
ret: 'return' PAL ';' ;
asig: PAL '=' PAL ';' ;
control: PAL ' '* '('EXP ')' ' '* '{'cont'}';

/*Variables*/
/*hay que mejorar esto*/
var: PAL ' ' PAL (' '* '=' ' '* PAL)? (' '* ',' PAL (' '* '=' ' '* PAL)? )* ' '* ';';


/*Macros*/
macro: '#' PAL PAL ;


/*Comentarios*/
/*meter formula de comentarios*/
coment: '/*' PAL '*/';


/*Definiciones de funciones*/
def: PAL ' ' PAL ' '* '(' PAL ')'';';

/*****************************************************************************************************
 *                            LEXICO                                                                 *
 *****************************************************************************************************/
