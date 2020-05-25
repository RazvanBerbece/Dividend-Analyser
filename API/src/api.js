/* -------------- Requires & Port init -------------- */

require('dotenv').config();
const express = require('express');

const app = express();
const port = 3000;

const bodyParser = require('body-parser');
const cors = require('cors');

const Client = require('./classes/client.js');

/* -------------- Saved variables (per request) -------------- */

var savedFinancialData = [];

/* -------------- Cors() and body-parser -------------- */

app.use(cors());

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

/* -------------- CRUD -------------- */

app.get('/', (req, res) => { // Testing server is listening
    res.send('Server listening ...')
});

app.get('/stocks/:symbol', (req, res) => { // Getting the list of all required stocks

	let client = new Client(); // this will download the requested financial data

	let result = client.FinancialData(req.params.symbol, req.query.number, (err, resp) => { // callback function

		if (err) { // display error
			res.send(err);
		}
		else { // successfully got data from Client request
			res.send(resp);
		}
	});

})

/* -------------- Listening -------------- */

app.listen(port, () => console.log(`Server listening on ${port} ...`));