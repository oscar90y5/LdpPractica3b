grammar p3b;

/*En un programa C solo puede haber funciones, variables, macros, comentarios y definicion de
 *las funciones.
 */

prog: (func|var|macro|coment|def)*;

/*cosas que valen para todo el programa:*/
PAL: [a-zA-Z]+;


/*Funciones:*/
func: PAL ' ' PAL ' '? '('PAL ')' '{'cont'}' '\n';
cont: (llamada|otro)*;
llamada: PAL ' '? '('PAL')'' '* ';\n';
otro: ~('\n')* '\n';

/*Variables*/
/*hay que mejorar esto*/
var: PAL ' ' PAL ';\n';


/*Macros*/
macro: '#' PAL PAL '\n';


/*Comentarios*/
/*meter formula de comentarios*/
coment: '/*' PAL '*/';


/*Definiciones de funciones*/
def: PAL ' ' PAL ' '* '(' PAL ')'';\n';
