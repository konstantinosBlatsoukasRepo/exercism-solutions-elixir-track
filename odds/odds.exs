defmodule Odds do
  def round_odds(odds, ladder) do
    odds
    |> Stream.map(&aply_rounding(&1, ladder))
    |> Enum.to_list()
  end

  defp aply_rounding(odds, ladder) do
    do_aply_rounding(odds, ladder)
    |> find_the_matched_bounds()
  end

  defp do_aply_rounding(odds, ladder) do
    Enum.reduce_while(
      ladder,
      rounding_result(odds, :infinity, [], :infinity),
      fn current_ladder_value, acc ->
        %{
          best_diff: best_difference,
          given_odds: odds,
          resulted_ladder: best_ladder_value,
          previous_ladder_values: previous_ladder_values
        } = acc

        previous_ladder_values = [current_ladder_value | previous_ladder_values]
        current_diff = abs(current_ladder_value - odds)

        if current_diff > best_difference do
          {:halt,
           rounding_result(odds, best_ladder_value, previous_ladder_values, best_difference)}
        else
          {:cont,
           rounding_result(odds, current_ladder_value, previous_ladder_values, current_diff)}
        end
      end
    )
  end

  defp rounding_result(odds, best_ladder_value, previous_ladder_values, best_diff) do
    %{
      best_diff: best_diff,
      given_odds: odds,
      resulted_ladder: best_ladder_value,
      previous_ladder_values: previous_ladder_values
    }
  end

  defp find_the_matched_bounds(rounding_result) do
    %{
      given_odds: odds,
      resulted_ladder: best_ladder_value,
      previous_ladder_values: previous_ladder_values
    } = rounding_result

    last_three_ladder_values = Enum.take(previous_ladder_values, 3)

    do_find_the_matched_bounds(last_three_ladder_values, odds, best_ladder_value)
    |> Map.put(:given_odds, odds)
  end

  defp do_find_the_matched_bounds(last_three_ladder_values, odds, best_ladder_value) do
    case length(last_three_ladder_values) do
      2 ->
        [last, first] = last_three_ladder_values
        %{resulted_odds: best_ladder_value, bounds: {first, last}}

      _ ->
        [last, middle, first] = last_three_ladder_values

        if odds > middle do
          %{resulted_odds: best_ladder_value, bounds: {middle, last}}
        else
          %{resulted_odds: best_ladder_value, bounds: {first, middle}}
        end
    end
  end
end

ladder = [1.5, 1.75, 1.8, 1.9, 3.0, 40.0]
IO.inspect(Odds.round_odds([1.6, 1.65, 1.71, 1.77, 1.78, 1.79, 1.8, 2.0, 30.0], ladder))
