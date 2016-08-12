Definitions.

FLOAT = [0-9]+\.[0-9]*
INTEGER = [0-9]+
P_OPEN = \(
P_CLOSE = \)
WORD = [a-zA-Z_][a-zA-Z0-9_\-]*

PLUS = \+
MINUS = \-
DIVIDE = \/
MULTIPLY = \*
POWER = \^

COMMA = ,

SIGN = (\-|\+)

WHITESPACE = [\s\t\n\r]

Rules.
{INTEGER}    : {token, {number, TokenLine, list_to_integer(TokenChars)}}.
{FLOAT}      : {token, {number, TokenLine, list_to_float(TokenChars)}}.
{P_OPEN}    : {token, {'(', TokenLine}}.
{P_CLOSE}   : {token, {')', TokenLine}}.
{PLUS}   : {token, {'+', TokenLine}}.
{MINUS}  : {token, {'-', TokenLine}}.
{DIVIDE} : {token, {'/', TokenLine}}.
{MULTIPLY} : {token, {'*', TokenLine}}.
{POWER} : {token, {'^', TokenLine}}.
{WORD}  : {token, {word, TokenLine, list_to_binary(TokenChars)}}.
{WHITESPACE}+ : skip_token.
{COMMA} : {token, {',', TokenLine}}.

Erlang code.
