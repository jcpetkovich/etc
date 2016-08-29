#!/usr/bin/env bash

sudo GOPATH=$GOPATH go get -u \
     golang.org/x/tools/cmd/cover

# Fetch happens in $GOPATH with root, can mess up ownership
sudo chown $USER:$USER -R $GOPATH

# The essentials
go get -u \
   github.com/rogpeppe/godef \
   github.com/PuerkitoBio/goquery  \
   github.com/goerr/goerr  \
   github.com/golang/lint/golint  \
   github.com/nsf/gocode  \
   golang.org/x/tools/cmd/godoc \
   golang.org/x/tools/cmd/gorename  \
   golang.org/x/tools/oracle \
   github.com/tools/godep

# Just try and get everything
go get -u golang.org/x/tools/cmd/...
# pushd $(go env GOPATH)/src/golang.org/x/tools > /dev/null
# go get -u -v ./...
# popd > /dev/null
