The following are recommendations for better site security. This list will grow and change over time and is not meant to be comprehensive.

## Always Enforce Strong Passwords.

Always enforce strong passwords. By default WordPress does not enforce strong passwords. Make sure to use a plugin or custom solution to enforce a strong password policy. 10up recommends using randomly generated passwords from a password manager application.

## Use multi-factor authentication for administrator accounts.

Use multi-factor (MFA) or Two factor (2FA) for admin level accounts. Multi-factor can prevent an attacker when a password is exposed. We do not recommend SMS based authentication methods due to increased risk from sim hijacking and social engineering.

## Always disallow plugin/theme edits from the admin.

Always ```define( 'DISALLOW_FILE_MODS', true );```. Code changes such as plugin updates should be done from the repository for easier code maintenance and constancy. This also prevents an attacker that might have gained admin access from making a code change by uploading a plugin.

## Always remove unused code.

Always remove unused code. Unused plugins and themes can provide a vector for attack. Also remove as much unused code as possible and regularly audit the code base for unused plugins.

## Regularly scan your codebase for vulnerable packages.

Build a process to regularly scan your codebase against known vulnerabilities. You can use tools like https://wpvulndb.com/ to scan for plugins or themes that could be an issue.

## X-Frame-Options set to SAMEORIGIN

By default, always set the ```X-Frame-Options``` header to ```SAMEORIGIN```. This can help protect against clickjacking attacks.

## Disable XML-RPC

Always disable XML-RPC since it can be used for brute force or DDoS attacks. XML_RPC is an older and mostly unused feature. Perfer the JSON API when available.

## WordPress updates

Always keep WordPress up to date. WordPress core minor versions should be installed as soon as possible. WordPress Core offers security updates and "minor" updates to older versions of WordPress. Often bad actors will scan the web for these vulnerabilities given the WP's popularity. This means it's very important to update as soon as possible.

## Don't use 'admin' as the default admin username.

Don't use usernames like `admin` since it is easily guessable. Usernames like this make brute forcing much easier.

## Disable User Enumeration

Always consider the information available on the JSON API about the users of the site. WordPress users data can be accessed via WordPress JSON API. This could expose something like usernames that could then be used in a brute force attempt or email addresses to be used to try to phish an user.

## Managing API Keys

Where possible, keys should be stored either in the `wp_options` table, or as a constant defined in the `wp-config.php`, never within the application source code. Storing keys in these locations reduce the chance of accidentally pushing these keys into an upstream version control repository.  Additionally, these locations increase discoverability during routine security audits or when rotating keys.

## 10up Experience Plugin

For improved security, 10up recommends our [10up experience plugin](https://github.com/10up/10up-experience). 10up experience configures WordPress to better protect and inform our clients. [Please read the plugin readme for a description of the functionality.](https://github.com/10up/10up-experience#functionality)

