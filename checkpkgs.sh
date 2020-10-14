#!/bin/sh

for d in core extra base wayland game; do
    kiss ou $d
done
