# Using ValueDomain API for Let's Encrypt
 
## Enabling the scripts

Set the following options in `getssl.cfg` (either global or domain-specific):

```
VALIDATE_VIA_DNS="true"
export VALUEDOMAIN_APIKEY=xxxx
DNS_ADD_COMMAND=/path/to/dns_add_valuedomain.sh
DNS_DEL_COMMAND=/path/to/dns_del_valuedomain.sh
```
