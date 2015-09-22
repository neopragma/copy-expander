require_relative '../lib/copy_expander'
require_relative '../lib/expander_config'

##
# Command-line driver for COBOL copy expander utility.
#
class Expander
  include CopyExpander
  include ExpanderConfig

  def initialize(argv=ARGV)
    @argv = argv
  end  

  def run
    load_config @argv
    open_source_file
    open_expanded_file
    process_source
    close_expanded_file
    close_source_file
  end

  def process_source
    init
    begin
      output_line = process read_line
      write_from output_line
    end while @eof == false
  end  

  def read_line
    line = @source_file.readline
    @eof = @source_file.eof?
    line
  end  

  def write_from line
    @expanded_file.write line
  end  

  def eof?
    @eof
  end  

  def open_source_file
    if @argv == nil || @argv[0] == nil
      abort 'Usage: expander name-of-cobol-source-file' 
    end
    @source_file = File.open("#{source_dir}/#{@argv[0]}", 'r')
    @eof = false
  end    

  def close_source_file
    @source_file.close
  end  

  def open_expanded_file
    @expanded_file = File.open("#{output_dir('.')}/#{expanded_file('TEMP.CBL')}", 'w')
  end
  
  def close_expanded_file
    @expanded_file.close
  end    

end