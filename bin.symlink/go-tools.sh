#!/bin/bash

go get -u  \
   code.google.com/p/rog-go/exp/cmd/godef  \
   github.com/PuerkitoBio/goquery  \
   github.com/goerr/goerr  \
   github.com/golang/lint/golint  \
   github.com/nsf/gocode  \
   golang.org/x/tools/cmd/godoc \
   golang.org/x/tools/cmd/gorename  \
   golang.org/x/tools/oracle

sudo go get -u \
     golang.org/x/tools/cmd/cover  \
     golang.org/x/tools/cmd/vet
