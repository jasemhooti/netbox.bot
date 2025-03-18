<?php
// bot.php

// تنظیمات اولیه
$telegram_api = "https://api.telegram.org/bot<Your-Bot-Token>/";
$chat_id = "<Your-Chat-ID>";

// اتصال به پنل ثنایی یا علیرضا
function getPanelConfig($panel_url, $username, $password) {
    // اینجا باید درخواست API به پنل ثنایی یا علیرضا ارسال شود
    // و کانفیگ لازم دریافت گردد
    // برای مثال، از cURL برای ارتباط با API پنل استفاده می‌کنیم
    $ch = curl_init($panel_url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, [
        'username' => $username,
        'password' => $password,
    ]);
    $response = curl_exec($ch);
    curl_close($ch);
    
    return $response;
}

// ساخت کانفیگ برای v2rayng
function createV2rayConfig($panel_data) {
    // اینجا بر اساس داده‌های پنل، کانفیگ v2rayng ساخته می‌شود
    $config = [
        "v" => "2",
        "ps" => "v2rayng",
        "add" => $panel_data['server'],
        "port" => $panel_data['port'],
        "id" => $panel_data['uuid'],
        "aid" => "64",
        "net" => "ws",
        "type" => "none",
        "host" => "example.com",
        "path" => "/v2ray"
    ];
    
    return json_encode($config, JSON_PRETTY_PRINT);
}

// ارسال پیام به تلگرام
function sendTelegramMessage($message) {
    global $telegram_api, $chat_id;
    
    $url = $telegram_api . "sendMessage?chat_id=" . $chat_id . "&text=" . urlencode($message);
    file_get_contents($url);
}

// ارسال کانفیگ به تلگرام
function sendV2rayConfigToTelegram($config) {
    $message = "کانفیگ v2rayng شما:\n" . $config;
    sendTelegramMessage($message);
}

// عملکرد اصلی ربات
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $panel_url = $_POST['panel_url'];
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    // دریافت داده‌های پنل
    $panel_data = json_decode(getPanelConfig($panel_url, $username, $password), true);
    
    // ساخت کانفیگ v2rayng
    $config = createV2rayConfig($panel_data);
    
    // ارسال کانفیگ به تلگرام
    sendV2rayConfigToTelegram($config);
}
?>
