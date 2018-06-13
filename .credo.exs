%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: ["lib/tensorflow"]
      },
      checks: [
        # this check doesn't work correctly with binary pattern matching <<>>
        {Credo.Check.Consistency.SpaceAroundOperators, false}
      ]
    }
  ]
}
