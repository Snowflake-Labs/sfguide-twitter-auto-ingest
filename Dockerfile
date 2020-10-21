FROM python:slim
RUN pip install -U pip
RUN pip install --no-cache-dir boto3
RUN pip install --no-cache-dir awscli
RUN pip install --no-cache-dir tweepy
RUN pip install --no-cache-dir datetime


    #get your AWS Access keys: https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html
ENV AWS_Access_Key_ID="********************"\
    AWS_Secret_Access_Key="****************************************"\
    #get your Twitter API Key and Secret https://developer.twitter.com/en/apply-for-access
    consumer_key="*************************"\
    consumer_secret="**************************************************"\
    # get your Twitter Access Token and Secret https://developer.twitter.com/en/apply-for-access
    access_token="**************************************************"\
    access_token_secret="*********************************************"\
    #AWS bucket name
    bucket="my-twitter-bucket"\
    # specify your own default twitter keyword here. 
    keyword="covid19"

ENV PYTHONUNBUFFERED=1

COPY ./twitter_local.py .
COPY ./twitter_local.sh .

RUN aws configure set aws_access_key_id $AWS_Access_Key_ID
RUN aws configure set aws_secret_access_key $AWS_Secret_Access_Key
RUN ["chmod","+x","/twitter_local.sh"]
ENTRYPOINT ["/bin/sh","/twitter_local.sh"]
