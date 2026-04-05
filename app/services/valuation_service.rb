class ValuationService
  PILLARS = %i[
    revenue_growth
    earnings_growth
    profit_margin
    return_on_equity
    pe_ratio
    price_to_book
    eps_positive
    dividend_yield
  ].freeze

  def initialize(stock)
    @stock = stock
  end

  def score
    PILLARS.sum { |pillar| send("score_#{pillar}") }
  end

  def breakdown
    PILLARS.each_with_object({}) do |pillar, hash|
      hash[pillar] = send("score_#{pillar}")
    end
  end

  def rating
    case score
    when 14..16 then { label: "Strong Buy", color: "positive" }
    when 10..13 then { label: "Buy", color: "positive" }
    when 6..9   then { label: "Watch", color: "warning" }
    else             { label: "Avoid", color: "danger" }
    end
  end

  private

  def score_revenue_growth
    val = @stock.revenue_growth.to_f
    if val >= 0.15 then 2
    elsif val >= 0.05 then 1
    else 0
    end
  end

  def score_earnings_growth
    val = @stock.earnings_growth.to_f
    if val >= 0.15 then 2
    elsif val >= 0.05 then 1
    else 0
    end
  end

  def score_profit_margin
    val = @stock.profit_margin.to_f
    if val >= 0.20 then 2
    elsif val >= 0.10 then 1
    else 0
    end
  end

  def score_return_on_equity
    val = @stock.roe.to_f
    if val >= 0.20 then 2
    elsif val >= 0.10 then 1
    else 0
    end
  end

  def score_pe_ratio
    val = @stock.pe_ratio.to_f
    return 0 if val <= 0
    if val <= 15 then 2
    elsif val <= 25 then 1
    else 0
    end
  end

  def score_price_to_book
    val = @stock.price_to_book.to_f
    return 0 if val <= 0
    if val <= 1.5 then 2
    elsif val <= 3.0 then 1
    else 0
    end
  end

  def score_eps_positive
    @stock.eps.to_f > 0 ? 2 : 0
  end

  def score_dividend_yield
    val = @stock.dividend_yield.to_f
    if val >= 0.03 then 2
    elsif val > 0 then 1
    else 0
    end
  end
end