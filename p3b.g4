grammar p3b;

/*En un programa C solo puede haber funciones, variables, macros, comentarios y definicion de
 *las funciones.
 */

prog: (func|var|macro|coment|def)*;

/*Funciones:*/
func: PAL ' ' PAL ' '? '('PAL ')' '{' '\n';
esp: '/t'
	|' '
	|'\n';
PAL: [a-zA-Z]+;

/*Variables*/
/*Macros*/
/*Comentarios*/
/*Definiciones de funciones*/

