# Notes on certificates 

We're using [Let's Encrypt](https://letsencrypt.org) certificates and the [certbot](https://certbot.eff.org) client.

## Moving from gh-pages

To get a certificate for a server, usually certbot uses a http challenge, asking the server where certbot is run. This is a not feasible solution on gh-pages. Instead we're trying to use the DNS challenge using this command:

```
sudo certbot certonly --manual --preferred-challenges dns
```
