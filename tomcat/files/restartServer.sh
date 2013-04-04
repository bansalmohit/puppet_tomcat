#!/bin/bash

SERVER_NAME=$1
/home/tomcat/release/stopServer.sh $SERVER_NAME
/home/tomcat/release/startServer.sh $SERVER_NAME

