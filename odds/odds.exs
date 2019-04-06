defmodule Odds do
  def round_odds(odds, ladder) do
    Enum.map(odds, fn current_odds -> aply_rounding(current_odds, ladder) end)
  end

  defp aply_rounding(odds, ladder) do
    do_aply_rounding(odds, ladder)
    |> find_the_matched_bounds()
  end

  defp do_aply_rounding(odds, ladder) do
    Enum.reduce_while(
      ladder,
      {:infinity, :infinity, []},
      fn current_ladder_value, acc ->
        {best_difference, best_ladder_value, previous_ladder_values} = acc

        previous_ladder_values = [current_ladder_value | previous_ladder_values]
        current_diff = abs(current_ladder_value - odds)

        if current_diff > best_difference do
          {:halt, rounding_result(odds, best_ladder_value, previous_ladder_values)}
        else
          {:cont, {current_diff, current_ladder_value, previous_ladder_values}}
        end
      end
    )
  end

  defp rounding_result(odds, best_ladder_value, previous_ladder_values) do
    %{
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
IO.inspect(Odds.round_odds([1.6, 1.65, 1.71, 1.77, 1.78], ladder))
