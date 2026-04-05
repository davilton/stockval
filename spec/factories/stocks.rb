FactoryBot.define do
  factory :stock do
    ticker { "AAPL" }
    name { "Apple Inc" }
    sector { "Technology" }
    industry { "Consumer Electronics" }
    exchange { "NASDAQ" }
    market_cap { 3_000_000_000_000 }
    pe_ratio { 28.5 }
    eps { 6.43 }
    profit_margin { 0.25 }
    roe { 0.45 }
    revenue_growth { 0.08 }
    earnings_growth { 0.12 }
    price_to_book { 2.1 }
    dividend_yield { 0.005 }
    last_fetched_at { Time.current }
  end
end