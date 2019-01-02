defmodule Acronym do
  @delimiters_regex ~r/[ _\-,!&@%:\p{S}]/
  @capitals_regex ~r/([A-Z][a-z]+)/
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    String.split(string, @delimiters_regex)
    |> Enum.flat_map(&String.split(&1, @capitals_regex, include_captures: true, trim: true))
    |> Enum.map_join(&String.first(&1))
    |> String.upcase()
  end
end
