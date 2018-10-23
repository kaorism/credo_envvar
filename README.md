# Credo

Add-on for Credo for avoiding environment variables usage at compile time

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `credo_envvar` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
    {:credo_envvar, "~> 0.0.1", only: [:dev, :test], runtime: false}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/credo_envvar](https://hexdocs.pm/credo_envvar).

