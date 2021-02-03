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
end
