The following are recommendations for better site security. This list will grow and change over time and is not meant to be comprehensive.

## Always Enforce Strong Passwords.

Always enforce strong passwords.

## Use multifactor authentication for administrator accounts.

Use multifactor authenication for admin level accounts.

## Always disallow plugin/theme edits from the admin.

Always ```define( 'DISALLOW_FILE_MODS', true );```. Code changes such as plugin updates should be done from the repository for easier code maintence and constancy.

## X-Frame-Options set to SAMEORIGIN

By default, always set the ```X-Frame-Options``` header to ```SAMEORIGIN```. This can help protect agaisnt clickjacking attacks.

## WordPress and plugin updates

Always keep WordPress up to date. Use as few plugins as possible and keep them updated.

## Don't use 'admin' as the default admin username.

Don't use the username `admin` since it is easily guessable.

## Disable XML-RPC

Always disable XML-RPC since it can be used for brute force attacks.

## Managing API Keys

Where possible, keys should be stored either in the `wp_options` table, or as a constant defined in the `wp-config.php`, never within the application source code. Storing keys in these locations reduce the chance of accidentally pushing these keys into an upstream version control repository.  Additionally, these locations increase discoverability during routine security audits or when rotating keys.
