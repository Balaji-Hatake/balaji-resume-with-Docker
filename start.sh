#!/bin/bash

# Start Webmin
service webmin start

# Start Apache in foreground
apachectl -D FOREGROUND