Yesterday I was working on a project (that will hopefully be released soon) that displays the most recent post differently than the rest of the posts on the page. This project also calls for pagination-like behavior on the second set of posts, while the feature post (most recent post) should be static and have no pagination.

I initially tried to use the [offset parameter](http://codex.wordpress.org/Class_Reference/WP_Query#Offset_Parameter) for the second post query to remove the most recent post from that loop. This however didn't seem to work with the pagination.

Turns out Wordpress' offset and pagination features collide, as the [note says](http://codex.wordpress.org/Class_Reference/WP_Query#Offset_Parameter) (always read those little notes\!),

> **Note:** Setting offset parameter will ignore the paged parameter.

I think the pagination feature uses offset internally which is why an explicit offset breaks the pagination.

Anyway, after hunting around a bit to see if anyone had a quick fix for this, I stumbled upon [a post](http://wordpress.org/support/topic/query_posts-offset-and-pagination#post-1245582) which had a quite complex question and an equally complex answer. Yet, it confirmed what I thought I'd have to do.

I simplified the solution quite a bit for my particular scenario, here is my code (note I am using verbose variable names here to help clarify):

    $number_of_feature_posts = 1;
    $number_of_secondary_posts = 3;
    $paged = (get_query_var('paged')) ? get_query_var('paged') : 1;
    $how_many_secondary_posts_past = ($number_of_secondary_posts * ($paged - 1));
    $off = $number_of_feature_posts + (($paged > 1) ? $how_many_secondary_posts_past : 0);

I then used a simple *`WP_Query` loop for the first loop, the featured (most recent) post, and then just used the normal `query_posts`* with the additional arguments from the above snippet, for the second loop

``` 

query_posts( "posts_per_page=$number_of_secondary_posts&offset=$off&showposts=$number_of_secondary_posts" );
```

This basically keeps the offset *dynamic* and *relative* to the page we are on. Hope you find it useful.
