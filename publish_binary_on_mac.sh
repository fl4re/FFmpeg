#!/bin/bash -xe

# make sure we are inside a git checkout
git rev-parse --is-inside-work-tree

# finally prades publish
prades publish -v

exit 0
