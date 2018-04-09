#!/usr/bin/env sh

../../vm_translator.rb ./SimpleAdd.vm && 
  ../../../../tools/CPUEmulator.sh SimpleAdd.tst

