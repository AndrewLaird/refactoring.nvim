<?
function foo_bar($a, $test, $test_other) {
    for($idx = $test - 1; $idx < $test_other; ++$idx) {
        var_dump($idx, $a);
    }
    return $fill_me;
}
function(int $a){
    $test = 1;
    $test_other = 11;

    $fill_me = foo_bar(a, test, test_other);
}
?>
