require_relative './dfhmdf'

class ConvertDfhmdf  
  include Dfhmdf

  def run
    open_file
    begin
      clear
      ingest_macro
      process_macro @macro_source
      puts te3270_text_field if dfhmdf?
    end while @eof == false
    close_file
  end

  def process_macro dfhmdf_macro
    parse_tokens tokenize_line dfhmdf_macro
  end  

  def ingest_macro
    macro_end = false
    @macro_source = ''
    current_line = read_line
    begin
      if current_line == nil || current_line.length < 72 || current_line[71] == ' '
        macro_end = true
      end  
      @macro_source << squish(current_line)
      current_line = read_line unless macro_end
    end while macro_end == false
    @macro_source
  end

  def process_macro dfhmdf_macro
    parse_tokens tokenize_line dfhmdf_macro
  end  

  def squish str
    str[71] = ' ' unless str.length < 72
    str.split.join(' ')
  end  

  def macro_source
    @macro_source
  end  

  def read_line
    line = @source_file.readline
    @eof = @source_file.eof?
    line
  end  

  def open_file
    if ARGV[0] == nil
      abort 'Usage: ruby make_fields.rb inputfilename' 
    end
    @source_file = File.open(ARGV[0], 'r')
    @eof = false
  end    

  def close_file
    @source_file.close
  end  

end