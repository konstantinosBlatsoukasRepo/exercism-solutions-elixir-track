defmodule Bob do
  @answer_to_question "Sure."
  @answer_to_shouting_with_question "Calm down, I know what I'm doing!"
  @answer_to_empty_string "Fine. Be that way!"
  @answer_to_shouting "Whoa, chill out!"
  @answer_whatever "Whatever."

  def hey(input) do
    input = String.trim(input)
    hey_helper(input)
  end

  defp hey_helper(""), do: @answer_to_empty_string

  defp hey_helper(input) do
    cond do
      shouting_with_question?(input) ->
        @answer_to_shouting_with_question

      question?(input) ->
        @answer_to_question

      shouting?(input) ->
        @answer_to_shouting

      true ->
        @answer_whatever
    end
  end

  defp shouting_with_question?(input) do
    question?(input) && shouting?(input) && !contains_numbers?(input)
  end

  defp question?(input), do: String.last(input) == "?"

  defp shouting?(input) do
    capitalized_input = String.upcase(input)
    capitalized_input == input && capitalized_input != String.downcase(input)
  end

  defp contains_numbers?(input) do
    String.match?(input, ~r/[0-9]/)
  end
end
