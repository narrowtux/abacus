Terminals '(' ')' '+' '/' '*' '-' '^' word ',' number '!'.
Nonterminals expr argument arguments function variable signed_number.
Rootsymbol expr.
Right 1000 '^'.
Unary 300 '!'.
Left 220 '*' '/'.
Left 200 '+' '-'.
Unary 100 function.
Unary 0 variable.

expr -> expr '^' expr : {power, '$1', '$3'}.
expr -> expr '+' expr : {add, '$1', '$3'}.
expr -> expr '-' expr : {subtract, '$1', '$3'}.
expr -> expr '/' expr : {divide, '$1', '$3'}.
expr -> expr '*' expr : {multiply, '$1', '$3'}.
expr -> '!' expr : {factorial, '$2'}.
expr -> '(' expr ')' : '$2'.
expr -> number : extract_token('$1').
expr -> function : '$1'.
expr -> variable : '$1'.
expr -> signed_number : '$1'.

signed_number -> '+' number : extract_token('$2').
signed_number -> '-' number : -extract_token('$2').

argument -> expr : '$1'.
variable -> word : {variable, extract_token('$1')}.

arguments -> argument : ['$1'].
arguments -> argument ',' arguments : ['$1' | '$3'].

function -> word '(' ')' : {function, extract_token('$1'), []}.
function -> word '(' arguments ')' : {function, extract_token('$1'), '$3'}.

Erlang code.
extract_token({_Token, _Line, Value}) -> Value.
