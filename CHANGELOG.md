## v0.0.3 2015-09-25

The patch fixes bug in matcher that broke gems:
- 'abstract_mapper',
- 'query_builder'
- 'attributes_dsl'
in rbx (nepalez)

### Bugs fixed

- Bug in rspec matcher `be_immutable` for rbx arrays and hashes (nepalez)

[Compare v0.0.2...v0.0.3](https://github.com/nepalez/immutability/compare/v0.0.2...v0.0.3)

## v0.0.2 2015-09-24

The version fixes some bugs and adds `#at` method fild past states of objects with memory.

### Added

- New decorator `Immutabitlity::Object` to iterate via past states of instance (nepalez)
- New method `Imutability::WithMemory#at` to return a state in the past (nepalez)
- Allow block to be send to initializer (nepalez)

### Bugs fixed

- Bug in rspec matcher `be_immutable` under rbx (nepalez)

[Compare v0.0.1...v0.0.2](https://github.com/nepalez/immutability/compare/v0.0.1...v0.0.2)

## v0.0.1 2015-09-20

First public release.
