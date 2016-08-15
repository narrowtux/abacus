Definitions.

FLOAT = [0-9]+\.[0-9]*
INTEGER = [0-9]+
P_OPEN = \(
P_CLOSE = \)
B_OPEN = \[
B_CLOSE = \]
WORD = [a-zA-Z_][a-zA-Z0-9_\-]*

PLUS = \+
MINUS = \-
DIVIDE = \/
MULTIPLY = \*
POWER = \^

FACTORIAL = !

COMMA = ,
DOT = \.

SIGN = (\-|\+)

WHITESPACE = [\s\t\n\r]

Rules.
% reserved words appear up here so they're not eaten by {WORD}
not : {token, {'not', TokenLine}}.
null : {token, {nil, TokenLine}}.
false : {token, {false, TokenLine}}.
true : {token, {true, TokenLine}}.

{INTEGER}    : {token, {number, TokenLine, list_to_integer(TokenChars)}}.
{FLOAT}      : {token, {number, TokenLine, list_to_float(TokenChars)}}.
{P_OPEN}    : {token, {'(', TokenLine}}.
{P_CLOSE}   : {token, {')', TokenLine}}.
{PLUS}   : {token, {'+', TokenLine}}.
{MINUS}  : {token, {'-', TokenLine}}.
{DIVIDE} : {token, {'/', TokenLine}}.
{MULTIPLY} : {token, {'*', TokenLine}}.
{POWER} : {token, {'^', TokenLine}}.
{FACTORIAL} : {token, {'!', TokenLine}}.
{WORD}  : {token, {word, TokenLine, list_to_binary(TokenChars)}}.
{B_OPEN} : {token, {'[', TokenLine}}.
{B_CLOSE} : {token, {']', TokenLine}}.
{DOT} : {token, {'.', TokenLine}}.
& : {token, {'&', TokenLine}}.
\|\^ : {token, {'|^', TokenLine}}.
\| : {token, {'|', TokenLine}}.
>> : {token, {'>>', TokenLine}}.
<< : {token, {'<<', TokenLine}}.
~ : {token, {'~', TokenLine}}.
&& : {token, {'and', TokenLine}}.
\|\| : {token, {'or', TokenLine}}.

\? : {token, {'?', TokenLine}}.
: : {token, {':', TokenLine}}.
!= : {token, {'!=', TokenLine}}.
== : {token, {'==', TokenLine}}.
<= : {token, {'<=', TokenLine}}.
>= : {token, {'>=', TokenLine}}.
<  : {token, {'<', TokenLine}}.
>  : {token, {'>', TokenLine}}.
{WHITESPACE}+ : skip_token.
{COMMA} : {token, {',', TokenLine}}.

Erlang code.
