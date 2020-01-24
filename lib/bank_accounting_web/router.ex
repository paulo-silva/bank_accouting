defmodule BankAccountingWeb.Router do
  use BankAccountingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug BankAccountingWeb.Plugs.Authenticate
  end

  scope "/api", BankAccountingWeb do
    pipe_through :api

    scope "/" do
      pipe_through :authenticate

      resources "/accounts", AccountController, only: [:index, :show, :create, :update, :delete] do
        get "/balance", Account.BalanceController, :show
      end

      resources "/transfers", TransferController, only: [:create]
    end

    scope "/auth" do
      post "/sign_in", AuthController, :create
      delete "/sign_out", AuthController, :delete
    end
  end
end
