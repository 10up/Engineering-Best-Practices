# Kanopi Engineering Best Practices

> These are the official best practices for Kanopi. This guide dictates how we, as a company, engineer websites. The purpose behind them is to improve the quality of the experiences we build as well as to standardize in order to facilitate more effective collaboration.

[![Support Level](https://img.shields.io/badge/support-active-green.svg)](#support-level) [![MIT License](https://img.shields.io/github/license/10up/Engineering-Best-Practices.svg)](https://github.com/10up/Engineering-Best-Practices/blob/gh-pages/LICENSE.md)

**[Start reading ☞](https://kanopi.github.io/Engineering-Best-Practices/)**

## Contributions

We don't know everything! We welcome pull requests and spirited debates :)

## Running Locally

```
bundle install
bundle exec jekyll serve
```

## Support Level

**Active:** Kanopi is actively working on this, and we expect to continue work for the foreseeable future including keeping tested up to the most recent version of WordPress.  Bug reports, feature requests, questions, and pull requests are welcome.

## Like what you see?

<a href="https://kanopi.com/contact/">Contact</a>

## Misc Instructions

### Update Navigation

* The primary menu in the header can be updated in the file for that page located in the root directory. Set the variables nav, group, and weight to add the item to the primary navigation.
* The front page submenu can be updated in the file index.md in the root directory.

### Add New Page

* Add the page as `Filename.md` to `markdown` folder. 
* Add the page as `filename.md` to the root folder.
* In the root file, update the necessary variables such as page, title, etc. 
* In the root file, modify the "capture" to point toward the markdown you created in step one.
* Update `_includes/_sass/components/_template-header.scss` to include your new header with the other headers.