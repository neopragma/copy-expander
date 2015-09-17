require_relative '../lib/copy_expander'

##
# Command-line driver for COBOL copy expander utility.
#
class Expander
  include CopyExpander

  def initialize(argv=ARGV)
    @argv = argv
  end  

  def run
    open_file
    begin
      puts "Scanning source file #{@argv[0]} for COPY statements"
    end while @eof == false
    close_file
  end

  def read_line
    line = @source_file.readline
    @eof = @source_file.eof?
    line
  end  

  def open_file
    if @argv == nil || @argv[0] == nil
      abort 'Usage: expander name-of-cobol-source-file' 
    end
    @source_file = File.open(@argv[0], 'r')
    @eof = false
  end    

  def close_file
    @source_file.close
  end  

end