#!/bin/bash

set -e

echo "in the entrypoint script"
while getopts :u:n: flag; do
    case "${flag}" in
        u)
          userid=${OPTARG}
          ;;
        n)
          uname=${OPTARG}
          ;;
    esac
done

# get host user and ensure they own the picogk dir
export uid=${userid%"${userid#????}"}

# check if the user already exists
if id "$uname" >/dev/null 2>&1; then
  echo "user $uname already exists"
else
  echo "user $uname does not exist, creating..."
  useradd -u $uid -s /bin/bash $uname
fi
echo "setting picogk volume owner to $uname $userid"
chown -R $userid /root/picogk

# add PicoGKRuntime library to /usr/local/lib
if [ -f "$PICOGK_LIB" ]; then
  echo "adding PicoGKRuntime library to /usr/local/lib"
  cp $PICOGK_LIB /usr/local/lib; else
  echo "PicoGKRuntime library not found at $PICOGK_LIB"
fi

#execute the command passed to the docker run
exec /bin/bash