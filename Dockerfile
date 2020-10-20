FROM alpine:3.12

# install dependencies
COPY Gemfile /Gemfile
RUN apk update \
 && apk add --no-cache \
        ca-certificates \
        ruby ruby-irb ruby-etc ruby-webrick \
        tini \
 && apk add --no-cache --virtual .build-deps \
        build-base linux-headers \
        ruby-dev gnupg \
 && echo 'gem: --no-document' >> /etc/gemrc \
 && gem install --file Gemfile \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem /usr/lib/ruby/gems/2.*/gems/fluentd-*/test

# copy the Fluentd configuration file for logging Docker container logs
COPY fluent.conf /etc/fluent/fluent.conf
COPY entrypoint.sh /bin/

ENV LD_PRELOAD=""
# Expose forward plugin
EXPOSE 24224

# run as non-root user
RUN addgroup -S fluent && adduser -S -g fluent -u 1000 fluent
USER 1000

ENTRYPOINT ["tini",  "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]
