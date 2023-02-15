#!/usr/local/opt/python@3.8/bin/python3

import yfinance as yf
import datetime

# specify the stock symbol and date range
symbol = 'AAPL'
start = datetime.datetime(2000, 1, 1)
end = datetime.datetime.now()

# download the stock data
df = yf.download(symbol, start=start, end=end)

# save the data to a CSV file
df.to_csv(f'{symbol}_prices.csv')

