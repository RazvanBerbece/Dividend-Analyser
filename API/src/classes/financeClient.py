import requests

### Acts as a Client for our API ###
class Client:
    """ This downloads Stock Market data from the IEX Cloud API """
    def __init__(self):
        self.base_link = "https://cloud.iexapis.com/stable"
        self.key = "pk_c97e6a5a4ae0452c8a10f1f161b41434"

    def requestStockDividend(self, symbol):
        """ GET """
        reqURL = f"{self.base_link}" + "/stock/" + f"{symbol}" + f"/dividends/3m?token={self.key}"

        print(f"Requesting from : {reqURL}")

        received = requests.get(reqURL)
        
        print(f"Got response : {received.status_code}")

        """ Returns tuple (symbol, data) """
        return received.json()


