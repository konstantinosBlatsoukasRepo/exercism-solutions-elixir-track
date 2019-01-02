defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    punctuation_removal_function = &String.replace(&1, ~r/[,!&@%:\p{S}]/, "")

    list_of_words =
      sentence
      |> String.split([" ", "_"])
      |> Enum.map(punctuation_removal_function)
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.downcase(&1))

    Enum.reduce(list_of_words, %{}, fn current_word, acc ->
      value = Map.get(acc, current_word)

      case value do
        nil -> Map.put(acc, current_word, 1)
        _ -> Map.put(acc, current_word, value + 1)
      end
    end)
  end
end
