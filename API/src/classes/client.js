var request = require('request');

/* Acts as client for the API, getting data from IEX Cloud through a HTTP request */
class Client {

    constructor() {
        this.base_link = "https://cloud.iexapis.com/stable";
        this.key = "pk_c97e6a5a4ae0452c8a10f1f161b41434";
    }

    FinancialData(symbol, callback) { // getting data from IEX Cloud and returning it as a list of values

      const finalLink = this.base_link + "/stock/" + symbol + "/dividends/3m?token=" + this.key;

      var options = { // request made with these options
        url: finalLink,
        method: "get"
      };

      request(options, (error, response, body) => {

        if (error) { 
          return callback(null, error);
        }
        else {

          var result = JSON.parse(body);

          // financial data values
          const dividendValue = result[0].amount;
          const cashValue = result[0].currency;
          const frequencyValue = result[0].frequency;

          const financialArray = [symbol, dividendValue, cashValue, frequencyValue] // contains all relevant values selected above

          return callback(financialArray, false); // returning the response, which is found in body

        }

      });

    }

}

module.exports = Client; // so it can be used externally (on the NodeJS API)