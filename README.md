# PressPass

Making WordPress development as awesome. PressPass is one simple command to download and install a WordPress installation, and start a local webserver to start developing without any extra configuration fuzz.

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

This will download the latest version of WordPress and install it into the <app_name> directory. It will also generate a `Procfile` that starts a PHP development server of your WordPress installation when you run:

``` bash
$ gem install foreman
$ foreman start
$ open http://localhost:8000
```

## Serve your WordPress environment with Pow

To serve your WordPress development environment using Pow and have nice local development domain names, add a symlink to port 8000:

```
$ cd ~/.pow
$ echo "8000" > ~/myblog
$ open http://myblog.dev/
```

## Theme Development Setup

Please read [DEVELOPING_THEMES.md](http://github.com/firmhouse/presspass/blob/master/DEVELOPING_THEMES.md) to
learn how you can hook PressPass into your theme development workflow and be awesome.

## Having problems?

Are you having problems? Please open an issue at https://github.com/firmhouse/presspass/issues.
