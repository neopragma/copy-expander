require 'dfhmdf'

class ScreenDef
  include Dfhmdf

  def operands_hash value    
    @operands_hash = value
  end  

  def field_label= value
    @field_label = value
  end  

end
  
describe ScreenDef do

  before(:each) do
    @screen_def = ScreenDef.new
  end  

  context "housekeeping" do
    it "clears all temporary values relevant to processing a DFHMDF macro" do
      @screen_def.clear
      expect(@screen_def.dfhmdf?).to be(false)
      expect(@screen_def.field_length).to eq(0)
      expect(@screen_def.field_label).to eq('x0y0')
      expect(@screen_def.x_coordinate).to eq(0)
      expect(@screen_def.y_coordinate).to eq(0)
    end    
  end  

  context "tokenizing" do
    describe "#tokenize_line" do
      it "collects tokens separated by spaces" do
        expect(@screen_def.tokenize_line('abc de,fg,hijk lmnop'))
          .to eq([ 'abc', 'de,fg,hijk', 'lmnop' ])
      end

      it "doesn't split on spaces that appear within quoted strings" do
        expect(@screen_def.tokenize_line("abc de,'fg hi',jkl mnop"))
          .to eq([ "abc", "de,'fg hi',jkl", "mnop" ])
      end

      it "splits properly when the last operand is a quoted string with a space" do
        expect(@screen_def.tokenize_line("abc de,fghi,'jkl mnop'"))
          .to eq([ "abc", "de,fghi,'jkl mnop'" ])
      end

      it "splits properly when an operand has multiple embedded spaces" do
        expect(@screen_def.tokenize_line("abc de,'fg hi jk',lmn"))
          .to eq([ "abc", "de,'fg hi jk',lmn" ])
      end
    end
  end    

  context "recognizing DFHMDF macros" do
    describe "#parse_tokens" do
      it "recognizes a DFHMDF macro with no label" do
        @screen_def.parse_tokens([ 'DFHMDF', 'POS=(4,5),LENGTH=15', 'baz' ])
        expect(@screen_def.dfhmdf?).to be(true)
      end

      it "clears the previous value of field label when none is specified" do
        @screen_def.field_label = 'aardvaark'
        @screen_def.parse_tokens([ 'DFHMDF', 'foo', 'bar' ])
        expect(@screen_def.field_label).to eql('x0y0')
      end

      it "recognizes a DFHMDF macro with a label" do
        @screen_def.parse_tokens([ 'FIELDNAME', 'DFHMDF', 'POS=(4,5),LENGTH=15', 'bar' ])
        expect(@screen_def.dfhmdf?).to be(true)
      end

      it "populates the field label when one is specified" do
        @screen_def.parse_tokens([ 'FIELDNAME', 'DFHMDF', 'POS=(4,5),LENGTH=15', 'bar' ])
        expect(@screen_def.field_label).to eq('fieldname')
      end

      it "ignores source lines that do not contain a DFHMDF macro" do
        @screen_def.parse_tokens [ 'foo', 'bar', 'DFHMDF', 'baz' ]
        expect(@screen_def.dfhmdf?).to eq(false)
      end
    end
  end

  context "parsing macro operands" do  
    describe "#parse_operands" do
      it "handles simple key-value pairs" do
        expect(@screen_def.parse_operands("KEY1=15,KEY2=30"))
          .to eq({ :key1 => "15", :key2 => "30" })
      end

      it "handles operands with quoted values" do
        expect(@screen_def.parse_operands("KEY1='Quoted value 1',KEY2='Quoted value 2'"))
          .to eq({ :key1 => "Quoted value 1", :key2 => "Quoted value 2" })
      end

      it "handles operands with comma-separated values in parentheses" do
        expect(@screen_def.parse_operands("KEY1=(one,two),KEY2=(three,four)"))
          .to eq({ :key1 => [ "one", "two" ], :key2 => [ "three", "four" ] })
      end

      it "handles operands in the order pos, length, attrb, initial" do
        expect(@screen_def.parse_operands("POS=(6,18),LENGTH=14,ATTRB=(ASKIP,NORM),INITIAL='Hello there'"))
          .to eq({ :pos => [ "6", "18" ], :length => "14", :attrb => [ "ASKIP", "NORM" ], :initial => "Hello there" })
      end

      it "handles operands in the order length, attrb, initial, pos" do
        expect(@screen_def.parse_operands("LENGTH=14,ATTRB=(ASKIP,NORM),INITIAL='Hello there',POS=(6,18)"))
          .to eq({ :pos => [ "6", "18" ], :length => "14", :attrb => [ "ASKIP", "NORM" ], :initial => "Hello there" })
      end
    end    
  end  

  context "determining field label" do
    describe "#field_label" do
      it "returns the field label that was specified on the DFHMDF macro" do
        @screen_def.field_label = 'NAME'
        expect(@screen_def.field_label).to eq('NAME')  
      end  

      it "derives a field label based on x and y coordinates when no label was specified" do
        @screen_def.field_label = nil
        @screen_def.operands_hash( { :pos => [ "5", "18" ] })
        expect(@screen_def.field_label).to eq('x6y18')  
      end  
    end    
  end  

  context "determining field position" do
    describe "#x_coordinate" do
      it "returns 0 as the x coordinate if the position has not been determined" do
        expect(@screen_def.x_coordinate).to eq(0)
      end  

      it "returns 0 as the x coordinate if POS=(x,y) was not specified" do
        @screen_def.operands_hash( { :foo => "bar" } )
        expect(@screen_def.x_coordinate).to eq(0)
      end  

      it "calculates the x coordinate value skipping the attribute byte" do
        @screen_def.operands_hash( { :pos => ["5", "28"] } )
        expect(@screen_def.x_coordinate).to eq(6)
      end
    end

    describe "#y_coordinate" do
      it "returns 0 as the y coordinate if the position has not been determined" do
        expect(@screen_def.y_coordinate).to eq(0)
      end  

      it "returns 0 as the y coordinate if POS=(x,y) was not specified" do
        @screen_def.operands_hash( { :foo => "bar" } )
        expect(@screen_def.y_coordinate).to eq(0)
      end  

      it "returns the y coordinate value from the POS=(x,y) parameter" do
        @screen_def.operands_hash( { :pos => ["5", "28"] } )
        expect(@screen_def.y_coordinate).to eq(28)
      end
    end
  end  

  describe "determining field length" do
    describe "handling the LENGTH= parameter of the DFHMDF macro" do
      it "returns 0 as the length if the length has not been determined" do
        expect(@screen_def.field_length).to eq(0)
      end  

      it "returns 0 as the length if the length was not specified" do
        @screen_def.operands_hash( { :foo => "bar" } )
        expect(@screen_def.field_length).to eq(0)
      end  

      it "returns the length value from the LENGTH= parameter" do
        @screen_def.operands_hash( { :length => "34" })
        expect(@screen_def.field_length).to eq(34)
      end
    end    

    describe "handling the PICOUT= parameter of the DFHMDF macro" do
      it "derives the length based on the PICOUT value" do  
        @screen_def.operands_hash( { :picout => "$,$$0.00" })
        expect(@screen_def.field_length).to eq(8)
      end  
    end    
  end  

  describe "generating a text_field definition" do
    it "generates a text_field definition for a field with a LENGTH= specification" do
      @screen_def.field_label = 'myfield'
      @screen_def.operands_hash({ :pos => [ "23", "6" ], :length => "14" })  
      expect(@screen_def.te3270_text_field).to eql('text_field(:myfield, 24, 6, 14)')
    end

    it "generates a text_field definition for a field with a PICOUT= specification" do
      @screen_def.field_label = 'otherfld'
      @screen_def.operands_hash({ :pos => [ "8", "16" ], :picout => "$$,$$0.00" })  
      expect(@screen_def.te3270_text_field).to eql('text_field(:otherfld, 9, 16, 9)')      
    end    

    it "generates a text_field definition for a field with INITIAL= and no LENGTH=" do
      @screen_def.field_label = 'otherfld'
      @screen_def.operands_hash({ :pos => [ "8", "16" ], :initial => "Hello" })  
      expect(@screen_def.te3270_text_field).to eql('text_field(:otherfld, 9, 16, 5)')      
    end    
  end 

end