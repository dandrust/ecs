#!/usr/bin/env sh

../../vm_translator.rb ./StackTest.vm && 
  ../../../../tools/CPUEmulator.sh StackTest.tst
