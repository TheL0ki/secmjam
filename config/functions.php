<?php
function forceSSL() {
    if($_SERVER["HTTPS"] != "on")
    {
        header("Location: https://" . $_SERVER["HTTP_HOST"] . $_SERVER["REQUEST_URI"]);
        exit();
    }
}

function doLogin($user, $pwd) {
    global $mysqli;
    $abfrage = "SELECT * FROM login WHERE user = ?";
    $ergebnis = $mysqli->prepare($abfrage);
    $ergebnis->bind_param('s', $user);
    $ergebnis->execute();
    $result = $ergebnis->get_result();
    if(!$result) {
        printf("Errormessage: %s\n", $mysqli->error);
    }
    if($result->num_rows == 0) {
        return FALSE;
    }
    $row = $result->fetch_assoc();
    if($row["pwd"] == $pwd) {
        $name = array(
            "vorname" => $row["firstname"],
            "nachname" => $row["lastname"],
            "id" => $row["id"],
            "user" => $row["user"],
            "email" => $row["email"],
            "notify" => $row["notify"],
            "vote" => $row["vote"],
            "active" => $row["active"]
        );
        return $name;
    } else {
        return FALSE;
    }
}

function checkBalance($userid) {
    global $mysqli;
    $select_balance = 'SELECT balance FROM login WHERE id = '.$userid;
    $query = $mysqli->query($select_balance);
    return $query->fetch_object()->balance;
}

function changeBalance($userid, $amount, $do = 'add') {
    global $mysqli;
    $get_balance = 'SELECT balance FROM login WHERE id = '.$userid;
    $query_balance = $mysqli->query($get_balance);
    $balance = $query_balance->fetch_object()->balance;
    if($do == 'sub') {
        $new_balance = $balance - $amount;
    } else {
        $new_balance = $balance + $amount;
    }

    $update_balance = 'UPDATE login SET balance = '.$new_balance.' WHERE id = '.$userid;
    $query_new_balance = $mysqli->query($update_balance);
    if($query_new_balance == TRUE) {
        return TRUE;
    } else {
        return FALSE;
    }
}

function getCategoryBySlug($slug) {
    global $mysqli;
    $select = 'SELECT * FROM categories WHERE slug = ?';
    $stmt = $mysqli->prepare($select);
    $stmt->bind_param('s', $slug);
    $stmt->execute();
    $result = $stmt->get_result();
    return $result->fetch_assoc();
}

function getCategoryIdBySlug($slug) {
    $category = getCategoryBySlug($slug);
    return $category ? (int) $category['id'] : null;
}

function getCategorySlugById($id) {
    global $mysqli;
    $select = 'SELECT slug FROM categories WHERE id = ?';
    $stmt = $mysqli->prepare($select);
    $stmt->bind_param('i', $id);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    return $row ? $row['slug'] : null;
}

function getPrice($foodid, $amount = 1) {
    global $mysqli;
    $select = 'SELECT * FROM menu WHERE id = '.$foodid;
    $query = $mysqli->query($select);
    $price = $query->fetch_object()->price;
    return $price * $amount;
}

function checkAfford($fullprice, $userid) {
    $balance = checkBalance($userid);
    if($balance >= $fullprice) {
        return TRUE;
    } else {
        return FALSE;
    }
}

function getPollVotes() {
    $filename = "config/poll_result.txt";
    $content = file($filename);
    
    $array = explode("||", $content[0]);
    $vote = array(
        'noodles' => $array[0],
        'pizza' => $array[1],
        'kebap' => $array[2],
        'schnitzel' => $array[3],
        'grill' => $array[4]
    );
    
    return $vote;
}

function updateVotes($vote) {
    $filename = "config/poll_result.txt";
    $insertvote = $vote['noodles']."||".$vote['pizza']."||".$vote['kebap']."||".$vote['schnitzel']."||".$vote['grill'];
    $fp = fopen($filename,"w");
    fputs($fp,$insertvote);
    fclose($fp);
} 

function getVotePercent($vote) {
    $sum = $vote['noodles']+$vote['pizza']+$vote['kebap']+$vote['schnitzel']+$vote['grill'];
    if($sum == 0) {
        $percent = array(
            'noodles' => $vote['noodles'],
            'pizza' => $vote['pizza'],
            'kebap' => $vote['kebap'],
            'schnitzel' => $vote['schnitzel'],
            'grill' => $vote['grill']
        );
    } else {
        $percent = array(
            'noodles' => (100*round($vote['noodles']/$sum,2)),
            'pizza' => (100*round($vote['pizza']/$sum,2)),
            'kebap' => (100*round($vote['kebap']/$sum,2)),
            'schnitzel' => (100*round($vote['schnitzel']/$sum,2)),
            'grill' => (100*round($vote['grill']/$sum,2))
        );
    }

    return $percent;
}

function lockOrder($dn) {
    global $mysqli;
    $update_lock = "UPDATE deliveries SET locked='1' WHERE delivery_number = '$dn'";
    $mysqli->query($update_lock);
}

function unlockOrder($dn) {
    global $mysqli;
    $update_lock = "UPDATE deliveries SET locked='0' WHERE delivery_number = '$dn'";
    $mysqli->query($update_lock);
}

function closeOrder($dn, $helperArray) {
    global $mysqli;
    $helperString = "";
    foreach($helperArray as $helper) {
        $helperString .= '"'.$helper.'"|';
    }
    $helperString = substr($helperString,0, -1);
    $update = 'UPDATE deliveries SET status = 1, locked = 1, helper = ? WHERE delivery_number = ?';
    $stmt = $mysqli->prepare($update);
    $stmt->bind_param('ss', $helperString, $dn);
    $stmt->execute();

    if($helperArray != NULL) {
        sendHelperMail($helperArray, $dn);
    }
}

function getPoints($id) {
    global $mysqli;
    $select = 'SELECT * FROM login WHERE id = '.$id;
    $query = $mysqli->query($select);
    return $query->fetch_object()->points;
}

function lastOrders($id) {
    global $mysqli;
    $select_user_delivery = 'SELECT d.*, c.slug AS category '
        . 'FROM deliveries d '
        . 'JOIN categories c ON c.id = d.category_id '
        . 'WHERE d.userid = '.$id.' AND d.status = 1 '
        . 'GROUP BY d.delivery_number ORDER BY d.id DESC LIMIT 10';
    $query = $mysqli->query($select_user_delivery);
    $orders = array();
    while ($row = $query->fetch_object()) {
        $date_output = new DateTime();
        $orders[] = array(
            'dn' => $row->delivery_number,
            'owner' => $row->owner,
            'date' => $date_output->setTimestamp($row->delivery_number)->format('d.m.Y'),
            'category' => $row->category
        );
    }
    
    return $orders;
}

function getDeliveries($dn) {
    global $mysqli;
    $deliveries = array();
    $select = 'SELECT d.*, c.slug AS category '
        . 'FROM deliveries d '
        . 'JOIN categories c ON c.id = d.category_id '
        . 'WHERE d.delivery_number = '.$dn.' '
        . 'ORDER BY CAST(d.delivery_text AS DECIMAL), d.sauce';
    $query = $mysqli->query($select);
    while($row = $query->fetch_assoc()) {
        $userData = getUserData($row['userid']);
        $delivery = getDeliveryText($row['delivery_text']);
        $deliveries[] = array(
            'id' => $row['id'],
            'fullname' => $userData['firstname'].' '.$userData['lastname'],
            'delivery' => $delivery['sub_category'].' '.$delivery['item'],
            'size' => $delivery['size'],
            'extra' => $row['sauce'],
            'price' => $delivery['price'],
            'userid' => $row['userid'],
            'status' => $row['status'],
            'locked' => $row['locked'],
            'owner' => $row['owner'],
            'category' => $row['category']
        );
    }
    return $deliveries;
}

/** @deprecated Use getDeliveries() */
function getDeliverys($dn) {
    return getDeliveries($dn);
}

function getUserData($id) {
    global $mysqli;
    $select = 'SELECT * FROM login WHERE id = '.$id;
    $query = $mysqli->query($select);
    
    return $query->fetch_assoc();    
}

function getDeliveryText($id) {
    global $mysqli;
    $select = 'SELECT m.*, c.slug AS category '
        . 'FROM menu m '
        . 'JOIN categories c ON c.id = m.category_id '
        . 'WHERE m.id = '.$id;
    $query = $mysqli->query($select);
    
    return $query->fetch_assoc();
}

function getOpenOrders() {
    global $mysqli;
    $select_deliveries = "SELECT d.*, c.slug AS category "
        . "FROM deliveries d "
        . "JOIN categories c ON c.id = d.category_id "
        . "WHERE d.status != '1' GROUP BY d.delivery_number";
    $query = $mysqli->query($select_deliveries);
    $orders = array();    
    while ($row = $query->fetch_assoc()) {
        $date = new DateTime();
        $date_output = $date->setTimestamp($row['delivery_number'])->format('d.m.Y');
        $owner = getUserData($row['owner']);        
        $orders[] = array(
            'dn' => $row['delivery_number'],
            'date_output' => $date_output,
            'category' => $row['category'],
            'ownerFullname' => $owner['firstname'].' '.$owner['lastname'],
            'locked' => $row['locked']
        );    
    }
    
    return $orders;
}

function getUnlockedOrders() {
    global $mysqli;
    $select_deliveries = "SELECT d.*, c.slug AS category "
        . "FROM deliveries d "
        . "JOIN categories c ON c.id = d.category_id "
        . "WHERE d.status != '1' AND d.locked != '1' GROUP BY d.delivery_number";
    $query = $mysqli->query($select_deliveries);
    $orders = array();
    while ($row = $query->fetch_assoc()) {
        $date = new DateTime();
        $date_output = $date->setTimestamp($row['delivery_number'])->format('d.m.Y');
        $owner = getUserData($row['owner']);
        $orders[] = array(
            'dn' => $row['delivery_number'],
            'date_output' => $date_output,
            'category' => $row['category'],
            'ownerFullname' => $owner['firstname'].' '.$owner['lastname'],
            'locked' => $row['locked']
        );
    }

    return $orders;
}

function getSingleOrder($dn) {
    global $mysqli;
    $select = "SELECT d.*, c.slug AS category "
        . "FROM deliveries d "
        . "JOIN categories c ON c.id = d.category_id "
        . "WHERE d.delivery_number = ?";
    $stmt = $mysqli->prepare($select);
    $stmt->bind_param('s', $dn);
    $stmt->execute();
    $result = $stmt->get_result();

    return $result->fetch_assoc();
}

function total($dn) {
    global $mysqli;
    $userids = array();
    $total = array();
    $items = array();
    $selectUserid = 'SELECT DISTINCT userid FROM deliveries WHERE delivery_number = '.$dn;
    $query = $mysqli->query($selectUserid);    
    while ($row = $query->fetch_assoc()) {
        $userids[] = $row['userid'];
    }
    foreach ($userids as $user) {
        $total[$user]['total'] = 0;        
        $userData = getUserData($user);
        $total[$user]['fullname'] = $userData['firstname'].' '.$userData['lastname'];
        $selectItems = 'SELECT delivery_text FROM deliveries WHERE delivery_number = '.$dn.' AND userid = '.$user;
        $query = $mysqli->query($selectItems);        
        while($row = $query->fetch_assoc()) {
            $items[] = $row['delivery_text'];
        }
        
        foreach ($items as $item) {
            $itemData = getItem($item);
            $total[$user]['total'] = $total[$user]['total'] + $itemData['price'];
        }
        $items = array();
    }
    
    return $total;
}

function getItem($id) {
    global $mysqli;
    $select = 'SELECT m.*, c.slug AS category '
        . 'FROM menu m '
        . 'JOIN categories c ON c.id = m.category_id '
        . 'WHERE m.id = '.$id;
    $query = $mysqli->query($select);
    return $query->fetch_assoc();
}

function totalItems($dn) {
    global $mysqli;
    $items = array();
    $total = array();
    $select = 'SELECT DISTINCT delivery_text FROM deliveries WHERE delivery_number = '.$dn;
    $query = $mysqli->query($select);
    while ($row = $query->fetch_assoc()) {
        $items[] = $row['delivery_text'];
    }
    
    foreach ($items as $item) {
        $itemData = getItem($item);
        if($itemData['size'] != '-') {
            $total[$item]['item'] = $itemData['sub_category'].' '.$itemData['item'].' '.$itemData['size'];
        } else {
            $total[$item]['item'] = $itemData['sub_category'].' '.$itemData['item'];
        }
        $count = 'SELECT count(delivery_text) FROM deliveries WHERE delivery_text = '.$item.' AND delivery_number = '.$dn;
        $query = $mysqli->query($count);
        $itemCount = $query->fetch_assoc();
        $total[$item]['count'] = $itemCount['count(delivery_text)'];
    }
    
    return $total;
}

function getHelper() {
    global $mysqli;
    $helper = array();
    $select = 'SELECT * FROM login WHERE active = 1 ORDER by lastname ASC';
    $query = $mysqli->query($select);
    while ($row = $query->fetch_assoc()) {
        $helper[] = $row;
    }
    
    return $helper;
}

function getMenu($category) {
    global $mysqli;
    $menu = array();
    $select = 'SELECT m.*, c.slug AS category '
        . 'FROM menu m '
        . 'JOIN categories c ON c.id = m.category_id '
        . 'WHERE c.slug = ? '
        . 'ORDER BY m.sub_category ASC';
    $stmt = $mysqli->prepare($select);
    $stmt->bind_param('s', $category);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        $menu[] = $row;
    }

    return $menu;
}

/** @deprecated Use getMenu() */
function getMenue($category) {
    return getMenu($category);
}

function saveOrder($order) {
    global $mysqli;
    $now = new DateTime('now');
    $extras = '';
    $insert_timestamp = $now->format('Y-m-d H:i:s');
    $categoryId = isset($order['category_id'])
        ? (int) $order['category_id']
        : getCategoryIdBySlug($order['category']);
    if ($order['new_order'] == "1") {
        if($order['autolock_check'] == "1") {
            $autolock_time = new DateTime();
            $autolock_time->setTimestamp($order['dn']);
            $autolock_time->setTime(substr($order['autolock_time'],0,2), substr($order['autolock_time'],-2));
            $autolock = $autolock_time->format('Y-m-d H:i:s');
        } else {
            $autolock = null;
        }
    } else {
        if($order['autolock_time'] == '0000-00-00 00:00:00') {
            $autolock = null;
        } else {
            $autolock = $order['autolock_time'];
        }
    }

    foreach ($order['food'] as $item) {
        for ($i = 1; $i <= $order['amount'][$item]; $i++) {
            if(!empty($order['sauce'][$item])) {
                foreach ($order['sauce'][$item] as $extra) {
                    $extras .= '|' . $extra;
                }
            }
            $extras = substr($extras,1);
            $insert = 'INSERT INTO deliveries (delivery_number, delivery_text, userid, sauce, owner, category_id, autolock, timestamp) VALUES (?,?,?,?,?,?,?,?)';
            $stmt = $mysqli->prepare($insert);
            $stmt->bind_param('sssssiss', $order['dn'], $item, $order['userid'], $extras, $order['owner'], $categoryId, $autolock, $insert_timestamp);
            $stmt->execute();
            $extras = "";
        }
    }
}

function changePWD($user) {
    global $mysqli;
    $userData = getUserData($user['id']);
    if($userData['pwd'] == $user['pwd_old']) {
        if ($user['pwd_new'] == $user['pwd2']) {
            $update = 'UPDATE login SET pwd = ? WHERE id = ?';
            $stmt = $mysqli->prepare($update);
            $stmt->bind_param('ss', $user['pwd_new'], $user['id']);
            $stmt->execute();
            return TRUE;
        } else {
            return FALSE;
        }
    } else {
        return FALSE;
    }
}

function getHighscore() {
    global $mysqli;
    $highscore = array();
    $select = 'SELECT * FROM login WHERE active = TRUE ORDER BY points DESC, lastname ASC';
    $query = $mysqli->query($select);
    while($row = $query->fetch_assoc()) {
        $sumOrders = getOrderCount($row['id']);
        $sumDeliverys = getDeliverySum();
        if($sumDeliverys == 0 OR $sumOrders == 0) {
            $quote = 0;
        } else {
            $quote = round(($sumOrders/$sumDeliverys)*100,2);
        }
        $highscore[] = array(
            'id' => $row['id'],
            'fullname' => $row['firstname'].' '.$row['lastname'],
            'points' => $row['points'],
            'orders' => $sumOrders,
            'quote' => $quote
        );
    }

    return $highscore;
}

function getOrderCount($id) {
    global $mysqli;
    $select = 'SELECT count(DISTINCT delivery_number) FROM deliveries WHERE userid = '.$id;
    $query = $mysqli->query($select);
    $result = $query->fetch_assoc();

    return $result['count(DISTINCT delivery_number)'];
}

function getDeliverySum() {
    global $mysqli;
    $select = 'SELECT count(DISTINCT delivery_number) FROM deliveries';
    $query = $mysqli->query($select);
    $result = $query->fetch_assoc();

    return $result['count(DISTINCT delivery_number)'];
}

function sendInfoMail($owner, $category, $autolock = FALSE, $time = '00:00') {
    global $mysqli;
    $headers = array();
    $headers[] = "MIME-Version: 1.0";
    $headers[] = "Content-Type: text/html; charset=UTF-8";
    $headers[] = "From: SEC-Mjam <no-reply@loki-net.at>";
    $headers[] = "Reply-To: SEC-Mjam <no-reply@loki-net.at>";
    $headers[] = "Subject: Neue SEC-Mjam Bestellung";
    $headers[] = "X-Mailer: PHP/".phpversion();
    $select_receiver = "SELECT email FROM login WHERE notify = '1' AND active = TRUE";
    $query = $mysqli->query($select_receiver);
    $receiver_arr = array();
    while ($row = $query->fetch_object()) {
        $receiver_arr[] = $row->email;
    }

    $owner = getUserData($owner);
    $ownerFullName = $owner['firstname'].' '.$owner['lastname'];

    $betreff = "Neue SEC-Mjam Bestellung";
    if($autolock == TRUE) {
        $text = file_get_contents('mailTemplates/mailTime.html');
        $text = str_replace('[time]', $time, $text);
    } else {
        $text = file_get_contents('mailTemplates/mailNoTime.html');
    }

    $text = str_replace('[name]', $ownerFullName, $text);
    $text = str_replace('[mail_food]', ucfirst($category), $text);

    foreach ($receiver_arr as $receiver) {
        mail($receiver, $betreff, $text, implode("\r\n", $headers));
    }
}

function sendHelperMail($helperArray, $dn) {
    $headers = array();
    $headers[] = "MIME-Version: 1.0";
    $headers[] = "Content-Type: text/html; charset=UTF-8";
    $headers[] = "From: SEC-Mjam <no-reply@loki-net.at>";
    $headers[] = "Reply-To: SEC-Mjam <no-reply@loki-net.at>";
    $headers[] = "Subject: Abschluss einer SEC-Mjam Bestellung";
    $headers[] = "X-Mailer: PHP/".phpversion();
    $betreff = "Abschluss einer SEC-Mjam Bestellung";

    $text = file_get_contents('mailTemplates/mailHelper.html');
    $delivery = getDeliveries($dn);
    $ownerData = getUserData($delivery[0]['owner']);
    $points = getPointsFromDelivery($dn);

    foreach ($helperArray as $helper) {
        $helperData = getUserData($helper);
        $text = str_replace('[points]', $points/2, $text);
        $text = str_replace('[name]', $ownerData['firstname'].' '.$ownerData['lastname'], $text);
        $text = str_replace('[dn]', $dn, $text);
        mail($helperData['email'], $betreff, $text, implode("\r\n", $headers));
    }
}

function calcOwnerPoints($user) {
    global $mysqli;
    $select = 'SELECT delivery_number FROM deliveries WHERE owner = '.$user.' GROUP BY delivery_number';
    $query = $mysqli->query($select);
    if($query->num_rows != 0) {
        $total = 0;
        while ($row = $query->fetch_object()) {
            $total += getPointsFromDelivery($row->delivery_number);
        }
    } else {
        $total = 0;
    }

    return $total;
}

function calcHelperPoints($user) {
    global $mysqli;
    $select = 'SELECT delivery_number FROM deliveries WHERE helper LIKE \'%"'.$user.'"%\' GROUP BY delivery_number';
    $query = $mysqli->query($select);
    if($query->num_rows != 0) {
        $total = 0;
        while ($row = $query->fetch_object()) {
            $total += getPointsFromDelivery($row->delivery_number);
        }
    } else {
        $total = 0;
    }

    return $total/2;
}

function getPointsFromDelivery($dn) {
    global $mysqli;
    $pointsArray = parse_ini_file('config/pts.ini', TRUE);
    $select = 'SELECT count(d.delivery_number) AS item_count, c.slug AS category '
        . 'FROM deliveries d '
        . 'JOIN categories c ON c.id = d.category_id '
        . 'WHERE d.delivery_number = '.$dn;
    $query = $mysqli->query($select);
    $result = $query->fetch_assoc();
    $count = $result['item_count'];
    $points = $count * $pointsArray['pts'][$result['category']];

    return $points;
}

function getHighscoreArray() {
    global $mysqli;
    $userArray = array();
    $sortArray = array();
    $highscore = array();
    $select = 'SELECT id FROM login WHERE active = TRUE';
    $query = $mysqli->query($select);
    while($row = $query->fetch_object()) {
        $userArray[] = $row->id;
    }

    foreach($userArray as $user) {
        $sortArray[$user] = calcHelperPoints($user) + calcOwnerPoints($user);
    }

    arsort($sortArray);

    foreach($sortArray as $user => $points) {
        $sumOrders = getOrderCount($user);
        $sumDeliverys = getDeliverySum();
        $highscore[$user]['points'] = $points;
        $highscore[$user]['data'] = getUserData($user);
        $highscore[$user]['orders'] = $sumOrders;

        if($sumDeliverys == 0 OR $sumOrders == 0) {
            $highscore[$user]['quote'] = 0;
        } else {
            $highscore[$user]['quote'] = round(($sumOrders/$sumDeliverys)*100,2);
        }
    }

    return $highscore;
}
