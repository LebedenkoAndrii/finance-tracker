class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    crypto = Alphavantage::Crypto.new(symbol: ticker_symbol, market: 'USD')
    
    daily_data = crypto.daily
    puts "Daily data: #{daily_data.inspect}"
    
    unless daily_data&.time_series_digital_currency_daily
      raise "Не вдалося отримати дані для #{ticker_symbol}. Перевірте API-ключ або символ."
    end
    
    last_day = daily_data.time_series_digital_currency_daily.first
    
    price = last_day[1]['close'].to_f
    name = daily_data.meta_data.digital_currency_name

    { ticker: ticker_symbol, name: name, price: price }

  rescue StandardError => e
    Rails.logger.error("Error fetching stock data: #{e.message}")
    nil
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end