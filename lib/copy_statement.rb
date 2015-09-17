##
# Encapsulate the details of a COBOL COPY statement.
#
class CopyStatement

  ##
  # Parse out the key elements of a COPY statement.
  #
  def initialize line
    tokens = line.gsub(/\s+/, ' ').split
    last = tokens.length-1
    @has_period = tokens[last].match(/\.$/) == nil ? false : true
    tokens[last] = tokens[last].gsub(/\./, '') 
    @copybook_name = tokens[1] 
    @has_replacing = tokens.length > 2 && tokens[2].downcase == 'replacing' ? true : false
    @old_value = strip_equals_signs(tokens[3]) if has_replacing?
    @new_value = strip_equals_signs(tokens[5]) if has_replacing?
  end  

  def copybook_name
    @copybook_name
  end  

  def has_period?
    @has_period
  end  

  def has_replacing?
    @has_replacing
  end  

  def old_value
    @old_value
  end  

  def new_value
    @new_value
  end  

  private

  def strip_equals_signs value
    value.gsub(/\=\=/, '')
  end  

end