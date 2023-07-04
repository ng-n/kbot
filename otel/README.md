## Introduction
This repository provides a Docker Compose configuration file for setting up a monitoring stack witht he following components:
OpenTelemetry, Prometheus, Fluentbit, Grafana Loki, and Grafana.

The monitoring stack allows you to collect, store, and visualize metrics, logs, and traces from the kbot application.

Requirements:
Ensure that Docker and Docker Compose are installed and properly configured on your local development environment.

Setup Instructions:

Create a test directory and move to it
```
    mkdir test
    cd test
```

Clone the kbot repository from the opentelemetry branch
```   
    git clone -b opentelemetry git@github.com/ng-n/kbot.git
```

Move to the kbot directory
```
    cd kbot
```
Donwload `docker-compose.yaml`
```
 curl -O https://raw.githubusercontent.com/den-vasyliev/kbot/opentelemetry/otel/docker-compose.yaml
```
Run docker-compose -f otel/docker-compose.yaml
```
   docker-compose -f otel/docker-compose.yaml up
```
Open Telegram kbot and test. Some output like below is expected.
![](https://github.com/ng-n/kbot/blob/opentelemetry/otel/.data/kbot_output_img.png)

### Access Grafana Dashboard: Select the `Web preview` on the right in the Google Cloud Shell and select `Change port`.
Change Preview Port > Port number: 3002 > Change and Preview

The landing page should look like below:
![](https://github.com/ng-n/kbot/blob/opentelemetry/otel/.data/grafana_landing_page.png)

Select `Configuration` > Add `data source` > Prometheus

Add URL http://prometheus:9090 and Save & Test

Repeat the action for Loki
Add URL http:///loki:3100 and Save & Test


The result should look like below:
![](https://github.com/ng-n/kbot/blob/opentelemetry/otel/.data/grafana_configuration.png)

### Configure Data Source: In the Grafana dashboard, configure Prometheus and Grafana Loki as data sources. 
Enter kbot in the `Metric` and select `kbot_bitcoin_total`
![](https://github.com/ng-n/kbot/blob/opentelemetry/otel/.data/grafana_metric.png)

### Explore Metrics, Logs, and Traces: Customize the dashboards and panels according to your monitoring requirements.
Select Explore > Loki
Select `Label browser` > `OTLP` > `Show logs`
Type `kbot` in the `Line contains`, then select `Operations` > `Line filter` > `Line contains` and type `hello`
The result is below:
![](https://github.com/ng-n/kbot/blob/opentelemetry/otel/.data/grafana_kbot_hello_explore.png)

## [TODO]
