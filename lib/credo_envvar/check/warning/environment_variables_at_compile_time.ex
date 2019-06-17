defmodule CredoEnvvar.Check.Warning.EnvironmentVariablesAtCompileTime do
  @moduledoc """
  Application.get_env() or  System.get_env() should not appear outside def or defp.
  Since it might be compiled at build time in local or CI. Your production may use wrong ENV variables
  """

  @explanation [check: @moduledoc]
  @get_env_ops_fun [{:Application, :get_env}, {:System, :get_env}]
  @ops [:def, :defp, :defmodule]

  alias Credo.Code.Block

  use Credo.Check, base_priority: :high

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    excluded_paths = Keyword.get(params, :excluded_paths, [])

    source_file.filename
    |> String.starts_with?(excluded_paths)
    |> if do
      []
    else
      Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
    end
  end

  defp traverse({:defmodule, _, _} = ast, issues, issue_meta) do
    ast
    |> Block.do_block_for!()
    |> find_environment_vars_getter(issues, issue_meta)
  end

  defp traverse(ast, issues, _source_file), do: {ast, issues}

  defp find_environment_vars_getter(ast, issues, issue_meta) do
    {ast, Credo.Code.prewalk(ast, &traverse_inside_defmodule(&1, &2, issue_meta)) ++ issues}
  end

  for {ops, fun} <- @get_env_ops_fun do
    defp traverse_inside_defmodule(
           {:., meta, [{:__aliases__, _meta, [unquote(ops)]}, unquote(fun)]} = ast,
           issues,
           issue_meta
         ) do
      {ast, issues ++ [issue_for(issue_meta, meta[:line], "#{unquote(ops)}.#{unquote(fun)}")]}
    end
  end

  defp traverse_inside_defmodule({:defmodule, _, _} = ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp traverse_inside_defmodule(ast, issues, _issue_meta) do
    filtered_ast = filter_out_ops(ast, [])

    {filtered_ast, issues}
  end

  for ops <- @ops do
    def filter_out_ops([{unquote(ops), _, _} | tail], acc),
      do: filter_out_ops(tail, acc)

    def filter_out_ops({unquote(ops), _, _}, acc), do: acc
  end

  def filter_out_ops({:__block__, _, ast}, acc), do: filter_out_ops(ast, acc)
  def filter_out_ops([head | tail], acc), do: filter_out_ops(tail, [head | acc])
  def filter_out_ops([], acc), do: acc
  def filter_out_ops(ast, _acc), do: ast

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue(
      issue_meta,
      message: "Environment variables should not be evaluated at compile time",
      trigger: trigger,
      line_no: line_no
    )
  end
end
