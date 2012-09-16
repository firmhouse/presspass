# Developing WordPress themes with PressPass

PressPass helps you develop WordPress themes in a convenient way.

[We](http://firmhouse.com) use and suggest the following workflow:

## Create your local WordPress installation

With the instructions from the [README](http://github.com/firmhouse/presspass/blob/master/README.md], create a clean WordPress installation and configure it through 
the WordPress installer. In this example ```Code``` is the directory where we store all our projects.

``` bash
cd Code
presspass new my_blog --php /usr/local/bin/php-cgi

gem install rack rack-legacy rack-rewrite
ln -s ~/Code/my_blog ~/.pow/my_blog

open http://myblog.dev/
```

## Starting with a theme from scratch

At ```~/Code/my_theme``` create an empty theme directory with at least the required ```style.css``` file 
with the theme metadata so WordPress shows it in the admin. If you'd like to, you can initialize
a git repository here and push it to for example GitHub.

Then, symlink the theme directory into the ```wp-content/themes``` directory of the WordPress installation:

```
ln -s ~/Code/my_theme ~/Code/my_blog/wp-content/themes/my_theme
```

Go to your WordPress admin and switch to the theme.

## Or, clone an existing theme from GitHub

Just like when starting a theme from scratch. Clone your theme to some directory in ```~/Code```:

```
git clone git@github.com:michiels/my_theme ~/Code/my_theme
```

Then, symlink it into your WordPress installation:

```
ln -s ~/Code/my_theme ~/Code/my_blog/wp-content/themes/my_theme
```

## Code, commit and repeat!

The working directory where you can make changes to your theme will be ```~/Code/my_theme```. So, just
make your changes, commit and repeat.