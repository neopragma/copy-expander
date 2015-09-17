##
# Work with individual source lines to perform token replacement declared
# in COBOL COPY REPLACING statements.
#
module CopyExpander 

  ##
  # Save the first six and last eight characters of the 80-character line
  # so that we won't shift characters into the interpreted area of the
  # line when we make text substitutions.
  #
  def break_up_source_line line
    line.length >=  6 ? @first_six_characters  = line[0..5]   : nil
    line.length >= 80 ? @last_eight_characters = line[72..79] : nil
    line.length >= 72 ? @work_area             = line[6..71]  : nil
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
    @work_area.match(/ COPY /i)
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
    line.gsub(copy_statement.old_value, copy_statement.new_value)
  end  

end