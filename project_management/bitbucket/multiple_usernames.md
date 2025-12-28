# **[Managing multiple Bitbucket user SSH keys on one device](https://support.atlassian.com/bitbucket-cloud/docs/managing-multiple-bitbucket-user-ssh-keys-on-one-device/)**

If you have more than one Bitbucket Cloud account (such as a personal account and a work account), some additional configuration is required to use two (or more) accounts on the same device. This additional configurations ensures that Git connects to Bitbucket as the correct user for each repository cloned to your device. Due to the differences between operating systems and SSH-based access methods (Personal SSH Keys and Access Keys), this guide should be read alongside the relevant **[SSH setup guide for your operating system](https://support.atlassian.com/bitbucket-cloud/docs/configure-ssh-and-two-step-verification/)**.

1. Check that SSH is installed and the SSH Agent is started (see the relevant SSH setup guide for your operating system).

2. Create an SSH key pair for each account, such as:

    ```bash
    ssh-keygen -t ed25519 -b 4096 -C "{username@emaildomain.com}" -f {ssh-key-name}
    ```

3. Add each private key to the SSH agent, such as:

    ```bash
    ssh-add ~/.ssh/{ssh-key-name}
    ```

4. Add each private key to the SSH configuration, such as:

    ```toml
    # git@gitlab.com-linamar:brent.groves/liokr.git
    Host gitlab.com-linamar
      HostName gitlab.com
      User git
      IdentityFile ~/.ssh/gitlab_linamar
      IdentitiesOnly yes
    #brent_admin account
    Host bitbucket.org-brent_admin
      HostName bitbucket.org
      User git
      IdentityFile ~/.ssh/bitbucket_home
      IdentitiesOnly yes
    #brent_groves account
    Host bitbucket.org-brent_groves
      HostName bitbucket.org
      User git
      IdentityFile ~/.ssh/bitbucket_personal
      IdentitiesOnly yes
    ```

    Where bitbucket_username1 and bitbucket_username2 are the Bitbucket usernames of the two accounts the SSH keys were created for. Your Bitbucket username is listed under Bitbucket profile settings on your **[Bitbucket Personal settings](https://bitbucket.org/account/settings/)** page.

5. Add the public keys to the corresponding accounts on Bitbucket Cloud (see the relevant **[SSH setup guide](https://support.atlassian.com/bitbucket-cloud/docs/configure-ssh-and-two-step-verification/)** for your operating system).

6. Clone repositories or update the git remote for repositories already cloned.

To clone a repository, use the git clone command with the updated host bitbucket.org-{bitbucket_username}, such as:

```bash
# git clone git@bitbucket.org-{bitbucket_username}:{workspace}/{repo}.git
git clone git@bitbucket.org-brent_groves:biokr/biokr.git
git clone git@bitbucket.org-brent_admin:liokr/liokr.git
git clone git@gitlab.com-linamar:brent.groves/liokr.git

```
