defmodule BSTTest do
  use ExUnit.Case
  doctest BST

  alias BST.Node

  setup do
    %{root: Node.new(10)}
  end

  describe "new/3" do
    test "new/3 creates a node with defaults" do
      assert BST.new(2) == %BST.Node{data: 2}
    end

    test "new/3 creates a node with children" do
      left = BST.new(1)
      right = BST.new(3)
      assert BST.new(2, left, right) == %BST.Node{data: 2, left: left, right: right}
    end
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

  describe "insert_many/2" do
    test "insert_many/2 inserts multiple nodes on root", %{root: root} do
      tree = BST.insert_many(root, [5, 500, 5000])

      assert tree == %BST.Node{
               data: 10,
               left: %BST.Node{data: 5, left: nil, right: nil},
               right: %BST.Node{
                 data: 500,
                 left: nil,
                 right: %BST.Node{data: 5000, left: nil, right: nil}
               }
             }
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

  describe "traverse/3" do
    setup %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(11)
        |> BST.insert(6)
        |> BST.insert(15)

      %{tree: tree}
    end

    test "traverse/3 traverses tree in order by default", %{tree: tree} do
      {:ok, agent} = Agent.start(fn -> [] end)

      BST.traverse(tree, &Agent.update(agent, fn collected -> collected ++ [&1] end))

      assert Agent.get(agent, & &1) == [5, 6, 10, 11, 15]
    end

    test "traverse/3 can traverse tree pre-order", %{tree: tree} do
      {:ok, agent} = Agent.start(fn -> [] end)

      BST.traverse(
        tree,
        &Agent.update(agent, fn collected -> collected ++ [&1] end),
        :pre_order
      )

      assert Agent.get(agent, & &1) == [10, 5, 6, 11, 15]
    end

    test "traverse/3 can traverse tree post-order", %{tree: tree} do
      {:ok, agent} = Agent.start(fn -> [] end)

      BST.traverse(
        tree,
        &Agent.update(agent, fn collected -> collected ++ [&1] end),
        :post_order
      )

      assert Agent.get(agent, & &1) == [6, 5, 15, 11, 10]
    end

    test "traverse/3 can traverse tree reverse", %{tree: tree} do
      {:ok, agent} = Agent.start(fn -> [] end)

      BST.traverse(
        tree,
        &Agent.update(agent, fn collected -> collected ++ [&1] end),
        :reverse
      )

      assert Agent.get(agent, & &1) == [15, 11, 10, 6, 5]
    end
  end

  describe "collect/2" do
    setup %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(11)
        |> BST.insert(6)
        |> BST.insert(15)

      %{tree: tree}
    end

    test "collect/2 collects from tree in order by default", %{tree: tree} do
      assert BST.collect(tree) == [5, 6, 10, 11, 15]
    end

    test "collect/2 collects from tree in any traversal mode", %{tree: tree} do
      assert BST.collect(tree, :pre_order) == [10, 5, 6, 11, 15]
      assert BST.collect(tree, :post_order) == [6, 5, 15, 11, 10]
      assert BST.collect(tree, :reverse) == [15, 11, 10, 6, 5]
    end
  end

  describe "search/2" do
    test "search/2 finds an existing node in the tree", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(11)
        |> BST.insert(6)
        |> BST.insert(15)

      assert BST.search(tree, 15) == %BST.Node{data: 15}
    end

    test "search/2 returns nil if node can't be found", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(3)

      refute BST.search(tree, 30)
    end
  end

  describe "find_min/1" do
    test "gets smallest node on left subtree", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(11)
        |> BST.insert(6)
        |> BST.insert(15)

      min = BST.find_min(tree)
      assert min.data == 5
    end
  end

  describe "delete/2" do
    test "delete/2 removes node with no children", %{root: root} do
      tree =
        root
        |> BST.insert(5)

      assert BST.delete(tree, 5) == root
    end

    test "delete/2 removes node with one left child", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(3)

      assert BST.delete(tree, 5) == %BST.Node{
               data: 10,
               left: %BST.Node{data: 3, left: nil, right: nil},
               right: nil
             }
    end

    test "delete/2 removes node with one right child", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(30)

      assert BST.delete(tree, 5) == %BST.Node{
               data: 10,
               left: nil,
               right: %BST.Node{data: 30, left: nil, right: nil}
             }
    end

    test "delete/2 removes node with both children", %{root: root} do
      tree =
        root
        |> BST.insert(5)
        |> BST.insert(30)
        |> BST.insert(60)
        |> BST.insert(61)
        |> BST.insert(20)

      assert BST.delete(tree, 30) == %BST.Node{
               data: 10,
               left: %BST.Node{
                 data: 5,
                 left: nil,
                 right: nil
               },
               right: %BST.Node{
                 data: 60,
                 left: %BST.Node{data: 20, left: nil, right: nil},
                 right: %BST.Node{data: 61, left: nil, right: nil}
               }
             }
    end
  end

  describe "delete_many/2" do
    test "delete_many/2 deletes multiple nodes", %{root: root} do
      values = [5, 500, 5000]
      tree = BST.insert_many(root, values) |> BST.delete_many(values)

      assert tree == root
    end
  end
end
