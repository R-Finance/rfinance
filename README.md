# osQF (R/Finance) Conference Website

### getting started

* clone repo and submodule

```
git clone git@github.com:R-Finance/rfinance.git
cd rfinance/themes/hugo-universal-theme/
git submodule init
git submodule update
```

* install hugo
    * currently needs Hugo version 0.54 or later
* run locally using the commands below

```
cd rfinance/     # the top-level of the repo
hugo -D          # -D for draft pages (if there are any)
hugo server      # run the website locally
```

### repo layout

* top-level content is in `content/`
* all prior years are in `content/archive/`
* layouts are in `conference/layouts/`

### adding 'Archive' years

All prior years' conferences are specified in a `[yyyy].md` file in the
`content/archive/` directory. Each file header contains roughly the same
metadata, with the exception of the `linktitle` and `weight` value. The
`weight` value needs to be smaller for more recent years.

The `agendatable` shortcode takes a CSV from `assets/data-csv/yyyy/` and uses
uses it to create a table of agenda items. You need to specify the day and the
file location for each day's table. Use the page for the latest year as a
template for new years.

The CSV parser isn't particularly clever, so make sure your CSVs looks very
much like those that already exist.

### deployment

The site uses GitHub Actions to automatically deploy on every push. There's no
need to build locally.

### ideas

The Hugo docs may be useful if we want to do something more fancy in the
future: https://gohugo.io/hosting-and-deployment/

AWS Amplify - possibly can use for storage as well: https://aws.amazon.com/amplify/console/getting-started/?nc=sn&loc=3
