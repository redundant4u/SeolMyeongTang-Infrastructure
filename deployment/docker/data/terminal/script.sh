#!/bin/sh

WORKDIR="/home/seol"

useradd -U -u 999 -d ${WORKDIR} -l seol

### Disable Linux command
mkdir -p ${WORKDIR}/bin

cp /bin/ls ${WORKDIR}/bin/ls
cp /bin/cat ${WORKDIR}/bin/cat
cp /bin/clear ${WORKDIR}/bin/clear

### Remove SSH Welcome Message
touch ${WORKDIR}/.hushlogin

### Set bash settings
mv bashrc .bashrc
mv bash_profile .bash_profile
mv inputrc .inputrc

### Set rbash
chsh -s /bin/rbash seol

### Configure SSH Setting
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

mkdir -p ${WORKDIR}/.ssh /run/sshd

### Set SSH key
ssh-keygen -N '' -t rsa -f ${WORKDIR}/.ssh/terminal
mv ${WORKDIR}/.ssh/terminal.pub ${WORKDIR}/.ssh/authorized_keys

chmod 644 ${WORKDIR}/.ssh/authorized_keys
chmod 400 ${WORKDIR}/.ssh/terminal

### Clean up
rm ./script.sh
