defmodule Forth do
  @valid_words_regex ~r/DROP|DUP|SWAP|OVER|\+|-|\*|\/|:|;|[0-9]+/
  @valid_arithmetic_ops MapSet.new(["\*", "\+", "-", "\/"])
  @initial_stack_ops %{
    "DROP" => "DROP",
    "DUP" => "DUP",
    "SWAP" => "SWAP",
    "OVER" => "OVER"
  }

  @doc """
  Create a new evaluator.
  """
  def new(), do: ""

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  def eval(_, ""), do: ""

  def eval(ev, ":" <> <<rest::binary>>) do
    [new_command | mapped_commands] =
      String.upcase(rest)
      |> String.slice(0, String.length(rest) - 1)
      |> String.split(" ", trim: true)

    if number?(new_command), do: raise Forth.InvalidWord

    res = if ev != "", do: ev, else: @initial_stack_ops
    Map.put(res, new_command, Enum.join(mapped_commands, " "))
  end

  def eval(ev, s) do
    upcased_expr = String.upcase(s)

    case upcased_expr do
      "DUP" ->
        raise Forth.StackUnderflow

      "DROP" ->
        raise Forth.StackUnderflow

      "SWAP" ->
        raise Forth.StackUnderflow

      "OVER" ->
        raise Forth.StackUnderflow

      _ ->
        stack_ops = if ev != "", do: ev, else: @initial_stack_ops

        upcased_expr = replace_any_custom_stack_ops(upcased_expr, stack_ops)
        invalid_words = String.split(upcased_expr, @valid_words_regex, trim: true)
        initial_stack = String.split(upcased_expr, invalid_words)

        do_eval([], initial_stack, stack_ops)
    end
  end

  defp replace_any_custom_stack_ops(upcased_expr, stack_ops) do
     Map.keys(stack_ops)
      |>  Enum.filter(
            fn key ->
              {:ok, val} = Map.fetch(stack_ops, key)
              val != key
            end)
      |>  Enum.reduce(upcased_expr,
            fn x, acc ->
              {:ok, value} = Map.fetch(stack_ops, x)
              String.replace(acc, x, value)
            end)
  end

  defp do_eval(resulted_stack, [], _), do: resulted_stack

  defp do_eval(resulted_stack, [current_word | rest], stack_ops) do
    cond do
      number?(current_word) ->
        do_eval([current_word | resulted_stack], rest, stack_ops)

      arithmetic_op?(current_word) ->
        previous_numbers = extract_two_previous_numbers(resulted_stack)
        op_result = perform_arithmetic_op(current_word, previous_numbers)
        [_ | [_ | res_rest]] = resulted_stack
        do_eval([op_result | res_rest], rest, stack_ops)

      stack_op?(current_word, stack_ops) ->
        resulted_stack = perform_stack_op(current_word, resulted_stack)
        do_eval(resulted_stack, rest, stack_ops)

      true ->
        nil
    end
  end

  defp number?(word) do
    case Integer.parse(word) do
      :error -> false
      _ -> true
    end
  end

  defp arithmetic_op?(current_word), do: MapSet.member?(@valid_arithmetic_ops, current_word)

  defp stack_op?(current_word, stack_ops), do: Map.has_key?(stack_ops, current_word)

  defp extract_two_previous_numbers(resulted_stack) do
    [first | [second | _]] = resulted_stack
    {first_num, _} = Integer.parse(first)
    {second_num, _} = Integer.parse(second)
    {first_num, second_num}
  end

  defp perform_arithmetic_op(arithmetic_op, previous_numbers) do
    {first_num, second_num} = previous_numbers

    case arithmetic_op do
      "\*" ->
        Integer.to_string(second_num * first_num)

      "\+" ->
        Integer.to_string(second_num + first_num)

      "-" ->
        Integer.to_string(second_num - first_num)

      "\/" ->
        case first_num do
          0 ->
            raise Forth.DivisionByZero

          _ ->
            Integer.to_string(div(second_num, first_num))
        end
    end
  end

  defp perform_stack_op(stack_op, resulted_stack) do
    case stack_op do
      "DROP" ->
        perform_drop_op(resulted_stack)

      "DUP" ->
        perform_dup_op(resulted_stack)

      "SWAP" ->
        perform_swap_op(resulted_stack)

      "OVER" ->
        perform_over_op(resulted_stack)
    end
  end

  defp perform_drop_op(resulted_stack) do
    [first | rest] = resulted_stack

    case first do
      [] -> raise Forth.StackUnderflow
      _ -> rest
    end
  end

  defp perform_dup_op(resulted_stack) do
    [first | _] = resulted_stack

    case first do
      [] -> raise Forth.StackUnderflow
      _ -> [first | resulted_stack]
    end
  end

  defp perform_swap_op(resulted_stack) when length(resulted_stack) < 2 do
    raise Forth.StackUnderflow
  end

  defp perform_swap_op([first | [second | rest]]), do: [second | [first | rest]]

  defp perform_over_op(resulted_stack) when length(resulted_stack) < 2 do
    raise Forth.StackUnderflow
  end

  defp perform_over_op([first | [second | rest]]), do: [second | [first | [second | rest]]]

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  def format_stack(""), do: ""

  def format_stack(ev), do: Enum.reverse(ev) |> Enum.join(" ")

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
