--- 
layout: post
title: Wordpress getting the current Page or Post ID
tags: 
- wordpress
- get
- page
- id
---
An example of getting the current page / post ID, identifying whether the current item is a page or a post, and then appending the results to the content.

All from within a plugin.


<code lang="php" line="1">
<?PHP
/*
Plugin Name: Get Page / Post ID using a plugin by D.Busby Saiweb.co.uk
Plugin URI: http://saiweb.co.uk
Description: Identifies the current page/post and appends text to the content
Version: 0.1
Author: David Busby
Author URI: http://saiweb.co.uk
*/

//WP hooks start
add_filter('the_content', 'post_page');
//WP hooks end

function post_page($content){
    global $post; //wordpress post global object
    if($post->post_type == 'page'){
        $content .= '<br /> This item is a page and the ID is: '.$post->ID;
    } elseif($post->post_type == 'post') {
        $content .= '<br /> This item is a post and the ID is: '.$post->ID;
    }
    return $content;
}
?>
</code>

Install the above as a plugin i.e. in wp-content/plugins/test/test.php

Head over to your admin menu and enable the plugin, now each page and post will identify itself as a page or post, and provide it's ID.

There is a lot available in the $post object for a list add

<code lang="php">
ob_start();
var_dump($post);
$content .= ob_get_contents();
ob_end_clean();
</code>

