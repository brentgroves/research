# **[SHA-256 checksum](https://unix.stackexchange.com/questions/464010/how-to-verify-a-checksum-using-one-command-line)**

## references

- **[how to verify asc](https://serverfault.com/questions/896228/how-to-verify-a-file-using-an-asc-signature-file)**

**[Current Status](../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../research_list.md)**\
**[Back Main](../../../../README.md)**

## reference

- **[sha256sum](https://linux.die.net/man/1/sha256sum)**

## Download file

```bash
cd ~/Downloads
wget https://github.com/containerd/containerd/releases/download/v1.7.20/containerd-1.7.20-linux-amd64.tar.gz
wget https://github.com/containerd/containerd/releases/download/v1.7.20/containerd-1.7.20-linux-amd64.tar.gz.sha256sum
```

## How to verify SHA-256 checksum?

```bash
sha256sum -c containerd-1.7.20-linux-amd64.tar.gz.sha256sum
containerd-1.7.20-linux-amd64.tar.gz: OK
```

## **[how to verify a file with asc signature file](https://www.baeldung.com/linux/verify-file-asc-signature)**

Adding Public Key to Keyring
To get started, we’ll first need to ensure that we have the issuer’s public key in our keyring. Information on where to acquire the issuer’s public key will usually be in the same place as the target file. For the most part, this will also include the key’s fingerprint to check against when importing.

If the public key is provided through a file, we can simply download the file and then import it:

```bash
cd ~/Downloads
wget https://github.com/opencontainers/runc/raw/main/runc.keyring
gpg --show-keys --with-fingerprint runc.keyring
pub   rsa4096 2016-06-21 [SC] [expires: 2031-06-18]
      5F36 C6C6 1B54 6012 4A75  F5A6 9E18 AA26 7DDB 8DB4
uid                      Aleksa Sarai <asarai@suse.com>
uid                      Aleksa Sarai <asarai@suse.de>
sub   rsa4096 2016-06-21 [E] [expires: 2031-06-18]

pub   ed25519 2019-06-21 [C]
      C9C3 70B2 46B0 9F6D BCFC  744C 3440 1015 D1D2 D386
uid                      Aleksa Sarai <cyphar@cyphar.com>
sub   ed25519 2019-06-21 [S] [revoked: 2022-09-30]
sub   cv25519 2019-06-21 [E] [revoked: 2022-09-30]
sub   ed25519 2019-06-21 [A] [revoked: 2022-09-30]
sub   ed25519 2022-09-30 [S] [expires: 2030-03-25]
sub   cv25519 2022-09-30 [E] [expires: 2030-03-25]
sub   ed25519 2022-09-30 [A] [expires: 2030-03-25]

pub   rsa2048 2020-04-28 [SC] [expires: 2025-04-18]Releases
You can find official releases of runc on the release page.

All releases are signed by one of the keys listed in the runc.keyring file in the root of this repository.

      C242 8CD7 5720 FACD CF76  B6EA 17DE 5ECB 75A1 100E
uid                      Kir Kolyshkin <kolyshkin@gmail.com>
sub   rsa2048 2020-04-28 [E] [expires: 2025-04-18]

pub   rsa3072 2019-07-25 [SC] [expires: 2025-07-27]
      C020 EA87 6CE4 E06C 7AB9  5AEF 4952 4C6F 9F63 8F1A
uid                      Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
uid                      Akihiro Suda <suda.kyoto@gmail.com>
```

The previous command allows us to obtain the fingerprint of the key file. It’s important to compare this fingerprint to the fingerprint listed at a trusted source, such as the issuer’s website, to verify that it is the correct public key. After verifying our public key file, we can then import it:

```bash
gpg --import runc.keyring
gpg: /home/ubuntu/.gnupg/trustdb.gpg: trustdb created
gpg: key 9E18AA267DDB8DB4: public key "Aleksa Sarai <asarai@suse.com>" imported
gpg: key 34401015D1D2D386: public key "Aleksa Sarai <cyphar@cyphar.com>" imported
gpg: key 17DE5ECB75A1100E: public key "Kir Kolyshkin <kolyshkin@gmail.com>" imported
gpg: key 49524C6F9F638F1A: public key "Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>" imported
gpg: Total number processed: 4
gpg:               imported: 4
```

A public key may be hosted on a keyserver as well. To import a key from a keyserver, we should use the full fingerprint of the public key. This is important because key IDs are vulnerable to collision attacks.

```bash
$ gpg --keyserver 'keys.openpgp.org' --recv-keys 'A21FAB74B0088AA361152586B8EF1A6BA9DA2D5C'
gpg: key B8EF1A6BA9DA2D5C: public key "Tomáš Mráz <tm@t8m.info>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

To import a key from a keyserver, we use gpg with the –keyserver option passing it to the keyserver we want to search. Since most key servers share keys with each other, it typically will not matter which keyserver we use long as it is reputable. Then, we use the –recv-keys option with the fingerprint of the public key we want to import. The key will automatically be downloaded to our keyring if found on the key server.

## Download the file

```bash
wget https://github.com/opencontainers/runc/releases/download/v1.1.13/runc.amd64
wget https://github.com/opencontainers/runc/releases/download/v1.1.13/runc.amd64.asc
```

## Verifying Our File

After ensuring that we have the correct public key, we can begin verifying our file:

```bash
$ gpg --verify runc.amd64.asc runc.amd64
gpg: Signature made Thu Jun 13 15:59:00 2024 UTC
gpg:                using RSA key C2428CD75720FACDCF76B6EA17DE5ECB75A1100E
gpg: Good signature from "Kir Kolyshkin <kolyshkin@gmail.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: C242 8CD7 5720 FACD CF76  B6EA 17DE 5ECB 75A1 100E
```

Here we use gpg –verify  with our signature file and the file we want to verify. The output indicates that our file was verified successfully.

The output may also contain this warning:

```bash
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
```

If we have added our public key to our keyring but not to our list of trusted keys, this will be included in the output.

In general, this warning can be safely ignored if we have properly verified that the public key in our keyring is correct. However, if we want to prevent this warning from being displayed, we can add the associated public key to our trusted keys.

When the verification process has failed, the output includes this line:

```bash
gpg: BAD signature from "Tomáš Mráz <tm@t8m.info>" [unknown]
Copy
This output indicates our verification was unsuccessful, and we should redownload the file and signature.
```

**[The other is you could tell gpg to go ahead and trust.](https://security.stackexchange.com/questions/147447/gpg-why-is-my-trusted-key-not-certified-with-a-trusted-signature)**

```bash
gpg --encrypt --recipient YOUR_RECIPIENT --trust-model always YOUR_FILE
```
