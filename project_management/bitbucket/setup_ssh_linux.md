# **[Set up personal SSH keys on Linux](https://support.atlassian.com/bitbucket-cloud/docs/set-up-personal-ssh-keys-on-linux/)**

## check access

```bash
curl https://bitbucket.org/site/ssh
```

The Secure Shell protocol (SSH) is used to create secure connections between your device and Bitbucket Cloud. The connection is authenticated using public SSH keys, which are derived from a private SSH key (also known as a private/public key pair). The secure (encrypted) connection is used to securely transmit your source code between your local device and Bitbucket Cloud. To set up your device for connecting Bitbucket Cloud using SSH, you need to:

1. Install OpenSSH on your device.
2. Start the SSH Agent.
3. Create an SSH key pair.
4. Add your key to the SSH agent.
5. Provide Bitbucket Cloud with your public key.
6. Check that your SSH authentication works.

## Create an SSH key pair

To create an SSH key pair:

1. Open a terminal and navigate to your home or user directory using cd, for example:

    `cd ~`
2. Generate a SSH key pair using ssh-keygen, such as:

```bash
# ssh-keygen -t ed25519 -b 4096 -C "{<username@emaildomain.com>}" -f ~/.ssh/{ssh-key-name}
ssh-keygen -t ed25519 -b 4096 -C "brent.groves@linamar.com" -f ~/.ssh/bitbucket_home
ssh-keygen -t ed25519 -b 4096 -C "brent.groves@gmail.com" -f ~/.ssh/bitbucket_personal
ssh-keygen -t ed25519 -b 4096 -C "brent.groves@linamar.com" -f ~/.ssh/bitbucket_isdev
ssh-keygen -t ed25519 -b 4096 -C "brent.groves@gmail.com" -f ~/.ssh/gitlab

```

Where:

- {<username@emaildomain.com>} is the email address associated with the Bitbucket Cloud account, such as your work email account.

- {ssh-key-name} is the output filename for the keys. We recommend using a identifiable name such as bitbucket_work.

1. Add your key to the SSH agent
    To add the SSH key to your SSH agent (ssh-agent):

    Run the following command, replacing the {ssh-key-name} with the name of the private key:

    ```bash
    # ssh-add ~/.ssh/{ssh-key-name}
    ssh-add ~/.ssh/bitbucket_home
    Identity added: /home/brent/.ssh/bitbucket_home (brent.groves@linamar.com)
    ssh-add ~/.ssh/bitbucket_personal
    Identity added: /home/brent/.ssh/bitbucket_personal (brent.groves@gmail.com)
    ```

2. To ensure the correct SSH key is used when connecting to Bitbucket, update or create your SSH configuration file (~/.ssh/config) with the following settings:

Host bitbucket.org
  AddKeysToAgent yes
  IdentityFile ~/.ssh/{ssh-key-name}

Where {ssh-key-name} is the name of the private key file once it has been added to the ssh-agent.

## Provide Bitbucket Cloud with your public key

To add an SSH key to your user account:

1. Select the Settings cog on the top navigation bar.
2. From the Settings dropdown menu, select Personal Bitbucket settings.
3. Under Security, select SSH keys.
4. Select Add key.
5. In the Add SSH key dialog, provide a Label to help you identify which key you are adding. For example, Work Laptop <Manufacturer> <Model>. A meaningful label will help you identify old or unwanted keys in the future.
6. Copy the contents of the public key file and paste the key into the Key field of the Add SSH key dialog.

    Copy and paste your key with
    `cat ~/.ssh/bitbucket_home.pub | xclip -selection clipboard`

7. Under Expiry, select No expiry to not set an expiry date, or select Expires on and then select the date picker to set a specific date for your SSH key to expire. Note: The default date range for expiry is set to 365 days (one year) from today’s date.

8. Select Add key.

If the key is added successfully, the dialog will close and the key will be listed on the SSH keys page.

If you receive the error That SSH key is invalid, check that you copied the entire contents of the public key (.pub file).

## Check that your SSH authentication works

To test that the SSH key was added successfully, open a terminal on your device and run the following command:

`ssh -T git@bitbucket.org`
If SSH can successfully connect with Bitbucket using your SSH keys, the command will produce output similar to:

authenticated via ssh key.
You can use git to connect to Bitbucket. Shell access is disabled

<https://support.atlassian.com/bitbucket-cloud/docs/create-your-workspace/>
