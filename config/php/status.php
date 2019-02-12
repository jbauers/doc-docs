<?php
$page = $_SERVER['PHP_SELF'];
$sec = "30";
?>
<meta http-equiv="refresh" content="<?php echo $sec?>;URL='<?php echo $page?>'">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8"> 
<link rel="stylesheet" href="style.css">
<article class="markdown-body">

<h3>📖 <a href='index.html'>Index</a> | 🔎 <a href='search.php'>Search</a> | ⚠️ Status</h3>
<hr />

<?php
$urls = [
  'https://www.example.org',
];
$cert_file = 'cert.pem';

echo "<h2>URLs</h2>";
foreach($urls as $url) {
  echo "<a href='#" . $url . "'>" . $url . '</a><br>';
}
echo '<br>';
echo "👉 <a href='#trusted_cert'>See trusted certificate</a>";
echo "<hr/>";
foreach($urls as $url) {
  $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true,);
    curl_setopt($ch, CURLOPT_AUTOREFERER, true);
#    curl_setopt($ch, CURLOPT_CAINFO, getcwd() . "/$cert_file");
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2);

    $response = curl_exec($ch);

    $ip_address = curl_getinfo($ch, CURLINFO_PRIMARY_IP);
    $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
    $headers = substr($response, 0, $header_size);

  curl_close($ch);

  $headers = explode("\r\n", $headers); 
  $headers = array_filter($headers);

  $html = '';
  foreach ($headers as &$value) {
      $html .= $value . '<br>';
  }

  $all_good = "✅ All good! <br>";
  $redirect = "⚠️ " . $headers[0] . " - please <b>adjust URL</b>. <br>";
  $error_code = "❌ " . $headers[0] . '<br>';

  echo "<h3 id='$url'><a href='" . $url . "'>" . $url . '</a> @ ' . $ip_address . '</h3>';
  if (strpos($headers[0], '200') !== false) {
    echo $all_good . '<br>';
  }
  else if (strpos($headers[0], '301') !== false) {
    echo $redirect . '<br>';
  }
  else {
    echo $error_code . '<br>';
  }
  echo '<pre><code>';
  echo $html . '<br>';
  echo '</code></pre>';
  echo '<hr/>';
}

echo "<h2 id='trusted_cert'>Trusted certficate</h2>";
echo '<pre><code>';
readfile("$cert_file");
echo '</code></pre>';
?>
</article>
