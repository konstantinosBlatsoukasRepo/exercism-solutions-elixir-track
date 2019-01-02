defmodule Words do
  @delimiters_regex ~r/[ _,!&@%:\p{S}]/
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    list_of_words =
      sentence
      |> String.split(@delimiters_regex, trim: true)
      |> Enum.map(&String.downcase(&1))

    Enum.reduce(list_of_words, %{}, fn current_word, acc ->
      Map.update(acc, current_word, 1, &(&1 + 1))
    end)
  end
end
