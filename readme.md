## Repository with shell/bash script examples

## NTP

Client and server scripts meant for debian based distributions. 
This configuration allows NTP server to serve time even when there is no connection to the Internet, thus global NTP servers are unreachable.

To run scripts use `sudo` or switch to root user.

## Password generator

A simple script generating password with at least 24 characters. The script may or may not use special sign, based on user choice.

To run script it is needed to provide two agruments:
* first argument must be "*sign*" or "*nosign*" string - it defines whether to use special signs,
* second argument must be number greater then 23 - it defines length of a password.

Examples: 

`./create_password.sh sign 24`



`./create_password.sh nosign 124`

