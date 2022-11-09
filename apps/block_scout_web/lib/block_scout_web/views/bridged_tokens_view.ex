defmodule BlockScoutWeb.BridgedTokensView do
  use BlockScoutWeb, :view

  alias BlockScoutWeb.ChainView
  alias Explorer.Chain
  alias Explorer.Chain.{Address, Token}

  def decimals?(%Token{decimals: nil}), do: false
  def decimals?(%Token{decimals: _}), do: true

  def token_display_name(%Token{name: nil}), do: ""

  def token_display_name(%Token{name: name}), do: name

  def bridged_token_usd_cap(bridged_token, token) do
    if bridged_token.custom_cap do
      bridged_token.custom_cap
    else
      if bridged_token.exchange_rate && token.total_supply do
        Decimal.mult(bridged_token.exchange_rate, divide_decimals(token.total_supply, token.decimals))
      else
        Decimal.new(0)
      end
    end
  end
end
