const axios = require('axios');

module.exports = {
  createXuiUser: async (telegramId, trafficGB = 100) => {
    try {
      const response = await axios.post(`${process.env.XUI_PANEL_URL}/api/inbounds/addClient`, {
        inboundId: '1',
        email: `user_${telegramId}@netbox`,
        limitIp: 1,
        totalGB: trafficGB,
        expireTime: Date.now() + 30 * 86400 * 1000 // 30 روز
      }, {
        auth: {
          username: process.env.XUI_USERNAME,
          password: process.env.XUI_PASSWORD
        }
      });
      return response.data;
    } catch (error) {
      console.error('X-UI Error:', error.response.data);
      throw new Error('خطا در ایجاد کاربر X-UI');
    }
  }
};
