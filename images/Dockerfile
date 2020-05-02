# Releaser

FROM bitwalker/alpine-elixir-phoenix:latest as releaser

WORKDIR /app

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

# Copy mix.exs for dependencies
COPY /apps/gqlgateway/mix.exs /app/apps/gqlgateway/

# Get and compile dependences
ENV MIX_ENV=prod
RUN mix do deps.get --only $MIX_ENV, deps.compile

# Copy everything
COPY . /app/

WORKDIR /app/apps/gqlgateway
RUN MIX_ENV=prod mix compile

WORKDIR /app
ENV DATABASE_URL=ecto://postgres:postgres@db/fidelity-prod
RUN MIX_ENV=prod mix release testing

# Release
FROM bitwalker/alpine-elixir-phoenix:latest

EXPOSE 4000
ENV MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=releaser app/_build/prod/rel/testing .

CMD ["./bin/testing", "eval", "Gqlgateway.Release.migrate"]
CMD ["./bin/testing", "start"]
