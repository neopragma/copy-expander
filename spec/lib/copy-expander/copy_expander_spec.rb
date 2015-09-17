require 'copy_expander'
require 'copy_statement'
  
describe CopyExpander do

  include CopyExpander

  context 'preparing a source line to be processed' do

    it 'recognizes a comment line' do
      expect(comment?('123456*8901234567890')).to be_truthy
    end    

    it 'recognizes a non-comment line' do
      expect(comment?('12345678901234567890')).to be_falsy
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

    it 'recognizes that the work area of a line contains a COPY statement' do
      @work_area = ' something something COPY something'
      expect(has_copy_statement?).to be_truthy
    end  

    it 'recognizes that the work area of a line contains a copy statement' do
      @work_area = ' something something copy something'
      expect(has_copy_statement?).to be_truthy
    end  

    it 'recognizes that the work area of a line does not contain a COPY statement' do
      @work_area = ' something something something'
      expect(has_copy_statement?).to be_falsy
    end  

    it 'does not return a false positive when COPY appears as part of a variable name' do
      @work_area = ' MOVE "N" TO WS-COPY-INDICATOR.'
      expect(has_copy_statement?).to be_falsy
    end  

    it 'does not return a false positive when copy appears as part of a variable name' do
      @work_area = ' set copy-allowed to true'
      expect(has_copy_statement?).to be_falsy
    end  

  end  

  context 'reconstructing and commentizing source lines' do

    it 'reconstructs a source line' do
      @work_area = '  something something'
      @first_six_characters = '123456'
      @last_eight_characters = 'abcdefgh'
      expect(reconstruct_line).to eq('123456  something something' + ' '*40 + '     abcdefgh')
    end  

    it 'reconstructs a source line as a comment line' do
      @work_area = '  something something'
      @first_six_characters = '123456'
      @last_eight_characters = 'abcdefgh'
      expect(commentize(reconstruct_line)).to eq('123456* something something' + ' '*40 + '     abcdefgh')
    end  

  end  

  context 'substituting token values in a source line' do

    it 'substitutes the new value for the old value in a source line' do
      expect(replace_tokens('           05  :ALPHA:-FIELDNAME PIC X.', CopyStatement.new('           COPY FOOBAR REPLACING ==:ALPHA:== BY ==BETA==.')))
          .to eq('           05  BETA-FIELDNAME PIC X.')
    end  

  end  

end