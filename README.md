# Luzifer / github-masswatch

[![License: Apache 2.0](http://badge.luzifer.io/v1/badge?color=5d79b5&title=license&text=Apache%202.0)](LICENSE)

This project is a small helper for mass-watching / unwatching in GitHub repositories. If you are in a bigger organization like me you might have switched off auto-watching for new repositories as your mailbox gets flooded with stuff you don't even like to see. So after turning off the automatic watching you will not notice new repositories and you have to subscribe them one by one. To make this a bit more easy and have a chance to do this with a Jenkins job or similar I wrote this little tool.

## Features

- List all repositories you have access to
- List all repositories you are currently subscribed to
- Test a RegExp against that repository list
- Watch and unwatch repositories by providing a RegExp

## Simple usage example

```bash
# bundle install
[...]

# ruby watch.rb help
Commands:
  watch.rb help [COMMAND]   # Describe available commands or one specific command
  watch.rb list <regex>     # lists all repos, useful to test your watch regex
  watch.rb unwatch <regex>  # unwatch all repos matching your regex
  watch.rb watch <regex>    # watch all repos matching your regex
  watch.rb watched <regex>  # show all watched repos, useful to test your unwatch regex

Options:
  [--token=TOKEN]

# ruby watch.rb list --token=<mytoken>
Luzifer/alarmclock
Luzifer/alfred-fold
Luzifer/alfred-pwdgen
Luzifer/AMZWishlist
Luzifer/awsenv
[...]

# ruby watch.rb list '^Luzifer/alfred-.*' --token=<mytoken>
Luzifer/alfred-fold
Luzifer/alfred-pwdgen

# ruby watch.rb watch '^Luzifer/alfred-.*' --token=<mytoken>
Subscribing to Luzifer/alfred-fold...
Subscribing to Luzifer/alfred-pwdgen...
```

## Advanced: Auto-Watch repos using Jenkins

Given you have a running Jenkins instance you either can let it clone this repository and put your watch commands into the build-script or if your Jenkins does not understand Ruby but is able to execute Docker containers you could use this script to auto-watch repositories:

```bash
#!/bin/bash

GHTOKEN=<mytoken>

echo "cd /scripts/" > ./build.sh
echo "bundle install" >> ./build.sh
echo "bundle exec ruby watch.rb watch '^YourOrg/someprefix' --token=$GHTOKEN" >> ./build.sh
echo "bundle exec ruby watch.rb watch '^Luzifer/' --token=$GHTOKEN" >> ./build.sh

docker pull ruby:2.1
docker run --rm -v ${PWD}:/scripts ruby:2.1 bash /scripts/build.sh
```

For this you also let Jenkins clone this repository and then put that script into the build commands. The tool will now run in a ruby container which is disposed afterwards.

## Docker support

Besides using your local ruby installation you can also run the watch command in
a Docker container like this:
```bash
docker run --rm -it quay.io/luzifer/github-masswatch [COMMAND]
```
