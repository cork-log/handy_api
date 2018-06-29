FROM elixir:1.6.4

RUN apt-get update
RUN apt-get install --yes inotify-tools protobuf-compiler git

WORKDIR /app
ADD . /app


ENV PATH="/root/.mix/escripts:${PATH}"

ENV MIX_ENV=docker

RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force
RUN mix escript.install hex protobuf --force
# RUN git submodule init
# RUN protoc -I /app/proto-files --elixir_out=plugins=grpc:/app/lib/proto/ /app/proto-files/*.proto
RUN /bin/sh ./init.sh

WORKDIR /app



CMD ["iex", "-S", "mix", "phx.server"]
