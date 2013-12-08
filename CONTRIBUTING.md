# Contributing

Thanks for using and improving Busted! If you'd like to help out, check out
[the project's issues list][issues] for ideas on what could be improved.
If there's an idea you'd like to propose, or a design change, feel free to
file a new issue. For bonus brownie points, [pull requests][pr] are always
welcome.

## Running the Tests

To run the full suite:

  `$ bundle exec rake`

To run a specific test file:

  `$ bundle exec ruby -Itest test/busted_test.rb`

To run a specific test:

  `$ bundle exec ruby -Itest test/busted_test.rb -n test_cache_with_new_constant`

[issues]: https://github.com/simeonwillbanks/busted/issues
[pr]: https://help.github.com/articles/using-pull-requests