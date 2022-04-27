# Bhojpur OS Repository Index

It is built automatically by [Bhojpur ISO](https://github.com/bhojpur/iso/) manager and contains repository index.

You can also build this repository locally, if you wish:

```sh
$ make deps
$ BHOJPURISO_MANAGER=$GOPATH/bin/isomgr make build-all create-repo
```
To consume this repository with [Bhojpur ISO](https://github.com/bhojpur/iso/), add in the `iso.yaml`:

```yaml
repositories:
- name: "repository-index"
  description: "Bhojpur OS Repository index"
  type: "http"
  enable: true
  cached: true
  priority: 1
  urls:
  - "https://raw.githubusercontent.com/bhojpur/repository-index/gh-pages"
```

or, create this file under `Bhojpur ISO` repositories dir (/etc/bhojpur/repos.conf.d/repository-index.yml):

```yaml
name: "repository-index"
description: "Bhojpur OS Repository Index"
type: "http"
enable: true
cached: true
priority: 1
urls:
- "https://raw.githubusercontent.com/bhojpur/repository-index/gh-pages"
```
