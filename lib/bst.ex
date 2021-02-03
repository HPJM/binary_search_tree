defmodule BST do
  @moduledoc """
  Handles operations for working with binary search trees.
  """

  alias BST.Node

  @doc """
  Inserts a node into the tree.

  ## Examples

      iex> root = BST.Node.new(2)
      iex> BST.insert(root, 3)
      %BST.Node{data: 2, right: %BST.Node{data: 3}}

  """

  # At leaf - return new node
  def insert(nil, data) do
    Node.new(data)
  end

  # Lower value than current node - recurse down left subtree
  def insert(%Node{left: left, right: right, data: data}, to_insert)
      when to_insert < data do
    Node.new(data, insert(left, to_insert), right)
  end

  # Greater value than current node - recurse down right subtree
  def insert(%Node{left: left, right: right, data: data}, to_insert)
      when to_insert > data do
    Node.new(data, left, insert(right, to_insert))
  end

  # Equal - just return node
  def insert(%Node{left: left, right: right, data: parent_data}, _data) do
    Node.new(parent_data, left, right)
  end

  @doc """
  Verifies the tree is valid.

  ## Examples

      iex> BST.Node.new(2) |> BST.insert(3) |> BST.verify?()
      true

  """

  def verify?(%Node{} = node) do
    do_verify?(node, nil, nil)
  end

  # At leaf: this branch must be valid
  defp do_verify?(nil, _min, _max) do
    true
  end

  # Node violates min / max limits
  defp do_verify?(%Node{data: data}, _min, max) when is_number(max) and data > max do
    false
  end

  defp do_verify?(%Node{data: data}, min, _max) when is_number(min) and data < min do
    false
  end

  # Verify left and right subtrees, recursively
  defp do_verify?(%Node{left: left, right: right, data: data}, min, max) do
    do_verify?(left, min, data) and do_verify?(right, data, max)
  end

  @doc """
  Traverses tree, in one of four different modes.
  """
  def traverse(node, callback, mode \\ :in_order)

  def traverse(nil, _callback, _mode) do
    nil
  end

  def traverse(%Node{left: left, right: right} = node, callback, :in_order)
      when is_function(callback, 1) do
    traverse(left, callback, :in_order)
    callback.(node.data)
    traverse(right, callback, :in_order)
  end

  def traverse(%Node{left: left, right: right} = node, callback, :pre_order)
      when is_function(callback, 1) do
    callback.(node.data)
    traverse(left, callback, :pre_order)
    traverse(right, callback, :pre_order)
  end

  def traverse(%Node{left: left, right: right} = node, callback, :post_order)
      when is_function(callback, 1) do
    traverse(left, callback, :post_order)
    traverse(right, callback, :post_order)
    callback.(node.data)
  end

  def traverse(%Node{left: left, right: right} = node, callback, :reverse)
      when is_function(callback, 1) do
    traverse(right, callback, :reverse)
    callback.(node.data)
    traverse(left, callback, :reverse)
  end

  @doc """
  Searches tree for node with given value.

  ## Examples
      iex> BST.Node.new(2) |> BST.insert(3) |> BST.search(3)
      %BST.Node{data: 3}

      iex> BST.Node.new(1) |> BST.insert(5) |> BST.search(30)
      nil
  """

  def search(nil, _value) do
    nil
  end

  def search(%Node{data: data} = node, value) when data == value do
    node
  end

  def search(%Node{data: data, left: left}, value) when value < data do
    search(left, value)
  end

  def search(%Node{data: data, right: right}, value) when value > data do
    search(right, value)
  end

  @doc """
  Retrieves smallest node in tree.

  ## Examples
      iex> tree = BST.Node.new(200) |> BST.insert(2) |> BST.insert(33) |> BST.insert(3) |> BST.find_min()
      iex> tree.data
      2
  """
  def find_min(%Node{left: nil} = node) do
    node
  end

  def find_min(%Node{left: left}) do
    find_min(left)
  end

  @doc """
  Removes node from tree.

  ## Examples
      iex> tree = BST.Node.new(3) |> BST.insert(2) |> BST.insert(1) |> BST.delete(2)
      iex> tree.left.data
      1
  """
  def delete(nil, _search_value) do
    nil
  end

  # Node has no children
  def delete(%Node{data: data, left: nil, right: nil}, search_value)
      when data == search_value do
    nil
  end

  # Node has one child
  def delete(%Node{data: data, left: %Node{} = left, right: nil}, search_value)
      when data == search_value do
    left
  end

  def delete(%Node{data: data, left: nil, right: %Node{} = right}, search_value)
      when data == search_value do
    right
  end

  # Node has two children
  def delete(%Node{data: data, left: %Node{} = left, right: %Node{} = right}, search_value)
      when data == search_value do
    # Get left-most child of right
    successor = find_min(right)
    # Move successor up to this node, and replace right branch without it
    right_without_successor = delete(right, successor.data)
    Node.new(successor.data, left, right_without_successor)
  end

  # Recurse down left or right subtrees
  def delete(%Node{data: data, left: left, right: right}, search_value)
      when search_value < data do
    Node.new(data, delete(left, search_value), right)
  end

  def delete(%Node{data: data, left: left, right: right}, search_value)
      when search_value > data do
    Node.new(data, left, delete(right, search_value))
  end
end
