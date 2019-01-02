defmodule Frame do
  defstruct id: 0, rolls_pair: {nil, nil}, type: nil

  def roll(%Frame{id: 0, rolls_pair: {nil, nil}, type: nil}, roll),
    do: do_roll(%Frame{id: 0, rolls_pair: {nil, nil}, type: nil}, roll, true)

  def roll(frame, roll) when is_integer(roll), do: do_roll(frame, roll, frame_concluded?(frame))

  def frame_concluded?(%Frame{id: id, rolls_pair: {a, b}, type: type}),
    do: is_integer(id) and is_integer(a) and is_integer(b) and is_atom(type)

  defp do_roll(%Frame{id: id}, roll, true) do
    case roll do
      10 -> %Frame{id: id + 1, rolls_pair: {10, 0}, type: :strike}
      _ -> %Frame{id: id + 1, rolls_pair: {roll, nil}, type: nil}
    end
  end

  defp do_roll(%Frame{id: id, rolls_pair: {a, nil}}, roll, false) do
    deduced_type = deduce_frame_type({a, roll})
    %Frame{id: id, rolls_pair: {a, roll}, type: deduced_type}
  end

  defp deduce_frame_type({a, b}) do
    cond do
      a + b == 10 -> :spare
      true -> :open
    end
  end
end

defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start, do: [%Frame{id: 0, rolls_pair: {nil, nil}, type: nil}]

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll(game, roll) when roll < 0, do: {:error, "Negative roll is invalid"}

  def roll(game, roll) when roll > 10, do: {:error, "Pin count exceeds pins on the lane"}

  def roll([%Frame{id: 0}], roll), do: [Frame.roll(%Frame{id: 0}, roll)]

  def roll([%Frame{id: 10, type: :open} | _], roll),
    do: {:error, "Cannot roll after game is over"}

  def roll(game, roll) do
    [previous_frame | rest] = game
    result = Frame.roll(previous_frame, roll)
    frame_concluded = Frame.frame_concluded?(previous_frame)

    case frame_concluded do
      true ->
        [result | game]

      _ ->
        if valid_total_points?(result, roll) do
          [result | rest]
        else
          {:error, "Pin count exceeds pins on the lane"}
        end
    end
  end

  def valid_total_points?(result, roll) do
    %Frame{rolls_pair: {a, _}, type: type} = result

    case type do
      :strike -> true
      _ -> a + roll <= 10
    end
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score([%Frame{id: 0}]), do: {:error, "Score cannot be taken until the end of the game"}

  def score([%Frame{id: id} | _]) when id < 10,
    do: {:error, "Score cannot be taken until the end of the game"}

  def score([%Frame{id: 10, type: :strike} | rest]),
    do: {:error, "Score cannot be taken until the end of the game"}

  def score([%Frame{id: 10, type: :spare} | rest]),
    do: {:error, "Score cannot be taken until the end of the game"}

  def score([%Frame{id: 11, type: :strike} | [%Frame{id: 10, type: :strike} | rest]]),
    do: {:error, "Score cannot be taken until the end of the game"}

  def score(frames) do
    ordered_frames = Enum.reverse(frames)
    [frame | _] = ordered_frames
    %Frame{id: id, type: type} = frame
    do_score(ordered_frames, type, id)
  end

  def do_score([], _, _), do: 0

  def do_score([%Frame{rolls_pair: {a, b}}], :open, 10), do: a + b

  def do_score([%Frame{rolls_pair: {a, b}} | [next_frame | rest]], :strike, 10) do
    %Frame{rolls_pair: {c, d}, type: next_type} = next_frame

    case next_type do
      :strike ->
        [last_frame | []] = rest
        %Frame{rolls_pair: {e, f}} = last_frame

        case f do
          nil -> a + c + e
          _ -> a + c + e + f
        end

      _ ->
        a + c + d
    end
  end

  def do_score([%Frame{rolls_pair: {a, b}} | rest], :spare, 10) do
    [last_frame | []] = rest
    %Frame{rolls_pair: {c, d}} = last_frame

    case d do
      nil -> a + b + c
      _ -> a + b + c + d
    end
  end

  def do_score([frame | [next_frame | rest]], :open, _) do
    %Frame{id: id, rolls_pair: {a, b}, type: type} = frame
    %Frame{type: next_type, id: next_id} = next_frame
    a + b + do_score([next_frame | rest], next_type, next_id)
  end

  def do_score([frame | [next_frame | rest]], :spare, _) do
    %Frame{id: id, rolls_pair: {a, b}, type: type} = frame
    %Frame{rolls_pair: {c, _}, type: next_type, id: next_id} = next_frame
    a + b + c + do_score([next_frame | rest], next_type, next_id)
  end

  def do_score([frame | [next_frame | rest]], :strike, _) do
    %Frame{id: id, rolls_pair: {a, b}, type: type} = frame
    %Frame{rolls_pair: {c, d}, type: next_type, id: next_id} = next_frame

    case next_type do
      :strike ->
        case rest do
          [] ->
            a + b + c + d + do_score([next_frame | rest], next_type, next_id)

          _ ->
            [%Frame{rolls_pair: {e, f}} | _] = rest
            a + b + c + e + do_score([next_frame | rest], next_type, next_id)
        end

      _ ->
        a + b + c + d + do_score([next_frame | rest], next_type, next_id)
    end
  end
end
