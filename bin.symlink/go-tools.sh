#!/usr/bin/env bash

sudo GOPATH=$GOPATH go get -u -v \
     golang.org/x/tools/cmd/cover \
     golang.org/x/tools/cmd/vet

# Fetch happens in $GOPATH with root, can mess up ownership
sudo chown $USER:$USER -R $GOPATH

# This is stupid
go get -u -v \
   code.google.com/p/rog-go/exp/cmd/godef  \
   github.com/PuerkitoBio/goquery  \
   github.com/goerr/goerr  \
   github.com/golang/lint/golint  \
   github.com/nsf/gocode  \
   golang.org/x/tools/cmd/godoc \
   golang.org/x/tools/cmd/gorename  \
   golang.org/x/tools/oracle \
   github.com/tools/godep

pushd $(go env GOPATH)/src/golang.org/x/tools > /dev/null
go get -u -v ./...
popd > /dev/null
