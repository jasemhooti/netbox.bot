<?php
$token = "6414210268:AAEL-RZiABoMzS_QY922hOQnpXcam9OgiF0"; // توکن ربات خود را اینجا وارد کنید
$admin_id = 5691972852; // آیدی عددی ادمین را اینجا وارد کنید

$website = "https://api.telegram.org/bot".$token;

$update = file_get_contents("php://input");
$update = json_decode($update, TRUE);

$chatId = $update["message"]["chat"]["id"];
$text = $update["message"]["text"];

if ($text == "/start") {
    $message = "به ربات فروش VPN خوش آمدید! لطفا حجم مورد نظر خود را انتخاب کنید:";
    $keyboard = json_encode([
        "keyboard" => [
            ["1GB", "5GB"],
            ["10GB", "20GB"]
        ],
        "resize_keyboard" => true
    ]);
    sendMessage($chatId, $message, $keyboard);
} elseif ($text == "1GB" || $text == "5GB" || $text == "10GB" || $text == "20GB") {
    $message = "لطفا مبلغ را به شماره کارت زیر واریز کنید و عکس رسید را ارسال نمایید:\n1234-5678-9012-3456";
    sendMessage($chatId, $message);
} elseif (isset($update["message"]["photo"])) {
    $message = "رسید شما دریافت شد. لطفا منتظر تایید ادمین باشید.";
    sendMessage($chatId, $message);
    $message_to_admin = "کاربر با آیدی $chatId رسید پرداخت ارسال کرده است.";
    sendMessage($admin_id, $message_to_admin);
} elseif ($text == "/confirm" && $chatId == $admin_id) {
    $message = "کانفیگ VPN برای کاربر ایجاد شد و ارسال گردید.";
    sendMessage($chatId, $message);
    // در اینجا کد اتصال به پنل x-ui و ایجاد کانفیگ قرار می‌گیرد
    // پس از ایجاد کانفیگ، آن را به کاربر ارسال کنید
}

function sendMessage($chatId, $message, $keyboard = null) {
    global $website;
    $url = $website."/sendMessage?chat_id=".$chatId."&text=".urlencode($message);
    if ($keyboard) {
        $url .= "&reply_markup=".$keyboard;
    }
    file_get_contents($url);
}
?>
