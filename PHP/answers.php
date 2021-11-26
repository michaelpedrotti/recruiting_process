<?php
/*
 * The data source has a intentional problem in the name column. Where some names
 * have a comma as part of it self. If the programmer is not careful when converting
 * the formats thinks can go wrong.
 */
define('ESCAPE', '"');
define('SEPARATOR', ',');


function extractRowFromLine($line = ''){

  $values = preg_split('/\"\,\"/', $line);

  array_walk($values, function(&$value){

    $value = str_replace(['"'], '', $value);

  });

  return $values;
}

/**
 * Source code here is about items 1 and 2 from read-me.pdf file
 *
 * @param string $filepath
 * @return array
 */
function readJsonToRows($filepath){

  $content = file_get_contents($filepath);
  return json_decode($content, true);
}

/**
 * Source code here is about items 3 and 4 from read-me.pdf file
 *
 * @example curl --location --request GET 'https://economia.awesomeapi.com.br/last/USD-BRL'
 * @return float
 */
function usdToBrl(){

  $curl = curl_init();

  curl_setopt_array($curl, array(
    CURLOPT_URL => 'https://economia.awesomeapi.com.br/last/USD-BRL',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'GET',
  ));

  $content = curl_exec($curl);

  curl_close($curl);

  $data = json_decode($content, true);

  return round($data['USDBRL']['bid'], 2);
}

/**
 * Source code here is about item 5 from read-me.pdf file
 *
 * @param array $rows
 * @param float $brl
 * @return array
 */
function updateRowsPrice($rows = array(), $brl = 5.5){

  foreach($rows as &$row){

    $price = $row['price'] * $brl;
    $row['price'] = round($price, 2);
  }


  return $rows;
}

/**
 * Source code here is about item 6 from read-me.pdf file
 *
 * @param array $rows
 * @return array
 */
function createRowsNewColumns($rows = array()){

  foreach($rows as &$row){

    $row['created_at'] = date('Y-m-d H:i:s');
    $row['update_at'] = date('Y-m-d H:i:s');
    $row['delete_at'] = null;
  }

  return $rows;
}

/**
 * Source code here is about items 7, 8, 11 from read-me.pdf file
 *
 * @param array $rows
 * @param string $filepath
 * @return void
 */
function rowsToCsv($rows, $filepath){

  $content = '';

  // Header
  foreach(array_keys($rows[0]) as $key){

    $content .= ESCAPE . $key . ESCAPE . SEPARATOR;
  }

  $content .= PHP_EOL;

  // Body
  foreach($rows as $row){

    foreach($row as &$val){

      $val = ESCAPE . $val . ESCAPE;
    }

    $content .= implode(',', $row) . PHP_EOL;
  }

  file_put_contents($filepath, $content);

  unset($rows);
}

/**
 * Source code here is about items 9 from read-me.pdf file
 *
 * @throws Exception
 * @return array
 */
function csvToRows($filepath){

  if(!file_exists($filepath)){

    throw new \Exception(sprintf("File %s was not found", $filepath));
  }

  $lines = file($filepath, FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES);
  $rows = [];

  // Header
  $keys = extractRowFromLine(array_shift($lines));

  foreach($lines as $line){


    $values = extractRowFromLine($line);

    $rows[] = array_combine($keys, $values);
  }


  return $rows;
}

/**
 * Source code here is about items 10 from read-me.pdf file
 *
 * @return array
 */
function filterRowsForDelete($rows = array()){


  foreach($rows as &$row){

    if($row['price'] >= 275){

      $row['delete_at'] = date('Y-m-d H:i:s');
    }
  }

  return $rows;
}


try {


  $rows = readJsonToRows(__DIR__. '/products.json');
  $brl = usdToBrl();

  if(empty($rows)){

    throw new \Exception('Cannot read products.json');
  }

  $rows = updateRowsPrice($rows, $brl);
  $rows = createRowsNewColumns($rows);

  $filepath = __DIR__. '/products.csv';

  rowsToCsv($rows, $filepath);

  $rows = csvToRows($filepath);


  $rows = filterRowsForDelete($rows);

  rowsToCsv($rows, $filepath);

  printf("success: file %s was created\n", $filepath);

  exit(0);
}
catch(\Exception $e){

  printf("fail: Exception\n");
  printf("message: %s\n", $e->getMessage());
  printf("trace: %s\n", $e->getTraceAsString());
  exit(1);
}
