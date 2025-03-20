<?php

require_once 'config/config.php';
require_once 'Database.php';

class Bot
{
    private $telegram;

    public function __construct()
    {
        $this->telegram = new \Longman\TelegramBot\Telegram(BOT_TOKEN, 'MyBot');
    }

    public function handle()
    {
        $this->telegram->handle();
    }

    public function sendMessage($chat_id, $text)
    {
        $data = [
            'chat_id' => $chat_id,
            'text' => $text
        ];

        return \Longman\TelegramBot\Request::sendMessage($data);
    }
}
?>
