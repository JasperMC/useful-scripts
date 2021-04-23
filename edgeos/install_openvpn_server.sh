!#/bin/bash

# Log in as the root user.
sudo su

echo 'Generating DH Keyfile in /config/auth'
# Generate a Diffie-Hellman (DH) key file and place it in the /config/auth directory.
openssl dhparam -out /config/auth/dh.pem -2 2048

# Change the current directory.
cd /usr/lib/ssl/misc

# Generate a root certificate (replace <secret> with your desired passphrase).
echo 'Generating a root certificate: Please enter your desired passphrase'
./CA.pl -newca

# Copy the newly created certificate + key to the /config/auth directory.
echo "Copying certifcate and key to /config/auth"
cp demoCA/cacert.pem /config/auth
cp demoCA/private/cakey.pem /config/auth


# Generate the server certificate.
echo "Generating new server certificate"
./CA.pl -newreq

# Sign the server certificate.
echo "Signing new server certificate"
./CA.pl -sign


# Move and rename the server certificate and key files to the /config/auth directory.
echo "Moving and renaming server certificate and key files to /config/auth"
mv newcert.pem /config/auth/server.pem
mv newkey.pem /config/auth/server.key

# Generate, sign and move the certificate and key files for the first OpenVPN client.
echo "Generating, signing and moving the certificate and key files for the first OpenVPN client.
./CA.pl -newreq
./CA.pl -sign
