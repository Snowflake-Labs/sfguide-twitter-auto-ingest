

# Demo: Auto-Ingest Twitter Data into Snowflake

This demo shows how to auto-ingest streaming and event-driven data from Twitter into Snowflake using Snowpipe.  By completing this demo you will have built a docker image containing a python application that listens and saves live tweets; those tweets are uploaded into Snowflake using AWS S3 as a file stage.

The lessons learned in demo can be applied to any streaming or event-driven data source.

The core topics covered in this demo include: 

1.  **Data Loading**: Load Twitter streaming data in an event-driven, real-time fashion into Snowflake with Snowpipe
2.  **Semi-structured data**: Querying semi-structured data (JSON) without needing transformations
3.  **Secure Views**: Create a Secure View to allow data analysts to query the data
4.  **Snowpipe**: Overview and configuration

#### Architecture: 
![Twitter to Snowflake Auto-Ingest Architecture](media/architecture.png?raw=true)

## **INSTRUCTIONS**

### **PREREQUISITES**

You will need:

-   [git](https://git-scm.com/downloads)
-   [Docker Desktop](https://www.docker.com/products/docker-desktop)
-   [Twitter Developer](https://developer.twitter.com/) account (free)
-   [AWS](https://aws.amazon.com/) account (12-month free tier)

### **SETUP SCRIPT**

#### **1. Download the repository**

clone this repository locally
```bash
git clone https://github.com/Snowflake-Labs/demo-twitter-auto-ingest
```
navigate to the repository you just cloned: 
```bash
cd demo-twitter-auto-ingest
```

#### **2. Add your AWS and Twitter keys**

Use your text editor of choice to edit the following files:

-   `Dockerfile` (lines 9 to 16)
-   `0_setup_twitter_snowpipe.sql` (lines 23 to 25)

As you will be able to see in the files, you will also need to specify your AWS S3 bucket (where the data will be stored) and a default search keyword.

#### **3. Build the image**

1. While in your `demo-twitter-auto-ingest` directory run:
```bash
docker build . -t snowflake-twitter
```
This command builds the `Dockerfile` in the current directory, and tags the built image as `snowflake-twitter`.

The last two lines of the output should look similar to the following:
```bash
Successfully built c1c0b7262436
Successfully tagged snowflake-twitter:latest
```

Note: In the above example, _c1c0b7262436_  is the image id - yours will likely be different.


#### **4. Run the image**

`$ docker run --name <YOUR_CONTAINER_NAME> snowflake-twitter:latest <YOUR_TWITTER_KEYWORD>`

Example (searching for #wednesdaymotivation):

`$ docker run --name twitter-wednesdaymotivation snowflake-twitter:latest wednesdaymotivation`

At this point you should be able to see the tweets coming in... (every `.` represents two tweets)

#### **5. Configure Snowpipe in Snowflake**

-   Log into your Snowflake demo account and load the _0_setup_twitter_snowpipe.sql_  script (edited at point 2).
-   Execute the script one statement at a time.
-   Make sure to configure event notifications in AWS S3 as described  [here](https://docs.snowflake.net/manuals/user-guide/data-load-snowpipe-auto-s3.html#step-4-configure-event-notifications).

#### **6.  Stop your container**

Once you have finished with the setup, it's important that you stop your container in order not to reach your  [Twitter API rate limits](https://developer.twitter.com/en/docs/basics/rate-limits).

Go back to Terminal, open a new Terminal tab (you can use the shortcut ⌘T) and execute the following command:

```bash
docker stop <YOUR_CONTAINER_NAME>
```

**Note**: the container has a "safety" timeout of 15 minutes.