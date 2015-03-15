# dfhmdf

Converts DFHMDF macro specifications into ```text_field``` definitions for use with the (https://github.com/cheezy/te3270/)[TE3270 gem]. The purpose is to eliminate the need for you to count the characters across and down a 3270 screen to determine the X and Y coordinates and the length of each field you wish to define for TE3270.

## Example

Given a BMS macro source file named ```macro-source``` with the following contents:

```
QCKSET   DFHMSD TYPE=MAP,STORAGE=AUTO,MODE=OUT,LANG=COBOL,TIOAPFX=YES
QCKMAP   DFHMDI SIZE=(24,80),LINE=1,COLUMN=1,CTRL=ALARM
         DFHMDF POS=(1,1),LENGTH=3,ATTRB=(ASKIP,BRT),INITIAL='QCK'
         DFHMDF POS=(1,26),LENGTH=28,ATTRB=(ASKIP,NORM),                X
              INITIAL='Quick Customer Account Check'
         DFHMDF POS=(3,1),LENGTH=8,ATTRB=(ASKIP,NORM),INITIAL='Account:'
ACCTNO   DFHMDF POS=(3,13),LENGTH=7,ATTRB=(ASKIP,NORM)
         DFHMDF POS=(4,1),LENGTH=5,ATTRB=(ASKIP,NORM),INITIAL='Name:'
SURNAME  DFHMDF POS=(4,13),LENGTH=15,ATTRB=(ASKIP,NORM)
FNAME    DFHMDF POS=(4,30),LENGTH=10,ATTRB=(ASKIP,NORM)
         DFHMDF POS=(5,1),LENGTH=11,ATTRB=(ASKIP,NORM),INITIAL='Max charge:'
CHG      DFHMDF POS=(5,13),ATTRB=(ASKIP,NORM),PICOUT='$,$$0.00'
MSG      DFHMDF LENGTH=20,POS=(7,1),ATTRB=(ASKIP,NORM)
         DFHMSD TYPE=FINAL
```

run ```dfhmdf``` as a command-line utility:

```sh
dfhmdf macro-source > target-file
```

to produce the following output:

```ruby
  text_field(:acctno, 4, 13, 7)
  text_field(:surname, 5, 13, 15)
  text_field(:fname, 5, 30, 10)
  text_field(:chg, 6, 13, 8)
  text_field(:msg, 8, 1, 20)
```

From the example you may surmise:

1. It only pays attention to DFHMDF macros. 
1. It uses the downcased label value as the TE3270 field name, or a name like 'x14y12' for unlabeled DFHMDF macros.
1. It adjusts the X axis offset to account for the attribute byte.
1. When PICOUT is specified instead of LENGTH, it derives the length from the PICOUT value.
1. It generates only ```text_field``` definitions, and not a complete TE3270 screen class.

So, if you have coded a TE3270 screen class like this:

```ruby
class MainframeScreen
  include TE3270

  def login(username, password)
    self.userid = username
    self.password = password
  end
end

emulator = TE3270.emulator_for :extra do |platform|
  platform.session_file = 'sessionfile.edp'
end
my_screen = MainframeScreen.new(emulator)
my_screen.userid = 'the_id'
my_screen.password = 'the_password'
```

then you can paste in the generated ```text_field``` definitions like this:

```ruby
class MainframeScreen
  include TE3270

  text_field(:acctno, 4, 13, 7)
  text_field(:surname, 5, 13, 15)
  text_field(:fname, 5, 30, 10)
  text_field(:chg, 6, 13, 8)
  text_field(:msg, 8, 1, 20)

  def login(username, password)
    self.userid = username
    self.password = password
  end
end

emulator = TE3270.emulator_for :extra do |platform|
  platform.session_file = 'sessionfile.edp'
end
my_screen = MainframeScreen.new(emulator)
my_screen.userid = 'the_id'
my_screen.password = 'the_password'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dfhmdf'
```

And then execute:

    $ bundle

or install it yourself as:

    $ gem install dfhmdf

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dfhmdf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
