# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# General application configuration
config :explorer,
  ecto_repos: [Explorer.Repo, Explorer.Repo.Account],
  token_functions_reader_max_retries: 3

config :explorer, Explorer.Counters.AverageBlockTime,
  enabled: true,
  period: :timer.minutes(10)

config :explorer, Explorer.ChainSpec.GenesisData, enabled: true

config :explorer, Explorer.Chain.Cache.BlockNumber, enabled: true

config :explorer, Explorer.Chain.Cache.AddressSum,
  enabled: true,
  ttl_check_interval: :timer.seconds(1)

config :explorer, Explorer.Chain.Cache.AddressSumMinusBurnt,
  enabled: true,
  ttl_check_interval: :timer.seconds(1)

cache_address_with_balances_update_interval = System.get_env("CACHE_ADDRESS_WITH_BALANCES_UPDATE_INTERVAL")

balances_update_interval =
  if cache_address_with_balances_update_interval do
    case Integer.parse(cache_address_with_balances_update_interval) do
      {integer, ""} -> integer
      _ -> nil
    end
  end

config :explorer, Explorer.Counters.AddressesWithBalanceCounter,
  enabled: false,
  enable_consolidation: true,
  update_interval_in_seconds: balances_update_interval || 30 * 60

config :explorer, Explorer.Counters.AddressesCounter,
  enabled: true,
  enable_consolidation: true,
  update_interval_in_seconds: balances_update_interval || 30 * 60

config :explorer, Explorer.Counters.AddressTransactionsGasUsageCounter,
  enabled: true,
  enable_consolidation: true

config :explorer, Explorer.Counters.AddressTokenUsdSum,
  enabled: true,
  enable_consolidation: true

config :explorer, Explorer.Chain.Cache.ContractsCounter,
  enabled: true,
  enable_consolidation: true,
  update_interval_in_seconds: 30 * 60

config :explorer, Explorer.Chain.Cache.NewContractsCounter,
  enabled: true,
  enable_consolidation: true,
  update_interval_in_seconds: 30 * 60

config :explorer, Explorer.Chain.Cache.VerifiedContractsCounter,
  enabled: true,
  enable_consolidation: true,
  update_interval_in_seconds: 30 * 60

config :explorer, Explorer.Chain.Cache.NewVerifiedContractsCounter,
  enabled: true,
  enable_consolidation: true,
  update_interval_in_seconds: 30 * 60

config :explorer, Explorer.Chain.Cache.TokenExchangeRate,
  enabled: true,
  enable_consolidation: true

config :explorer, Explorer.Counters.TokenHoldersCounter,
  enabled: true,
  enable_consolidation: true

config :explorer, Explorer.Counters.TokenTransfersCounter,
  enabled: true,
  enable_consolidation: true

config :explorer, Explorer.Counters.AddressTransactionsCounter,
  enabled: true,
  enable_consolidation: true

config :explorer, Explorer.Counters.AddressTokenTransfersCounter,
  enabled: true,
  enable_consolidation: true

config :explorer, Explorer.Counters.BlockBurnedFeeCounter,
  enabled: true,
  enable_consolidation: true

config :explorer, Explorer.Counters.BlockPriorityFeeCounter,
  enabled: true,
  enable_consolidation: true

bridge_market_cap_update_interval =
  if System.get_env("BRIDGE_MARKET_CAP_UPDATE_INTERVAL") do
    case Integer.parse(System.get_env("BRIDGE_MARKET_CAP_UPDATE_INTERVAL")) do
      {integer, ""} -> integer
      _ -> nil
    end
  end

config :explorer, Explorer.Counters.Bridge,
  enabled: if(System.get_env("SUPPLY_MODULE") === "TokenBridge", do: true, else: false),
  enable_consolidation: System.get_env("DISABLE_BRIDGE_MARKET_CAP_UPDATER") !== "true",
  update_interval_in_seconds: bridge_market_cap_update_interval || 30 * 60,
  disable_lp_tokens_in_market_cap: System.get_env("DISABLE_LP_TOKENS_IN_MARKET_CAP") == "true"

config :explorer, Explorer.Chain.Cache.GasUsage,
  enabled: System.get_env("CACHE_ENABLE_TOTAL_GAS_USAGE_COUNTER") == "true"

config :explorer, Explorer.Chain.Block.Reward,
  validators_contract_address: System.get_env("VALIDATORS_CONTRACT"),
  keys_manager_contract_address: System.get_env("KEYS_MANAGER_CONTRACT")

if System.get_env("POS_STAKING_CONTRACT") do
  config :explorer, Explorer.Staking.ContractState,
    enabled: true,
    staking_contract_address: System.get_env("POS_STAKING_CONTRACT"),
    eth_subscribe_max_delay: System.get_env("POS_ETH_SUBSCRIBE_MAX_DELAY", "60"),
    eth_blocknumber_pull_interval: System.get_env("POS_ETH_BLOCKNUMBER_PULL_INTERVAL", "500")
else
  config :explorer, Explorer.Staking.ContractState, enabled: false
end

case System.get_env("SUPPLY_MODULE") do
  "TokenBridge" ->
    config :explorer, supply: Explorer.Chain.Supply.TokenBridge

  "rsk" ->
    config :explorer, supply: Explorer.Chain.Supply.RSK

  _ ->
    :ok
end

if System.get_env("SOURCE_MODULE") == "TokenBridge" do
  config :explorer, Explorer.ExchangeRates.Source, source: Explorer.ExchangeRates.Source.TokenBridge
end

config :explorer, Explorer.Integrations.EctoLogger, query_time_ms_threshold: :timer.seconds(2)

config :explorer, Explorer.Tags.AddressTag.Cataloger, enabled: true

config :explorer, Explorer.Chain.Cache.MinMissingBlockNumber, enabled: System.get_env("DISABLE_WRITE_API") != "true"

config :explorer, Explorer.Repo, migration_timestamps: [type: :utc_datetime_usec]

config :explorer, Explorer.Tracer,
  service: :explorer,
  adapter: SpandexDatadog.Adapter,
  trace_key: :blockscout

config :explorer,
  solc_bin_api_url: "https://solc-bin.ethereum.org"

config :logger, :explorer,
  # keep synced with `config/config.exs`
  format: "$dateT$time $metadata[$level] $message\n",
  metadata:
    ~w(application fetcher request_id first_block_number last_block_number missing_block_range_count missing_block_count
       block_number step count error_count shrunk import_id transaction_id)a,
  metadata_filter: [application: :explorer]

config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :ecto,
  tracer: Explorer.Tracer,
  otp_app: :explorer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
