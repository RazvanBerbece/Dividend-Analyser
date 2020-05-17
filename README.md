# Dividend-Analyser
Application which uses an API made in JS (NodeJS), with a Client made in Swift. The Client uses the API to create a portofolio of shares for an user, displaying the total amount of money/year the user earns from dividends. Stock Data is gathered using IEX Cloud API.

# Tech Stack :

## API :
   * JavaScript ( NodeJS )
   > API access : https://us-central1-dividend-analyser.cloudfunctions.net/app
   
   ### API Requests :
   + " / " ( Testing API availability );
   + " /stocks/< STOCK SYMBOL HERE > " ( Returns JSON with the data required by the Client ).

   ### Also Used :
   * Firebase ( implemented )

## Client :
   * Swift ( UIKit )
   
   ### Also Used :
   * Firebase ( implemented )
   * Alamofire
   * SwiftyJSON 
   
# Contributors :
   1. Antonio Berbece
   2. Sergiu-Stefan Tomescu

testing new workflow
