<?php
    
$command = $_POST["command"];

if(strcmp($command, "getItem") == 0) {
    getItem();
} else if(strcmp($command, "getCategory") == 0) {
    getCategory();
} else if(strcmp($command, "register") == 0) {
    register();
} else if(strcmp($command, "login") == 0) {
    login();
} else if(strcmp($command, "getCart") == 0) {
    getCart();
} else if(strcmp($command, "setCart") == 0) {
    setCart();
} else if(strcmp($command, "getHistory") == 0) {
    getHistory();
} else if(strcmp($command, "getUserInformation") == 0) {
    getUserInformation();
} else if(strcmp($command, "setUserInformation") == 0) {
    setUserInformation();
} else if(strcmp($command, "getCreditCard") == 0) {
    getCreditCard();
} else if(strcmp($command, "setCreditCard") == 0) {
    setCreditCard();
} else if (strcmp($command, "purchase") == 0) {
    purchase();
} else if (strcmp($command, "getNews") == 0) {
	getNews();
}
    
function getItem() {
    echoFileData("data/item.json", "[]");
}

function getCategory() {
    echoFileData("data/category.json", "[]");
}

function register() {

    $email = $_POST["email"];
    $password = $_POST["password"];
    
    if ((strlen($email) == 0) || (strlen($email) > 255) || (strlen($password) == 0) || strlen($password) > 255) {
        $ret = array("result" => "2",
                     "userId" => "");
        $json = json_encode($ret);
        echo($json);
        return;
    }
    if ((!preg_match("/^[a-zA-Z0-9@-_.+]/", $email))
     || (!preg_match("/^[a-zA-Z0-9]/", $password))) {
        $ret = array("result" => "2",
                     "userId" => "");
        $json = json_encode($ret);
        echo($json);
        return;
    }
    if (isExistEmail($email)) {
        $ret = array("result" => "1",
                     "userId" => "");
        $json = json_encode($ret);
        echo($json);
        return;
    }

    $json = readJson("data/user.json");
    if (!is_array($json)) {
        $ret = array("result" => "4",
                     "userId" => "");
        $json = json_encode($ret);
        echo($json);
        return;
    }
    
    date_default_timezone_set('Asia/Tokyo');
    $userId = date("YmdHis") . md5($email);

    $json[] = array("id" => $userId,
                    "email" => $email,
                    "password" => $password);
    $encoded = json_encode($json);
    file_put_contents("data/user.json", $encoded);

    $ret = array("result" => "0", "userId" => $userId);
    echo(json_encode($ret));
}

function login() {

    $email = $_POST["email"];
    $password = $_POST["password"];
    
    if ((strlen($email) == 0) || (strlen($email) > 255) || (strlen($password) == 0) || strlen($password) > 255) {
        $ret = array("result" => "2",
                     "userId" => "");
        $json = json_encode($ret);
        echo($json);
        return;
    }
    
    $json = readJson("data/user.json");
    if (($json !== false) && (is_array($json))) {
        for ($i = 0; $i < count($json); $i++) {
            if ((strcmp($json[$i]->email, $email) == 0) && (strcmp($json[$i]->password, $password) == 0)) {
                $ret = array("result" => "0",
                             "userId" => $json[$i]->id);
                echo(json_encode($ret));
                return;
            }
        }
    }
    $ret = array("result" => "4",
                 "userId" => "");
    echo(json_encode($ret));
}

function getCart() {

    $userId = $_POST["userId"];
    $fileName = "data/userdata/" . $userId . "/cart.json";
    echoFileData($fileName, "[]");
}

function setCart() {
    
    $userId = $_POST["userId"];
    $items = explode(",", $_POST["items"]);
    
    createUserDirectory($userId);

    $cartData = array();
    for ($i = 0; $i < count($items); $i++) {
        $exploded = explode(":", $items[$i]);
        if (count($exploded) == 2) {
            $cartData[] = array("itemId" => $exploded[0],
                                "number" => $exploded[1]);
        }
    }
    $encoded = json_encode($cartData);
    $fileName = "data/userdata/" . $userId . "/cart.json";
    file_put_contents($fileName, $encoded);

    $ret = array("result" => "0");
    echo(json_encode($ret));
}

function getHistory() {

    $userId = $_POST["userId"];
    $fileName = "data/userdata/" . $userId . "/history.json";
    echoFileData($fileName, "[]");
}
    
function getUserInformation() {

    $userId = $_POST["userId"];
    $fileName = "data/userdata/" . $userId . "/information.json";
    echoFileData($fileName, "{}");
}
    
function setUserInformation() {

    $userId = $_POST["userId"];
    $name = $_POST["name"];
    $kana = $_POST["kana"];
    $postCode = $_POST["postCode"];
    $address = $_POST["address"];
    $phoneNumber = $_POST["phoneNumber"];
    
    createUserDirectory($userId);
    
    $fileName = "data/userdata/" . $userId . "/information.json";
    $fileData = array("name" => $name,
                      "kana" => $kana,
                      "postCode" => $postCode,
                      "address" => $address,
                      "phoneNumber" => $phoneNumber);
    $encoded = json_encode($fileData);
    file_put_contents($fileName, $encoded);
    
    $ret = array("result" => "0");
    echo(json_encode($ret));
}

function getCreditCard() {

	$userId = $_POST["userId"];
	$fileName = "data/userdata/" . $userId . "/creditCard.json";
	echoFileData($fileName, "{}");
}

function setCreditCard() {

	$userId = $_POST["userId"];
	$cardNumber = $_POST["number"];
	$expire = $_POST["expire"];
	$cvc = $_POST["cvc"];
	$name = $_POST["name"];

	$fileName = "data/userdata/" . $userId . "/creditCard.json";
	$fileData = array("number" => $cardNumber,
					  "expire" => $expire,
					  "cvc" => $cvc,
					  "name" => $name);
	$encoded = json_encode($fileData);
	file_put_contents($fileName, $encoded);

	$ret = array("result" => "0");
    echo(json_encode($ret));
}
    
function purchase() {
    
    $userId = $_POST["userId"];
    
    $cartFileName = "data/userdata/" . $userId . "/cart.json";
    if (!file_exists($cartFileName)) {
        $ret = array("result" => "1");
        echo(json_encode($ret));
        return;
    }
    $cartData = readJson($cartFileName);
    if (!is_array($cartData)) {
        $ret = array("result" => "1");
        echo(json_encode($ret));
        return;
    }

    $historyFileName = "data/userdata/" . $userId . "/history.json";
    $historyData = [];
    if (file_exists($historyFileName)) {
        $oldHistoryData = readJson($historyFileName);
        if ($oldHistoryData !== false) {
            if (is_array($oldHistoryData)) {
                $historyData = $oldHistoryData;
            }
        }
    }
    
    date_default_timezone_set('Asia/Tokyo');
    $purchaseId = "purchase_" . $userId . "_" . date("YmdHis");
    
    $historyData[] = array("id" => $purchaseId,
                           "items" => $cartData);
    $encoded = json_encode($historyData);
    file_put_contents($historyFileName, $encoded);

    file_put_contents($cartFileName, "[]");
    
    $ret = array("result" => "0");
    echo(json_encode($ret));
}

function getNews() {
	echoFileData("data/news.json", "[]");
}
    
function createUserDirectory($userId) {
    
    $directoryName = "data/userdata/" . $userId;
    if (!file_exists($directoryName)) {
        mkdir($directoryName, 0777);
        chmod($directoryName, 0777);
    }
}

function echoFileData($fileName, $defaultString) {
        
    if (file_exists($fileName)) {
        $fileData = file_get_contents($fileName);
        if ($fileData !== false) {
            echo($fileData);
            return;
        }
    }
    echo($defaultString);
}

function readJson($fileName) {

    if (file_exists($fileName) == false) {
        return false;
    }
    $fileData = file_get_contents($fileName);
    if ($fileData === false) {
        return false;
    }
    $json = json_decode($fileData);
    if ($json === false) {
        return false;
    }
    return $json;
}

function isExistEmail($email) {

    $json = readJson("data/user.json");
    for ($i = 0; $i < count($json); $i++) {        
        if (strcmp($json[$i]->email, $email) == 0) {
            return true;
        }
    }
    return false;
}

?>
