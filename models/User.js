const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const User = sequelize.define('User', {
  telegramId: {
    type: DataTypes.BIGINT,
    unique: true,
    allowNull: false
  },
  trafficLimit: {
    type: DataTypes.INTEGER,
    defaultValue: 100 // GB
  },
  expiresAt: {
    type: DataTypes.DATE,
    allowNull: false
  },
  isAdmin: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
});

module.exports = User;
