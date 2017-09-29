/**
 * Sundry database models
 */

import Sequelize = require('sequelize');

export const sequelize = new Sequelize(
  process.env.DATABASE_URL || 'postgres://localhost/uber', {
    logging: false,
  });

export const Decision = sequelize.define('decision', {
  type: Sequelize.STRING, // Maps to Ink variable name
  value: Sequelize.STRING, // The player's value
  difficulty: Sequelize.STRING, // Game difficulty chosen
  meta: Sequelize.JSONB, // JSON blob containing all the other variables for later analysis
}, {
  timestamps: true,
  updatedAt: false, // Only add createdAt column
});

export const Result = sequelize.define('result', {
  difficulty: Sequelize.STRING, // Game difficulty chosen
  hourlyWage: Sequelize.FLOAT,
  revenue: Sequelize.INTEGER,
  income: Sequelize.INTEGER,
  expenses: Sequelize.INTEGER,
  meta: Sequelize.JSONB,
}, {
  timestamps: true,
  updatedAt: false, // Only add createdAt column
});
