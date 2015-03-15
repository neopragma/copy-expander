module Dfhmdf  

  def te3270_text_field
    "text_field(:#{field_label}, #{x_coordinate}, #{y_coordinate}, #{field_length})" 
  end  

  def clear
    @field_label, @parameter_hash, @parameters, @tokens = nil
    @dfhmdf = false
  end

  def tokenize_line input_line

# Want to split on spaces except when space occurs within single quotes.    
# Should be able to do it with a regex. Unable to figure it out so far. Using brute force.
# This regex doesn't work but was as close as I was able to get.
#    @tokens = [@tokens, input_line.scan(/'.*?'|".*?"|\S+/)].compact.reduce([], :|)

    new_tokens = []
    temp = input_line.split
    for i in 0..temp.length-1 do
      if temp[i] != nil
        if temp[i].include? "'"
          temp[i] << ' ' << temp[i+1] unless temp[i+1] == nil
          temp[i + 1] = nil
          if new_tokens[i] == nil
            new_tokens[i] = temp[i]
          else  
            new_tokens[i] << temp[i]
          end   
        else
          new_tokens << temp[i]
        end  
      end    
    end
    @tokens = [@tokens, new_tokens].compact.reduce([], :|)
  end  

  def parse_tokens tokens
    @dfhmdf = false
    if tokens[0] == 'DFHMDF'
      @dfhmdf = true
      @field_label = nil
      operands = tokens[1]
    elsif tokens[1] == 'DFHMDF'
        @dfhmdf = true
        @field_label = tokens[0].downcase
        operands = tokens[2]
    end
    if dfhmdf? && tokens != nil && operands != nil && operands.include?('=')
      parse_operands operands
    end  
  end  


  def parse_operands operands_as_string
  #-----------------------------------------------------------------------------
  # Parse the operands in a macro source statement:
  #
  # LABEL MACRO OPERAND,OPERAND,OPERAND COMMENT X
  #             xxxxxxxxxxxxxxxxxxxxxxx  
  #
  # Example
  # -------
  # from this...
  # FIELD1 DFHMDF POS=(6,18),LENGTH=14,ATTRB=(ASKIP,NORM),INITIAL='Hello there'
  #
  # to this...
  # { :pos => [ "6", "18" ], :length => "14", :attrb => [ "ASKIP", "NORM" ], 
  #   :initial => "Hello there" }
  #-----------------------------------------------------------------------------
    @operands_hash = {}

    # Split on comma except when the comma appears within parentheses.
    # Couldn't figure out how to make it ignore commas within single quotes,
    # so it misses PICOUT='$,$$0.00' and similar. Using brute force to handle it.

    item = operands_as_string.split(/,(?![^(]*\))/)
    for i in 0..item.length-1
      if item[i].match(/^PICOUT=/)
        item[i] << ',' << item[i+1]
      end  

      if item[i].include? '='
        key_value_pair = item[i].split('=')

        # handle operand values consisting of a comma-separated list within parentheses
        if key_value_pair[1][0] == '('
          key_value_pair[1].gsub!(/[\(\)]/, '')
          key_value_pair[1] = key_value_pair[1].split(',')
        end  

        # handle operand values in single quotes
        if key_value_pair[1][0] == "'"
          key_value_pair[1].gsub!(/'/, '')
        end  

        @operands_hash[key_value_pair[0].downcase.to_sym] = key_value_pair[1]
      end
    end    
    @operands_hash
  end  

  def x_coordinate
    (@operands_hash != nil && @operands_hash[:pos] && @operands_hash[:pos][0].to_i + 1) || 0
  end  

  def y_coordinate
    (@operands_hash != nil && @operands_hash[:pos] && @operands_hash[:pos][1].to_i) || 0
  end  

  def field_length
    (@operands_hash != nil && @operands_hash[:length] && @operands_hash[:length].to_i) ||
    (@operands_hash != nil && @operands_hash[:initial] && @operands_hash[:initial].length) ||
    (@operands_hash != nil && @operands_hash[:picout] && @operands_hash[:picout].length) || 0
  end  

  def field_label
    (@field_label == nil && "x#{x_coordinate}y#{y_coordinate}") || @field_label
  end

  def dfhmdf?
    @dfhmdf
  end    

end