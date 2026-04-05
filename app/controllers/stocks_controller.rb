class StocksController < ApplicationController
  def show
    @stock = Stock.fetch_or_create(params[:ticker].upcase)

    if @stock.nil?
      redirect_to root_path, alert: "Ticker not found. Please try again."
    else
      @valuation = ValuationService.new(@stock)
      @fundamentals = build_fundamentals(@stock)
      @analyst_ratings = build_analyst_ratings(@stock)
    end
  end

  def search
    ticker = params[:ticker].to_s.strip.upcase
    redirect_to stock_path(ticker)
  end
private

  def build_fundamentals(stock)
    raw = stock.raw_data
    [
      ["Market Cap", number_to_human(raw["MarketCapitalization"].to_i, units: { billion: "B", million: "M", thousand: "K" })],
      ["Revenue (TTM)", number_to_human(raw["RevenueTTM"].to_i, units: { billion: "B", million: "M" })],
      ["Gross Profit (TTM)", number_to_human(raw["GrossProfitTTM"].to_i, units: { billion: "B", million: "M" })],
      ["EBITDA", number_to_human(raw["EBITDA"].to_i, units: { billion: "B", million: "M" })],
      ["Forward P/E", raw["ForwardPE"]],
      ["PEG Ratio", raw["PEGRatio"]],
      ["Price to Sales", raw["PriceToSalesRatioTTM"]],
      ["Beta", raw["Beta"]],
      ["52W High", "$#{raw["52WeekHigh"]}"],
      ["52W Low", "$#{raw["52WeekLow"]}"],
      ["Dividend Yield", "#{(raw["DividendYield"].to_f * 100).round(2)}%"],
      ["Shares Outstanding", number_to_human(raw["SharesOutstanding"].to_i, units: { billion: "B", million: "M" })]
    ]
  end

  def build_analyst_ratings(stock)
    raw = stock.raw_data
    [
      ["Strong Buy", raw["AnalystRatingStrongBuy"], "#00c076"],
      ["Buy", raw["AnalystRatingBuy"], "#00d4aa"],
      ["Hold", raw["AnalystRatingHold"], "#666"],
      ["Sell", raw["AnalystRatingSell"], "#ff4d4d"],
      ["Strong Sell", raw["AnalystRatingStrongSell"], "#ff4d4d"]
    ]
  end
end