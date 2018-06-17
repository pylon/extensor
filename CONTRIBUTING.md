## How to contribute to Extensor
Interested in contributing to Extensor? We appreciate all kinds of help!

### Pull Requests
We gladly welcome pull requests.

Before making any changes, we recommend opening an issue (if it doesn’t
already exist) and discussing your proposed changes. This will let us give
you advice on the proposed changes. If the changes are minor, then feel free
to make them without discussion.

### Development Process
To make changes, fork the repo. Write code in this fork with the following
guidelines. Some of these checks are performed automatically by CI whenever
a branch is pushed. These automated checks must pass before a PR will be
merged. The checks can also be used in a commit/push hook with the following
script.

```bash
mix compile --warnings-as-errors --force || exit 1
mix format --check-formatted || exit 1
mix test || exit 1
mix credo --strict -i todo || exit 1
mix dialyzer --halt-exit-status || exit 1
```

#### Formatting
For better or worse, we use the Elixir formatter. You can run `mix format`
prior to checkin to format your changes.

#### Static Analysis
Extensor uses the `credo` tool to check consistency and find bugs. You can
run `mix credo --strict` to evaluate these checks. We also use `dialyzer`
for typespec checking.

#### Test Coverage
We strive to keep test coverage as high as possible using `excoveralls`.
Coverage can be checked by running `mix coveralls.html` for an HTML report.

#### Native Code
Extensor interfaces with Tensorflow using Erlang Native Interface Functions
(NIFs) written in C++. We don't trust ourselves or anyone else to write
C/C++ safely, so we try to write as little of it as possible. Native code is
subjected to higher scrutiny during review and requires stress tests for
memory leaks and parallelism tests for safety.

Feel free to contact the maintainers for information on how to do work with
and test the native interface. And if you have ideas on how to improve the
NIF development process, please suggest them!
