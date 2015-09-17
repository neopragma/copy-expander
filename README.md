# copy-expander

Utility to expand nested COPY REPLACING statements in a COBOL source program. 

## The problem

The COBOL specification does not allow nested COPY REPLACING statements because of the risk of recursion. However, IBM implementation of COBOL attempt to determine whether recursion would _actually_ occur, and if not then they allow the nesting. When we want to use an off-platform COBOL tool such as Microfocus COBOL or GnuCOBOL to work with legacy mainframe code, programs that use this technique will not compile.

## The solution

The solution (or _workaround_, if you prefer) is to expand the nested copybooks and apply the replacements before executing the compiler. 

## Usage

TBD



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
