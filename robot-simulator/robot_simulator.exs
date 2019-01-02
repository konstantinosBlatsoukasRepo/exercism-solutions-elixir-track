defmodule Robot do
  defstruct direction: :north, position: {0, 0}

  @spec create_robot(direction :: atom, position :: {integer, integer}) :: any
  def create_robot(direction \\ :north, position \\ {0, 0}) do 
    case create_robot_starting_at(direction, position) do
      %Robot{direction: direction, position: position} -> %Robot{direction: direction, position: position}
      {:error, error_msg} -> {:error, error_msg}
    end
  end

  defp create_robot_starting_at(nil, nil), do: %Robot{}
  defp create_robot_starting_at(_, {x, y}) when not(is_number(x)) or not(is_number(y)), do: {:error, "invalid position"}
  defp create_robot_starting_at(:west, {x, y}), do: %Robot{direction: :west, position: {x, y}}
  defp create_robot_starting_at(:south, {x, y}), do:  %Robot{direction: :south, position: {x, y}}
  defp create_robot_starting_at(:north, {x, y}), do:  %Robot{direction: :north, position: {x, y}}
  defp create_robot_starting_at(:east, {x, y}), do: %Robot{direction: :east, position: {x, y}}
  defp create_robot_starting_at(_, {_, _}), do: {:error, "invalid direction"}
  defp create_robot_starting_at(_, _), do: {:error, "invalid position"}

  def position(robot), do: robot.position
  def direction(robot), do: robot.direction

  def simulate(instructions, %Robot{position: initial_position, direction: initial_direction}) do
    instructions_list = to_charlist(instructions)
    case valid_instructions?(instructions_list) do
      false -> {:error, "invalid instruction"}
      true -> follow_instructions(instructions_list, initial_direction, initial_position)  
    end
  end
  
  def valid_instructions?([head | tail]), do: head in [?R, ?A, ?L] and valid_instructions?(tail)
  def valid_instructions?([]), do: true

  defp follow_instructions([?A | tail], initial_direction, position) do
    %Robot{position: new_position, direction: direction} = simulate_instruction(position, initial_direction, ?A)    
    follow_instructions(tail, direction, new_position)
  end

  defp follow_instructions([?R | tail], initial_direction, position) do
    %Robot{position: position, direction: new_direction} = simulate_instruction(position, initial_direction, ?R)    
    follow_instructions(tail, new_direction, position)
  end

  defp follow_instructions([?L | tail], initial_direction, position) do
    %Robot{position: position, direction: new_direction} = simulate_instruction(position, initial_direction, ?L)    
    follow_instructions(tail, new_direction, position)
  end

  defp follow_instructions([], direct, position), do: %Robot{position: position, direction: direct}

  defp simulate_instruction(position, direct, ?R) do
    new_direction = change_direction(direct, ?R)
    %Robot{position: position, direction: new_direction}
  end 

  defp simulate_instruction(position, direct, ?L) do
    new_direction = change_direction(direct, ?L)
    %Robot{position: position, direction: new_direction}
  end

  defp simulate_instruction({x, y}, :west, ?A), do: %Robot{position: {x - 1, y}, direction: :west}
  defp simulate_instruction({x, y}, :south, ?A), do: %Robot{position: {x, y - 1}, direction: :south}
  defp simulate_instruction({x, y}, :north, ?A), do: %Robot{position: {x, y + 1}, direction: :north}
  defp simulate_instruction({x, y}, :east, ?A), do: %Robot{position: {x + 1, y}, direction: :east}

  defp change_direction(:west, ?R), do: :north
  defp change_direction(:west, ?L), do: :south
  defp change_direction(:south, ?R), do: :west
  defp change_direction(:south, ?L), do: :east
  defp change_direction(:north, ?R), do: :east
  defp change_direction(:north, ?L), do: :west
  defp change_direction(:east, ?R), do:  :south
  defp change_direction(:east, ?L), do: :north
  defp change_direction(direct, ?A), do: direct
end

# Client API
defmodule RobotSimulator do  
  import Robot
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """  
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ nil, position \\ nil) do 
    case create_robot(direction, position) do
      %Robot{direction: direction, position: position} -> 
        {:ok, robot_id} = GenServer.start(RobotServer, %Robot{direction: direction, position: position})
        robot_id
      {:error, error_msg} -> {:error, error_msg}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot_id :: any, instructions :: String.t()) :: any
  def simulate(robot_id, instructions) do    
    valid_instructions? = GenServer.call(robot_id, {:validate_instructions, instructions})
    case valid_instructions? do
      {:error, msg} -> {:error, msg}
      _ -> GenServer.call(robot_id, {:move_robot, instructions})
    end
  end
  # @doc """
  # Return the robot's direction.

  # Valid directions are: `:north`, `:east`, `:south`, `:west`
  # """
  @spec direction(robot_id :: any) :: atom
  def direction(robot_id) do
    GenServer.call(robot_id, {:direction})
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot_id :: any) :: {integer, integer}
  def position(robot_id) do
    GenServer.call(robot_id, {:position})
  end

end

defmodule RobotServer do
  use GenServer
  import Robot

  @impl true
  def init(robot_starting_point) do
    {:ok, robot_starting_point}
  end
  
  @impl true
  def handle_call({:direction}, _, state), do: {:reply, state.direction, state}
  def handle_call({:position}, _, state), do: {:reply, state.position, state}

  def handle_call({:validate_instructions, instructions}, _, state) do 
    case valid_instructions?(to_charlist(instructions)) do
      true -> {:reply, :ok, state}
      false -> {:reply, {:error, "invalid instruction"}, state}
    end
  end

  def handle_call({:move_robot, instructions}, _, state), do: {:reply, self(), simulate(instructions, state)}
      
end