#! /usr/bin/env bash

if ! [[ -f ${NEAR_HOME}/genesis.json ]]; then
  neard --home=${NEAR_HOME} init
fi

if [[ -f ${NEAR_CONFIG} ]]; then
  cp ${NEAR_CONFIG} ${NEAR_HOME}/config.json
fi

exec neard --home=${NEAR_HOME} "${@}"
