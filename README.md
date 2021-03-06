# LetsEncrypt CNAME

AS211869.net (and a few of my other domains) use self-hosted DNS servers which do not provide an easy to use method to remotely update records. Due to this, it can be challenging to obtain a wildcard LetsEncrypt certificate using automated tools. The scripts in this repository aim to fix that by making use of the DigitalOcean DNS API.

# Usage

Create a DNS zone at DigitalOcean, and set your NS records for that (sub)domain to the DigitalOcean name servers. Enter this zone into a text file called `zone.txt`.

![DigitalOcean DNS](https://cdn.truewinter.dev/i/5f5e90.png)

![Cloudflare DNS](https://cdn.truewinter.dev/i/513f5a.png)

Then, create a DigitalOcean API key, ensuring that it has `write` permissions. Copy this key into a text file called `key.txt`.

Create a CNAME record for `_acme-challenge.example.com` and point it to `example-com.{ZONE}`.

![CNAME Record](https://cdn.truewinter.dev/i/f3248f.png)

By default, the script will wait 30 seconds before allowing LetsEncrypt to validate the DNS records. This can be overridden by creating a file called `sleep.txt` containing the number of seconds the script should wait.

Modify the command in `command.txt` as needed, and the run the command with `sudo`. If successful, you should now have a LetsEncrypt wildcard certificate in the directory indicated by the script.

# Requirements

- Linux (tested on Ubuntu 18.04 and 20.04)
- curl
- jq