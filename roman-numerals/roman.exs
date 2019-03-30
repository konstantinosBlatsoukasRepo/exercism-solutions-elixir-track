defmodule Roman do
  @numerals %{
    1 => "I",
    4 => "IV",
    5 => "V",
    9 => "IX",
    10 => "X",
    40 => "XL",
    50 => "L",
    90 => "XC",
    100 => "C",
    400 => "CD",
    500 => "D",
    900 => "CM",
    1000 => "M"
  }

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    transform_to_roman("", number)
  end

  keys =
    Map.keys(@numerals)
    |> Enum.reverse()

  for key <- keys do
    defp transform_to_roman(roman, number) when number - unquote(key) >= 0,
      do: Map.get(@numerals, unquote(key)) <> transform_to_roman(roman, number - unquote(key))
  end

  defp transform_to_roman(roman, _), do: roman
end
