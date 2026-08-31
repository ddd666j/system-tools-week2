#!/usr/bin/env bash
printf 'alpha\nbeta\ngamma\n'
echo 'producer: simulated failure' >&2
exit 7
