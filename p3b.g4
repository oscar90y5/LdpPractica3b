grammar p3b;

/*En un programa C solo puede haber funciones, variables, macros, comentarios y definicion de
 *las funciones.
 */
/*****METEMOS LOS SALTOS DE LINEA EN LAS GRANDES???? prog, cont...*******/
prog: (func|var|macro|coment|def|'\n')*;

/*cosas que valen para todo el programa:*/
PAL: [a-zA-Z]+;


/*Funciones:*/
func: PAL ' ' PAL ' '? '('PAL ')' '{'cont'}';

cont: (llamada|otro|'\n')*;
llamada: PAL ' '? '('PAL')'' '* ';';
otro: ~('\n')+ ;

/*Variables*/
/*hay que mejorar esto*/
var: PAL ' ' PAL ';';


/*Macros*/
macro: '#' PAL PAL ;


/*Comentarios*/
/*meter formula de comentarios*/
coment: '/*' PAL '*/';


/*Definiciones de funciones*/
def: PAL ' ' PAL ' '* '(' PAL ')'';';

