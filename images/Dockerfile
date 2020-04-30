# Releaser

FROM bitwalker/alpine-elixir-phoenix:1.10.1 as releaser

WORKDIR /app

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

# Copy mix.exs for dependencies
COPY /apps/gqlgateway/mix.exs /app/apps/gqlgateway/

ENV MIX_ENV=prod
RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY . /app/

WORKDIR /app/apps/gqlgateway
RUN MIX_ENV=prod mix compile

WORKDIR /app
RUN MIX_ENV=prod mix release testing

# Release
FROM bitwalker/alpine-elixir-phoenix:1.10.1

EXPOSE 4000
ENV MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=releaser app/_build/prod/rel/testing .
COPY --from=releaser app/bin/ ./bin

CMD ["./bin/start"]
