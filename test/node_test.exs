defmodule BSTNodeTest do
  use ExUnit.Case
  doctest BST

  test "new/3 creates a node with defaults" do
    assert BST.Node.new(2) == %BST.Node{data: 2}
  end

  test "new/3 creates a node with children" do
    left = BST.Node.new(1)
    right = BST.Node.new(3)
    assert BST.Node.new(2, left, right) == %BST.Node{data: 2, left: left, right: right}
  end
end
