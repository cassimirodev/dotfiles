#!/bin/bash

echo "[SETUP] Configurando Git Global..."

git config --global user.name "cassimirodev"
git config --global user.email "luiseduardocass06@gmail.com"
git config --global init.defaultBranch main

git config --global core.editor "nano"
git config --global color.ui true