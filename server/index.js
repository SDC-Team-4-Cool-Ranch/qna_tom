/* eslint-disable import/no-extraneous-dependencies */
require('dotenv').config();
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
// const path = require('path');
const router = require('./routes');

const app = express();
const { SV_PORT, LOADER_KEY } = process.env;

app.use(express.json());
app.use(cors());
app.use(morgan('dev'));

// loader-io
app.get(`/${LOADER_KEY}`, (req, res) => {
  res.status(200).send(LOADER_KEY);
});

app.use('/', router);

// serve static assets from front-end (if we had one)
// app.use(express.static(path.join(__dirname, '../client/dist')));

// listen on a port that's different from db
app.listen(SV_PORT);
console.log(`Server is listening at http://localhost:${SV_PORT}`);
