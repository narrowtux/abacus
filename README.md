# Abacus

## Installation

If [available in Hex](https://hex.pm/abacus), the package can be installed as:

  1. Add `abacus` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:abacus, "~> 0.1.0"}]
    end
    ```

  2. Ensure `math_parser` is started before your application:

    ```elixir
    def application do
      [applications: [:abacus]]
    end
    ```
