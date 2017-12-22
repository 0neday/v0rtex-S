#!/bin/bash

currDir=$(dirname $0)

echo "Found current dir: $currDir"

binCount=$(ls -1q  $currDir/bins | wc -l | sed -e 's/^[ `t]*//')

echo "Found $binCount bins"

echo "Giving all bins correct permissions (755)..."

for file in $currDir/bins/*
do
  chmod 755 $file
done

echo "Packing the binpack..."

cd $currDir
tar -cf bootstrap.tar ./bins/*

echo "Packed $binCount bins from $currDir/bins into $currDir/bootstrap.tar!"

echo "Please copy the bootstrap.tar file into the Xcode project!"
