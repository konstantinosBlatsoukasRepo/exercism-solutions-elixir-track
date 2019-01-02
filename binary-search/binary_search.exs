defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _), do: :not_found
  def search(numbers, key), do: search(numbers, key, tuple_size(numbers) - 1, 0)

  defp search(numbers, key, high, low) do
    middle = div(high + low, 2)
    mid_value = elem(numbers, middle)
    cond do
      low > high -> :not_found
      key == mid_value -> {:ok, middle}
      key < mid_value -> search(numbers, key, high - 1, low)
      key > mid_value -> search(numbers, key, high, middle + 1)      
    end
  end
end
