#!/bin/bash

link=$(echo "${1/\/details\//download}&output=json")
itemname=$(echo "${1/https:\/\/archive.org\/details\//}")
apires=(curl "$link")

mkdir 
