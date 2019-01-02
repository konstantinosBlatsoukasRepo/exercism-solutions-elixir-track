defmodule Roman do
  @numerals %{
    1000 => "M",
    900 => "CM",
    500 => "D",
    400 => "CD",
    100 => "C",
    90 => "XC",
    50 => "L",
    40 => "XL",
    10 => "X",
    9 => "IX",
    5 => "V",
    4 => "IV",
    1 => "I"
  }

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    transform_to_roman("", number)
  end

  defguard is_positive(number, value) when number - value >= 0

  defp transform_to_roman(roman, number) when is_positive(number, 1000),
    do: Map.get(@numerals, 1000) <> transform_to_roman(roman, number - 1000)

  defp transform_to_roman(roman, number) when is_positive(number, 900),
    do: Map.get(@numerals, 900) <> transform_to_roman(roman, number - 900)

  defp transform_to_roman(roman, number) when is_positive(number, 500),
    do: Map.get(@numerals, 500) <> transform_to_roman(roman, number - 500)

  defp transform_to_roman(roman, number) when is_positive(number, 400),
    do: Map.get(@numerals, 400) <> transform_to_roman(roman, number - 400)

  defp transform_to_roman(roman, number) when is_positive(number, 100),
    do: Map.get(@numerals, 100) <> transform_to_roman(roman, number - 100)

  defp transform_to_roman(roman, number) when is_positive(number, 90),
    do: Map.get(@numerals, 90) <> transform_to_roman(roman, number - 90)

  defp transform_to_roman(roman, number) when is_positive(number, 50),
    do: Map.get(@numerals, 50) <> transform_to_roman(roman, number - 50)

  defp transform_to_roman(roman, number) when is_positive(number, 40),
    do: Map.get(@numerals, 40) <> transform_to_roman(roman, number - 40)

  defp transform_to_roman(roman, number) when is_positive(number, 10),
    do: Map.get(@numerals, 10) <> transform_to_roman(roman, number - 10)

  defp transform_to_roman(roman, number) when is_positive(number, 9),
    do: Map.get(@numerals, 9) <> transform_to_roman(roman, number - 9)

  defp transform_to_roman(roman, number) when is_positive(number, 5),
    do: Map.get(@numerals, 5) <> transform_to_roman(roman, number - 5)

  defp transform_to_roman(roman, number) when is_positive(number, 4),
    do: Map.get(@numerals, 4) <> transform_to_roman(roman, number - 4)

  defp transform_to_roman(roman, number) when is_positive(number, 1),
    do: Map.get(@numerals, 1) <> transform_to_roman(roman, number - 1)

  defp transform_to_roman(roman, _), do: roman
end
