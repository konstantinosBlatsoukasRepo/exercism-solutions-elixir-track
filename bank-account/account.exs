defmodule Account do
  defstruct balance: 0

  def get_balance(%Account{balance: balance}), do: %Account{balance: balance}

  def deposit(%Account{balance: balance}, amount) when amount > 0, do: %Account{balance: balance + amount}
  def wihtdraw(%Account{balance: balance}, amount) when amount < 0, do: %Account{balance: balance - amount}
    
end

defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank(), do: GenServer.start(AccountServer, %Account{balance: 0})

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank({:ok, account_id}) do
    case Process.alive?(account_id) do
      true -> Process.exit(account_id, :kill)
      _ -> :ok  
    end
  end 
  
  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance({:ok, account_id}) do
    case Process.alive?(account_id) do 
      true -> GenServer.call(account_id, {:balance})
      _ ->  {:error, :account_closed}       
    end    
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update({:ok, account_id}, amount) do 
    case Process.alive?(account_id) do 
      true -> update_helper({:ok, account_id}, amount)
      _ ->  {:error, :account_closed}       
    end    
  end  
  def update_helper({:ok, account_id}, amount) when amount > 0, do: GenServer.call(account_id, {:deposit, amount}) 
  def update_helper({:ok, account_id}, amount) when amount < 0, do: GenServer.call(account_id, {:wihtdraw, amount}) 
  def update_helper({:ok, account_id}, 0), do: GenServer.call(account_id, {:balance})

end

defmodule AccountServer do
  use GenServer

  @impl true
  def init(acount), do: {:ok, acount}

  @impl true
  def handle_call({:deposit, amount}, _, account) do 
    new_balance = account.balance + amount
    {:reply, new_balance, %Account{balance: new_balance}}
  end

  def handle_call({:wihtdraw, amount}, _, account) do 
    new_balance = account.balance + amount
    {:reply, new_balance, %Account{balance: new_balance}}
  end

  def handle_call({:balance}, _, account), do: {:reply, account.balance, account}  

end