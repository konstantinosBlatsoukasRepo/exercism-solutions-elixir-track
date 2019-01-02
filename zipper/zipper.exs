defmodule BinTree do
  import Inspect.Algebra

  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{value: any, left: BinTree.t() | nil, right: BinTree.t() | nil}
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat([
      "(",
      to_doc(v, opts),
      ":",
      if(l, do: to_doc(l, opts), else: ""),
      ":",
      if(r, do: to_doc(r, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  defstruct focus_node: nil, trail: []

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t()) :: Z.t()
  def from_tree(bt), do: %Zipper{focus_node: bt, trail: []}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t()) :: BT.t()
  def to_tree(%Zipper{focus_node: bt, trail: []}), do: bt
  def to_tree(%Zipper{focus_node: {:root, bt}, trail: []}), do: bt

  def to_tree(%Zipper{focus_node: focus_node, trail: tail}) do
    zipper_reversed = Enum.reverse([focus_node | tail])
    do_tree(zipper_reversed, %BinTree{value: nil, left: nil, right: nil})
  end

  def do_tree([], bt), do: bt

  def do_tree([{:root, focus} | tail], %BinTree{value: _, left: _, right: _}),
    do: do_tree(tail, %BinTree{value: focus.value, left: focus.left, right: focus.right})

  def do_tree([{:right, focus} | tail], %BinTree{value: value, left: left_node, right: _}),
      do: %BinTree{value: value, left: left_node, right: do_tree(tail, focus)}

  def do_tree([{:left, focus} | tail], %BinTree{value: value, left: _, right: right_node}),
    do: %BinTree{value: value, left: do_tree(tail, focus), right: right_node}

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t()) :: any
  def value(%Zipper{focus_node: {:left, focus}, trail: _}), do: focus.value

  def value(%Zipper{focus_node: {:right, focus}, trail: _}), do: focus.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t()) :: Z.t() | nil
  def left(%Zipper{focus_node: {:root, focus}, trail: []}),
    do: %Zipper{focus_node: {:left, focus.left}, trail: [{:root, focus}]}

  def left(%Zipper{focus_node: focus, trail: []}),
    do: %Zipper{focus_node: {:left, focus.left}, trail: [{:root, focus}]}

  def left(%Zipper{focus_node: {:left, focus}, trail: previous_nodes}) do
    case focus.left do
      nil -> nil
      _ -> %Zipper{focus_node: {:left, focus.left}, trail: [{:left, focus} | previous_nodes]}
    end
  end

  def left(%Zipper{focus_node: {:right, focus}, trail: previous_nodes}) do
    case focus.left do
      nil -> nil
      _ -> %Zipper{focus_node: {:left, focus.left}, trail: [{:right, focus} | previous_nodes]}
    end
  end



  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t()) :: Z.t() | nil
  def right(%Zipper{focus_node: {:root, focus}, trail: []}),
    do: %Zipper{focus_node: {:right, focus.right}, trail: [{:root, focus}]}

  def right(%Zipper{focus_node: focus, trail: []}),
    do: %Zipper{focus_node: {:right, focus.right}, trail: [{:root, focus}]}

  def right(%Zipper{focus_node: {:right, focus}, trail: previous_nodes}) do
    case focus.right do
      nil -> nil
      _ -> %Zipper{focus_node: {:right, focus.right}, trail: [{:right, focus} | previous_nodes]}
    end
  end

  def right(%Zipper{focus_node: {:left, focus}, trail: previous_nodes}) do
    case focus.right do
      nil -> nil
      _ -> %Zipper{focus_node: {:right, focus.right}, trail: [{:left, focus} | previous_nodes]}
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t()) :: Z.t()
  def up(%Zipper{focus_node: _, trail: []}), do: nil

  def up(%Zipper{focus_node: _, trail: [parent_node | rest]}),
    do: %Zipper{focus_node: parent_node, trail: rest}

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t(), any) :: Z.t()
  def set_value(%Zipper{focus_node: {:left, %BinTree{left: l, right: r, value: _}}, trail: trail}, v), do:
    %Zipper{focus_node: {:left, %BinTree{left: l, right: r, value: v}}, trail: trail}

  def set_value(%Zipper{focus_node: {:right, %BinTree{left: l, right: r, value: _}}, trail: trail}, v), do:
    %Zipper{focus_node: {:right, %BinTree{left: l, right: r, value: v}}, trail: trail}

  def set_value(%Zipper{focus_node: {:root, %BinTree{left: l, right: r, value: _}}, trail: trail}, v), do:
    %Zipper{focus_node: {:root, %BinTree{left: l, right: r, value: v}}, trail: trail}

  def set_value(%Zipper{focus_node: %BinTree{left: l, right: r, value: _}, trail: trail}, v), do:
    %Zipper{focus_node: %BinTree{left: l, right: r, value: v}, trail: trail}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t(), BT.t()) :: Z.t()
  def set_left(%Zipper{focus_node: {:left, %BinTree{left: _, right: r, value: val}}, trail: trail}, l), do:
    %Zipper{focus_node: {:left, %BinTree{left: l, right: r, value: val}}, trail: trail}

  def set_left(%Zipper{focus_node: {:right, %BinTree{left: _, right: r, value: val}}, trail: trail}, l), do:
    %Zipper{focus_node: {:right, %BinTree{left: l, right: r, value: val}}, trail: trail}

  def set_left(%Zipper{focus_node: {:root, %BinTree{left: _, right: r, value: val}}, trail: trail}, l), do:
    %Zipper{focus_node: {:root, %BinTree{left: l, right: r, value: val}}, trail: trail}

  def set_left(%Zipper{focus_node: %BinTree{left: _, right: r, value: val}, trail: trail}, l), do:
    %Zipper{focus_node: %BinTree{left: l, right: r, value: val}, trail: trail}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t(), BT.t()) :: Z.t()
  def set_right(%Zipper{focus_node: {:left, %BinTree{left: l, right: _, value: val}}, trail: trail}, r), do:
    %Zipper{focus_node: {:left, %BinTree{left: l, right: r, value: val}}, trail: trail}

  def set_right(%Zipper{focus_node: {:right, %BinTree{left: l, right: _, value: val}}, trail: trail}, r), do:
    %Zipper{focus_node: {:right, %BinTree{left: l, right: r, value: val}}, trail: trail}

  def set_right(%Zipper{focus_node: {:root, %BinTree{left: l, right: _, value: val}}, trail: trail}, r), do:
    %Zipper{focus_node: {:root, %BinTree{left: l, right: r, value: val}}, trail: trail}

  def set_right(%Zipper{focus_node: %BinTree{left: l, right: _, value: val}, trail: trail}, r), do:
    %Zipper{focus_node: %BinTree{left: l, right: r, value: val}, trail: trail}
end
