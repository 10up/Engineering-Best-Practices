<h2 id="nginx" class="anchor-heading">Nginx{% include Util/top %}</h2>

[Nginx](http://nginx.org/ "Nginx Web Server") is our preferred web server software at WisdmLabs. It has proven extremely stable, performant, and reliable at high scale and offers a powerful set of tools. This is not to imply there is anything wrong with using [Apache](https://httpd.apache.org/ "Apache Web Server") - we’ve worked on many high scale deployments that use Apache and mod_php that perform very well.  In general, we've found Nginx to be more lightweight, use less memory, provide more flexible configuration, and perform better under heavy load than Apache.  WisdmLabs maintains a public set of [Nginx configuration templates](https://github.com/WisdmLabs/nginx_configs "WisdmLabs Nginx Configuration Template for WordPress") that apply these best practices. 

### Installation

Nginx should be installed from the repos provided on [Nginx.org](http://nginx.org/en/linux_packages.html). This will ensure timely updates. The "mainline" version is preferred over stable as [mainline gets updates and improvements](https://www.nginx.com/blog/nginx-1-6-1-7-released/) while stable only gets major bugfixes. “Stable” only means a stable feature set, it does not indicate that the stable version will be more reliable on a production server. 

### Configuration Files

The "events{ }" and “http{ }” blocks should be the only blocks in the /etc/nginx/nginx.conf file. These contain configurations that apply server-wide. Any configurations that are site specific should go in the “server{ }” blocks. As a rule of thumb, each WordPress install or website should have it’s own configuration file in ```/etc/nginx/conf.d/``` (the ```/etc/nginx/sites-enabled/``` and ```/etc/nginx/sites-available/``` directory structure is also common and workable) clearly named with the domain of the site, such as “example.com.conf”. Multiple domains can be served from the same “server{ }” block and config file (for WordPress multisite for example). In general, there should be one server{ } block per configuration file, with the exception of server blocks for port 80 (HTTP) and port 443 (SSL) for the same site. 

Using the ```include``` function is a good way to avoid repetitive configuration blocks by abstracting it to a separate file. Microcaching settings and security configurations are often good candidates for a separate include file. 

### Security

Nginx does not have a history of security vulnerabilities, but keeping it at the latest version is always a best practice. Nginx updates are extremely stable and are one of the least likely upgrades to cause problems, so it is recommended to either automatically update Nginx on a cron or proactively apply updates often. 

Nginx has a number of modules that provide Web Application Firewall (WAF) style protection, but nearly all come with some significant trade-offs including the need to compile Nginx from source to install. [Naxsi](https://github.com/nbs-system/naxsi) and [modsecurity](https://www.trustwave.com/Resources/SpiderLabs-Blog/Announcing-the-availability-of-ModSecurity-extension-for-Nginx/) are 2 popular choices.

Even without a security module compiled in, Nginx can be used to block some common exploit requests. The basic strategy is to know what kind of traffic you are expecting and would be legitimate, and block everything else. This way, a file snuck onto the server cannot be exploited. The [wordpress_security.inc](https://github.com/WisdmLabs/nginx_configs/blob/master/security/wordpress_security.inc) file in our Nginx template provides some examples of this. 

If you are certain a WordPress site is not using XML-RPC, block it in Nginx to prevent [brute force amplification attacks](https://blog.sucuri.net/2015/10/brute-force-amplification-attacks-against-wordpress-xmlrpc.html).  [Our Nginx template blocks XML-RPC](https://github.com/WisdmLabs/nginx_configs/blob/master/security/block_xmlrpc.inc) but allows for connections from Jetpack or whitelisted IP addresses.

### Performance

There are some basic settings that can be adjusted in Nginx to improve the performance of WordPress:

* [Compress files with gzip](https://github.com/WisdmLabs/nginx_configs/blob/master/includes/performance.inc)

* Add [upstream response timing to the Nginx access logs](https://github.com/WisdmLabs/nginx_configs/blob/master/template/nginx.conf#L20) to monitor PHP performance and cache hit status

* Set appropriate [expires headers for static assets](https://github.com/WisdmLabs/nginx_configs/blob/master/includes/expires.inc).  The expires header should be set to as far in the future as possible.  Keep in mind that a method to deal with cache invalidation at the CDN and in the browser cache should be utilized for assets (like css and js) that occasionally will change. 

* Always enable [HTTP/2](https://en.wikipedia.org/wiki/HTTP/2) on SSL sites to take advantage of the improved header compression, pipelining, and multiplexing.  All major browsers support HTTP/2.

### Caching

Nginx has a built-in caching mechanism that can be applied to data being proxied or passed to fastCGI. Since Nginx cached data can be served without an extra hop to PHP or a dedicated caching tool like Varnish, it has the potential for being the fastest option. Solutions like Varnish, however, have a big advantage when it comes to cache management and invalidation. Varnish allows sophisticated rules to be built around cache invalidation, whereas Nginx requires extra modules be compiled in to do anything but basic cache management. 

WisdmLabs often uses a "microcaching" strategy with Nginx to provide a performance boost without compiling in extra modules. Cache invalidation integration with WordPress is handled at the PHP level where Batcache provides the main caching mechanism. With microcaching, a small expiration time is set so that cached pages will expire before anyone notices they were even cached in the first place. In this way, there is no need to worry about invalidating caches on new posts, or any other WordPress action that would require a page cache update. This essentially rate limits the amount of requests that are sent to PHP for any given page. A microcaching expiration time of as short as 10 seconds can be helpful on busy sites with spiky traffic patterns. 

While a short microcaching time can be useful, the best practice is to set this microcaching expiration for as long a duration as is tolerable. For publishers that deal in breaking news, this may be tens of seconds. On a more static site, or a publisher where the stories are not time critical, microcaching up to 5 or 10 minutes can work and provide a big performance boost. This expiration time should be determined by collaborative discussion with the publishers and content creators. 

#### Implementation

A handful of good [blog](https://thelastcicada.com/2014/microcaching-with-nginx-for-wordpress) posts cover microcaching and our Nginx templates provide the settings we commonly use with comments for context.  Microcaching needs configuration in a number of places, so be sure to include configuration in the [server block](https://github.com/WisdmLabs/nginx_configs/blob/master/includes/wp_microcaching.inc), the [http block](https://github.com/WisdmLabs/nginx_configs/blob/master/template/example.conf#L3), and in the [php location block](https://github.com/WisdmLabs/nginx_configs/blob/master/includes/php.inc).

<h2 id="php-fpm" class="anchor-heading">PHP-FPM{% include Util/top %}</h2>

PHP-FPM is WisdmLabs’s preferred solutions for parsing PHP and serving via fastCGI through Nginx to the web. PHP-FPM has proven to be a stable and performant solution, offering a number of variables to configure in the pursuit of performance. 

WisdmLabs recommends keeping the PHP version updated to be within 1 release of the most recent version. For example, when PHP is on version 7.1, the version of PHP in production should be no lower than PHP 7.0. 

### Installation

The default repos in CentOS (and most Linux distributions) provide stable but usually well out-of-date packages for PHP. These are often more than 1 version behind the latest PHP release. Because of this, WisdmLabs relies on the [Remi repos](https://blog.remirepo.net/pages/Config-en) to provide up-to-date versions of PHP for CentOS. When using the Remi repos, edit ```/etc/yum.repos.d/remi.repo``` to select the PHP version to install. Alternatively, look for similarly named files that could be used for other PHP versions (such as ```/etc/yum.repos.d/remi-php71.repo```). By enabling and disabling specific Remi repos, the desired version of PHP can be installed. 

When doing a standard yum install PHP-FPM, the software will be installed in the usual places on Linux and updating to a new version of PHP will mean installing directly over the existing version. An alternative method of installation is to use [Software Collections](https://www.softwarecollections.org/en/). Software Collections allow multiple versions of the same software to be installed and run at the same time. The scl command is used to specify which version of the software to use. In this scenario, multiple versions of PHP-FPM can be running simultaneously, making upgrading a website to a new version of PHP as simple as changing the upstream FastCGI process in Nginx. This allows for easy rollbacks if incompatibilities are discovered. This is also a great setup for development environments. 

The following packages are recommended for WordPress installs:

```php
php-cli
php-common
php-fpm
php-gd
php-mbstring
php-mcrypt
php-mysqlnd
php-opcache
php-pdo
php-pear
php-pecl-jsonc
php-pecl-memcache
php-pecl-memcached
php-pecl-zip
php-process
php-redis
php-soap
php-xml
```

Not all of these packages are necessary for every WordPress install, but they cover the most common cases. 

### Configuration

There are a number of places PHP can be configured. The main configuration file is the ```php.ini``` file, normally located at ```/etc/php.ini```. Settings in the ```php.ini``` file can often be overridden by the PHP-FPM configuration file (```www.conf``` at ```/etc/php-fpm.d/www.conf```) or by ```ini_set``` functions in the code. Not all settings can be changed in all locations and the scope is noted in the [PHP documentation](http://php.net/manual/en/configuration.changes.modes.php). Best practice is to set reasonable defaults in the ```php.ini``` file that apply broadly to the PHP code running on the server. If a specific subset of code or requests needs a different value, override the default settings by creating a new PHP-FPM pool with the new setting or creating a rule in the ```wp-config.php``` file that applies the override. For example, if the ```memory_limit``` in wp-admin needs to be increased for bulk post editing, create a specific PHP-FPM pool for wp-admin requests with an increased ```memory_limit``` and use Nginx to route wp-admin requests to that pool. This way, public web requests will retain the lower limit for security and stability purposes, but wp-admin requests will benefit from looser restrictions. Note that it is recommended that ```ini_set``` directives be done in the ```wp-config.php``` if possible. When ```ini_set``` is done within the code, troubleshooting errors can be challenging as not only will ```php.ini``` and ```www.conf``` settings need to be checked, but all PHP code will need to be scanned for ```ini_set``` directives. It is often difficult to determine if an ini_set statement directly impacts the code generating a vague error message. If ```ini_set``` statements can be confined to the ```wp-config.php``` file, it is much simpler for engineers to check the settings at all levels.

#### php.ini

The following are settings in the ```php.ini``` file that commonly are adjusted for WordPress sites. 

* **upload_max_filesize**: This will be the largest file size that can be uploaded to WordPress, usually through the media library. While a large value can increase the risk of certain type of flood attacks, these are uncommon and uploading media is a core business requirement of many sites, so it is generally considered safe to increase this as high as needed. When using Nginx, the ```client_max_body_size``` should be set to the same size as ```upload_max_filesize```.  Additionally, CDNs such as Cloudflare can have an adjustable upload limit as well. Consider all media types when setting this value as audio and video can be several hundred megabytes. 

* **max_post_size**: Needs to be as large or larger than ```upload_max_filesize```. This will be the maximum size of data sent through the POST method.

* **date.timezone**: Set this to the main timezone of the admins of a WordPress site. It doesn’t much matter what this is set to, but some functions will work better when this value is set.

* **short_open_tag**: Should be set to `Off`. Short PHP open tags should never be used in code. This prevents accidental parsing of other files with open tags similar to PHP (such as some XML formats). 

* **expose_php**: Set to `Off` to prevent the PHP version from being reported in the headers. Very minimal security risk, but a best practice anyways. 

* **memory_limit**: Should be increased to 256M (or more) for WordPress sites. Many sites may require 512M. Not all PHP processes will use memory up to the limit, but this value should not be set higher than the amount of RAM available for PHP. If RAM is plentiful, this can be increased as high as necessary. When over 512M is needed, if not explicitly for imports, a problem in the code is likely.

* **max_input_vars**: This value can be safely raised from the default of 1000 (common values are 3000 or 5000). This limit can be hit in complicated WordPress menu structures or in posts with many custom attributes. A common symptom is the menu items or custom fields not appearing to save in the database, but in a very random way. 

#### www.conf

PHP-FPM has a useful feature where multiple pools can be defined, listening on different upstream ports or sockets, to segment traffic to be processed by a different set of rules. While these are not often necessary to employ, they can be handy in certain situations:

* Setting different ini values for wp-admin traffic with looser security restrictions and limits

* Restarting PHP-FPM workers more frequently for certain requests known to have memory leaks or stability issues

* Limiting the amount of PHP-FPM workers for certain requests to avoid resource exhaustion

* Segment PHP processing so 2 sites share no PHP resources

PHP-FPM pools are defined in brackets with the default pool being ```[www]```. To create a new pool, add a new section to ```www.conf``` starting with ```[pool-name]```. Then, make sure this new pool listens on a different port or socket than the main pool and configure Nginx to fastcgi_pass to this new port or socket for the desired requests. 

### Scaling

PHP-FPM scaling is mainly controlled by the process manager (pm). These pm settings are commonly adjusted in the PHP-FPM configuration file (```www.conf```) for high scale WordPress:

* **listen**: Usually set to use TCP/IP (such as ```127.0.0.1:9000```) rather than a socket (ex: ```/tmp/php-fpm.sock```). The socket might be minimally faster, but can fail at high concurrency and scale, so for reliability, TCP/IP is used.

* **pm**: Short for "process manager", this defines the way PHP processes are managed. The options for this are ```static```, ```dynamic```, or ```Ondemand```. ```dynamic``` and ```Ondemand``` spin up PHP-FPM processes when they are needed, making memory consumption lower for most workloads. These settings are great in shared hosting environments where multiple web servers are sharing resources and multiple PHP-FPM pools are defined to isolate resources and each pool to scale independently. However, in a situation where a web server or multiple web servers are dedicated to a single site (or a single customer) and a single PHP-FPM pool is used, ```static``` will offer the highest performance as it keeps all PHP-FPM processes active and ready to accept requests at all time, eliminating the small amount of time needed to initiate a new PHP-FPM process to scale. 

* **pm.max_children**: This value is the maximum number of PHP-FPM processes that are allowed to be spawned. In ```static``` mode, this is also the number of PHP-FPM processes that are always running. This number should be set as high as possible without exhausting either the CPU or memory resources of the server. A good strategy for choosing a value is to start conservative (low numbers) and increase based on monitoring data. [New Relic Infrastructure](https://newrelic.com/products/infrastructure "New Relic Infrastructure") provides a great way to observe CPU and memory usage by PHP-FPM. In general, each PHP-FPM process will use between 20 and 40 MB of memory to run WordPress. Some processes (such as those running an import or publishing posts) will take more memory and some (cached page views) will take less. Ideally a web server will run with at least 10 to 20% free memory and never start using swap space for web requests. However, it is not as critical that a web server never use swap as it is a database or Memcached server. A web server should also very rarely spike to 100% CPU usage. If either memory or CPU are hitting 100% usage, decrease the number of PHP-FPM max_children or add more resources to the server. Some very high traffic sites can effectively run with a very small number of PHP-FPM workers, so start small and monitor tools like New Relic and the PHP-FPM error logs where notices will be output when the ```max_children``` are reached and no more children are available to serve requests. 

* **pm.start_servers, pm.min_spare_servers, pm.max_spare_servers**: Settings for Dynamic mode that should be adjusted based on the ```max_children``` setting. While it is important to set reasonable numbers for these, it is much less important than the ```max_children``` setting. 

* **pm.max_requests**: PHP applications very commonly will use more and more memory in PHP-FPM as time passes. This is known as a "memory leak" and doesn’t necessarily indicate a major code level problem unless the memory increase is dramatic. PHP-FPM should be able to handle this situation with the ```max_requests``` setting. This should not be set to ```0``` unless monitoring shows there to be no memory leaks and stable memory usage. Setting this to ```1000``` requests is a good place to start where PHP-FPM processes will be killed and restarted often enough to prevent most problems. This setting should be routinely reviewed and adjusted based on monitoring data. A higher setting is more efficient when only minor memory leaks are present.

For further reading, ["Scaling PHP Apps" by Steve Corona](https://www.scalingphpbook.com/) provides a thorough discussion of options for scaling PHP. 

### OpCode Cache

OpCode caching is recommended on all PHP webservers and has been observed to boost PHP performance significantly while reducing server resource usage by up to 3x. OpCode caching saves the PHP code in a post-compilation state, increasing the performance of every request beyond the first. The Zend Opcache has been the standard for PHP since version 5.5 (and is available for earlier PHP versions). There are no downsides to using the Zend Opcache and it should always be enabled.

When configuring OPcache the three most important settings are:

* **opcache.memory_consumption** - defaults to 64MB for caching all compiled scripts. See discussion below for more guidance.

* **opcache.max_accelerated_files** - defaults to 2000 cacheable files, but internally this is increased to a higher prime number for undocumented reasons. The maximum is 100,000

* **opcache.max_wasted_percentage** - is the percentage of wasted space in Opcache that is necessary to trigger a restart (default 5).

On CentOS these settings are typically found in ```/etc/php.d/10-opcache.ini```. Always allocate enough memory to accommodate all code that needs to be cached. The amount required will vary depending on the number of lines of code in the WordPress theme and plugins. Simple sites may use less than 30MB of memory for Opcache while complex sites can use 100MB or more. A setting of 128MB is often appropriate.

The ```max_accelerated_files``` setting is fairly self explanatory: it should be set high enough to hold all of the files in your WordPress site. "Waste" in the cache is memory that is allocated for the cache, but is not being used. Things such as caches for code that was updated since the cache last reset are an example of waste in the cache.

For best performance OPcache should never be 100% full. When the maximum memory consumption is reached OPcache will attempt to restart (ie clear) the cache. However, if ```max_wasted_percentage``` has not been reached, OPcache will **not** restart and every uncached script will be compiled on the fly at request time and perform as if OPcache were not enabled at all! A [number](https://github.com/PeeHaa/OpCacheGUI) of [tools](https://github.com/amnuts/opcache-gui) are [available](https://github.com/rlerdorf/opcache-status) for viewing OPcache usage. Be sure to password protect or limit access to this tool. 

When you want to squeeze all the performance possible out of PHP, there is another OPcache setting to pay attention to, ```opcache.validate_timestamps```. This default setting of 1 has OPcache frequently checking the timestamps (how frequently is configured with ```opcache.revalidate_freq```) for each PHP file to determine if the cache needs to be updated. For maximum performance this can be set to 0, eliminating unnecessary file system calls. However, when new code is deployed to the server, OPcache will have no way of knowing that the cache should be updated and will continue to serve the outdated cached version. In this case manual purging of the OpCode cache is required. This can be accomplished by restarting php-fpm, or by using a tool such as [cachetool](http://gordalina.github.io/cachetool/) to send commands directly to the PHP listener, over FastCGI, and instruct it to clear the OPcache:

```$ php cachetool.phar opcache:reset --fcgi=127.0.0.1:9000```

```$ php cachetool.phar opcache:reset --fcgi=/var/run/php5-fpm.sock```

### PHP Sessions

PHP offers a shared space that can persist across processes to store information that needs to be accessible to all PHP processes called "sessions". Sessions are like cookies, but stored server-side instead of on the client. By default, PHP uses files to store sessions. This presents a problem in multi web server environments where not all servers will have access to a shared filesystem. A reliable solution to this problem is to use Memcached as the storage location for PHP sessions. Memcached is recommended for WordPress object caching and is often available in a high scale WordPress environment and will make PHP sessions available across all web servers.

<h2 id="mysql" class="anchor-heading">MySQL{% include Util/top %}</h2>

The impact of MySQL performance is very different site to site. A slow database might not have much noticeable impact on a well cached site with a small collection of content, but could have major impact on a busy site with many editors publishing into a very large library of content. The amount of effort to spend on MySQL tuning should be gauged by the expected impact.

### Version

Both MySQL and MariaDB can serve WordPress as they are fully compatible with each other.  While WisdmLabs generally has switched to MariaDB due to the more open source ethos of the project, there’s very little reason not to use MySQL if that is the easier option.  In this document, "MySQL" is used as the generic term to refer to both MySQL and MariaDB.

MySQL versions have a longer lifespan than PHP versions and as long as security patches are being issued for the version in use, it is likely acceptable to use. 

### Hardware

The best way to ensure fast MySQL performance is fast disks. Fast hard disks in a database server can overcome poor configuration and tuning. Slow queries become more tolerable. Large datasets are no longer a challenge. If fast SSD disks can be afforded, they are the best place to invest for database speed. 

If fast disks are unavailable or cost prohibitive, ample RAM is the next best resource. The general rule to follow is that all routinely queried data should be able to fit in system memory with room to spare. If, for example, a database was 2.5 GB, a server with 4GB of RAM would provide ample space to tune optimally.

### Tools

[MySQLTuner](https://github.com/major/MySQLTuner-perl) is a Perl script that gathers metrics on MySQL and Linux and generates a report of configuration settings with recommendations on optimisations. While these optimisations should not be used without critical evaluation, they provide an excellent basis for performance tuning. MySQLTuner should be run regularly to understand the evolving nature of the WordPress dataset and how MySQL is performing under stress. While MySQLTuner can be installed through most package managers, downloading the tool from GitHub is simple and ensures the latest version. 

[Sequel Pro](https://www.sequelpro.com/) (OS X), [HeidiSQL](https://www.heidisql.com/) (Windows), and [MySQL Workbench](https://www.mysql.com/products/workbench/) (cross-platform) are among many GUI tools available for connecting to remote MySQL servers. A tool of this nature should be setup and configured on your local workstation for each database routinely worked with. Everything these tools can do can be done via the command line, but in an emergency, it is helpful to have connection information and credentials saved with a quick way to visualize tables and their contents.

### Replication and HA design

Introducing database replication to any configuration is a giant leap in complexity compared to a single database setup. The maintenance burden and troubleshooting difficulty both increase substantially, so evaluate whether a project really needs this complexity before embarking. 

There are a few common goals of database replication:

* High Availability: add redundancy so that if a single database server goes offline unexpectedly or for maintenance, the application will continue working

* Performance: add additional horsepower by adding servers

* Segmentation: isolate workloads to prevent taxing jobs from impacting site performance

The three commonly encountered MySQL replication types are Master-Slave, Master-Master, and Synchronous clusters like Galera.

#### Master-Slave

A Master-Slave replication pair consists of the Master node, where all database writes happen, and the Slave node, where only database reads can occur. The Slave node never pushes any data back to the Master node, so any writes that are attempted on this node are refused. 

Here’s how Master-Slave replication does on our replication goals:

* **High Availability:** If the slave database server goes down, WordPress is still completely functional, but if the master database goes offline, WordPress becomes read-only and no new articles, comments, or changes to any content can be made. Additionally, as WordPress is not usually designed to be read only, some sites will not load at all without successful database writes. Master-Slave is not the best solution for High Availability. 

* **Performance:** Master-Slave replication is excellent for scaling database reads. Replication overhead is very low, so nearly all of the horsepower of a slave server is used for performing database reads. If more performance is needed, another replica can be added. This can scale horizontally almost infinitely. However, writes do not scale at all in a Master-Slave setup as writes are limited to only the single master server.

* **Segmentation:** Master-Slave replication is a great solution when offloading taxing jobs from your main production server. Backups or reports can be run from a dedicated slave database server that has no impact at all on the master server or any of the other slaves. This slave server can be small and cheap as long as it can keep up with the replication workload. 

#### Master-Master

Do not use MySQL Master-Master replication. It is attractive as it seems to solve all the limitations of Master-Slave replication. However, Master-Master replication can be very dangerous and can result in data collisions, lost data, or duplicated data if the replication were to break or one of the database servers were to crash. It is a fragile type of replication and, while it can be engineered to be a reliable system, there are better options available.

#### Galera Cluster

A Galera cluster is a synchronous multi-master database cluster for InnoDB tables where writes must happen successfully on all cluster members to finish successfully on a single member. This gives Galera a high data durability. A Galera cluster should always be setup with an odd number of nodes. This is so in the event of a replication failure of 1 node, 2 remaining nodes can remain a quorum and the source of true data, re-syncing to the lone disconnected database node when it reconnects. If the absolute lowest cost is needed, the 3rd (or odd-numbered) Galera member could be a [Galera Arbitrator](http://galeracluster.com/documentation-webpages/arbitrator.html), which does not participate in the replication, but will maintain connections to all other Galera nodes and assist in determining a quorum. 

Here’s how Galera performs on the common replication goals:

* **High Availability:** Galera is the recommended solution for High Availability MySQL replication. A Galera cluster will remain online and fully functional as long as more than 50% of nodes remain online and synced. This means in a typical 3 node cluster, a single database server can be brought offline for upgrades without any noticeable difference in performance in WordPress. It is crucial that a smart load balancing strategy be employed that recognizes an offline or out of sync database and reroutes traffic accordingly. 

* **Performance:** Database reads can scale horizontally in much the same manner as in Master-Slave replication when using Galera as each server acts as a standalone database server in the context of reads. Writes, however, do not scale as more nodes are added since Galera requires all nodes in a cluster to perform every write synchronously. In practice, writes become slightly slower with Galera, though usually by a very small percentage. Database writes can only be scaled through faster hardware in a Galera cluster. For most WordPress installations, reads are where scaling is needed and a single server can keep up with write operations effectively. 

* **Segmentation:** Galera can be used for workload segmentation, running backups or other read-heavy tasks to a single Galera server and using the other nodes for production work. Additionally, a read-only slave can be added to any node in Galera in typical Master-Slave configuration if a read-only server is desired. 

### Performance Tuning

MySQL performance can be substantially improved with careful tuning of buffers, caches, and other settings. A good first step is to run [MySQLTuner](https://github.com/major/MySQLTuner-perl) and carefully consider each of the recommendations. Listed near the top of the MySQLTuner output is section about MySQL memory usage. It is critical to constantly evaluate the total memory usage of MySQL and how it compares to the available memory on the server while tuning. MySQL’s memory footprint is very stable and predictable and is completely determined by the settings in the my.cnf file. There’s no reason a database server should ever run out of memory (which can lead to prolonged and difficult data recovery sessions). 

When evaluating memory usage, all programs running on the database server should be considered. A typical database server will have MySQL and sometimes Memcached running, both of which have predictable memory footprints. If the full stack is running on a single server, predicting RAM usage becomes more challenging as PHP can vary substantially from one request to the next. As uncertainty increases, so should the amount of free RAM left on a server, leaving space for overruns. A good rule of thumb is to leave at least 512MB available for Linux system use (preferably more if the resources are available). 

When tuning memory usage, be aware that many MyISAM buffers and caches are per thread while many InnoDB buffers are global. InnoDB is the default database engine in MySQL and is what most WordPress installs will be using at this time, so MyISAM buffers can be greatly reduced (but should be non-zero as some MySQL internal tables can use MyISAM).

This section will outline the most common variables that are tuned in the ```/etc/my.cnf``` or ```/etc/my.cnf.d/server.cnf``` files using a real example from a WisdmLabs configured site.

* **Innodb_buffer_pool_size**: This is by far the most important variable for efficient performance of an InnoDB database.  InnoDB is the database engine which all WordPress databases should be unless there are very unusual circumstances. The InnoDB buffer pool should be larger than the size of the MySQL dataset so that all active databases can fit into memory, limiting at 85% of system RAM (assuming no other services are run on the database server). MySQLTuner provides excellent guidance for setting this value correctly. In our example project, MySQLTuner states ```InnoDB buffer pool / data size: 200.0M/455.9M```. This server has 4GB of RAM and has Memcached (the only other process running on this server) already using 128MB of RAM, so there’s plenty of room to devote to MySQL. MySQLTuner reports this as well showing ```Maximum possible memory usage: 972.0M (24.61% of installed RAM)```. In this example, this setting was increased as such to allow for growth: ```innodb_buffer_pool_size = 600M``` 

* **Innodb_file_per_table**: This is a true/false setting. When on, each table will have a dedicated file on disk. When disabled, all InnoDB tables are written to ```ibdata1``` in the MySQL data directory. The problem with ```ibdata1``` is that space can never be reclaimed once it is created. Deleting a table will not remove the data from ```ibdata1```. With ```innodb_file_per_table```, deleting a table deletes it’s file and that space can be reclaimed. ```innodb_file_per_table``` can slow down performance when routinely creating and deleting hundreds of tables, but for nearly all use cases with WordPress, this setting should be enabled. 

* **Tmp_table_size** and **max_heap_table_size**: When MySQL is performing a join, a temporary table is created. The ```tmp_table_size``` and ```max_heap_table_size``` determine how much room in memory is devoted to these temporary tables. Tables too large to fit in the allocated memory will be created on the much slower disk. MySQLTuner will almost always recommend increasing these two settings for a WordPress site. It is unlikely that increasing these values will yield any better performance as WordPress does a substantial amount of table joins using the ```wp_posts``` table and the post_content field, which is formatted as LONGTEXT. Fields of LONGTEXT or BLOB type included in a join will never be stored in memory and will always use a temporary table on disk. MySQLTuner does not recognize this as why so many temporary tables are created on disk and will therefore make the inaccurate recommendation to increase the ```tmp_table_size``` and ```max_heap_table_size```. Keep these 2 values modestly sized (8Mb or 16Mb is usually appropriate) for best efficiency. For ways to improve WordPress temp table performance, see the [MySQL ](#heading=h.2q42senjsimy)[tmpdir](#heading=h.2q42senjsimy)[ Performance Optimization](#heading=h.2q42senjsimy) section. 

* **Always enable an error log**

Once tuning moves beyond these main items, performance improvements will be minor to negligible.

#### MySQL tmpdir Performance Optimization

As discussed earlier, WordPress utilizes on-disk temporary tables when doing JOIN statements that reference the ```wp_posts``` table as many of the ```wp_posts``` table’s fields are of type TEXT or LONGTEXT. If a TEXT or LONGTEXT field are in the results of a JOIN, that query cannot use in-memory temporary tables and will create those temporary tables on disk. One way to optimize the performance of these on-disk temporary tables is to set MySQL’s `tmpdir` to a [tmpfs](https://en.wikipedia.org/wiki/Tmpfs) filesystem. tmpfs appears to the operating system to be a normally mounted disk drive, but it is actually a filesystem that resides entirely in volatile memory (RAM). By mounting the tmpdir in memory, MySQL will read and write temporary tables very quickly without the input/output limitations for traditional drives. This method is even faster than most SSDs and has been shown to provide a significant performance boost for some WordPress workloads. 

Most Linux servers have a few tmpfs mounts already. The `/dev/shm` mount is a tmpfs mount for efficiently storing temporary files for programs and we can set MySQL to use this with the tmpdir variable in the ```my.cnf``` file. tmpfs only uses space in RAM when files exist (it isn’t preallocated), but if the WordPress database is very busy, beware that MySQL could use as much RAM as is allocated for ```/dev/shm``` (which is normally 50% of total RAM). In most WordPress workloads, MySQL only uses a few megabytes in temporary tables on disk, but if ```/dev/shm``` usage were to grow, it could quickly cause an out of memory situation. Take this into account when tuning MySQL for memory usage. ```/dev/shm``` size should be monitored if used for the MySQL tmpdir.
