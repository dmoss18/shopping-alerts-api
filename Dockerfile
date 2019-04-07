FROM ruby:2.6.1-stretch

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update -qq && apt-get install -y apt-utils build-essential
RUN apt-get update -qq && apt-get install -y git less nano nodejs postgresql-client-9.6 postgresql-client 

ENV RAILS_ROOT /shopping-alerts-api
RUN mkdir $RAILS_ROOT
RUN mkdir -p $RAILS_ROOT/tmp/pids
WORKDIR $RAILS_ROOT

# this invalidates docker's cache markers upon gem updates and changes
# NOTE: always bundle before copying application
COPY Gemfile $RAILS_ROOT/Gemfile
COPY Gemfile.lock $RAILS_ROOT/Gemfile.lock
RUN gem install bundler
RUN bundle install

COPY . $RAILS_ROOT/
RUN  rm -f tmp/pids/*.pid
# RUN chmod 775 $RAILS_ROOT/config/containers/app_cmd.sh
# CMD [ "config/containers/app_cmd.sh" ]

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
