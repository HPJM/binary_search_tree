defmodule BSTTest do
  use ExUnit.Case
  doctest BST

  alias BST.Node

  setup do
    %{root: Node.new(10)}
  end

  describe "insert/2" do
    test "insert/2 inserts on left correctly", %{root: root} do
      tree = BST.insert(root, 5)

      assert tree.left.data == 5
    end

    test "insert/2 inserts on right correctly", %{root: root} do
      tree = BST.insert(root, 11)

      assert tree.right.data == 11
    end

    test "insert/2 returns tree if nodes equal", %{root: root} do
      tree = BST.insert(root, 10)

      assert tree == root
    end

    test "insert/2 works at depth", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(11)
        |> BST.insert(6)
        |> BST.insert(15)

      assert tree.left.right.data == 6
      assert tree.right.right.data == 15
    end
  end

  describe "verify?/1" do
    test "verify?/1 accepts valid trees", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(11)
        |> BST.insert(6)
        |> BST.insert(15)
        |> BST.verify?()

      assert tree
    end

    test "verify?/1 rejects invalid trees", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(3)
        |> BST.insert(1)

      tree = put_in(tree.left.left.data, 100)

      refute BST.verify?(tree)
    end
  end
end
