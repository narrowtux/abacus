Terminals '(' ')' '{' '}' newline
  '+' '/' '*' '-' '^'
  word ',' number
  '!' '=>'
  '.' '[' ']'
  '~' '&' '|' '|^' '<<' '>>'
  'and' 'or' 'not' '?' ':'
  '==' '!=' '<=' '>=' '<' '>' nil true false string.
Nonterminals expr statement statements argument arguments function variable variables signed_number lambda block.
Rootsymbol expr.
Right 1100 '=>'.
Unary 1000 '!'.
Right 900 '^'.
Unary 850 'not'.
Unary 800 '~'.
Left 750 '*' '/'.
Left 700 '+' '-'.
Left 600 '<<' '>>'.
Left 590 '==' '!=' '<=' '<' '>=' '>'.
Left 580 '&'.
Left 550 '|^'.
Left 520 '|'.
Left 480 'and'.
Left 420 'or'.
Right 300 '?' ':'.


Unary 100 function.
Unary 20 argument.
Unary 0 variable.

% boolean stuff
expr -> nil : nil.
expr -> true : true.
expr -> false : false.

expr -> expr '==' expr : {'==', [], ['$1', '$3']}.
expr -> expr '!=' expr : {'!=', [], ['$1', '$3']}.
expr -> expr '>=' expr : {'>=', [], ['$1', '$3']}.
expr -> expr '<=' expr : {'<=', [], ['$1', '$3']}.
expr -> expr '<' expr : {'<', [], ['$1', '$3']}.
expr -> expr '>' expr : {'>', [], ['$1', '$3']}.

expr -> expr 'and' expr : {'&&', [], ['$1', '$3']}.
expr -> expr 'or' expr : {'||', [], ['$1', '$3']}.
expr -> 'not' expr : {'not', [], ['$2']}.

expr -> expr '?' expr ':' expr : {ternary_if, '$1', '$3', '$5'}.

% Binary stuff
expr -> '~' expr : {'not', '$2'}.
expr -> expr '&' expr : {'and', '$1', '$3'}.
expr -> expr '|' expr : {'or', '$1', '$3'}.
expr -> expr '|^' expr : {'xor', '$1', '$3'}.
expr -> expr '<<' expr : {shift_left, '$1', '$3'}.
expr -> expr '>>' expr : {shift_right, '$1', '$3'}.

% Math stuff
expr -> expr '^' expr : {power, '$1', '$3'}.
expr -> expr '+' expr : {'+', [], ['$1', '$3']}.
expr -> expr '-' expr : {'-', [], ['$1', '$3']}.
expr -> expr '/' expr : {'/', [], ['$1', '$3']}.
expr -> expr '*' expr : {'*', [], ['$1', '$3']}.
expr -> expr '!' : {factorial, '$1'}.

% Grouping
expr -> '(' expr ')' : '$2'.

% What is an expression
expr -> number : extract_token('$1').
expr -> function : '$1'.
expr -> variables : prepare_variables('$1').
expr -> signed_number : '$1'.

% Support signed numbers
signed_number -> '+' number : extract_token('$2').
signed_number -> '-' number : -extract_token('$2').

% Functions
argument -> expr : '$1'.
arguments -> argument : ['$1'].
arguments -> argument ',' arguments : ['$1' | '$3'].

function -> word '(' ')' : {function, extract_token('$1'), []}.
function -> word '(' arguments ')' : {function, extract_token('$1'), '$3'}.

% Strings
expr -> string : extract_token('$1').

% Lambdas
statement -> expr : '$1'.
statements -> statement newline : ['$1'].
statements -> statement : ['$1'].
statements -> statement newline statements : ['$1' | '$3'].
block -> '{' statements '}' : {do, [], '$2'}.
lambda -> '(' arguments ')' '=>' block : {'=>', [], [extract_token('$2'), '$5']}.
expr -> lambda : '$1'.

% Access
variable -> word : {variable, extract_token('$1')}.

variables -> variable : var('$1').
variables -> variables '.' variable : {'.', [], ['$1', '$3']}.
variables -> variables '[' expr ']' : {'.', [], ['$1', '$3']}.

Erlang code. 

extract_token({_Token, _Line, Value}) -> Value.

var({variable, Name}) -> 
  Variables = 'Elixir.Process':get(variables, maps:new()),
  Symbol = case maps:get(Name, Variables, nil) of
    nil -> 
      Len = maps:size(Variables),
      LenS = integer_to_binary(Len),
      SymbolGen = binary_to_atom(<<"var", LenS/binary>>, utf8),
      UpdatedVariables = maps:put(Name, SymbolGen, Variables),
      'Elixir.Process':put(variables, UpdatedVariables),
      SymbolGen;
    S -> S
  end,
  {Symbol, [], 'nil'}.

prepare_variables({'.', Ctx, [Lhs, {variable, Name}]}) ->
  get_in(Ctx, [prepare_variables(Lhs), Name]);
prepare_variables({'.', Ctx, [Lhs, Expr]}) ->
  get_in(Ctx, [prepare_variables(Lhs), Expr]);
prepare_variables(Diff) ->
  Diff.

get_in(Ctx, Args) ->
  {{'.', [], 
    [{'__aliases__', [{alias, false}], ['Abacus', 'Runtime', 'Scope']}, get_in]}, Ctx, Args}.