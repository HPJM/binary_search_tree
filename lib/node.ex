defmodule BST.Node do
  alias BST.Node
  defstruct [:left, :right, :data]

  def new(data, left \\ nil, right \\ nil) do
    %Node{data: data, left: left, right: right}
  end
end
