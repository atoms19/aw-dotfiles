#!/bin/sh


cliphist list | wofi --show dmenu | cliphist decode | wl-copy
