require 'convert_dfhmdf'
  
describe ConvertDfhmdf do

  before(:each) do
    @screen_def = ConvertDfhmdf.new
  end  

  describe "#process_macro" do
    it "handles a DFHMDF macro" do
      @screen_def.process_macro 'SURNAME  DFHMDF POS=(4,13),LENGTH=15,ATTRB=(ASKIP,NORM)'
      expect(@screen_def.dfhmdf?).to be(true)
      expect(@screen_def.field_label).to eq('surname')
      expect(@screen_def.x_coordinate).to eq(5)
      expect(@screen_def.y_coordinate).to eq(13)
      expect(@screen_def.field_length).to eq(15)
    end    
    it "ignores macros other than DFHMDF" do
      @screen_def.process_macro 'QCKSET   DFHMSD TYPE=MAP,STORAGE=AUTO,MODE=OUT,LANG=COBOL,TIOAPFX=YES'
      expect(@screen_def.dfhmdf?).to be(false)
      expect(@screen_def.field_label).to eq('x0y0')
      expect(@screen_def.x_coordinate).to eq(0)
      expect(@screen_def.y_coordinate).to eq(0)
      expect(@screen_def.field_length).to eq(0)
    end  
  end  

  describe "#ingest_macro" do
    it "stores macro source coded on a single line" do
      allow(@screen_def).to receive(:read_line).and_return('SURNAME  DFHMDF POS=(4,13),LENGTH=15,ATTRB=(ASKIP,NORM)')
      @screen_def.ingest_macro
      expect(@screen_def.macro_source).to eq('SURNAME DFHMDF POS=(4,13),LENGTH=15,ATTRB=(ASKIP,NORM)')
    end

    it "stores macro source coded on multiple lines, POS first" do
      allow(@screen_def).to receive(:read_line).and_return(
#                 1         2         3         4         5         6         7         8           
#        12345678901234567890123456789012345678901234567890123456789012345678901234567890      
        'SURNAME  DFHMDF POS=(4,13),                                            X',
        '                LENGTH=15,                                             X',
        '                ATTRB=(ASKIP,NORM),                                    X',
        '                INITIAL=\'Name here\'')
      @screen_def.ingest_macro
      expect(@screen_def.macro_source)
        .to eq('SURNAME DFHMDF POS=(4,13),LENGTH=15,ATTRB=(ASKIP,NORM),INITIAL=\'Name here\'')
    end  

    it "stores macro source coded on multiple lines, INITIAL first" do
      allow(@screen_def).to receive(:read_line).and_return(
#                 1         2         3         4         5         6         7         8           
#        12345678901234567890123456789012345678901234567890123456789012345678901234567890      
        'SURNAME  DFHMDF INITIAL=\'Name here\',                                   X',
        '                LENGTH=15,                                             X',
        '                ATTRB=(ASKIP,NORM),                                    X',
        '                POS=(4,13)')
      @screen_def.ingest_macro
      expect(@screen_def.macro_source)
        .to eq('SURNAME DFHMDF INITIAL=\'Name here\',LENGTH=15,ATTRB=(ASKIP,NORM),POS=(4,13)')
    end  
  end  

end