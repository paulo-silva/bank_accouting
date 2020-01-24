defmodule BankAccounting.Services.Authenticator do
  @seed System.get_env("AUTH_SEED", "user token")
  @secret System.get_env("AUTH_SECRET", "CHANGE_ME_k7kTxvFAgeBvAVA0OR1vkPbTi8mZ5m")
  @one_day_in_seconds 86400

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> get_token_from_header(auth_header)
      _ -> {:error, :missing_auth_header}
    end
  end

  defp get_token_from_header(auth_header) do
    {:ok, reg} = Regex.compile("Bearer\:?\s+(.*)$", "i")

    case Regex.run(reg, auth_header) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> {:error, "token not found"}
    end
  end

  def generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: @one_day_in_seconds)
  end

  def verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token, max_age: @one_day_in_seconds) do
      {:ok, _id} -> {:ok, token}
      error -> error
    end
  end
end
