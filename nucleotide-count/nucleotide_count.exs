defmodule NucleotideCount do
  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) do
    Enum.reduce(strand, 0, fn x, acc -> if x == nucleotide, do: acc + 1, else: acc end)
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([char]) :: map
  def histogram(strand) do
    Enum.reduce(strand, %{?A => 0, ?T => 0, ?C => 0, ?G => 0}, fn
      ?A, acc -> Map.put(acc, ?A, Map.get(acc, ?A) + 1)
      ?T, acc -> Map.put(acc, ?T, Map.get(acc, ?T) + 1)
      ?C, acc -> Map.put(acc, ?C, Map.get(acc, ?C) + 1)
      ?G, acc -> Map.put(acc, ?G, Map.get(acc, ?G) + 1)
    end)
  end
end
