<?php
require 'vendor/autoload.php';
use Telegram\Bot\Api;

// تنظیمات پایه
$telegram = new Api(getenv('BOT_TOKEN'));

// هندلر اصلی
$update = $telegram->getWebhookUpdate();

try {
    if ($update->getMessage()) {
        $message = $update->getMessage();
        $chat_id = $message->getChat()->getId();
        $text = $message->getText();

        // منو اصلی
        if ($text == '/start') {
            $telegram->sendMessage([
                'chat_id' => $chat_id,
                'text' => 'به ربات NetBox خوش آمدید!'
            ]);
        }
    }
} catch (Exception $e) {
    file_put_contents('error.log', $e->getMessage(), FILE_APPEND);
}
