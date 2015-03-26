FROM kiyoto/fluentd:0.10.56-2.1.1
MAINTAINER kiyoto@treausure-data.com

RUN mkdir /etc/fluent

ADD fluent.conf /etc/fluent/

# Serialized JSON parsing plugin, makes "log" field easier to work with
RUN ["/usr/local/bin/gem", "install", "fluent-plugin-parser", "--no-rdoc", "--no-ri"]

# Record reformer plugin, adds "container_id" field
RUN ["/usr/local/bin/gem", "install", "fluent-plugin-record-reformer", "--no-rdoc", "--no-ri"]

# Grep plugin, filters out empty logs to prevent flooding system (empty if log was not in JSON format)
RUN ["/usr/local/bin/gem", "install", "fluent-plugin-grep", "--no-rdoc", "--no-ri"]

# Elasticsearch plugin for Fluentd
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "--yes", "make", "libcurl4-gnutls-dev"]
RUN ["/usr/local/bin/gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri"]

ENTRYPOINT ["/usr/local/bin/fluentd", "-c", "/etc/fluent/fluent.conf"]
