#!/bin/bash

source /scripts/my.env
export PATH=/root/.cargo/bin:$PATH
alias psql="/hab/pkgs/core/postgresql/9.6.1/20170606002619/bin/psql -U hab -h 127.0.0.1"
