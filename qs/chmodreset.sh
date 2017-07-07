#! /bin/bash

dir=$1

chmod -R g-w $dir
chmod -R o-w $dir
cd $dir && find -type f -exec chmod 644 {} \;
