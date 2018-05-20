# docker-dactyl
Docker image for ripple/dactyl

Using this Docker container, one can build with [`dactyl`][dactyl] without
having to set up with virtualenv. 

## Running



In your [`dactyl`][dactyl] project root run:

```sh
docker run --rm -v $(pwd):/ws yyolk/dactyl
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
