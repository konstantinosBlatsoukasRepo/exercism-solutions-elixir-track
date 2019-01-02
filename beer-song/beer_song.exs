defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    get_verse_of(number)
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range) do
    range
    |> Enum.map_join("\n", &(get_verse_of(&1)))
  end

  def lyrics(), do: lyrics(99..00)

  defp get_verse_of(0), do: "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, #{total_bottles(99)} of beer on the wall.\n"
  defp get_verse_of(1), do: "#{total_bottles(1)} of beer on the wall, #{total_bottles(1)} of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n"
    
  defp get_verse_of(number) do   
    bottles_left = number - 1  
    
    "#{total_bottles(number)} of beer on the wall, #{total_bottles(number)} of beer.\nTake one down and pass it around, #{total_bottles(bottles_left)} of beer on the wall.\n"    
  end

  defp total_bottles(1), do: "1 bottle"
  defp total_bottles(total), do: "#{total} bottles"
  
end
