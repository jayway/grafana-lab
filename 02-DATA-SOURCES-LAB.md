# Data sources lab

In this lab, you'll try out most of the different data sources natively supported by `Grafana`.

Since focus is not on creating/configuring dashboards, `Grafana` offers a nifty `import/export` functionality that allows you to import dashboards created by others. Have a look here:
- [http://docs.grafana.org/reference/export_import/](http://docs.grafana.org/reference/export_import/)

Community built dashboards can be found here:
- https://grafana.net/dashboards

## Prometheus

To attach Prometheus as a data source, first install it using docker:
```bash
docker run -p 9090:9090 prom/prometheus
```
You can have a look at the webserver started by Prometheus on [localhost:9090](localhost:9090).

Then attach it in [http://localhost:3000/datasources](http://localhost:3000/datasources).

It's an empty data source, so not really useful until it is populated. A simple trick to get some data is by letting Prometheus monitor itself. Stop the container, and customize it by creating a new `Dockerfile` with the following content:

```Dockerfile
FROM prom/prometheus
ADD prometheus/monitor-self.yml /etc/prometheus/prometheus.yml
```

Info on the `monitor-self.yml` config file can be found in the [Prometheus Getting Started guide](https://prometheus.io/docs/prometheus/latest/getting_started/).

Build and run:
```bash
docker build -t my-prometheus .
docker run -p 9090:9090 my-prometheus
```

Open [http://localhost:3000/datasources](http://localhost:3000/datasources) again, and refresh it. Under the `Dashboards` tab, add the `Prometheus Stats` dashboard. 

Finish off by reading up on some of the Prometheus concepts here:
[https://prometheus.io/docs/concepts/data_model/](https://prometheus.io/docs/concepts/data_model/).

## InfluxDB

Install it:
```bash
mkdir tmp
docker run -p 8086:8086 \
      -v $PWD/tmp:/var/lib/influxdb \
      influxdb
```

Attach it in [http://localhost:3000/datasources](http://localhost:3000/datasources). There are no databases created by default, but there is a system `_internal` database we can use for lab purposes.

Next, import a dashboard for the `_internal` db, e.g:
[https://grafana.com/dashboards/421](https://grafana.com/dashboards/421).

If you later need to configure your influx, create a config file like:
```bash
docker run --rm influxdb influxd config > $PWD/tmp/influxdb.conf
```

Modify, then run with:
```bash
docker run -p 8086:8086 \
      -v $PWD/tmp/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
      influxdb -config /etc/influxdb/influxdb.conf
```
You'll find more info on:
- [https://hub.docker.com/_/influxdb/](https://hub.docker.com/_/influxdb/)
- [https://docs.influxdata.com/influxdb/v1.4/introduction/getting_started/](https://docs.influxdata.com/influxdb/v1.4/introduction/getting_started/)

## CloudWatch

Add a new *CloudWatch* datasource in http://localhost:3000/datasources. You can choose from 3 different authentication mechanisms:

- **Access & Secret Key** - Access keys belong to [IAM](https://aws.amazon.com/iam/) users, which means you have to create a user for Grafana. It's a simple and common practice, but not recommended.
- **Credentials file** - Essentially the same as **Access keys**. If you have configured your [AWS CLI](https://aws.amazon.com/cli/) properly, you'll have the **Access key** stored in a *credentials file* usually located in `~/.aws/credentials`. By referencing a profile in the credentials file, you don't have to store the **Access key** in Grafana:
```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[user2]
aws_access_key_id=AKIAI44QH8DHBEXAMPLE
aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
```
- **ARN** - Instead of creating a user for Grafan, you can specify a role. The role is given the proper permissions (IAM policies) 

Log in to your AWS console:
- [https://console.aws.amazon.com/](https://console.aws.amazon.com/)



## ElasticSearch

## Graphite

## MySQL

## OpenTSDB





