# Extensor

Extensor implements [Tensorflow](https://tensorflow.org) bindings for inference
in [Elixir](https://elixir-lang.org/). This library can be used to execute
computation graphs created in Tensorflow on the CPU or GPU. Extensor
provides minimal abstractions over the Tensorflow C library and includes
as little custom native code as possible. These NIFs have been extensively
tested for memory leaks and paralellism safety so that the library can be
relied on for production use.

## Status
[![Hex](http://img.shields.io/hexpm/v/extensor.svg?style=flat)](https://hex.pm/packages/extensor)
[![CircleCI](https://circleci.com/gh/pylon/extensor.svg?style=shield)](https://circleci.com/gh/pylon/extensor)
[![Coverage](https://coveralls.io/repos/github/pylon/extensor/badge.svg)](https://coveralls.io/github/pylon/extensor)

The API reference is available [here](https://hexdocs.pm/extensor/).

## Installation

### Hex
```elixir
def deps do
  [
    {:extensor, "~> 2.1"}
  ]
end
```

### Dependencies
This project requires the Tensorflow C headers/libraries. For development,
these can be installed by following the [official Tensorflow instructions](
https://www.tensorflow.org/install/install_c).

For docker deployment, see the sample dockerfiles in the docker directory.
Docker for ubuntu can be tested with the following commands.

```bash
docker build -t extensor -f docker/ubuntu-cpu.dockerfile .
docker run --rm -it extensor mix test
```

If you have nvidia tools installed, you can test on the GPU by using the
`ubuntu-gpu.dockerfile` and substituting `nvidia-docker` for `docker` above.

## Usage
For a simple example, Extensor can be used to evaluate the Pythagorean
identity (c² = a² + b²). The following python [script](
https://github.com/pylon/extensor/tree/master/test/pythagoras.py) can be used
to create and save a graph that calculates the length of the hypotenuse.

```python
import tensorflow as tf

a = tf.placeholder(tf.float32, name='a')
b = tf.placeholder(tf.float32, name='b')
c = tf.sqrt(tf.add(tf.square(a), tf.square(b)), name='c')

with tf.Session() as session:
    tf.train.write_graph(session.graph_def,
                         'test/data',
                         'pythagoras.pb',
                         as_text=False)
```

This model can then be used in Elixir to evaluate the compute graph and
calculate a few hypotenuses. This model file is also available in the repo
under [test/data/pythagoras.pb](
https://github.com/pylon/extensor/tree/master/test/data/pythagoras.pb).

```elixir
session = Extensor.Session.load_frozen_graph!("test/data/pythagoras.pb")

input = %{
  "a" => Extensor.Tensor.from_list([3, 5]),
  "b" => Extensor.Tensor.from_list([4, 12])
}

output = Extensor.Session.run!(session, input, ["c"])

Extensor.Tensor.to_list(output["c"])
```

This block should output the list [5.0, 13.0], which corresponds to the
lengths of the hypotenuses of the first two Pythagorean triples.

### Model Formats
Extensor supports the frozen [graph_def](
https://www.tensorflow.org/extend/tool_developers/#graphdef) and [saved_model](
https://www.tensorflow.org/programmers_guide/saved_model) serialization
formats.

For example, the Google [Inception](https://github.com/google/inception)
[model](http://download.tensorflow.org/models/inception_v3_2016_08_28.tar.gz)
has its weights frozen to constant tensors, so that it can be loaded directly
from a protobuf via `load_frozen_graph`.

However, the frozen graph approach may not work for models that contain
unfreezable variables (like RNNs). For these models, Extensor supports the
Tensorflow saved_model format, which is the format used by Tensorflow serving
(TFS). The saved_model format is loaded from a directory path, which includes
model metadata and initial variable weights. These models can be loaded with
`load_saved_model`.

### Configuration
Extensor supports passing a [ConfigProto](
https://www.tensorflow.org/versions/r1.0/api_docs/python/tf/ConfigProto)
object when creating a session for inference configuration. See the
Tensorflow.ConfigProto module for more information on the configuration
data structures.

```elixir
config = %{
    Tensorflow.ConfigProto.new()
    | gpu_options: %{
        Tensorflow.GPUOptions.new()
        | allow_growth: true
    }
}

session = Extensor.Session.load_saved_model!("test/data/pythagoras", config)
```

### Tensor Format
The previous examples used the tensor from_list/to_list convenience functions
to read/write tensor data. However, any binary tensor data may be used, as
long as it adheres to Tensorflow's [layout](
https://www.tensorflow.org/performance/xla/shapes) and endianness (native)
conventions.

In general, a tensor is defined by `type`, `shape`, and `data` parameters.
These can be used to construct an `Extensor.Tensor` struct directly.

The data `type` is an atom identifying one of the supported tensorflow data
types.

atom|tensorflow type
-|-
`:float`|`TF_FLOAT`
`:double`|`TF_DOUBLE`
`:int32`|`TF_INT32`
`:uint8`|`TF_UINT8`
`:int16`|`TF_INT16`
`:int8`|`TF_INT8`
`:string`|`TF_STRING`
`:complex64`|`TF_COMPLEX64`
`:complex`|`TF_COMPLEX`
`:int64`|`TF_INT64`
`:bool`|`TF_BOOL`
`:qint8`|`TF_QINT8`
`:quint8`|`TF_QUINT8`
`:qint32`|`TF_QINT32`
`:bfloat16`|`TF_BFLOAT16`
`:qint16`|`TF_QINT16`
`:quint16`|`TF_QUINT16`
`:uint16`|`TF_UINT16`
`:complex128`|`TF_COMPLEX128`
`:half`|`TF_HALF`
`:resource`|`TF_RESOURCE`
`:variant`|`TF_VARIANT`
`:uint32`|`TF_UINT32`
`:uint64`|`TF_UINT64`

The tensor `shape` is a tuple containing the dimensions of the tensor. The
`data` field contains the binary tensor data, whose size must be consistent
with the tensor shape. The following is an example of a tensor struct.

```elixir
%Tensor{
    type: :double,
    shape: {2, 1},
    data: <<1::native-float-64, 2::native-float-64>>
}
```

## Matrex Integration

Extensor supports optional integration with
[Matrex](https://hexdocs.pm/matrex/Matrex.html). To demonstrate, we'll re-use
our Pythagoras example [test/data/pythagoras.pb](
https://github.com/pylon/extensor/tree/master/test/data/pythagoras.pb)

```elixir
a = Matrex.new([[3, 5], [7, 9]])
b = Matrex.new([[4, 12], [24, 40]])

input = %{
  "a" => Extensor.Matrex.to_tensor(a),
  "b" => Extensor.Matrex.to_tensor(b)
}

session = Extensor.Session.load_frozen_graph!("test/data/pythagoras.pb")
output = Extensor.Session.run!(session, input, ["c"])

output |> Map.get("c") |> Extensor.Matrex.from_tensor()
```

This block should output a 2x2 matrix, which corresponds to the
lengths of the hypotenuses of the first four Pythagorean triples.

## Development
The Tensorflow protocol buffer wrappers were generated using the
[protobuf-elixir](https://github.com/tony612/protobuf-elixir) library
with the following command, assuming Tensorflow is cloned in the
../tensorflow directory:

```bash
protoc \
  --elixir_out=lib \
  --proto_path=../tensorflow \
  $(ls -1 \
    ../tensorflow/tensorflow/core/framework/*.proto \
    ../tensorflow/tensorflow/core/protobuf/*.proto \
    ../tensorflow/tensorflow/stream_executor/*.proto)
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
