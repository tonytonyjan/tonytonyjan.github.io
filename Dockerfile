FROM ruby:2.7.3-alpine3.13
ADD Gemfile Gemfile.lock ./
RUN apk -U add --no-cache --virtual .build \
  g++ gcc make musl-dev libxml2-dev libxslt-dev \
  && BUNDLE_JOBS=4 BUNDLE_BUILD__NOKOGIRI=--use-system-libraries bundle install \
  && apk del .build
RUN apk -U add libxml2 libxslt nodejs tzdata
CMD ["bundle", "exec", "middleman"]
