Terminals '(' ')' number '+' '/' '*' '-' '^' word ','.
Nonterminals expr argument arguments function.
Rootsymbol expr.
Right 1000 '^'.
Left 200 '+' '-' '*' '/'.

expr -> expr '^' expr : {power, '$1', '$3'}.
expr -> expr '+' expr : {add, '$1', '$3'}.
expr -> expr '-' expr : {subtract, '$1', '$3'}.
expr -> expr '/' expr : {divide, '$1', '$3'}.
expr -> expr '*' expr : {multiply, '$1', '$3'}.
expr -> '(' expr ')' : '$2'.
expr -> number : extract_token('$1').
expr -> function : '$1'.

argument -> expr : '$1'.

arguments -> argument : ['$1'].
arguments -> argument ',' arguments : ['$1' | '$3'].

function -> word '(' ')' : {function, extract_token('$1'), []}.
function -> word '(' arguments ')' : {function, extract_token('$1'), '$3'}.

Erlang code.
extract_token({_Token, _Line, Value}) -> Value.
