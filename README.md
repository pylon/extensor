# Extensor

Tensorflow bindings for inference in Elixir. This library can be used to
execute computation graphs created for tensorflow on the CPU or GPU.

## Status
[![Hex](http://img.shields.io/hexpm/v/extensor.svg?style=flat)](https://hex.pm/packages/extensor)
[![Test](http://circleci-badges-max.herokuapp.com/img/pylon/extensor?token=:circle-ci-token)](https://circleci.com/gh/pylon/extensor)
[![Coverage](https://coveralls.io/repos/github/pylon/extensor/badge.svg)](https://coveralls.io/github/pylon/extensor)

The API reference is available [here](https://hexdocs.pm/extensor/).

## Installation

### Dependencies
This project requires the tensorflow C headers/libraries. For development,
these can be installed from the steps [here](https://www.tensorflow.org/install/install_c).

For docker deployment, see the sample dockerfiles in the docker directory.
Docker for ubuntu can be tested with the following commands.

```bash
docker build -t extensor -f docker/ubuntu.dockerfile .
docker run --rm -it extensor mix test
```

If you have nvidia tools installed, you can test on the GPU by substituting
`nvidia-docker` for `docker` above.

### Hex
```elixir
def deps do
  [
    {:extensor, "~> 0.1"}
  ]
end
```

## License

Copyright 2018 Pylon, Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
