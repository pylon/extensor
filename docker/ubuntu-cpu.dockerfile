FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

# install packages
RUN apt-get update -qq && apt-get install -y \
      build-essential curl locales libatlas-base-dev

# install tensorflow
RUN curl -L https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.9.0.tar.gz | \
      tar -C /usr/local -xz

# install elixir
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
RUN curl https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb > /tmp/erlang-solutions_1.0_all.deb && \
    dpkg -i /tmp/erlang-solutions_1.0_all.deb && \
    apt-get update -qq && apt-get install -y esl-erlang elixir && \
    mix local.rebar --force && \
    mix local.hex --force

ADD mix.exs .
ADD c_src ./c_src
ADD lib ./lib
ADD test ./test
RUN mkdir priv
RUN mix deps.get
RUN mix compile

CMD ["iex", "-S", "mix"]
