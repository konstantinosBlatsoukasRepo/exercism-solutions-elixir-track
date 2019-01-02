defmodule MyList do
  def each(enumerable, fun) do
    case enumerable do
      [head | tail] ->
        each(tail, fun)
        fun.(head)

      [] ->
        :ok
    end
  end

  def any?(enumerable, fun \\ fn x -> x end) do
    case enumerable do
      [head | tail] ->
        fun.(head) || any?(tail, fun)

      [] ->
        false
    end
  end

  def map(enumerable, fun \\ fn x -> x end) do
    case enumerable do
      [head | tail] -> [fun.(head)] ++ map(tail, fun)
      [] -> []
    end
  end

  def reverse(enumerable) do
    case enumerable do
      [head | tail] -> reverse(tail) ++ [head]
      [] -> []
    end
  end

  def reduce(enumerable, acc, fun) do
    case enumerable do
      [head | tail] -> reduce(tail, fun.(head, acc), fun)
      [] -> acc
    end
  end

  def chunk_every(enumerable, count) do
    case enumerable do
      [] -> []
      _ -> chunk([hd(enumerable)], count, 1, tl(enumerable))
    end
  end

  defp chunk(item, count, index, enumerable) do
    case enumerable do
      [head | tail] ->
        if rem(index, count) != 0 do
          chunk(item ++ [head], count, index + 1, tail)
        else
          [item] ++ chunk([head], count, index + 1, tail)
        end

      [] ->
        [item]
    end
  end
end
