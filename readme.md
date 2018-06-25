# Cloudflare Dynamic DNS Updater

_Simple Bash Script to update your Cloudflare DNS IPv4 and IPv6 Addresses._

## Parameter

- `EXTERNAL_IPv4`: optional, if not set it uses the current external ipv4 addr
- `EXTERNAL_IPv6`: optional, if not set it uses the current external ipv6 addr
- `CF_EMAIL`: required, your cloudflare login email
- `CF_TOKEN`: required, your cloudflare api key (you can find it under [Settings](https://www.cloudflare.com/a/account/my-account) -> `API Key` -> `Global API Key`)
- `CF_ZONE_NAME` required, your root domain name (eg. example.tld)
- `CF_DOMAIN_NAME` required, your domain or subdomain name you want to update (eg. subdomain.example.tld)

## FreeBSD

This is a bash script. It is necessary to install `bash`, `jq` & `bind-tools`

## Crontab

(Freebsd) add the following line to `/etc/crontab`

```
*/5     *       *       *       *       root    /usr/local/bin/bash /usr/local/bin/cloudflare-update-v4-and-v6.sh
```
