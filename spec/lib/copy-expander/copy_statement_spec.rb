require 'copy_statement'

describe CopyStatement do

  context 'parsing out the copybook name' do

    it 'handles a simple COPY statement with no period' do
      copy_statement = CopyStatement.new '   COPY     CPYBOOK1    '
      expect(copy_statement.copybook_name).to eq('CPYBOOK1')
    end

    it 'handles a simple COPY statement with a period' do
      copy_statement = CopyStatement.new '   COPY     CPYBOOK1.    '
      expect(copy_statement.copybook_name).to eq('CPYBOOK1')
    end

    it 'handles a COPY REPLACING statement with a period' do
      copy_statement = CopyStatement.new '    COPY  CPYBOOK2    REPLACING ==:QUAL:==  BY ==WS==.'
      expect(copy_statement.copybook_name).to eq('CPYBOOK2')
    end  

  end
  
  context 'remembering whether the COPY statement is terminated by a period' do

    it 'remembers that a COPY statement is terminated by a period' do
      copy_statement = CopyStatement.new '   COPY     CPYBOOK1.    '
      expect(copy_statement.has_period?).to be_truthy
    end      

    it 'remembers that a COPY statement is not terminated by a period' do
      copy_statement = CopyStatement.new '   COPY     CPYBOOK1    '
      expect(copy_statement.has_period?).to be_falsy
    end      

  end

  context 'recognizing token replacement' do

    it 'recognizes the REPLACING option' do
      copy_statement = CopyStatement.new '    COPY  CPYBOOK2    REPLACING ==:QUAL:==  BY ==WS==.'
      expect(copy_statement.has_replacing?).to be_truthy
    end      

    it 'recognizes when there is no REPLACING option' do
      copy_statement = CopyStatement.new '    COPY  CPYBOOK2.'
      expect(copy_statement.has_replacing?).to be_falsy
    end   

    it 'stores the value to be replaced' do
      copy_statement = CopyStatement.new '    COPY  CPYBOOK2    REPLACING ==:QUAL:==  BY ==WS==.'
      expect(copy_statement.old_value).to eq(':QUAL:')
    end   

  end  

end  