#!/usr/bin/env bash

####################################################
# install http://mikefarah.github.io/yq/read/ first
####################################################

# set -x

# parses .travis.yml for content of
# .. env:
#      global:
out=$(yq r .travis.yml env.global)
# and replaces the leading dash with export
out=$(echo "$out" | sed -E "s/^-/export/")

# This whole is required cause bash -c can not resolve vars, neither on multiline
while IFS= read -r line
do
   # ... nor on singleline.
   # Used envsubst here...
   thecmd=$(echo $line | envsubst)
   # but had to use eval, cause a subshell ala 
   # bash -c does not deliver
   echo $thecmd
   eval "$thecmd" # the "" around $thecmd prevents the shell from expanding to the first space or #
done < <(printf '%s\n' "$out")

# set +x