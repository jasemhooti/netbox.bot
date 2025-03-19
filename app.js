const express = require('express');
const app = express();
require('dotenv').config();

// Database
require('./config/database');

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.set('view engine', 'ejs');

// Routes
app.use('/', require('./routes/web'));
app.use('/api', require('./routes/api'));

// Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`NetBox Panel running on port ${PORT}`);
});
