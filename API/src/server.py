from flask import Flask
import json
from classes.financeClient import Client
from flask import request

app = Flask(__name__)

### Session-time variables & Building the Stocks Yield Dictionary ###
stocks = dict()
client = Client()

def getDividendValue(symbol):
    """ Building the API data using IEXCloud """
    if len(symbol) == 0:
        print("No symbol given to API call.")
    else:
        stocks.update( {symbol : client.requestStockDividend(symbol)} )

### HTTP Request Methods ###
@app.route('/')
def simpleRequest():
    """ Testing if connection to API is established """
    return "Server listening ..."

@app.route('/stocks', methods=['GET'])
def getStocks():
    """ Getting session-time stock data """

    symbol = request.args.get('symbol', default = '', type = str)

    getDividendValue(symbol)

    for item in stocks.items():
        print(f"{item}")

    return json.dumps(stocks)

if __name__ == '__main__':
    app.run()