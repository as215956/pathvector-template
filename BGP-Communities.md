# AS215956.net - Pathvector Template BGP Communities

The BGP Communities used in this template file, feel free to customize, add, remove any bgp community you use. The informational BGP Communities are defined in "/etc/bird/definitions/general.conf" and used in function calls in "/etc/bird/functions/[im|ex]port_default_communities.conf".

## Variables

Variables used in pathvector "add-on-import" or "add-on-export" or via the custom function calls.

| Variable            | Defined                       | Description                                                                                                                                                             |
| ------------------- | ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ASN                 | /etc/pathvector.yml           | Your own ASN                                                                                                                                                            |
| ROUTER_REGION_CODE  | /etc/bird/define/general.conf | The region code location of the router                                                                                                                                  |
| ROUTER_COUNTRY_CODE | /etc/bird/define/general.conf | The country code location of the router                                                                                                                                 |
| ROUTER_LOCATION_ID  | /etc/bird/define/general.conf | The location ID of the router, for example when you have multiple POP's in a country                                                                                    |
| ROUTER_ID           | /etc/bird/define/general.conf | ID of the router itself, for example if you have multiple routers in the same location. Personally I use the location_id + router_id (ex: 1103 = Location 11, Router 3) |
| SESSION_ASN         | generated                     | ASN of the peer, auto generated by scripts and functions                                                                                                                |
| IX_ASN              | generated                     | ASN of the peer, auto generated by scripts and functions                                                                                                                |

## Informational

Added on import and export via the "import_default_communities" or "export_default_communities".

| Community                   | Description                                            |
| --------------------------- | ------------------------------------------------------ |
| ASN:100:1                   | Originated by MY_NETWORK                               |
| ASN:100:2                   | Learned from customer/downstream                       |
| ASN:100:3                   | Learned from Direct Peer                               |
| ASN:100:4                   | Learned from IX route servers                          |
| ASN:100:5                   | Learned from transit/upstream                          |
| ASN:101:SESSION_ASN         | Learned from SESSION_NAME                              |
| ASN:102:IX_ASN              | Learned from Internet Exchange IX_NAME                 |
| ASN:103:ROUTER_REGION       | Learned in region where router is located              |
| ASN:104:ROUTER_COUNTRY_CODE | Learned in country where router is located             |
| ASN:105:ROUTER_LOCATION_ID  | Learned in location/datacenter where router is located |
| ASN:106:ROUTER_ID           | Learned from router ID                                 |

## Blackhole

This is handled by vectorpath by default

| Community | Description |
| --------- | ----------- |
| 65535:666 | Blackhole   |

## Well-known Communities (RFC)

| Community   | Description                               |
| ----------- | ----------------------------------------- |
| 65535:0     | Graceful shutdown, lowers local-pref to 0 |
| 65535:65281 | No Export (RFC1997)                       |
| 65535:65282 | No Advertisement (RFC1997)                |
| 65535:65284 | No Export (RFC3765)                       |

## Prepend

| Community | Description                             |
| --------- | --------------------------------------- |
| ASN:600:1 | Prepend the peer AS one time            |
| ASN:600:2 | Prepend the peer AS two time            |
| ASN:600:3 | Prepend the peer AS three time          |
| ASN:601:n | Prepend the peer AS one time to AS[n]   |
| ASN:602:n | Prepend the peer AS two time to AS[n]   |
| ASN:603:n | Prepend the peer AS three time to AS[n] |

## Local preference

By default, customers/downstreams are imported to BGP with LocalPref 5000. However, we provides a LocalPref manipulation community that will allow you to control the link over which traffic comes in for active-passive backup purposes. You can set the LocalPref to 4000 by tagging the route with ASN:610:4000, which is still higher than non-customer routes.

| Community | Description                 |
| --------- | --------------------------- |
| ASN:610:x | Set local preference to [x] |

| LocalPref | Description                                   |
| --------- | --------------------------------------------- |
| 1000      | Upstream / Transit                            |
| 2000      | Internet Exchange Route Server                |
| 3000      | Peer over Internet Exchange                   |
| 4000      | Direct PNI Session (over tunnel)              |
| 4500      | Direct PNI Session (over physical connection) |
| 5000      | Downstream / Customer                         |

## Exports (do not export)

| Community                   | Description                              |
| --------------------------- | ---------------------------------------- |
| ASN:660:1                   | Do not export to any transit/upstream    |
| ASN:660:2                   | Do not export to any bilateral peers     |
| ASN:660:3                   | Do not export to any customer/downstream |
| ASN:660:n                   | Do not export to specific AS[n]          |
| ASN:670:ROUTER_REGION       | Do not export to specific region         |
| ASN:671:ROUTER_COUNTRY_CODE | Do not export to specific country        |
| ASN:672:ROUTER_LOCATION_ID  | Do not export to specific location       |
| ASN:673:ROUTER_ID           | Do not export to specific router         |