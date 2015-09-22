# copy-expander

Utility to expand nested COPY REPLACING statements in a COBOL source program. 

## The problem

The COBOL specification does not allow nested COPY REPLACING statements because of the risk of recursion. However, IBM implementations of COBOL attempt to determine whether recursion would _actually_ occur, and if not then they allow the nesting. When we want to use an off-platform COBOL tool such as GnuCOBOL to work with legacy mainframe code, programs that use this technique will (probably) not compile.

Nested COPY REPLACING is not a generally-accepted good practice for COBOL development, but we have to be realistic about handling legacy code that is found in the wild.

## The solution

The solution (or _workaround_, if you prefer) is to expand the nested copybooks and apply the replacements before executing the compiler. This utility performs the expansion and text replacement. It does not automatically compile the resulting program.

## Configuration

Define the configuration options in ```expander.yml```. The configuration file lives in the project root directory. Here is a sample:

```yml
{
  expanded_file: TEMP.CBL,
  source_dir: cobol-source,
  copy_dir: cobol-source/copy
}
```

Here is an example that complies with the default directory structure used in the [cobol-unit-test](http://github.com/neopragma/cobol-unit-test) project:

```yml
{
  expanded_file: TEMP.CBL,
  source_dir: src/main/cobol,
  copy_dir: src/main/cobol/copy
}
```

## Usage

Run the utility from the command line, passing the name of the source program as the first command-line argument:

```shell
expander PROGNAME.CBL
```

The source file with the copybooks expanded will be written to the file refernced by the ```expanded-file``` key in the ```expander.yml``` file. In this example, it will be ```./TEMP.CBL```.

## Running the checks

Rake and rspec are used for automated checks.

```shell
rake help for expander:
rake help       => this text
rake fast       => run specs not tagged slow (default)
rake slow       => run specs tagged slow
rake all        => run all specs
rake functional => run functional checks (no mocks)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'copy-expander'
```

And then execute:

    $ bundle

or install it yourself as:

    $ gem install copy-expander

## Contributing

1. Fork it ( https://github.com/[my-github-username]/copy-expander/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Specs, comments, and documentation must be updated and all specs passing for a pull request to be deemed "complete."

## Issues

Use Github's issue tracking system.

## License

MIT.
