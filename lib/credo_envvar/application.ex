defmodule CredoEnvvar.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Credo.Service.SourceFileScopes,
      Credo.Service.SourceFileAST,
      Credo.Service.SourceFileLines,
      Credo.Service.SourceFileSource
    ]

    opts = [strategy: :one_for_one, name: Credo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
