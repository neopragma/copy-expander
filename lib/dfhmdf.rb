module Dfhmdf  

  # Generate a te3270 text_field declaration using values parsed from a DFHMDF macro.
  def te3270_text_field
    "text_field(:#{field_label}, #{x_coordinate}, #{y_coordinate}, #{field_length})" 
  end  

  # Clear variables to prepare for parsing a DFHMDF macro.
  def clear
    @field_label, @parameter_hash, @parameters, @tokens = nil
    @dfhmdf = false
  end


  # Tokenize an input line from the macro source file. 
  #
  # LABEL MACRO OPERAND,OPERAND,OPERAND COMMENT X
  # 1     2     3                       4       discard
  def tokenize_line input_line
    # Want to split on spaces except when space occurs within single quotes.    
    # Should be able to do it with a regex. Unable to figure it out so far. Using brute force.
    # This regex doesn't work but was as close as I was able to get.
    #    @tokens = [@tokens, input_line.scan(/'.*?'|".*?"|\S+/)].compact.reduce([], :|)
    # +input_line+:: A line of input from the macro source file.

    new_tokens = []
    temp = input_line.split
    new_tokens[0] = temp[0]
    if temp[0] == 'DFHMDF'
      start_ix = 1
    else
      start_ix = 2
      new_tokens[1] = temp[1]
    end    
    temp = input_line.split(' ')
    open_quote = false
    for i in 0..temp.length-1 do
      if temp[i] != nil
        open_quote = true unless temp[i].count("'") % 2 == 0
        while open_quote
          if temp[i+1] != nil
            temp[i] << ' ' << temp[i+1]
            temp[i+1] = nil
            temp.compact!
            open_quote = false if temp[i].count("'") % 2 == 0
          else
            open_quote = false  
          end  
        end  
      end
    end  
    @tokens = [@tokens, temp].compact.reduce([], :|)
  end  

  # Look at the tokens that were extracted from an input line and determine whether
  # we are reading a DFHMDF macro. There may or may not be a label (1st token).
  # +tokens+:: array of tokens extracted from the current input line
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
  # +operands_as_string+:: The DFHMDF operands as a single string.
  def parse_operands operands_as_string
    @operands_hash = {}
    # Split on comma except when the comma appears within parentheses.
    # Couldn't figure out how to make regex ignore commas within single quotes,
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

  
  # Return the X coordinate of the field as specified in the POS=(x,y) operand of DFHMDF. 
  # Bump the offset by one to account for the 3270 attribute byte. If the X coordinate 
  # value hasn't been set, return zero.
  def x_coordinate
    (@operands_hash != nil && @operands_hash[:pos] && @operands_hash[:pos][0].to_i + 1) || 0
  end  


  # Return the Y coordinate of the field as specified in the POS=(x,y) operand of DFHMDF.
  # If the Y coordinate value hasn't been set, return zero.
  def y_coordinate
    (@operands_hash != nil && @operands_hash[:pos] && @operands_hash[:pos][1].to_i) || 0
  end  


  # Return the length of the field. This may be specified in the LENGTH= operand of DFHMDF or
  # derived from the PICOUT= or INTIAL= operand.
  def field_length
    (@operands_hash != nil && @operands_hash[:length] && @operands_hash[:length].to_i) ||
    (@operands_hash != nil && @operands_hash[:initial] && @operands_hash[:initial].length) ||
    (@operands_hash != nil && @operands_hash[:picout] && @operands_hash[:picout].length) || 0
  end  


  # Return the field label (name) as specified on the DFHMDF macro. When no label is coded on
  # the macro, build a name based on the X and Y coordinates, like x20y5 or x9y32.
  def field_label
    (@field_label == nil && "x#{x_coordinate}y#{y_coordinate}") || @field_label
  end


  # True if we are looking at a DFHMDF macro in the input.
  def dfhmdf?
    @dfhmdf
  end    

end