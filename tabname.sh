#!/bin/bash

# function to change the name of tab (might be osx specific)

function tabname {
  printf "\e]1;$1\a"
}
