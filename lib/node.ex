defmodule BST.Node do
  alias BST.Node
  defstruct [:left, :right, :data]

  @doc """
  Creates new node

  ## Examples
      iex> BST.Node.new(2)
      %BST.Node{data: 2}

  """
  def new(data, left \\ nil, right \\ nil) do
    %Node{data: data, left: left, right: right}
  end
end
