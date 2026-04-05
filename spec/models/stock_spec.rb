require "rails_helper"

RSpec.describe Stock do
  describe ".fetch_or_create" do
    let(:api_response) do
      {
        "Symbol" => "TSLA",
        "Name" => "Tesla Inc",
        "Sector" => "Consumer Cyclical",
        "Industry" => "Auto Manufacturers",
        "Exchange" => "NASDAQ",
        "Country" => "USA",
        "MarketCapitalization" => "800000000000",
        "PERatio" => "60.5",
        "EPS" => "4.30",
        "QuarterlyRevenueGrowthYOY" => "0.08",
        "QuarterlyEarningsGrowthYOY" => "0.12",
        "ProfitMargin" => "0.15",
        "ReturnOnEquityTTM" => "0.28",
        "PriceToBookRatio" => "12.5",
        "DividendYield" => "0.0"
      }
    end

    before do
      allow_any_instance_of(StockService).to receive(:profile).and_return(api_response)
    end

    context "when stock does not exist" do
      it "creates a new stock record" do
        expect { Stock.fetch_or_create("TSLA") }.to change(Stock, :count).by(1)
      end

      it "returns a stock with the correct ticker" do
        stock = Stock.fetch_or_create("TSLA")
        expect(stock.ticker).to eq("TSLA")
      end

      it "maps API fields correctly" do
        stock = Stock.fetch_or_create("TSLA")
        expect(stock.name).to eq("Tesla Inc")
        expect(stock.pe_ratio).to eq(60.5)
        expect(stock.eps).to eq(4.30)
      end
    end

    context "when stock exists and is fresh" do
      let!(:existing) { create(:stock, ticker: "TSLA", last_fetched_at: 1.hour.ago) }

      it "does not hit the API" do
        expect_any_instance_of(StockService).not_to receive(:profile)
        Stock.fetch_or_create("TSLA")
      end

      it "returns the existing record" do
        stock = Stock.fetch_or_create("TSLA")
        expect(stock.id).to eq(existing.id)
      end
    end

    context "when stock exists but is stale" do
      let!(:stale) { create(:stock, ticker: "TSLA", last_fetched_at: 25.hours.ago) }

      it "hits the API again" do
        expect_any_instance_of(StockService).to receive(:profile).and_return(api_response)
        Stock.fetch_or_create("TSLA")
      end

      it "updates the existing record" do
        Stock.fetch_or_create("TSLA")
        expect(stale.reload.last_fetched_at).to be > 1.minute.ago
      end
    end

    context "when API returns blank data" do
      before do
        allow_any_instance_of(StockService).to receive(:profile).and_return({})
      end

      it "returns nil" do
        expect(Stock.fetch_or_create("INVALID")).to be_nil
      end
    end
  end
end