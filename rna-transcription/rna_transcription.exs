defmodule RNATranscription do
  @g_to_c %{'G' => 'C'}
  @c_to_g %{'C' => 'G'}
  @t_to_a %{'T' => 'A'}
  @a_to_u %{'A' => 'U'}
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    case dna do
      [head | tail] ->
        transform([head]) ++ to_rna(tail)

      [] ->
        []
    end
  end

  defp transform('G'), do: Map.get(@g_to_c, 'G')
  defp transform('C'), do: Map.get(@c_to_g, 'C')
  defp transform('T'), do: Map.get(@t_to_a, 'T')
  defp transform('A'), do: Map.get(@a_to_u, 'A')
end
