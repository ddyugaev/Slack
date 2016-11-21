# Slack
Send notifications to the Slack

## Fail2ban
Using Fail2Ban, we can receive Slack notifications when a jail executes a ban or unban action. When the action is trigger, a notification will be sent to the slack channel of your choice with the corresponding jail name and offending IP.

## Requirements
Slack
Fail2Ban
CURL

## **Method #1 (Token)**
## **Step 1**

The first thing you will need is an [API token](https://api.slack.com/docs/oauth-test-tokens) that will allow us to issue commands to the Slack API.

## **Step 2**

**Create a new ban action for Fail2Ban**

With root, copy or use your favorite editor to create the following file:

`vim /etc/fail2ban/action.d/slack-notify.conf`

Replace **YOUR_SLACK_API_TOKEN_GOES_HERE** with the API token you created. 
And where it says “**notifications**,” that’s the channel name (without the pound sign). Also you may want to change **slack_username** and **slack_icon**

Save the file. Now it’s time to add this action to one of our jails.

## **Step 3.**

**Apply the action to your jail(s)**

For this demonstration we are going to be using the SSH and Asterisk jails. If you haven’t already, create a jail.local file for Fail2Ban in case a package update overwrite the default configuration:

`vim /etc/fail2ban/jail.local`

Now let’s add the Slack notification action.

```
[asterisk]
enabled  = true
filter   = asterisk
action   = iptables-asterisk[name=asterisk]
           slack-notify[name=SIP]
logpath  = /var/log/asterisk/security_log
maxretry = 3
bantime  = 1800

[ssh]
enabled  = true
port     = ssh
filter   = sshd
action   = iptables-multiport[name=SSH]
           slack-notify[name=SSH]
logpath  = /var/log/auth.log
maxretry = 5
bantime  = 1800
```

Save and close the file.

**Now restart the Fail2Ban service and you should see your jails starting up:**

`service fail2ban restart`

_Fail2Ban SSH jail has started_
_Fail2Ban Asterisk jail has started_


## **Method #2 (WebHook)**
## **Step 1**

**[Generate an Incoming WebHook for Slack:](https://my.slack.com/services/new/incoming-webhook/)**

## **Step 2**

**Create a new ban action for Fail2Ban**

With root, copy or use your favorite editor to create the following files:

`vim /etc/fail2ban/action.d/slack.conf`
`vim /etc/fail2ban/action.d/slack.ssh`

In slack.sh replace&nbsp;**<your hook url>**&nbsp;with the your WebHook URL. And where it says “**notifications**,” that’s the channel name.

Save the file and run chmod. 

`chmod 755 /etc/fail2ban/action.d/slack.sh`

## **Step 3.**

**Apply the action to your jail(s)**

For this demonstration we are going to be using the SSH and Asterisk jail. If you haven’t already, create a jail.local file for Fail2Ban in case a package update overwrite the default configuration:

`vim /etc/fail2ban/jail.local`

Now let’s add the Slack notification action.

```
[asterisk]
enabled  = true
filter   = asterisk
action   = iptables-asterisk[name=asterisk]
           slack[name=SIP]
logpath  = /var/log/asterisk/security_log
maxretry = 3
bantime  = 1800

[ssh]
enabled  = true
port     = ssh
filter   = sshd
action   = iptables-multiport[name=SSH]
           slack[name=SSH]
logpath  = /var/log/auth.log
maxretry = 5
bantime  = 1800
```

Save and close the file.

Optional: You may want to upload custom icon for [notification](https://slack.com/customize/emoji). Type a name: fail2ban and select picture with maximum size of 128x128.

**Now restart the Fail2Ban service and you should see your jails starting up:**

`service fail2ban restart`

_Fail2Ban SSH jail has started_
_Fail2Ban Asterisk jail has started_

Both methods has tested on RasPBX – Asterisk for Raspberry Pi which is based on Debian Jessie (Raspbian).
