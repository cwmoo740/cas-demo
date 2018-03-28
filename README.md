# CAS 5 Behind Reverse Proxy Demo

CAS documentation is opaque, so this is an example and walkthrough of putting CAS 5 into a production-like environment
behind a reverse proxy with docker-compose.

## Diagram and Basic Flow


                               +-----------------+
                               |     postgres    |
                               |                 |
                               +--------+--------+
                                        ^
                                        |
                                        |
                                        |
                                 +------+------+
                                 |             |
                                 |    CAS      |
                   +------------>+             |
                   |             |             |
                   |             |             |
                   |             +------+------+
    +--------------+                    ^
    |              |                    |
    |              |                    |
    |    nginx     |                    |
    |              |                    |
    |              |                    |
    +--------------+                    |
                   |            +-------+-------+
                   |            |               |
                   |            |               |
                   |            |               |
                   +----------->+     node      |
                                |     app       |
                                |               |
                                |               |
                                +---------------+

NGINX serves as a proxy that handles TLS connections and forwards /cas/* to CAS, and /app/* to the nodejs app.

When a user requests /app/protected without a valid session, they are redirected to 

`/cas/login?service=/app/protected`

and asked to log in. They are then redirected back to 

`/app/protected?ticket=SERVICE_TICKET`

The node app must then request 

`/cas/serviceValidate?ticket=SOMETICKET&service=/app/protected`

and verify a 200 OK result before treating the user as authenticated.

## Getting Started in Docker

1. Generate keys:

    `./scripts/keys.sh`

    will output

    ```text
    ssl/
      cas-demo.crt
      cas-demo.key
    cas/    
      ssl/
        cas-demo.der
    ```

    It will also import the cas-demo.der into ${JAVA_HOME}/jre/lib/security/cacerts to allow CAS to be run locally and have java 
    libraries trust your self signed certificate. To undo this,

    `sudo keytool -delete -alias cas-demo -keystore "${JAVA_HOME}/jre/lib/security/cacerts"`

    The default password for the java cacerts is `changeit`.
    
    You can also run `./scripts/keys.sh --delete` to undo everything and delete the keys.

2. Set a hostname

    edit /etc/hosts and insert this line: 
    `127.0.0.1	cas-demo.org  cas-demo`

    If you want another hostname, there are several places in the cas configuration and node app that have to be changed.
    
3. `docker-compose build`

4. `docker-compose up`

5. Try an authed route

    Navigate to `https://cas-demo.org/cas/status/dashboard` to see the dashboard.
    `https://cas-demo.org/app/protected` to see a protected route

    The admin username/password is `jyoung2/jyoung2`.
   
   
## Debugging CAS

1. Start nginx with `sudo nginx -c $(pwd)/nginx/local.conf`

2. Start CAS in debug mode with `cd cas && ./gradlew debug`

3. Attach a debugger to localhost:5005

[This may help](https://apereo.github.io/cas/developer/Build-Process-5X.html#remote-debugging)

## WTFs

* CAS documentation is WTF and it's impossible to search for where configuration properties are actually loaded and read

* CAS gets confused by ipv4/ipv6: if a user is assigned a ticket on an ipv4 route, but later they connect to CAS over
ipv6 to verify it, it fails

* CAS doesn't seem to work without https anymore

* Hostname and redirect urls are difficult
    
    * required network alias in the docker-compose.yml so CAS knew how to reach nginx
    
## TODOs

* Signing/encryption key management for CAS

    * this will currently fail in a clustered environment because each CAS instance will make random encryption keys

* Redis ticket registry for deploying multiple CAS nodes
