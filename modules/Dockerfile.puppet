FROM puppet/puppet-agent-alpine:latest

RUN apk add --no-cache ruby-rdoc

RUN gem install yard \
  && gem install puppet-strings

RUN mkdir /puppet
WORKDIR /puppet

CMD ["strings","generate","--format","markdown","--out","reference.md"]
