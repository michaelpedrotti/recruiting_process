<?php
/**
 * Source code here is about items 1 and 2 from read-me.pdf file
 *
 * @param string $filepath
 * @return array
 */
function readJsonToRows($filepath){

  // put your source code here
  return array();
}

/**
 * Source code here is about items 3 and 4 from read-me.pdf file
 *
 * @example curl --location --request GET 'https://economia.awesomeapi.com.br/last/USD-BRL'
 * @return float
 */
function usdToBrl(){

  // put your source code here
  return 5.5;
}

/**
 * Source code here is about item 5 from read-me.pdf file
 *
 * @param array $rows
 * @param float $brl
 * @return array
 */
function updateRowsPrice($rows = array(), $brl = 5.5){

  // put your source code here
  return array();
}

/**
 * Source code here is about item 6 from read-me.pdf file
 *
 * @param array $rows
 * @return array
 */
function createRowsNewColumns($rows = array()){

  // put your source code here
  return array();
}

/**
 * Source code here is about items 7, 8, 11 from read-me.pdf file
 *
 * @param array $rows
 * @param string $filepath
 * @return void
 */
function rowsToCsv($rows, $filepath){

  // put your source code here
  unset($rows);
}

/**
 * Source code here is about items 9 from read-me.pdf file
 *
 * @throws Exception
 * @return array
 */
function csvToRows($filepath){

  // put your source code here
  return array();
}

/**
 * Source code here is about items 10 from read-me.pdf file
 *
 * @return array
 */
function filterRowsForDelete($rows = array()){

  // put your source code here
  return array();
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
