defmodule BankAccountingWeb.Router do
  use BankAccountingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankAccountingWeb do
    pipe_through :api
  end

  scope "/", BankAccountingWeb do
    pipe_through :api

    resources "/accounts", AccountController, only: [:index, :show, :create, :update, :delete]
  end
end
