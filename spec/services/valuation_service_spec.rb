require "rails_helper"

RSpec.describe ValuationService do
  describe "#score" do
    context "with a strong stock" do
      let(:stock) { build(:stock, profit_margin: 0.25, roe: 0.45, pe_ratio: 14, eps: 6.43, revenue_growth: 0.20, earnings_growth: 0.20, price_to_book: 1.2, dividend_yield: 0.03) }
      let(:service) { described_class.new(stock) }

      it "returns a high score" do
        expect(service.score).to be >= 12
      end
    end

    context "with a weak stock" do
      let(:stock) { build(:stock, profit_margin: 0.02, roe: 0.03, pe_ratio: 80, eps: -1.0, revenue_growth: -0.05, earnings_growth: -0.10, price_to_book: 8.0, dividend_yield: 0.0) }
      let(:service) { described_class.new(stock) }

      it "returns a low score" do
        expect(service.score).to be <= 4
      end
    end
  end

  describe "#rating" do
    let(:stock) { build(:stock) }
    let(:service) { described_class.new(stock) }

    it "returns a hash with label and color" do
      expect(service.rating).to include(:label, :color)
    end

    it "returns Strong Buy for score 14-16" do
      allow(service).to receive(:score).and_return(15)
      expect(service.rating[:label]).to eq("Strong Buy")
    end

    it "returns Avoid for score below 6" do
      allow(service).to receive(:score).and_return(3)
      expect(service.rating[:label]).to eq("Avoid")
    end
  end

  describe "#breakdown" do
    let(:stock) { build(:stock) }
    let(:service) { described_class.new(stock) }

    it "returns a score for each pillar" do
      breakdown = service.breakdown
      expect(breakdown.keys).to match_array(ValuationService::PILLARS)
    end

    it "each pillar score is 0, 1, or 2" do
      service.breakdown.each_value do |score|
        expect(score).to be_between(0, 2)
      end
    end
  end
end