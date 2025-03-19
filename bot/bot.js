const { Telegraf } = require('telegraf');
const { startHandler, panelHandler } = require('./commands');
const bot = new Telegraf(process.env.BOT_TOKEN);

// Start Command
bot.start(startHandler);

// Panel Command
bot.command('panel', panelHandler);

// Error Handling
bot.catch((err) => {
  console.error('Bot error:', err);
});

bot.launch();
console.log('NetBox Bot Started!');
