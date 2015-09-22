require 'copy_expander'
require 'copy_statement'
  
describe CopyExpander do

  include CopyExpander

  context 'preparing a source line to be processed' do

    it 'recognizes a comment line' do
      expect(comment?('123456*8901234567890')).to be true
    end    

    it 'recognizes a non-comment line' do
      expect(comment?('12345678901234567890')).to be false
    end    

    it 'stores the first 6 characters of the line' do
      break_up_source_line('12345678901234567890')
      expect(@first_six_characters).to eq('123456')
    end    

    it 'does not try to store the first 6 characters if the line is too short' do
      break_up_source_line('12345')
      expect(@first_six_characters).to be_nil
    end    

    it 'stores the last 8 characters of the line' do
      break_up_source_line('1234567890'*7 + 'abcdefghij')
      expect(@last_eight_characters).to eq('cdefghij')
    end    

    it 'does not try to store the last 8 characters if the line is too short' do
      break_up_source_line('1234567890'*7)
      expect(@last_eight_characters).to be_nil
    end    

    it 'stores the intepreted portion of a source line' do
      break_up_source_line('1234567890'*7 + 'abcdefghij')
      expect(@work_area).to eq('7890' + '1234567890'*6 + 'ab')
    end  

    it 'does not try to store the intepreted portion of a source line that is too short' do
      break_up_source_line('1234567890'*7)
      expect(@work_area).to be_nil
    end  

  end
  
  context 'identifying source lines that contain COPY statements' do  

    before(:each) do
      init 
    end

    it 'recognizes that the work area of a line contains a COPY statement' do
      @work_area = ' something something COPY something'
      expect(has_copy_statement?).to be true
    end  

    it 'recognizes that the work area of a line contains a copy statement' do
      @work_area = ' something something copy something'
      expect(has_copy_statement?).to be true
    end  

    it 'recognizes that the work area of a line does not contain a COPY statement' do
      @work_area = ' something something something'
      expect(has_copy_statement?).to be false
    end  

    it 'does not return a false positive when COPY appears as part of a variable name' do
      @work_area = ' MOVE "N" TO WS-COPY-INDICATOR.'
      expect(has_copy_statement?).to be false
    end  

    it 'does not return a false positive when copy appears as part of a variable name' do
      @work_area = ' set copy-allowed to true'
      expect(has_copy_statement?).to be false
    end  

    it 'ignores the word COPY when it appears between single quotes' do
      @work_area = ' DISPLAY \'I want to COPY something, and I want it now!\' '
      expect(has_copy_statement?).to be false
    end  

    it 'ignores the word COPY when it appears between double quotes' do
      @work_area = ' DISPLAY "I want to COPY something, and I want it now!" '
      expect(has_copy_statement?).to be false
    end  

    it 'ignores the word COPY when it appears immediately after a single quote' do
      @work_area = '\'COPY me this, Batman!\''
      expect(has_copy_statement?).to be false
    end  

    it 'ignores the word COPY when it appears immediately before a single quote' do
      @work_area = ' \'this is only a COPY\''
      expect(has_copy_statement?).to be false
    end  

    it 'ignores the word COPY when it appears immediately after a double quote' do
      @work_area = '"COPY me this, Batman!"'
      expect(has_copy_statement?).to be false
    end  

    it 'ignores the word COPY when it appears immediately before a double quote' do
      @work_area = ' "this is only a COPY"'
      expect(has_copy_statement?).to be false
    end  

  end  

  context 'reconstructing and commentizing source lines' do

    it 'reconstructs a source line' do
      @work_area = '  something something'
      @first_six_characters = '123456'
      @last_eight_characters = 'abcdefgh'
      expect(reconstruct_line).to eq('123456  something something' + ' '*40 + "     abcdefgh\n")
    end  

    it 'reconstructs a source line as a comment line' do
      @work_area = '  something something'
      @first_six_characters = '123456'
      @last_eight_characters = 'abcdefgh'
      expect(commentize(reconstruct_line)).to eq('123456* something something' + ' '*40 + "     abcdefgh\n")
    end  

  end  

  context 'substituting token values in a source line' do

    it 'substitutes the new value for the old value in a source line' do
      expect(replace_tokens(
          '           05  :ALPHA:-FIELDNAME PIC X.', 
          CopyStatement.new('           COPY FOOBAR REPLACING ==:ALPHA:== BY ==BETA==.')))
          .to eq('           05  BETA-FIELDNAME PIC X.')
    end  

  end  

  ##
  # Format a piece of COBOL source text as a fixed-length 80-character
  # line with a six-digit line number in positions 1-6 and an arbitrary
  # 8-character value in positions 73-80.
  # The source text represents the contents of positions 7-72 of a line
  # in a conventional COBOL source file.
  #
  def format_source_line line_number, text
    first_six = '%6.6d' % line_number.to_s    
    ('%-72.72s' % "#{first_six}#{text}") + "AAAAAAAA\n"
  end  

end