# Introduction lab

Grafana SW consist of
- Backend written in Go
- Frontend assets written in Node.js (and other stuff)

### 0. Prerequisites

Install
- [Docker](https://www.docker.com/)

Then launch Grafana:
```bash
docker run -d -p 3000:3000 grafana/grafana
```

Open browser:
```bash
http://localhost:3000
```

User:pass
```bash
admin:admin
```

See more on [https://github.com/grafana/grafana-docker](https://github.com/grafana/grafana-docker).

### 1. Getting started

- [http://docs.grafana.org/guides/getting_started/](http://docs.grafana.org/guides/getting_started/)

Grafana has a [getting started guide](http://docs.grafana.org/guides/getting_started/). It requires an attached data source. Thankfully, Grafana has some sample data ready to be installed as plugin:

- [http://localhost:3000/plugins/testdata/edit](http://localhost:3000/plugins/testdata/edit).

### 2. Data sources lab

Move on to the next lab:
- [02-DATA-SOURCES.md](02-DATA-SOURCES-LAB.md)
