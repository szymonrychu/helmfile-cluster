#!/bin/sh -ex

# ensure sudo group exists
if [ $(grep '^sudo\:' /etc/group | wc -l) -lt 1 ]; then
    groupadd --system "sudo"
fi

# sudo group no password
echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/50-sudo-nopasswd

# username
if [ $(grep "^${username}\:" /etc/passwd | wc -l) -lt 1 ]; then
    useradd --shell "/bin/bash" --groups "sudo" --create-home "${username}"
fi

# username_path
if [ "${username}" = "root" ]; then
    USERNAME_PATH="/root"
else
    USERNAME_PATH="/home/${username}"
fi

# username_sshkeys
mkdir -p "$USERNAME_PATH/.ssh"
cat > $USERNAME_PATH/.ssh/id_rsa <<EOF
${private_ssh_key}
EOF
cat > $USERNAME_PATH/.ssh/id_rsa.pub <<EOF
${public_ssh_key}
EOF
cp $USERNAME_PATH/.ssh/id_rsa.pub $USERNAME_PATH/.ssh/authorized_keys
chown -R "${username}":"${username}" "$USERNAME_PATH/.ssh"
chmod 0700 "$USERNAME_PATH/.ssh"
chmod 0600 "$USERNAME_PATH/.ssh/id_rsa"
chmod 0600 "$USERNAME_PATH/.ssh/authorized_keys"

# remove root passwd and reset timeouts
sed -i -e '/^root:/s/^.*$/root:\*:17000:0:99999:7:::/' /etc/shadow

# disable root ssh login
if [ "${username}" != "root" ]; then
    rm -f "/root/.ssh/*.pub"
    rm -f "/root/.ssh/authorized_keys"
    sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
    /etc/init.d/ssh reload
fi

