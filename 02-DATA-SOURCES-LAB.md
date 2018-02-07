# Data sources lab

In this lab, you'll try out most of the different data sources natively supported by `Grafana`.

Since focus is not on creating/configuring dashboards, `Grafana` offers a nifty `import/export` functionality that allows you to import dashboards created by others. Have a look here:
- [http://docs.grafana.org/reference/export_import/](http://docs.grafana.org/reference/export_import/)

Community built dashboards can be found here:
- https://grafana.net/dashboards

Also, some [debug](#debug) info can be found last in this chapter

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

See [http://docs.grafana.org/features/datasources/cloudwatch/#using-aws-cloudwatch-in-grafana](http://docs.grafana.org/features/datasources/cloudwatch/#using-aws-cloudwatch-in-grafana) for more details.

Grafana supports 3 different authentication mechanisms for AWS:

- **Access & Secret Key** - Access keys belong to [IAM](https://aws.amazon.com/iam/) users, which means you have to create a user for Grafana (and optionally create temporary credentials using [AWS STS](https://docs.aws.amazon.com/cli/latest/reference/sts/index.html)). You can either save the access key when creating the Grafana datasource, or as environment variables in the Grafana docker image, see [Configuring AWS credentials for CloudWatch support](https://github.com/grafana/grafana-docker/blob/master/README.md#configuring-aws-credentials-for-cloudwatch-support)).
- **Credentials file** - Essentially the same as above, but you save the access keys in a file instead. If you have configured your [AWS CLI](https://aws.amazon.com/cli/) properly, you'll have a *credentials file* with your own **Access key**, most likely in `~/.aws/credentials`. By creating a credentials file in the Docker image, you don't have to store the key in Grafana, see
[CloudWatch Authentication](http://docs.grafana.org/features/datasources/cloudwatch/#authentication).
- **ARN** - Instead of creating a user for Grafana, you can specify a role. This is mainly useful when your docker container is already running in the AWS cloud. The role must be given the proper permissions (IAM policies).

Restart the container according to [Configuring AWS credentials for CloudWatch support](https://github.com/grafana/grafana-docker/blob/master/README.md#configuring-aws-credentials-for-cloudwatch-support):
```bash
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_AWS_PROFILES=default" \
  -e "GF_AWS_default_ACCESS_KEY_ID=YOUR_ACCESS_KEY" \
  -e "GF_AWS_default_SECRET_ACCESS_KEY=YOUR_SECRET_KEY" \
  -e "GF_AWS_default_REGION=us-east-1" \
  grafana/grafana
```

It will actually create a *credentials file* in the Grafana users home directory; `/usr/share/grafana/.aws/credentials`, with a default profile as specified above.

Add a new *CloudWatch* datasource in http://localhost:3000/datasources. Leave everything as default, and the datasource should pick up your default profile

Find an interesting dashboard at [https://grafana.com/dashboards?dataSource=cloudwatch](https://grafana.com/dashboards?dataSource=cloudwatch).

## ElasticSearch

More details here: [http://docs.grafana.org/features/datasources/elasticsearch/](http://docs.grafana.org/features/datasources/elasticsearch/).

For this lab, we'll connect to a **Elasticsearch** cluster running in your AWS account. First, fire up a new ES cluster using a [CloudFormation](https://aws.amazon.com/cloudformation/) template:

```bash
./es/deploy.sh
```

Take a note of the domain name in the output. Next, you need to put som data in the domain:

```bash
./es/es-put.sh <domain endpoint>
```

Open up [http://localhost:3000/datasources](http://localhost:3000/datasources), add a new *Elasticsearch* datasource with the following parameters:

| Setting | Value         |
| ------- | -----         |
| Name    | AwsEs         |
| Type    | Elasticsearch |
| Url     | *Url returned by deploy script* |
| Access  | direct |
| Basic Auth  | *not checked (we're using IP whitelisting)* |
| With Credentials  | *not checked* |
| Index name  | movies |
| Pattern  | No pattern |
| Time field name  | @timestamp |
| Version  | 5.x |

Next, create a dashboard to display the 3(!) values added by the script. Hint! You need to set the time range to start from the 1950's.

## Graphite

## MySQL

## OpenTSDB

## Debug

Check `Grafana` logs on Docker container:
```bash
docker container ls
docker logs <container name>
```


