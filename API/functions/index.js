/* -------------- Requires & Port init -------------- */

require('dotenv').config();
const express = require('express');

const app = express();

const bodyParser = require('body-parser');
const cors = require('cors');

const Client = require('./classes/client.js');

/* -------------- Firebase Config & Init -------------- */

var firebase = require('firebase');

const config = {
  apiKey: process.env.FB_KEY,
  authDomain: "dividend-analyser.firebaseapp.com",
  databaseURL: "https://dividend-analyser.firebaseio.com",
  projectId: "dividend-analyser",
  storageBucket: "dividend-analyser.appspot.com",
  messagingSenderId: "427852493651",
  appId: "1:427852493651:web:a22d5a92393bbcba9627a6"
};

firebase.initializeApp(config);

const functions = require('firebase-functions');

/* -------------- Saved variables (per request) -------------- */

var savedFinancialData = [];

/* -------------- Cors() and body-parser -------------- */

app.use(cors());

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

/* -------------- CRUD -------------- */

app.get('/', (req, res) => { // Testing server is listening
    res.json({"message": "Hello, you accessed the server.", "result": true});
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


/* -------------- Uploading to Firebase Functions  -------------- */

exports.app = functions.https.onRequest(app);