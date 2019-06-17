# Credo Envvar
[![Build Status](https://travis-ci.org/kaorism/credo_envvar.svg)](https://travis-ci.org/kaorism/credo_envvar)
[![Hex Version](https://img.shields.io/hexpm/v/credo_envvar.svg)](https://hex.pm/packages/credo_envvar)

Add-on for Credo for checking environment variables that get evaluated at Elixir compile time.
Please see [Credo](https://github.com/rrrene/credo) for usage.


## How does it work? + Disclaimer

This plugin does not guarantee 100% that all environment variables that are evaluated at compile time could be detected.

It just simply check wherever Application.get_env() or System.get_env() have been used outside def or defp.
This will help you screen for most of the cases to make you less worried about environment variables compilation in your app.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `credo_envvar` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
    {:credo_envvar, "~> 0.1.0", only: [:dev, :test], runtime: false}
  ]
end
```
And run:

```
$ mix deps.get
```

## Basic Usage

Add CredoEnvvar check to `.credo.exs` in your project
```
  #
  ## Warnings
  #
  {Credo.Check.Warning.BoolOperationOnSameValues},
  {CredoEnvvar.Check.Warning.EnvironmentVariablesAtCompileTime}, # <- Add here
  {Credo.Check.Warning.ExpensiveEmptyEnumCheck},
  {Credo.Check.Warning.IExPry},

```

To run credo in the current project, just type:

```
$ mix credo
```

### Options

#### Exclusions

You can exclude files or paths with the `excluded_paths` option:

```elixir
{CredoEnvvar.Check.Warning.EnvironmentVariablesAtCompileTime, excluded_paths: ["test/support", "priv"]}
```

## Contributing

1. [Fork it!](http://github.com/kaorism/credo_envvar/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Author

Theesit Konkaew (@kaorism)


## License

CredoEnvvar is released under the MIT License. See the LICENSE file for further
details.
