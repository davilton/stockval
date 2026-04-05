class StockService
  BASE_URL = "https://www.alphavantage.co/query"

  def initialize
    @api_key = Rails.application.credentials.alpha_vantage[:api_key]
    @conn = Faraday.new do |f|
      f.response :json
      f.adapter Faraday.default_adapter
    end
  end

  def search(query)
    get(function: "SYMBOL_SEARCH", keywords: query)
  end

  def profile(ticker)
    get(function: "OVERVIEW", symbol: ticker)
  end

  def income_statement(ticker)
    get(function: "INCOME_STATEMENT", symbol: ticker)
  end

  def balance_sheet(ticker)
    get(function: "BALANCE_SHEET", symbol: ticker)
  end

  def cash_flow(ticker)
    get(function: "CASH_FLOW", symbol: ticker)
  end

  def quote(ticker)
    get(function: "GLOBAL_QUOTE", symbol: ticker)
  end
  
  private

  def get(params = {})
    response = @conn.get(BASE_URL, params.merge(apikey: @api_key))
    response.body
  rescue Faraday::Error => e
    Rails.logger.error "Alpha Vantage API error: #{e.message}"
    nil
  end
end