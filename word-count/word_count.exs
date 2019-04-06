defmodule Words do
  @delimiters_regex ~r/[ _,!&@%:\p{S}]/
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  # @spec count(String.t()) :: map
  # def count(sentence) do
  #   list_of_words =
  #     sentence
  #     |> String.split(@delimiters_regex, trim: true)
  #     |> Enum.map(&String.downcase(&1))

  #   Enum.reduce(list_of_words, %{}, fn current_word, acc ->
  #     Map.update(acc, current_word, 1, &(&1 + 1))
  #   end)
  # end

  def count(sentence) do
    String.replace(sentence, "_", " ")
    |> String.replace(~r/[^-\w\s]/u, "")
    |> String.downcase()
    |> String.split()
    |> Enum.reduce(%{}, fn word, map ->
      Map.update(map, word, 1, &(&1 + 1))
      # if Map.has_key?(map, word) do
      #   %{map | word => map[word] + 1}
      # else
      #   Map.put(map, word, 1)
      # end
    end)
  end
end
