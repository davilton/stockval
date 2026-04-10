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
    stock_data = stock.raw_data
    [
      ["Market Cap", number_to_human(stock_data["MarketCapitalization"].to_i, units: { billion: "B", million: "M", thousand: "K" })],
      ["Revenue (TTM)", number_to_human(stock_data["RevenueTTM"].to_i, units: { billion: "B", million: "M" })],
      ["Gross Profit (TTM)", number_to_human(stock_data["GrossProfitTTM"].to_i, units: { billion: "B", million: "M" })],
      ["EBITDA", number_to_human(stock_data["EBITDA"].to_i, units: { billion: "B", million: "M" })],
      ["Forward P/E", stock_data["ForwardPE"]],
      ["PEG Ratio", stock_data["PEGRatio"]],
      ["Price to Sales", stock_data["PriceToSalesRatioTTM"]],
      ["Beta", stock_data["Beta"]],
      ["52W High", "$#{stock_data["52WeekHigh"]}"],
      ["52W Low", "$#{stock_data["52WeekLow"]}"],
      ["Dividend Yield", "#{(stock_data["DividendYield"].to_f * 100).round(2)}%"],
      ["Shares Outstanding", number_to_human(stock_data["SharesOutstanding"].to_i, units: { billion: "B", million: "M" })]
    ]
  end

  def build_analyst_ratings(stock)
    stock_data = stock.raw_data
    [
      ["Strong Buy", stock_data["AnalystRatingStrongBuy"], "#00c076"],
      ["Buy", stock_data["AnalystRatingBuy"], "#00d4aa"],
      ["Hold", stock_data["AnalystRatingHold"], "#666"],
      ["Sell", stock_data["AnalystRatingSell"], "#ff4d4d"],
      ["Strong Sell", stock_data["AnalystRatingStrongSell"], "#ff4d4d"]
    ]
  end
end