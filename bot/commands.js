const { generateUserPanelLink } = require('../services/userService');

module.exports = {
  startHandler: async (ctx) => {
    const inviteCode = ctx.message.text.split(' ')[1];
    await ctx.reply(`🚀 به ربات NetBox خوش آمدید!\nلینک پنل کاربری: ${await generateUserPanelLink(ctx.from.id)}`);
  },

  panelHandler: async (ctx) => {
    await ctx.reply('🔒 در حال انتقال به پنل کاربری...');
    const panelUrl = await generateUserPanelLink(ctx.from.id);
    await ctx.reply(`پنل کاربری شما: ${panelUrl}`);
  }
};
