from flask import Flask
import json

app = Flask(__name__)

### Session-time variables ###
stocks = []

### HTTP Request Methods ###
@app.route('/')
def simpleRequest():
    """ Testing if connection can be made to API """
    return "API listening ..."

@app.route('/stocks')
def getStocks():
    """ Getting session-time stock data """
    return json.dumps(stocks)

if __name__ == '__main__':
    app.run()