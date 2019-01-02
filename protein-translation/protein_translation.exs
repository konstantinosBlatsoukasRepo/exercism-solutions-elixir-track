defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    String.codepoints(rna)
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.join(&1))
    |> Enum.map(&of_codon(&1))
    |> get_translation([])
  end

  defp get_translation(answers, proteins) do
    case answers do
      [head | tail] ->
        case head do
          {:ok, "STOP"} -> {:ok, proteins}
          {:ok, protein} -> get_translation(tail, proteins ++ [protein])
          {:error, "invalid codon"} -> {:error, "invalid RNA"}
        end

      [] ->
        {:ok, proteins}
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    case codon do
      "UGG" -> {:ok, "Tryptophan"}
      "UGA" -> {:ok, "STOP"}
      "UG" <> _ -> {:ok, "Cysteine"}
      "UUA" -> {:ok, "Leucine"}
      "UUG" -> {:ok, "Leucine"}
      "UU" <> _ -> {:ok, "Phenylalanine"}
      "AUG" -> {:ok, "Methionine"}
      "UC" <> _ -> {:ok, "Serine"}
      "UAU" -> {:ok, "Tyrosine"}
      "UAC" -> {:ok, "Tyrosine"}
      "UA" <> _ -> {:ok, "STOP"}
      _ -> {:error, "invalid codon"}
    end
  end
end
