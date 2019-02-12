<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8"> 
<link rel="stylesheet" href="style.css">
<article class="markdown-body">
<?php
$termErr = "";
$term = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if (empty($_POST["term"])) {
    $termErr = "🚨";
  } else {
    $term = test_input($_POST["term"]);
  }
}

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}?>

<h3>📖 <a href='index.html'>Index</a> | 🔎 Search | ⚠️ <a href='status.php'>Status</a></h3>
<hr />
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
<input type="submit" name="submit" value="Search">
<input type="text" name="term" value="<?php echo $term;?>">
<span class="error"><?php echo $termErr;?></span>
</form>
<br>

<?php
function scanAllDir($dir) {
  $result = [];
  foreach(scandir($dir) as $filename) {
    if ($filename[0] === '.') continue;
    $filePath = $dir . '/' . $filename;
    if (is_dir($filePath)) {
      foreach (scanAllDir($filePath) as $childFilename) {
        $result[] = $filename . '/' . $childFilename;
      }
    } else {
      $result[] = $filename;
    }
  }
  return $result;
}

if (empty($term)) {
  echo "<br><b>Search in files and directories.</b><br><br>";
  echo "You can set a regexp in 'search.php'. Currently set to '/\b<code>SEARCH_TERM</code>\b/i'.";
} else {
  $pattern = "/\b" . $term . "\b/i";
  $files = scanAllDir('/data');
  $results = preg_grep($pattern, $files);

  echo "<h2>Filenames</h2>";
  if ($results === []) {
    echo "<br>No filenames found.";
  }
  foreach($results as $result) {
    echo "<a href='$result'>$result</a><br>";
  }
  echo "<br><br>";
  echo "<h2>In files</h2>";
  foreach($files as $file) {
    if ($file !== 'index.html') {
      $lines = file("/data/$file");
      $matches = preg_grep($pattern, $lines);
      $numMatches = count($matches);

      if ($numMatches > 1) {
        $i = 0;
        echo "<a href='$file'>$file</a> - <i>$numMatches lines</i><br>";
        echo "<br>";
	foreach($matches as $match) {
          $i++;
          $unformatted = strip_tags($match, '<a>');
          echo "<code>$unformatted</code><br>";
	  if ($numMatches !== $i) {
	    echo "<br>";
	  } else {
            echo "<hr />";
          }
        }
      } else {
        foreach($matches as $match) {
          $unformatted = strip_tags($match, '<a>');
          echo "<a href='$file'>$file</a> - <i>1 line</i><br>";
          echo "<br>";
          echo "<code>$unformatted</code><br>";
          echo "<hr />";
        }
      }
    }
  }
  if ($match === null) {
    echo "<br>No matches in files.";
  }
}?>
</article>
