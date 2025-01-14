#!/usr/bin/env bash
set -euo pipefail
#
# GPG script to encrypt a file with our best settings.
#
# Syntax:
#
#     gpg-encrypt <file>
#
# Example:
#
#     $ gpg-encrypt foo.txt
#
# Output is a new encrypted file:
#
#     foo.txt.gpg
#
# To decrypt the file:
#
#     $ gpg-decrypt example.txt.aes
#
#
# ## Settings
#
#    * Symmetric encryption, i.e. we use the same password for encryption and decryption.
#      We choose this because our users can understand symmetric more easily than asymmetic.
#
#    * Encryption using the aes256 cipher algorithm.
#      We choose this because it's a good balance of strong and portable.
#
#    * digesting using the sha256 digest algorithm.
#      We choose this because it's a good balance of strong and portable.
#
#    * No compression, because typically our files are small or already compressed.
#      We choose this to maximize portability, PGP compatibility, and speed.
#
#    * Explicit settings, rather than depending on defaults.
#
#    * Suitable for GPG v2; backwards-compatible with GPG v1 when possible.
#
# To get our settings, we use these gpg options:
#
#    --symmetric                   Encrypt with symmetric cipher only This command asks for a passphrase.
#
#    --cipher-algo aes256          Use AES256 as the cipher algorithm
#
#    --digest-algo sha256          Use SHA256 as the digest algorithm.
#
#    --cert-digest-algo sha256     Use SHA256 as the message digest algorithm used when signing a key.
#
#    --compress-algo none -z 0     Do not compress the file.
#
#    --s2k-mode 3                  Use passphrase mangling iteration mode.
#
#    --s2k-digest-algo sha256      Use SHA256 as the passphrase iteration algorithm.
#
#    --s2k-count 65011712          Use the maximum number of passphrase iterations.
#
#    --no-symkey-cache             Disable the passphrase cache.
#
#    --force-mdc                   Use modification detection code.
#
#    --quiet                       Try to be as quiet as possible.
#
#    --no-greeting                 Suppress the initial copyright message but do not enter batch mode.
#
#    --pinentry-mode=loopback      Use the terminal for PIN entry.
#
#
# ## More examples
#
# To encrypt a file:
#
#     $ gpg-encrypt foo
#
# To encrypt a file to a specific output file name:
#
#     $ gpg-encrypt foo --output goo.gpg
#
# To encrypt a directory:
#
#     $ tar --create foo | gpg-encrypt --output foo.tar.gpg
#
# To encrypt a file then delete it:
#
#     $ gpg-encrypt foo && rm foo
#
# To encrypt a directory then delete it:
#
#     $ tar -c foo | gpg-encrypt --output foo.tar.gpg && rm -rf foo
#
#
# ## Advice
#
# We tend to use these naming conventions:
#
#   * GPG file name extension `.gpg`.
#   * tar file extension `.tar`.
#
# We tend to skip compression:
#
#   * We tend to use `gpg` without using compression.
#   * We tend to use `tar` without using compression.
#
#
# ## Troubleshooting
#
# ### TTY
#
# If you get error messages like this:
#
#     gpg: Inappropriate ioctl for device
#     gpg: problem with the agent: Inappropriate ioctl for device
#     gpg: error creating passphrase: Operation cancelled
#     gpg: symmetric encryption of `[stdin]' failed: Operation cancelled
#
# Then try this:
#
#     $ export GPG_TTY=$(tty)
#
#
# ### Restart
#
# If you get error message like this:
#
#     gpg: WARNING: server 'gpg-agent' is older than us (2.2.6 < 2.2.7)
#     gpg: Note: Outdated servers may lack important security fixes.
#     gpg: Note: Use the command "gpgconf --kill all" to restart them.
#     gpg: signal Interrupt caught ... exiting
#
# Then try this:
#
#     $ gpgconf --kill all
#
#
# ## See also
# 
# These commands are similar:
# 
#   * [`gpg-encrypt`](https://github.com/SixArm/gpg-encrypt): 
#     use GPG to encrypt a file using our best settings.
#   
#   * [`gpg-decrypt`](https://github.com/SixArm/gpg-decrypt): 
#     use GPG to decrypt a file using our best settings.
#
#   * [`openssl-encrypt`](https://github.com/SixArm/openssl-encrypt): 
#     use OpenSLL to encrypt a file using our best settings.
#   
#   * [`openssl-decrypt`](https://github.com/SixArm/openssl-decrypt): 
#     use OpenSSL to decrypt a file using our best settings.
#
#
# ## Tracking
#
#   * Command: gpg-encrypt
#   * Website: https://sixarm.com/gpg-encrypt
#   * Cloning: https://github.com/sixarm/gpg-encrypt
#   * Version: 4.0.0
#   * Created: 2010-05-20
#   * Updated: 2018-11-01
#   * License: GPL
#   * Contact: Joel Parker Henderson (joel@joelparkerhenderson.com)
#   * Tracker: 064750fa2efe1ca54b518a2ba8b4c34e
##
set -eu
gpg \
    --symmetric \
    --cipher-algo aes256 \
    --digest-algo sha256 \
    --cert-digest-algo sha256 \
    --compress-algo none -z 0 \
    --s2k-mode 3 \
    --s2k-digest-algo sha512 \
    --s2k-count 65011712 \
    --no-symkey-cache \
    --force-mdc \
    --quiet --no-greeting \
    --pinentry-mode=loopback \
    "$@"
