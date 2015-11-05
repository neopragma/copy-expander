require_relative 'copy_statement'
require_relative '../lib/expander_config'

##
# Work with individual source lines to perform token replacement declared
# in COBOL COPY REPLACING statements.
#
module CopyExpander 
  include ExpanderConfig


  def init
    @copy_statement_count = 0
    @copy_statement_depth = 0
  end
  
  def copy_statement_count
    @copy_statement_count
  end    

  ##
  # Expand COPY statement found on a single line of COBOL source code.
  #
  def process line
    return line if blank? line
    return line if comment? line
    break_up_source_line line
    return line unless has_copy_statement?
    @copy_statement_count += 1
    @depth = 0
    expand_copybook CopyStatement.new(@work_area)
    nil
  end  

  ##
  # Recursively expand copybooks and replace tokens
  #
  def expand_copybook copy_statement
    @depth += 1
    if @depth > 8
      puts "recursion depth is #{@depth}"
      exit(1)
    end  
    copybook = File.open("#{copy_dir}/#{copy_statement.copybook_name}", 'r')
    begin
      line = ('%-80.80s' % copybook.readline.chomp)
      if blank?(line) || comment?(line)
        write_from line
      else
        break_up_source_line line
        if has_copy_statement?
          @copy_statement_count += 1
          expand_copybook CopyStatement.new(@work_area)
        else
          @work_area = replace_tokens(@work_area, copy_statement)
          write_from reconstruct_line 
        end  
      end  
    end while copybook.eof? == false  
    @depth -= 1
  end  

  ##
  # Save the first six and last eight characters of the 80-character line
  # so that we won't shift characters into the interpreted area of the
  # line when we make text substitutions.
  #
  def break_up_source_line line
    if line[70] == ' ' && line[71..72] != '  ' 
      line[72..79] = line[71..78]
      line[71] = ' '
    end  

    line.length >=  6 ? @first_six_characters  = line[0..5]   : nil
    line.length >= 80 ? @last_eight_characters = line[72..79] : nil
    line.length >= 72 ? @work_area             = line[6..71]  : nil
  end  

  ##
  # Is this line logically blank?
  #
  def blank? line
    if ! line.valid_encoding?
      line = line.encode("UTF-16be", :invalid=>:replace, :replace=>" ").encode('UTF-8')
    end
    line == nil || line.gsub(/\s/, '').length == 0
  end  

  ##
  # Is this line a comment?
  # Source comments in COBOL are identified by an asterisk in position 7.
  #
  def comment? line
    line[6] == '*'
  end

  ##
  # Does the working area of the source line contain a COPY statement?
  #
  def has_copy_statement?
    @work_area.match(/ COPY (?=([^\"\']*\"[^\"\']*\"\')*[^\"\']*$)/i) ? true : false
  end  

  ##
  # Reconstruct the original source line.
  #
  def reconstruct_line
    @first_six_characters + ('%-66.66s' % @work_area) + @last_eight_characters
  end  

  ##
  # Make the current source line a comment line.
  #
  def commentize line
    line[6] = '*'
    line
  end  

  ##
  # Carry out token replacement in a source line per the REPLACING option
  #
  def replace_tokens line, copy_statement
    if copy_statement.old_value == nil || copy_statement.new_value == nil
      line
    else
      line.gsub(copy_statement.old_value, copy_statement.new_value) unless copy_statement.old_value == nil
    end
  end  

end