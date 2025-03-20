<?php

class Database
{
    private $connection;

    public function __construct()
    {
        $this->connection = new mysqli('localhost', 'username', 'password', 'database_name');
        if ($this->connection->connect_error) {
            die('Connection failed: ' . $this->connection->connect_error);
        }
    }

    public function query($sql)
    {
        return $this->connection->query($sql);
    }

    public function close()
    {
        $this->connection->close();
    }
}
?>
