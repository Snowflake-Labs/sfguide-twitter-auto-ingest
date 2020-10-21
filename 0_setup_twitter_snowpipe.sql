/*********************************************************************************
Create storage (database) to store the tweets
Create compute (warehouse) to run analytical queries on the tweets
*********************************************************************************/

use role sysadmin;

create or replace warehouse twitter_wh
  with warehouse_size = 'x-small'
  auto_suspend = 300
  auto_resume = true
  initially_suspended = true;

CREATE OR REPLACE DATABASE twitter_db;
USE SCHEMA twitter_db.public;


/*********************************************************************************
Create external S3 stage pointing to the S3 buckets storing the tweets
*********************************************************************************/

CREATE or replace STAGE twitter_db.public.tweets
    URL = 's3://my-twitter-bucket/'
    CREDENTIALS = (AWS_KEY_ID = 'xxxxxxxxxxxxxxxxxxxx'
    AWS_SECRET_KEY = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
    file_format=(type='JSON')
    COMMENT = 'Tweets stored in S3';


/*********************************************************************************
Create new table for storing JSON data in native format into a VARIANT column
*********************************************************************************/

create or replace table tweets(tweet variant);

/*********************************************************************************
Create pipe for auto-ingesting tweets from S3 into the "tweets" Snowflake table
*********************************************************************************/

create or replace pipe twitter_db.public.tweetpipe auto_ingest=true as
    copy into twitter_db.public.tweets
    from @twitter_db.public.tweets
    file_format=(type='JSON');


/*********************************************************************************
Check that the pipe is created
Copy the notification_channel value of the pipe
*********************************************************************************/
show pipes;


/*********************************************************************************
Go to the AWS S3 console and update the event notifications with the
    notification_channel value
*********************************************************************************/
