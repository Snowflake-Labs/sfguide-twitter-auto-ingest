use role sysadmin;
use warehouse twitter_wh;
use schema twitter_db.public;

/*********************************************************************************
Check files in the bucket
Check that the pipe is running
*********************************************************************************/

list @twitter_db.public.tweets;
select $1 from @twitter_db.public.tweets limit 10;

show pipes;
select system$pipe_status('twitter_db.public.tweetpipe');

/*********************************************************************************
Check content of the tweets table - run multiple times to highlight auto-ingest
*********************************************************************************/

select count(*) from tweets;
select * from tweets limit 100;

/*********************************************************************************
Create a flat view to be used in Tableau
*********************************************************************************/

create or replace view tweets_bi as
    select tweet:keyword::string as keyword
    ,tweet:created_at::timestamp as created_at
    ,tweet:id::int as id
    ,tweet:lang::string as lang
    ,regexp_substr(tweet:source::string,'<a.*?>(.+?)</a>',1,1,'e') as source
    ,tweet:text::string as text
    ,tweet:truncated::boolean as truncated
    ,tweet:user.description::string as user_description
    ,tweet:user.id::int as user_id
    ,tweet:user.name::string as user_name
    ,tweet:user.screen_name::string as user_screen_name
    ,tweet:user.favourites_count::int as user_favourites_count
    ,tweet:user.followers_count::int as user_followers_count
    ,tweet:user.friends_count::int as user_friends_count
    ,tweet:user.profile_image_url::string as user_profile_image_url
    ,tweet:user.profile_image_url_https::string as user_profile_image_url_https
    ,tweet:favorite_count::int as favorite_count
    ,tweet:quote_count::int as quote_count
    ,tweet:retweet_count::int as retweet_count
    ,tweet:reply_count::int as reply_count
    ,tweet:retweeted::boolean as retweeted
    ,tweet:in_reply_to_status_id::int as in_reply_to_status_id
    ,tweet:retweeted_status.id::int as retweeted_status_id
    from tweets;

/*********************************************************************************
Check content of the tweets view - run multiple times to highlight auto-ingest
...or switch to the Tableau dashboard and see new data coming in....
*********************************************************************************/

select count(*) from tweets_bi;
select * from tweets_bi limit 100;
