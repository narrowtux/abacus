# Abacus

A parser for mathematical expressions.

https://hex.pm/packages/abacus

## Usage

`Abacus.eval(expression, scope)`

Parses and evaluates the given expression. Variables can be supplied as a map of
binaries in the `scope`.

#### Examples

```elixir
iex> Abacus.eval("1 + 1")
{:ok, 2}
iex> Abacus.eval("sin(floor(3 + 2.5)) / 3")
{:ok, -0.3196414248877128}
iex> Abacus.eval("a * b", %{"a" => 10, "b" => 10})
{:ok, 100}
```

`Abacus.parse(expression)`

Parses the expression and returns the syntax tree.

### Features

An incomplete list of supported and planned features

 - [x] basic operators (`+`, `-`, `*`, `/`, `^`)
 - [ ] bitwise operators ('|', '&', '>>', '<<', etc.)
 - [x] support for functions
   - [x] trigonometric functions(`sin`, `cos`, `tan`)
   - [x] floating point manipulation(`ceil`, `floor`, `round`)
 - [x] support for variables
 - [ ] support for parsing units
 - [ ] support for converting units

## Installation

  1. Add `abacus` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:abacus, "~> 0.1.0"}]
    end
    ```

  2. Ensure `abacus` is started before your application:

    ```elixir
    def application do
      [applications: [:abacus]]
    end
    ```
