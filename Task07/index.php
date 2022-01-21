<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Стоматологическая клиника</title>
</head>
<body>

<?php
$pdo = new PDO('sqlite:dentistry.db');

$query = "SELECT id, last_name, first_name, middle_name FROM dentists";
$statement = $pdo->query($query);
$dentists = $statement->fetchAll();
$statement->closeCursor();
?>

<h3>Выберите номер врача:</h3>
<form action="" method="POST">
    <label>
        <select style="width: 300px;" name="select_id">
            <option value=<?= null ?>>
                Все врачи клиники
            </option>
            <?php foreach ($dentists as $dentist): ?>
                <option value=<?= $dentist['id'] ?>> <?= $dentist['id'] ?> </option>
            <?php endforeach; ?>
        </select>
    </label>
    <button type="submit">Выбрать врача</button>
</form>

<?php
$id = isset($_POST['select_id']) ? (int)$_POST['select_id'] : 0;
if ($id == 0) {
    $query = '
        SELECT d.id, last_name, first_name, middle_name, appointment_time, start_time, end_time,  title, price, status
            FROM dentists d 
            JOIN appointments a ON d.id = a.dentist_id 
            JOIN services s ON a.service_id = s.id 
            JOIN appointment_statuses "as" on a.appointment_status_id = "as".id
            ORDER BY last_name, appointment_time';
    $statement = $pdo->query($query);
} else {
    $query = '
        SELECT d.id, last_name, first_name, middle_name, appointment_time, start_time, end_time,  title, price, status
            FROM dentists d 
            JOIN appointments a ON d.id = a.dentist_id 
            JOIN services s ON a.service_id = s.id 
            JOIN appointment_statuses "as" on a.appointment_status_id = "as".id
            WHERE d.id == :id
            ORDER BY last_name, start_time, appointment_time';
    $statement = $pdo->prepare($query);
    $statement->execute(['id' => $id]);
}
$services = $statement->fetchAll();
$statement->closeCursor()
?>

<h1></h1>
<table class="workers-table" width="100%" border="1.5" cellpadding="5" cellspacing="0">
    <tr class="table-header">
        <th>Номер</th>
        <th>Фамилия</th>
        <th>Имя</th>
        <th>Отчество</th>
        <th>Статус</th>
        <th>Время записи</th>
        <th>Название услуги</th>
        <th>Цена</th>
    </tr>
    <?php foreach ($services as $service): ?>
        <tr>
            <td align="center"><?= $service['id'] ?></td>
            <td align="center"><?= $service['last_name'] ?></td>
            <td align="center"><?= $service['first_name'] ?></td>
            <td align="center"><?= $service['middle_name'] ?></td>
            <td align="center"><?= $service['status'] ?></td>
            <td align="center"><?= is_null($service['start_time']) || is_null($service['end_time']) ?
                    $service['appointment_time'] : 'с ' . $service['start_time'] . ' до ' . $service['end_time']; ?></td>
            <td align="center"><?= $service['title'] ?></td>
            <td align="center"><?= $service['price'] . 'р.' ?></td>
        </tr>
    <?php endforeach; ?>
</table>
</body>
</html>
