require('dotenv').config();
var request = require('request');

/* Acts as client for the API, getting data from IEX Cloud through a HTTP request */
class Client {

    constructor() {
        this.base_link = "https://cloud.iexapis.com/stable";
        this.key = process.env.IEX_KEY;
    }

    FinancialData(symbol, numberStocks, callback) { // getting data from IEX Cloud and returning it as a list of values

      /* IEX Cloud Batch Call for Dividends and Logo */
      const finalLinkData = this.base_link + "/stock/" + "market/" + "batch?&types=dividends,logo&symbols=" + symbol + "&range=1y&token=" + this.key;

      var optionsCore = { // core request made with these options
        url: finalLinkData,
        method: "get"
      };
      
      /* Request for core data : stock name, stock dividend, etc */
      request(optionsCore, (error, response, body) => {

        if (error) { 
          return callback(null, error);
        }
        else {

          var result = JSON.parse(body);

          // financial data values
          const logoURL = result[`${symbol}`].logo.url;
          const dividendValue = result[`${symbol}`].dividends[0].amount;
          const cashValue = result[`${symbol}`].dividends[0].currency;
          const frequencyValue = result[`${symbol}`].dividends[0].frequency;

          var financialArray = []; // contains all relevant values selected above

          financialArray.push(symbol);
          financialArray.push(dividendValue * parseFloat(numberStocks));
          financialArray.push(cashValue);
          financialArray.push(frequencyValue);
          financialArray.push(parseFloat(numberStocks));
          financialArray.push(logoURL);

          return callback(financialArray, false);

        }

      });

    }

}

module.exports = Client; // so it can be used externally (on the NodeJS API)