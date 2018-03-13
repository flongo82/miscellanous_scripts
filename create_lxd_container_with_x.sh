if [ "$#" -ne 1 ]; then
    echo "Usage: ./create_lxd_container_with_x.sh <container_name>"
fi

echo Creating $1
lxc launch ubuntu:17.10 $1 > /dev/null
sleep 20
echo Upgrading $1
lxc exec $1 -- sh -c "apt update" &> /dev/null
lxc exec $1 -- sh -c "apt upgrade -y" &> /dev/null
lxc exec $1 -- sh -c "apt dist-upgrade -y" &> /dev/null
lxc exec $1 -- sh -c "apt autoremove -y" &> /dev/null
echo Configuring $1
lxc config set $1 raw.idmap "both $UID 1000" > /dev/null
lxc restart $1 > /dev/null
lxc config device add $1 X0 disk path=/tmp/.X11-unix/X0 source=/tmp/.X11-unix/X0 > /dev/null
lxc config device add $1 Xauthority disk path=/home/ubuntu/.Xauthority source=${XAUTHORITY} > /dev/null
lxc config device add $1 mygpu gpu > /dev/null
lxc config device set $1 mygpu uid 1000 > /dev/null
lxc config device set $1 mygpu gid 1000 > /dev/null
lxc exec $1 -- sh -c "echo export DISPLAY=:0 >> /home/ubuntu/.profile" > /dev/null


