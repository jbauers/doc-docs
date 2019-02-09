FROM alpine:latest

ARG VERSION=0.6.0

RUN apk add --no-cache \
    wget

RUN wget https://github.com/segmentio/terraform-docs/releases/download/v${VERSION}/terraform-docs-v${VERSION}-linux-amd64 \
  && mv terraform-docs-v${VERSION}-linux-amd64 /usr/bin/terraform-docs \
  && chmod a+x /usr/bin/terraform-docs

RUN mkdir /terraform
WORKDIR /terraform

CMD ["sh","-c","terraform-docs markdown table . > module.md"]
