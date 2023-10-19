grammar ICSS;

//--- LEXER: ---

// IF support:
IF: 'if';
ELSE: 'else';
BOX_BRACKET_OPEN: '[';
BOX_BRACKET_CLOSE: ']';


//Literals
TRUE: 'TRUE';
FALSE: 'FALSE';
PIXELSIZE: [0-9]+ 'px';
PERCENTAGE: [0-9]+ '%';
SCALAR: [0-9]+;


//Color value takes precedence over id idents
COLOR: '#' [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f];

//Specific identifiers for id's and css classes
ID_IDENT: '#' [a-z0-9\-]+;
CLASS_IDENT: '.' [a-z0-9\-]+;

//General identifiers
LOWER_IDENT: [a-z] [a-z0-9\-]*;
CAPITAL_IDENT: [A-Z] [A-Za-z0-9_]*;

//All whitespace is skipped
WS: [ \t\r\n]+ -> skip;

//
OPEN_BRACE: '{';
CLOSE_BRACE: '}';
SEMICOLON: ';';
COMMA: ',';
COLON: ':';
PLUS: '+';
MIN: '-';
MUL: '*';
DIV: '/';
ASSIGNMENT_OPERATOR: ':=';




//--- PARSER: ---

//Een ICSS bestand heeft een styleRule (sterk geïnspireerd door CSS)
stylesheet: styleRule* EOF;

//styleRule: syntax van styles wordt gedefinieerd.
//Syntax: [selector] { [property] : [value] }
styleRule
    : selector OPEN_BRACE body CLOSE_BRACE;

declaration
    : propertyName COLON value SEMICOLON;
propertyName
    : LOWER_IDENT;


//Een waarde kan een literal zijn, maar kan ook vermenigvuldigt, gedeelt, opgeteld en vermindert worden.
value
    : literal
    | value (MUL | DIV) value
    | value (PLUS | MIN) value;


//Literals
boolLiteral
    : TRUE | FALSE;
colorLiteral
    : COLOR;
percentageLiteral
    : PERCENTAGE;
pixelLiteral
    : PIXELSIZE;
scalarLiteral
    : SCALAR;

//Een literal kan een boolean, kleur, percentage, pixelsize of een scalar zijn.
literal
    : boolLiteral
    | colorLiteral
    | percentageLiteral
    | pixelLiteral
    | scalarLiteral;

//Selectors
classSelector
    : CLASS_IDENT;
tagSelector
    : LOWER_IDENT;
idSelector
    : ID_IDENT | COLOR;

selector: (tagSelector | classSelector | idSelector) (COMMA selector)*;


body: (declaration)*;
