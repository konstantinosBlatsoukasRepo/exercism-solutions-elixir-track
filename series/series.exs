defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) when size <=0, do: []
  def slices(s, size), do: slices_helper(s, [], 0, size - 1)

  def slices_helper(s, result, min, max) do
    if max >= String.length(s) do
      result
    else 
      [String.slice(s, min..max)] ++ slices_helper(s, result, min + 1, max + 1)
    end      
  end

end
