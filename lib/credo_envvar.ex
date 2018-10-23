defmodule CredoEnvvar do
  @moduledoc false

  @version Mix.Project.config()[:version]

  def version, do: @version
end
