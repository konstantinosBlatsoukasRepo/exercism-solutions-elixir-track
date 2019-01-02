defmodule TwelveDays do
  @twelve_days %{
    1 => {"first", "a Partridge in a Pear Tree."},
    2 => {"second", "two Turtle Doves, "},
    3 => {"third", "three French Hens, "},
    4 => {"fourth", "four Calling Birds, "},
    5 => {"fifth", "five Gold Rings, "},
    6 => {"sixth", "six Geese-a-Laying, "},
    7 => {"seventh", "seven Swans-a-Swimming, "},
    8 => {"eighth", "eight Maids-a-Milking, "},
    9 => {"ninth", "nine Ladies Dancing, "},
    10 => {"tenth", "ten Lords-a-Leaping, "},
    11 => {"eleventh", "eleven Pipers Piping, "},
    12 => {"twelfth", "twelve Drummers Drumming, "}
  }

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    day = Map.get(@twelve_days, number) |> elem(0)

    case number do
      1 ->
        lyric = Map.get(@twelve_days, 1) |> elem(1)
        "On the #{day} day of Christmas my true love gave to me: #{lyric}"

      _ ->
        days = number..1 |> Enum.map(& &1)

        lyric =
          Enum.reduce(days, "", fn
            x, acc ->
              if x == 1 do
                acc <> "and " <> (Map.get(@twelve_days, 1) |> elem(1))
              else
                acc <> (Map.get(@twelve_days, x) |> elem(1))
              end
          end)

        "On the #{day} day of Christmas my true love gave to me: #{lyric}"
    end
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    days =
      starting_verse..ending_verse
      |> Enum.map(& &1)

    Enum.reduce(days, "", fn
      x, acc ->
        if x == ending_verse, do: acc <> verse(x), else: acc <> verse(x) <> "\n"
    end)
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end
end
