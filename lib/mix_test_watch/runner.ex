defmodule MixTestWatch.Runner do
  @moduledoc false

  alias MixTestWatch.Config

  #
  # Behaviour specification
  #

  @callback run(Config.t()) :: :ok

  #
  # Public API
  #

  @doc """
  Run tests using the runner from the config.
  """
  def run(%Config{} = config) do
    :ok = maybe_clear_terminal(config)
    IO.puts("\nRunning tests...")
    :ok = maybe_print_timestamp(config)
    :ok = config.runner.run(config)
    :ok
  end

  @doc """
  ANSI escape character to erase scroll-back from terminal.
  """
  @spec ansi_erase_scrollback() :: String.t()
  def ansi_erase_scrollback() do
    "\e[3J"
  end

  #
  # Internal functions
  #

  defp maybe_clear_terminal(%{clear: false}), do: :ok
  defp maybe_clear_terminal(%{clear: true}), do: :ok = real_clear_screen()

  defp maybe_print_timestamp(%{timestamp: false}), do: :ok

  defp maybe_print_timestamp(%{timestamp: true}) do
    :ok =
      DateTime.utc_now()
      |> DateTime.to_string()
      |> IO.puts()
  end

  defp real_clear_screen() do
    (IO.ANSI.home() <> IO.ANSI.clear() <> ansi_erase_scrollback())
    |> IO.puts()
  end
end
