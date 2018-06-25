[Nginx](http://nginx.org/ "Nginx Web Server") is our preferred web server software at 10up. It has proven extremely stable, performant, and reliable at high scale and offers a powerful set of tools. This is not to imply there is anything wrong with using [Apache])(https://httpd.apache.org/ "Apache Web Server") - we’ve worked on many high scale deployments that use Apache and mod_php that perform very well.  10up maintains a public set of [Nginx configuration templates](https://github.com/10up/nginx_configs "10up Nginx Configuration Template for WordPress") that apply these best practices. 

<h2 id="installation" class="anchor-heading">Installation{% include Util/top %}</h2>

Nginx should be installed from the repos provided on [Nginx.org](http://nginx.org/en/linux_packages.html). This will ensure timely updates. The "mainline" version is preferred over stable as [mainline gets updates and improvements](https://www.nginx.com/blog/nginx-1-6-1-7-released/) while stable only gets major bugfixes. “Stable” only means a stable feature set, it does not indicate that the stable version will be more reliable on a production server. 

<h2 id="configuration-files" class="anchor-heading">Configuration Files{% include Util/top %}</h2>

The "events{ }" and “http{ }” blocks should be the only blocks in the /etc/nginx/nginx.conf file. These contain configurations that apply server-wide. Any configurations that are site specific should go in the “server{ }” blocks. As a rule of thumb, each WordPress install or website should have it’s own configuration file in /etc/nginx/conf.d/ (the /etc/nginx/sites-enabled/ and /etc/nginx/sites-available/ directory structure is also common and workable) clearly named with the domain of the site, such as “example.com.conf”. Multiple domains can be served from the same “server{ }” block and config file (for WordPress multisite for example). In general, there should be one server{ } block per configuration file, with the exception of server blocks for port 80 (HTTP) and port 443 (SSL) for the same site. 

Using the "include" function is a good way to avoid repetitive configuration blocks by abstracting it to a separate file. Microcaching settings and security configurations are often good candidates for a separate include file. 

<h2 id="security" class="anchor-heading">Security{% include Util/top %}</h2>

Nginx does not have a history of security vulnerabilities, but keeping it at the latest version is always a best practice. Nginx updates are extremely stable and are one of the least likely upgrades to cause problems, so it is recommended to either automatically update Nginx on a cron or proactively apply updates often. 

Nginx has a number of modules that provide Web Application Firewall (WAF) style protection, but nearly all come with some significant trade-offs including the need to compile Nginx from source to install. [Naxsi](https://github.com/nbs-system/naxsi) and [modsecurity](https://www.trustwave.com/Resources/SpiderLabs-Blog/Announcing-the-availability-of-ModSecurity-extension-for-Nginx/) are 2 popular choices.

Even without a security module compiled in, Nginx can be used to block some common exploit requests. The basic strategy is to know what kind of traffic you are expecting and would be legitimate, and block everything else. This way, a file snuck onto the server cannot be exploited. The [wordpress_security.inc](https://github.com/10up/nginx_configs/blob/master/security/wordpress_security.inc) file in our Nginx template provides some examples of this. 

If you are certain a WordPress site is not using XML-RPC, block it in Nginx to prevent [brute force amplification attacks](https://blog.sucuri.net/2015/10/brute-force-amplification-attacks-against-wordpress-xmlrpc.html).  [Our Nginx template blocks XML-RPC](https://github.com/10up/nginx_configs/blob/master/security/block_xmlrpc.inc), but accounts for sites using Jetpack with a few ways to whitelist the connection from Automattic.

<h2 id="performance" class="anchor-heading">Performance{% include Util/top %}</h2>

There are some basic settings that can be adjusted in Nginx to improve the performance of WordPress:

* [Compress files with gzip](https://github.com/10up/nginx_configs/blob/master/includes/performance.inc)

* Add [upstream response timing to the Nginx access logs](https://github.com/10up/nginx_configs/blob/master/template/nginx.conf#L20) to monitor PHP performance and cache hit status

* Set appropriate [expires headers for static assets](https://github.com/10up/nginx_configs/blob/master/includes/expires.inc).  The expires header should be set to as far in the future as possible.  Keep in mind that a method to deal with cache invalidation at the CDN and in the browser cache should be utilized for assets (like css and js) that occasionally will change. 

<h2 id="caching" class="anchor-heading">Caching{% include Util/top %}</h2>

Nginx has a built-in caching mechanism that can be applied to data being proxied or passed to fastCGI. Since Nginx cached data can be served without an extra hop to PHP or a dedicated caching tool like Varnish, it has the potential for being the fastest option. Solutions like Varnish, however, have a big advantage when it comes to cache management and invalidation. Varnish allows sophisticated rules to be built around cache invalidation, whereas Nginx requires extra modules be compiled in to do anything but basic cache management. 

10up often uses a "microcaching" strategy with Nginx to provide a performance boost without compiling in extra modules. Cache invalidation integration with WordPress is handled at the PHP level where Batcache provides the main caching mechanism. With microcaching, a small expiration time is set so that cached pages will expire before anyone notices they were even cached in the first place. In this way, there is no need to worry about invalidating caches on new posts, or any other WordPress action that would require a page cache update. This essentially rate limits the amount of requests that are sent to PHP for any given page. A microcaching expiration time of as short as 10 seconds can be helpful on busy sites with spiky traffic patterns. 

While a short microcaching time can be useful, the best practice is to set this microcaching expiration for as long a duration as is tolerable. For publishers that deal in breaking news, this may be tens of seconds. On a more static site, or a publisher where the stories are not time critical, microcaching up to 5 or 10 minutes can work and provide a big performance boost. This expiration time should be determined by collaborative discussion with the publishers and content creators. 

### Implementation

A handful of good [blog](https://thelastcicada.com/2014/microcaching-with-nginx-for-wordpress) posts cover microcaching and our Nginx templates provide the settings we commonly use with comments for context.  Microcaching needs configuration in a number of places, so be sure to include configuration in the [server block](https://github.com/10up/nginx_configs/blob/master/includes/wp_microcaching.inc), the [http block](https://github.com/10up/nginx_configs/blob/master/template/example.conf#L3), and in the [php location block](https://github.com/10up/nginx_configs/blob/master/includes/php.inc). 
