<?php
include("connect.php");

$connection = @new mysqli($host, $db_user, $db_password, $db_name);
$connection->set_charset("utf8");	
	if ($connection->connect_errno!=0)
	{
		echo "Error: ".$connection->connect_errno;
	}
	else
	{
		if (isset($_POST['operation'])) {
			$operation = $_POST['operation'];
			//echo $operation;
		}else{
			$operation = 'nothing';
			//$operation = 'searchStandard';
		}
	
		if($operation == 'nothing'){	
				if ($resultList = @$connection->query(sprintf("SELECT * FROM milano_averages;")))
				{	while($row = $resultList->fetch_assoc()){
						$id = $row['SQUARE_ID'] - 1;
						$smsIn = $row['SMS_IN_AVG'];
						$array[$id] = $smsIn;
					}
					echo json_encode($array);
				}
		//$polaczenie->close();
	
		}else if($operation == 'remove'){
			echo $_POST['queryControl']."; ".$_POST['queryDrop'];
			$result = @$connection->query(sprintf($_POST['queryControl']));
			$result = @$connection->query(sprintf($_POST['queryDrop']));
	}
	
		$connection->close();
	}

?>