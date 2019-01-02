defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown_text) do
    String.split(markdown_text, "\n")
    |> Enum.map_join(&process_line/1)
    |> wrap_to_single_list
  end

  defp process_line(<<"#">> <> <<rest::binary>>),
    do: enclose_with_header_tag(parse_header_md_level(<<"#">> <> <<rest::binary>>))

  defp process_line(<<"*">> <> <<rest::binary>>),
    do: parse_list_md_level(<<"*">> <> <<rest::binary>>)

  defp process_line(markdown_line), do: enclose_with_paragraph_tag(String.split(markdown_line))

  defp parse_header_md_level(header_with_text) do
    [dashes | text] = String.split(header_with_text)
    {get_header_level(dashes), Enum.join(text, " ")}
  end

  defp get_header_level(dashes), do: to_string(String.length(dashes))

  defp parse_list_md_level(md_list_item) do
    raw_list_items = String.split(md_list_item, "* ", trim: true)
    "<li>#{join_words_with_tags(raw_list_items)}</li>"
  end

  defp join_words_with_tags(raw_list_items), do: Enum.map_join(raw_list_items, " ", &replace_md_with_tag/1)

  defp enclose_with_header_tag({header_level, text}),
    do: "<h#{header_level}>#{text}</h#{header_level}>"

  defp enclose_with_paragraph_tag(paragraph_words), do: "<p>#{join_words_with_tags(paragraph_words)}</p>"

  defp replace_md_with_tag(md_words_untagged) do 
    md_words_untagged
    |> replace_prefix_md
    |> replace_suffix_md
  end

  defp replace_suffix_md(words_with_prefix_tag) do
    cond do
      ends_with_bold?(words_with_prefix_tag) -> String.replace(words_with_prefix_tag, "#{"__"}", "</strong>")
      not_starting_with_italic?(words_with_prefix_tag) -> String.replace(words_with_prefix_tag, "_", "</em>")
      true -> words_with_prefix_tag
    end
  end

  defp ends_with_bold?(md_word), do: md_word =~ ~r/#{"__"}{1}$/
  defp not_starting_with_italic?(md_word), do: md_word =~ ~r/[^#{"_"}{1}]/

  defp replace_prefix_md(md_words_untagged) do
    cond do
      starts_with_bold?(md_words_untagged) -> String.replace(md_words_untagged, "#{"__"}", "<strong>", global: false)
      starts_with_italic?(md_words_untagged) -> String.replace(md_words_untagged, "_", "<em>", global: false)
      true -> md_words_untagged
    end
  end

  defp starts_with_bold?(md_word), do: md_word =~ ~r/^#{"__"}{1}/
  defp starts_with_italic?(md_word), do: md_word =~ ~r/^[#{"_"}{1}][^#{"_"}+]/

  defp wrap_to_single_list(html_words) do
    String.replace(html_words, "<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end