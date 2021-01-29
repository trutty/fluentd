FROM registry.access.redhat.com/ubi8/s2i-base:1

ENV RUBY_VERSION="2.7"

# install dependencies
COPY Gemfile ./
RUN yum -y module enable ruby:${RUBY_VERSION} \
 && yum -y update && yum -y install \
    ruby \
    ruby-devel \
    # required by fluentd plugin 'rewrite_tag_filter'
    hostname \
 && yum -y clean all --enablerepo='*' \
 && gem install --file ./Gemfile \
 && rm -rf /usr/local/share/gems/cache/

# copy basic Fluentd configuration
COPY fluent.conf /etc/fluent/fluent.conf

# Expose forward plugin
EXPOSE 24224

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root \
 && rpm-file-permissions
USER 1001

# start fluentd process
ENTRYPOINT [ "fluentd" ]
