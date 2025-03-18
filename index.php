<?php
// index.php
?>

<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>ربات فروش کانفیگ v2rayng</title>
</head>
<body>
    <h1>ورود به ربات فروش کانفیگ v2rayng</h1>
    <form action="bot.php" method="POST">
        <label for="panel_url">URL پنل:</label>
        <input type="text" id="panel_url" name="panel_url" required><br><br>
        
        <label for="username">نام کاربری:</label>
        <input type="text" id="username" name="username" required><br><br>
        
        <label for="password">کلمه عبور:</label>
        <input type="password" id="password" name="password" required><br><br>
        
        <input type="submit" value="دریافت کانفیگ">
    </form>
</body>
</html>
