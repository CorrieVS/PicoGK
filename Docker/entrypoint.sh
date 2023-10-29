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

# Dynamically sets the owner of the picogk volume to the host user
if [ -d "/home/$uname/picogk" ]; then
  echo "picogk directory already exists for $uname"
else
  chown -R $userid /root
  chmod 775 /root/picogk
  mkdir /home/$uname
  # create a symlink to the volume in the home directory
  cd /home/$uname && ln -s /root/picogk picogk
fi

# check if there is not a folder called Documents in the home directory
# if not, create it.  This is where PicoGK stores log files.
if [ ! -d "/home/$uname/Documents" ]; then
  echo "creating Documents folder in /home/$uname"
  mkdir /home/$uname/Documents
fi

# set the owner of the home directory to the host user
chown -R $userid /home/$uname
echo "$uname ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$uname && \
    chmod 0440 /etc/sudoers.d/$uname

# add PicoGKRuntime library to /usr/local/lib
if [ -f "$PICOGK_LIB" ]; then
  echo "adding PicoGKRuntime library to /usr/local/lib"
  cp $PICOGK_LIB /usr/local/lib; else
  echo "PicoGKRuntime library not found at $PICOGK_LIB"
fi

#execute the command passed to the docker run
exec /bin/bash