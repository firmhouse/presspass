# PressPass

Generate WordPress installations, themes and plugins. Generally making WordPress development awesome.

## Installing

PressPass is available as a gem:

```
gem install presspass
```

## Usage

To generate a new installation of WordPress:

```
presspass new <app_name>
```

This will download the latest version of WordPress and install it into the <app_name> directory.

## Using with Pow

The ```new``` command will generate a ```config.ru``` file in the installation directory so you can run your WordPress installation with [Pow](http://pow.cx). This will use a php-cgi installation on your system which defaults
to ```/usr/bin/php```. To set another path, use the ```--php``` flag:

```
presspass new <app_name> --php /usr/local/bin/php
```

Full example to run WordPress through Pow with a PHP version that is installed using Homebrew:

``` bash
cd Code
presspass new my_blog

gem install rack rack-legacy rack-rewrite
echo "9292" > ~/.pow/my_blog

cd ~/Code/my_blog
rackup

open http://myblog.dev/
```

### Pow and rbenv / RVM

If you are using rbenv or RVM. You need to add a .ruby-version like the following example inside the generated WordPress installation directory:

```
2.1.0
```

## Theme Development Setup

Please read [DEVELOPING_THEMES.md](http://github.com/firmhouse/presspass/blob/master/DEVELOPING_THEMES.md) to
learn how you can hook PressPass into your theme development workflow and be awesome.

## Having problems?

Are you having problems? Please open an issue at https://github.com/firmhouse/presspass/issues.