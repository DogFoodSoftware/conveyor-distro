<?php
// The minify configuration is based on the 'site' which is matched to the 
// 'SERVER_NAME' from the server vars.

$host = $_SERVER['SERVER_NAME'];
// Check to see if this is 'localhost' access. In that case, we expect
// to find a single, non-special http configuration file.
# TODO: reference doc
error_log("HOST IS: |".$host."|");
if ($host == 'localhost' || preg_match('/(\d{1,3}\.){2}\d{1,3}/', $host)) {
    $file_list = glob('/home/user/.conveyor/data/dogfoodsoftware.com/conveyor-apache/conf-inc/*.httpd.conf');
    $default_site_conf = null;
    foreach ($file_list as $file) {
        $file = basename($file);
        if (!preg_match('/^__/', $file)) {
            if ($default_site_conf == null) {
                $default_site_conf = $file;
            }
            else {
                error_log("Multiple default sites found. Please prune to single default.");
                return;
            }
        }
    }

    $domain = 
        substr($default_site_conf, 0, strlen($default_site_conf) - 11);
        error_log("domain: $domain");

}
else { # Not 'localhost'
    $host_bits = explode('.', $host);
    $domain = $host_bits[count($host_bits) - 2].'.'.
        $host_bits[count($host_bits) -1];
}
$minify_config_file = "/home/user/.conveyor/runtime/$domain/website/conf/minify.php";
$minify_config = null;
if (file_exists($minify_config_file)) {
    $minify_config = include $minify_config_file;
}
else {
    error_log("Did not find expected minify config file: '$minify_config_file'; \$site: '$site'");
    return;
}

return $minify_config;
?>
