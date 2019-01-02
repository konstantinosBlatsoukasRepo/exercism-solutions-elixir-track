defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @lowcase 97..122
  @upcase 65..90
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    char_list_text = String.to_charlist(text)

    Enum.map(char_list_text, fn
      x when x in @lowcase ->
        if x + shift <= 122, do: x + shift, else: rem(x + shift, 122) - 1 + 97

      x when x in @upcase ->
        if x + shift <= 90, do: x + shift, else: rem(x + shift, 90) - 1 + 65

      x ->
        x
    end)
    |> List.to_string()
  end
end
