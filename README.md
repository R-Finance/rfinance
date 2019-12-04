# rfinance
R/Finance Website (hugo)

# getting started

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
cd rfinance/    # the top-level of the repo
hugo server -D --destination docs
```

# repo layout

* top-level content is in `content/`
* all prior years are in `content/archive/`
    * recent years are built in to this site
    * older years are iframes to Dirk's original sites
* layouts are in `conference/layouts/`

# migrating older years to this site

All prior years' conferences are specified in a `[yyyy].md` file in the
`content/archive/` directory. Each file header contains roughly the same
metadata, with the exception of the `linktitle` and `weight` value. The
`weight` value needs to be smaller for more recent years.

Older years that are still hosted on GitHub pages in Dirk's `rf2` repo use
the `archive` shortcode (in `layouts/shortcodes/archive.html`). This is
simply an iframe to the old site hosted on GitHub.

Prior years that are hosted with the site in this repo use the `agendatable`
shortcode. This shortcode takes a CSV from `data-csv/` and uses it to create
a table of agenda items. You need to specify the day and the file location
for each day's table. Use the page for 2019 as a template for other years.

So migrating a prior year involves creating the CSV and changing the markdown
file in `content/archive/` to use the `agendatable` shortcode instead of the
`archive` shortcode.

The CSV parser isn't particularly clever, so make sure your CSVs looks very
much like the two that already exist for 2019.

# deploy

The site is hosted on GitHub pages, and all the generated content is stored
in the `docs/` directory. You should only need to run `hugo` at the top level
to build/update the site locally. Push the `master` branch to `origin` to make
your changes public.

The Hugo docs may be useful if we want to do something more fancy in the
future: https://gohugo.io/hosting-and-deployment/

AWS Amplify - possibly can use for storage as well: https://aws.amazon.com/amplify/console/getting-started/?nc=sn&loc=3
