defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) when hour < 0, do: new(hour + 24, minute)

  def new(hour, minute) when minute < 0, do: new(hour - 1, minute + 60)

  def new(hour, minute) do
    hour = rem(hour, 24)
    do_new(hour, minute)
  end

  def do_new(hour, minute) when minute > 59 do
    hour = rem(rem(hour, 24) + div(minute, 60), 24)
    minute = rem(minute, 60)
    %Clock{hour: hour, minute: minute}
  end

  def do_new(hour, minute), do: %Clock{hour: hour, minute: minute}

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute),
    do: Clock.new(hour, minute + add_minute)

  defimpl String.Chars, for: Clock do
    def to_string(%Clock{hour: hour, minute: minute}) when hour < 10 and minute < 10 do
      hour = Kernel.to_string(hour)
      minute = Kernel.to_string(minute)
      "0" <> hour <> ":" <> "0" <> minute
    end

    def to_string(%Clock{hour: hour, minute: minute}) when hour < 10 and minute > 9 do
      hour = Kernel.to_string(hour)
      minute = Kernel.to_string(minute)
      "0" <> hour <> ":" <> minute
    end

    def to_string(%Clock{hour: hour, minute: minute}) when hour > 9 and minute > 9 do
      hour = Kernel.to_string(hour)
      minute = Kernel.to_string(minute)
      hour <> ":" <> minute
    end

    def to_string(%Clock{hour: hour, minute: minute}) when hour > 9 and minute < 10 do
      hour = Kernel.to_string(hour)
      minute = Kernel.to_string(minute)
      hour <> ":" <> "0" <> minute
    end
  end
end
