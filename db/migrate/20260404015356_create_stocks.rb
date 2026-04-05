class CreateStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :stocks do |t|
      t.string :ticker
      t.string :name
      t.string :sector
      t.string :industry
      t.string :exchange
      t.string :country
      t.bigint :market_cap
      t.decimal :pe_ratio
      t.decimal :eps
      t.decimal :revenue_growth
      t.decimal :earnings_growth
      t.decimal :profit_margin
      t.decimal :roe
      t.decimal :price_to_book
      t.decimal :dividend_yield
      t.decimal :week_52_high
      t.decimal :week_52_low
      t.jsonb :raw_data
      t.datetime :last_fetched_at

      t.timestamps
    end
    add_index :stocks, :ticker, unique: true
  end
end
