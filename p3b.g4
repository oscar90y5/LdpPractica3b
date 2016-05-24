grammar p3b;

prog: func+;
func: PAL ' ' PAL ' '? '('PAL ')' '{' '\n';
esp: '/t'
	|' '
	|'\n';
PAL: [a-zA-Z]+;
