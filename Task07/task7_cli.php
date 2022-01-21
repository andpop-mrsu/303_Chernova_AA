<?php

$pdo = new PDO('sqlite:dentistry.db');

$query = "SELECT id, last_name, first_name, middle_name FROM dentists";
$statement = $pdo->query($query);
$dentists = $statement->fetchAll();
$statement->closeCursor();
echo str_repeat('-', 50) . PHP_EOL;
echo 'Все имеющиеся в базе врачи:' . PHP_EOL;
foreach ($dentists as $dentist) {
    echo "$dentist[id] $dentist[last_name] $dentist[first_name] $dentist[middle_name]\n";
}
echo str_repeat('-', 50) . PHP_EOL;

$dentist_number = readline("Введите номер врача: ");

if ($dentist_number == '') {
    $check = 0;
} else {
    $dentists_id = array_column($dentists, 'id');
    $check = in_array($dentist_number, $dentists_id) ? 1 : 2;
}

switch ($check) {
    case 0:
    {
        $query = '
        SELECT d.id, last_name, first_name, middle_name, appointment_time, start_time, end_time,  title, price, status
            FROM dentists d 
            JOIN appointments a ON d.id = a.dentist_id 
            JOIN services s ON a.service_id = s.id 
            JOIN appointment_statuses "as" on a.appointment_status_id = "as".id
            ORDER BY last_name, appointment_time';
        $statement = $pdo->query($query);
        $services = $statement->fetchAll();
        echo str_repeat('-', 100) . PHP_EOL;
        echo 'Все записи к врачам:' . PHP_EOL;
        foreach ($services as $service) {
            $time = is_null($service['start_time']) || is_null($service['end_time']) ?
                $service['appointment_time'] : "с $service[start_time] до $service[end_time]";

            echo "$service[id] $service[last_name] $service[first_name] $service[middle_name] " .
                "$service[status] $time $service[title] $service[price]р\n";
        }
        echo str_repeat('-', 100) . PHP_EOL;
        $statement->closeCursor();
        break;
    }
    case 1:
    {
        $query = '
        SELECT d.id, last_name, first_name, middle_name, appointment_time, start_time, end_time,  title, price, status
            FROM dentists d 
            JOIN appointments a ON d.id = a.dentist_id 
            JOIN services s ON a.service_id = s.id 
            JOIN appointment_statuses "as" on a.appointment_status_id = "as".id
            WHERE d.id == :id
            ORDER BY last_name, start_time, appointment_time';
        $statement = $pdo->prepare($query);
        $statement->execute(['id' => $dentist_number]);
        $services = $statement->fetchAll();
        echo str_repeat('-', 100) . PHP_EOL;
        echo "Записи к врачу с номером $dentist_number:" . PHP_EOL;
        foreach ($services as $service) {
            $time = is_null($service['start_time']) || is_null($service['end_time']) ?
                $service['appointment_time'] : "с $service[start_time] до $service[end_time]";

            echo "$service[id] $service[last_name] $service[first_name] $service[middle_name] " .
                "$service[status] $time $service[title] $service[price]р\n";
        }
        echo str_repeat('-', 100) . PHP_EOL;
        $statement->closeCursor();
        break;
    }
    default:
        echo 'Врача с таким номером не существует' . PHP_EOL;
        break;
}
