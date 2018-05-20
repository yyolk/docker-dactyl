# docker-dactyl
Docker image for ripple/dactyl

Using this Docker container, one can build with [`dactyl`][dactyl] without
having to set up with virtualenv. 

## Running

In your [`dactyl`][dactyl] project root run:

```sh
docker run --rm -v $(pwd):/ws yyolk/dactyl
```

## Dactyl Expanded Usage

_All options are passed to `dactyl_build`, [the regular usage options still
apply][dactyl-usage]_

Simple ("Ad-Hoc") usage:

```sh
$ docker run --rm -v $(pwd):/ws yyolk/dactyl --pages input1.md input2.md
```

By default, the resulting HTML pages are written to a folder called `out/` in the current working directory. You can specify a different output path in the config file or by using the `-o` parameter.

### Building PDF

Dactyl generates PDFs by making temporary HTML files and running [Prince][]. Use the `--pdf` command to generate a PDF. Dactyl tries to come up with a sensible output filename by default, or you can provide one (which must end in `.pdf`):

```sh
$ docker run --rm -v $(pwd):/ws yyolk/dactyl --pages input1.md input2.md --pdf MyGuide.pdf
```

### Advanced Usage

Dactyl is intended to be used with a config file containing a list of pages to parse. Pages are grouped into "targets" that represent a group of documents to be built together; a page can belong to multiple targets, and can even contain conditional syntax so that it builds slightly different depending on the target in question. Targets and pages can also use different templates from each other, and pages can inherit semi-arbitrary key/value pairs from the targets.

For more information on configuration, see the `default-config.yml` and the [examples](examples/) folder.

The input pages in the config file should be specified relative to the `content_path`, which is `content/` by default. You can also specify a URL to pull in a markdown file from a remote source, but if you do, Dactyl won't run any pre-processing on it.

For a full list of Dactyl options, use the `-h` parameter.

#### Specifying a Config File

By default, Dactyl looks for a config file named `dactyl-config.yml` in the current working directory. You can specify an alternate config file with the `-c` or `--config` parameter:

```sh
$ docker run --rm -v $(pwd):/ws yyolk/dactyl -c path/to/alt-config.yml
```

For more information on configuration, see the `default-config.yml` and the [examples](examples/) folder.

#### Specifying a Target

If your config file contains more than one **target**, Dactyl builds the first one by default. You can specify a different target by passing its `name` value with the `-t` parameter:

```sh
$ docker run --rm -v $(pwd):/ws yyolk/dactyl -t non-default-target
```

#### Static Files

Your templates may require certain static files (such as JavaScript, CSS, and images) to display properly. Your content may have its own static files (such as diagrams and figures). By default, Dactyl assumes that templates have static files in the `assets/` folder. You can configure this path and also specify one or more paths to static files referenced by your content. When you build, Dactyl copies files from these folders to the output folder by default depending on which mode you're building:

| Build Mode         | Files copied to output folder by default                |
|:-------------------|:--------------------------------------------------------|
| HTML               | Both template and content static files                  |
| PDF                | Neither template nor content static files (cannot be overridden) |
| Markdown           | Content static files only                               |
| ElasticSearch JSON | Neither template nor content static files               |

You can use a commandline flag to explicitly specify what gets copied to the output folder, except in the case of PDF. (In PDF mode, Dactyl writes only the final PDF to the output folder.) The flags are as follows:

| Flag (long version) | Short version | Meaning                                |
|:--------------------|:--------------|:---------------------------------------|
| `--copy_static`     | `-s`          | Copy all static files to the out dir.  |
| `--no_static`       | `-S`          | Don't copy any static files to the out dir. |
| `--template_static` | `-T`          | Copy only templates' static files to the out dir |
| `--content_static`  | `-C`          | Copy only the content's static files to the out dir |

The following config file parameters control what paths Dactyl checks for static content:

| Field | Default | Description |
|---|---|---|
| `template_static_path` | `assets/` | Static files belonging to the templates. |
| `content_static_path` | (None) | Static files belonging to content. This can be a single folder path, as a string, or an array of paths to files or folders. Dactyl copies all files and folders (regardless of whether the current target uses them). |

#### Listing Available Targets

If you have a lot of targets, it can be hard to remember what the short names for each are. If you provide the `-l` flag, Dactyl will list available targets and then quit without doing anything:

```sh
$ docker run --rm -v $(pwd):/ws yyolk/dactyl -l
tests		Dactyl Test Suite
rc-install		Ripple Connect v2.6.3 Installation Guide
rc-release-notes		
kc-rt-faq		Ripple Trade Migration FAQ
```

#### Building Markdown

This mode runs the pre-processor only, so you can generate Markdown files that are more likely to display properly in conventional Markdown parsers (like the one built into GitHub). Use the `--md` flag to output Markdown files, skipping the HTML/PDF templates entirely.

```sh
$ docker run --rm -v $(pwd):/ws yyolk/dactyl --md
```

#### Building Only One Page

If you only want to build a single page, you can use the `--only` flag, followed by the filename you want to build (either the input filename ending in `.md` or the output filename ending in `.html`):

```sh
docker run --rm -v $(pwd):/ws yyolk/dactyl --only index.html --pdf
```

This command can be combined with the `--pdf` or `--md` flags. You can also use it with the `--target` setting (in case you want the context from the target even though you're only building one page.)

#### Watch Mode

You can use the `-w` flag to make Dactyl run continuously, watching for changes to its input templates or markdown files. Whenever it detects that a file has changed, Dactyl automatically rebuilds the output in whatever the current mode is, (HTML, PDF, or Markdown).

To be detected as a change, the file has to match one of the following patterns:

```
*.md
*/code_samples/*
template-*.html
```




### Notes

Take a look at the [Dockerfile](Dockerfile).

Any options will be passed to `dactyl_build` since we're using that as the
`ENTRYPOINT`:


```sh
$ docker run --rm yyolk/dactyl --help
```

Will print out:

```
usage: dactyl_build [-h] [--quiet | --debug] [--config CONFIG] [--version]
                    [--bypass_errors] [--target TARGET] [--pdf [PDF] | --md |
                    --html | --es]
                    [--copy_static | --no_static | --template_static | --content_static]
                    [--es_upload [ES_UPLOAD]] [--leave_temp_files]
                    [--list_targets_only] [--only ONLY] [--out_dir OUT_DIR]
                    [--pages PAGES [PAGES ...]] [--no_cover]
                    [--skip_preprocessor] [--title TITLE] [--vars VARS]
                    [--watch]

Generate static site from markdown and templates.

optional arguments:
  -h, --help            show this help message and exit
  --quiet, -q           Suppress status messages
[...]
```


[dactyl]: https://github.com/ripple/dactyl "Ripple/Dactyl"
[dactyl-usage]: https://github.com/ripple/dactyl/blob/master/README.md#usage
