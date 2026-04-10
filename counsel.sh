#!/usr/bin/env bash
cd "$(dirname "$0")" && claude --plugin-dir . "$@"
