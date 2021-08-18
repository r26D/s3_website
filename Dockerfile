# Build
FROM jruby:9.2.19.0-jre8 as builder

RUN apt-get update && apt-get install -y git

ADD . .
RUN bundle install
RUN ./sbt assembly
RUN printf $(md5sum target/scala-2.11/s3_website.jar | awk '{print $1}') > /resources/s3_website.jar.md5
RUN rake build

# Run
FROM jruby:9.2.19.0-jre8

ENV TMPDIR "/tmp"
ENV S3_WEBSITE_VERSION 3.4.0

COPY --from=builder pkg/s3_website-$S3_WEBSITE_VERSION.gem .
RUN gem install ./s3_website-$S3_WEBSITE_VERSION.gem
COPY --from=builder target/scala-2.11/s3_website.jar $TMPDIR/s3_website-$S3_WEBSITE_VERSION.jar

ENV JRUBY_HOME /opt/jruby

ENTRYPOINT ["s3_website"]

CMD ["--help"]
