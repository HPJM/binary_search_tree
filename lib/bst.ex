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
end
