from flask import Flask
from flask import jsonify
import yfinance as yf

app = Flask(__name__)

### Session-time variables ###
stocks = dict()

def buildStockList():
    """ Building the API data using yfinance """

    data = yf.download("AAPL SPG MSFT", start="2009-01-01", group_by="ticker")

    companies = ['MSFT', 'AAPL', 'SPG']
    
    for company in companies:
        stocks.update( {company : data[company]} )

### HTTP Request Methods ###
@app.route('/')
def simpleRequest():
    """ Testing if connection can be made to API """
    return "API listening ..."

@app.route('/stocks', methods=['GET'])
def getStocks():
    """ Getting session-time stock data """
    buildStockList()
    for item in stocks.items():
        print(item)
    return "Output printed"

if __name__ == '__main__':
    app.run()