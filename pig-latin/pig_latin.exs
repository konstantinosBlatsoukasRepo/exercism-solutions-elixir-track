defmodule PigLatin do
  @consonant_regex ~r/^([(bcdfghjklmnpqrstvxzy)]+)/
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".

  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    words = String.split(phrase)
    Enum.map_join(words, " ", &translate_word(&1))
  end

  def translate_word(<<"a">> <> <<rest::binary>>), do: <<"a">> <> <<rest::binary>> <> <<"ay">>
  def translate_word(<<"e">> <> <<rest::binary>>), do: <<"e">> <> <<rest::binary>> <> <<"ay">>
  def translate_word(<<"i">> <> <<rest::binary>>), do: <<"i">> <> <<rest::binary>> <> <<"ay">>
  def translate_word(<<"o">> <> <<rest::binary>>), do: <<"o">> <> <<rest::binary>> <> <<"ay">>
  def translate_word(<<"u">> <> <<rest::binary>>), do: <<"u">> <> <<rest::binary>> <> <<"ay">>
  def translate_word(<<"yt">> <> <<rest::binary>>), do: <<"yt">> <> <<rest::binary>> <> <<"ay">>
  def translate_word(<<"xr">> <> <<rest::binary>>), do: <<"xr">> <> <<rest::binary>> <> <<"ay">>

  def translate_word(<<"x">> <> <<rest::binary>>) do
    second_letter = String.first(rest)

    if String.match?(second_letter, @consonant_regex) do
      <<"x">> <> <<rest::binary>> <> <<"ay">>
    else
      <<rest::binary>> <> <<"x">> <> <<"ay">>
    end
  end

  def translate_word(<<"y">> <> <<rest::binary>>) do
    second_letter = String.first(rest)

    if String.match?(second_letter, @consonant_regex) do
      <<"y">> <> <<rest::binary>> <> <<"ay">>
    else
      <<rest::binary>> <> <<"y">> <> <<"ay">>
    end
  end

  def translate_word(<<"ch">> <> <<rest::binary>>), do: <<rest::binary>> <> <<"ch">> <> <<"ay">>
  def translate_word(<<"qu">> <> <<rest::binary>>), do: <<rest::binary>> <> <<"qu">> <> <<"ay">>
  def translate_word(<<"squ">> <> <<rest::binary>>), do: <<rest::binary>> <> <<"squ">> <> <<"ay">>
  def translate_word(<<"thr">> <> <<rest::binary>>), do: <<rest::binary>> <> <<"thr">> <> <<"ay">>
  def translate_word(<<"th">> <> <<rest::binary>>), do: <<rest::binary>> <> <<"th">> <> <<"ay">>
  def translate_word(<<"sch">> <> <<rest::binary>>), do: <<rest::binary>> <> <<"sch">> <> <<"ay">>

  def translate_word(phrase) do
    consonant_split = String.split(phrase, @consonant_regex, trim: true)
    [not_consecutive_consonentes] = consonant_split
    [consecutive_consonentes] = String.split(phrase, not_consecutive_consonentes, trim: true)
    not_consecutive_consonentes <> consecutive_consonentes <> <<"ay">>
  end
end
