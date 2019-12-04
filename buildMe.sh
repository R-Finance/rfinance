#!/bin/sh

## GitHub pages wants static content in top-level directory docs/ so we make it so
hugo --destination docs --baseURL="https://www.rinfinance.com/"
