require 'expander'

describe Expander do 

  context 'opening and closing source files' do

    it 'complains when no source file name is passed on the command line' do
      stderr = $stderr
      $stderr = StringIO.new
      @expander = Expander.new nil
      expect { @expander.open_file }.to raise_error(SystemExit)
      $stderr.rewind
      expect($stderr.readlines).to include("Usage: expander name-of-cobol-source-file\n")
      $stderr = stderr
    end  

    it 'complains when it cannot find the file given on the command line' do
      stderr = $stderr
      $stderr = StringIO.new
      @expander = Expander.new 'nosuchfile'
      expect { @expander.open_file }.to raise_error(Errno::ENOENT)
      $stderr = stderr
    end  

  end

end
