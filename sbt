#!/usr/bin/env bash

SBT_OPTS="-Xms512M -Xmx1536M -Xss1M"
java $SBT_OPTS -jar `dirname $0`/project/sbt-launch.jar "$@"
