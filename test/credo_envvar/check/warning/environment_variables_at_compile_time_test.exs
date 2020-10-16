defmodule CredoEnvvar.Check.Warning.EnvironmentVariablesAtCompileTimeTest do
  use Credo.Test.Case

  @described_check CredoEnvvar.Check.Warning.EnvironmentVariablesAtCompileTime

  test "it should NOT report expected code" do
    """
    defmodule CredoSampleModule do
       @some_variable 1

       def some_function1(param1) do
       end

       def some_function2, do: nil

       defp some_function3(param1, param2) do
       end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should NOT report expected code when there is only 1 def in the block" do
    """
    defmodule CredoSampleModule do
      def some_foobar(foo) do
        Application.get_env(:param1, :param2)
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should NOT report expected code when there is only 1 defp in the block" do
    """
    defmodule CredoSampleModule do
      defp some_private_foobar do
        Application.get_env(:param1, :param2)
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should NOT report expected code when it is in a nested module" do
    """
    defmodule CredoSampleModule do
      defmodule Foo do
        defmodule Bar do
          def some_foobar do
            Application.get_env(:param1, :param2)
          end
        end
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should NOT report expected code when there are get env vars inside def" do
    """
    defmodule CredoSampleModule do
      def some_foobar, do: Application.get_env(:foo, :bar)
      defp some_private_foobar, do: Application.get_env(:param1, :param2)
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should report expected code when assigns env var to module attribute with Application.get_env" do
    """
    defmodule credosamplemodule do
      @compile_param Application.get_env(:param1, :param2)
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report not expected code if path is in excluded_paths" do
    """
    defmodule credosamplemodule do
      @compile_param Application.get_env(:param1, :param2)
    end
    """
    |> to_source_file()
    |> run_check(@described_check, excluded_paths: ["test-untitled"])
    |> refute_issues()
  end

  test "it should report expected code when assigns env var to module attribute with Application.get_env in nested module" do
    """
    defmodule credosamplemodule do
      defmodule nestedmodule do
        @compile_param Application.get_env(:param1, :param2)
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report expected code when assigns env var to module attribute with Application.get_env in nested siblings module" do
    """
    defmodule credosamplemodule do
      defmodule nestedmodule do
        def foobar do 
          Application.get_env(:param1, :param2)
        end
      end

      defmodule nestedmodule_compile do
        @compile_param Application.get_env(:param1, :param2)
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report expected code when env var is accessed outside def with Application.get_env" do
    """
    defmodule CredoSample.Router do
      pipeline :foo do
        plug(SamplePlug, Application.get_env(:foo, :bar))
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report expected code when assigns env var to module attribute with System.get_env" do
    """
    defmodule CredoSampleModule do
      @compile_var System.get_env(:param1, :param2)
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report expected code when env var is accessed outside def with System.get_env" do
    """
    defmodule CredoSample.Router do
      pipeline :foo do
        plug(SamplePlug, System.get_env(:foo, :bar))
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report expected code when assigns env var to module attribute with System.get_env and nested defmodule" do
    """
    defmodule CredoSampleModule do
      @compile_var System.get_env(:param1, :param2)

      defmodule nested do
      end
    end
    """
    |> to_source_file()
    |> run_check(@described_check)
    |> assert_issue()
  end
end
