#!/bin/sh

## GitHub pages wants static content in top-level directory docs/ so we make it so
cd conference && hugo server --destination ../docs
