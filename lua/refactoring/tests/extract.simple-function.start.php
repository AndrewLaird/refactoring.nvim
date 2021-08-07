<?php


function(int $a){
    $test = 1;
    $test_other = 11;
    for($idx = $test - 1; $idx < $test_other; ++$idx) {
        var_dump($idx, $a);
    }

}
?>
