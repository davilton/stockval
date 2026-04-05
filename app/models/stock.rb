class Stock < ApplicationRecord
  def self.fetch_or_create(ticker)
    stock = find_by(ticker: ticker.upcase)

    if stock.nil? || stock.last_fetched_at < 24.hours.ago
      data = ::StockService.new.profile(ticker.upcase)
      return nil if data.blank? || data["Symbol"].blank?

      stock = find_or_initialize_by(ticker: data["Symbol"])
      stock.assign_attributes(
        name: data["Name"],
        sector: data["Sector"],
        industry: data["Industry"],
        exchange: data["Exchange"],
        country: data["Country"],
        market_cap: data["MarketCapitalization"],
        pe_ratio: data["PERatio"],
        eps: data["EPS"],
        revenue_growth: data["QuarterlyRevenueGrowthYOY"],
        earnings_growth: data["QuarterlyEarningsGrowthYOY"],
        profit_margin: data["ProfitMargin"],
        roe: data["ReturnOnEquityTTM"],
        price_to_book: data["PriceToBookRatio"],
        dividend_yield: data["DividendYield"],
        raw_data: data,
        last_fetched_at: Time.current
      )
      stock.save!
    end

    stock
  end
end