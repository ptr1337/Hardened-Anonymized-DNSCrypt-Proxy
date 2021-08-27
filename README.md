<h1 align=center>Hardened-Anonymized-DNSCrypt-Proxy</h1>
<p align=center>Wipe Snoopers Out Of Your Networks</p>

A flexible DNS proxy, with support for modern encrypted DNS protocols such as [DNSCrypt v2](https://dnscrypt.info/protocol), [DNS-over-HTTPS](https://www.rfc-editor.org/rfc/rfc8484.txt) and [Anonymized DNSCrypt](https://github.com/DNSCrypt/dnscrypt-protocol/blob/master/ANONYMIZED-DNSCRYPT.txt).


## Features

- For all features please refer to the [OFFICIAL PAGE](https://github.com/DNSCrypt/dnscrypt-proxy#features)
- All binary files are downloaded from the [OFFICIAL RELEASE PAGE](https://github.com/DNSCrypt/dnscrypt-proxy/releases)


## Why This Project ?

There Are Automated DNSCrypt-Proxy Client For Both [Windows](https://github.com/bitbeans/SimpleDnsCrypt) & [Android (Magisk Module)](https://codeberg.org/quindecim/dnscrypt-proxy-android) <br/>
But For Linux, People Find It Hard To Configure DNSCrypt-Proxy Manually. But I Wanted To Keep It Simple, So It's Here !


## Supported Linux Distributions

`Any SystemD Based Linux Distro`


## Differences From The Main DNSCrypt-Proxy Project

- `server_names` = `acsacsar-ams-ipv4` [NLD], `altername` [RUS], `ams-dnscrypt-nl` [NLD], `bcn-dnscrypt` [ESP], `d0wn-tz-ns1` [TZA], `dama.no-osl-s04` [NOR], `dama.no-sa-a80` [NOR], `dct-ru1` [RUS], `dct-ru2` [RUS], `dns.watch` [DEU], `dnscrypt.be` [BEL], `dnscrypt.ca-1` [CAN], `dnscrypt.ca-2` [CAN], `dnscrypt.eu-nl` [NLD], `dnscrypt.pl` [POL], `dnscrypt.uk-ipv4` [GBR], `gombadi-syd` [AUS], `kenshiro` [NLD], `meganerd` [NLD], `moulticast-ca-ipv4` [CAN], `moulticast-de-ipv4` [DEU], `moulticast-fr-ipv4` [FRA], `moulticast-sg-ipv4` [SGP], `moulticast-uk-ipv4` [GBR], `pf-dnscrypt` [CHE], `plan9-dns` [USA], `plan9-ns2` [USA], `pryv8boi` [DEU], `pwoss.org-dnscrypt` [DEU], `resolver4.dns.openinternet.io` [USA], `scaleway-ams` [NLD], `scaleway-fr` [FRA], `serbica` [NLD], `suami` [DEU], `v.dnscrypt.uk-ipv4` [GBR], `zackptg5-us-il-ipv4` [USA], `zackptg5-us-pit-ipv4` [USA] are the resolvers in use.

- `doh_servers` = `false` (disable servers implementing the `DNS-over-HTTPS` protocol)

- `require_dnssec` = `true` (server must support `DNSSEC` security extension)

- `timeout` = `1000` (set the max. response time of a single DNS query from `5000` to `1000` ms.)

- `blocked_query_response` = `'refused'` (set `refused` response to blocked queries)

- `log_level` = `0` (set the log level of the `dnscrypt-proxy.log` file to very verbose, but still keep it disabled by default)

- `dnscrypt_ephemeral_keys` = `true` (create a new, unique key for every single DNS query)

- `bootstrap_resolvers` = `['91.239.100.100:53', '89.233.43.71:53']` (use [UncensoredDNS (Anycast & Unicast)](https://blog.uncensoreddns.org/) instead [CloudFlare](https://iscloudflaresafeyet.com/))

- `netprobe_address` = `'91.239.100.100:53'` (use [UncensoredDNS (Anycast)](https://blog.uncensoreddns.org/) instead [CloudFlare](https://iscloudflaresafeyet.com/))

- `block_ipv6` = `true` (immediately respond to IPv6-related queries with an empty response)

- `blocked_names_file`, `blocked_ips_file`, `allowed_names_file` and `allowed_ips_file` options enabled. (you can now filter your web content, to know how, please refer to the [official documentation](https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Filters) or take a look at my [block repository](https://codeberg.org/quindecim/block))

- `anonymized_dns` feature enabled. (`routes` are indirect ways to reach DNSCrypt servers, each resolver has 2 relays assigned)

- `skip_incompatible` = `true` (skip resolvers incompatible with anonymization instead of using them directly)

- `direct_cert_fallback` = `false` (prevent direct connections through the resolvers for failed certificate retrieved via relay)


## Configure/Deconfigure [Copy-Paste]

    git clone https://github.com/BL4CKH47H4CK3R/Hardened-Anonymized-DNSCrypt-Proxy
    cd "$(basename "$_" .git)"
    chmod +x run.sh && sudo ./run.sh
    

## DNS Leak Testing [Websites]
- 
- [BrowserLeaks](https://anon.to/?http://browserleaks.com/dns)
- [IPLeak](https://anon.to/?http://ipleak.net)
- [DNSLeakTest](https://anon.to/?https://www.dnsleaktest.com)


### Configuration (post-installing)

- You can edit `dnscrypt-proxy.toml` as you wish located on `/etc/dnscrypt-proxy/dnscrypt-proxy.toml`.
- For more detailed configuration please refer to [official documentation](https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Configuration).


## Credits

[Frank Denis](https://github.com/jedisct1) & All Other Contributors
For This Awesome [Project](https://github.com/DNSCrypt/dnscrypt-proxy)
