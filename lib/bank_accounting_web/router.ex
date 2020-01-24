defmodule BankAccountingWeb.Router do
  use BankAccountingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankAccountingWeb do
    pipe_through :api

    scope "auth" do
      post "/sign_in", AuthController, :create
      delete "/sign_out", AuthController, :delete
    end
  end

  scope "/", BankAccountingWeb do
    pipe_through :api

    resources "/accounts", AccountController, only: [:index, :show, :create, :update, :delete] do
      get "/balance", Account.BalanceController, :show
    end

    resources "/transfers", TransferController, only: [:create]
  end
end
