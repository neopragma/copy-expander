# Expander functional checks using real files
# These are not unit checks - there's no mocking.

require 'expander'

describe Expander, slow: true do

  before(:all) do
    File.open('expander.yml', 'w') do |file|
      file.write("{\n")
      file.write("  expanded_file: TEMP.CBL,\n")
      file.write("  source_dir: cobol-source,\n")
      file.write("  copy_dir: cobol-source/copy\n")
      file.write("}\n")
      file.close
    end  
  end  

  it 'copies a source file as-is when it contains no COPY statements' do
      system('bin/expander NOCOPY.CBL')
      expect_and_diff('./cobol-source/NOCOPY.CBL', './TEMP.CBL')
  end

  it 'expands a COPY REPLACING statement one level deep' do
      system('bin/expander COPY1LVL.CBL')
      expect_and_diff('./expected/EXPECTED1.CBL', './TEMP.CBL')
  end

  it 'expands two COPY REPLACING statements one level deep with different replacements' do
      system('bin/expander COPY1LVLA.CBL')
      expect_and_diff('./expected/EXPECTED2.CBL', './TEMP.CBL')
  end

  it 'expands one COPY REPLACING statement with a nested COPY REPLACING statement' do
      system('bin/expander COPY2LVL.CBL')
      expect_and_diff('./expected/EXPECTED3.CBL', './TEMP.CBL')
  end

  it 'expands COPY REPLACING statements down to three levels deep' do
      system('bin/expander COPY3LVL.CBL')
      expect_and_diff('./expected/EXPECTED4.CBL', './TEMP.CBL')
  end

  def expect_and_diff file1, file2
    system("diff #{file1} #{file2}") unless FileUtils.compare_file(file1, file2)
    expect(FileUtils.compare_file(file1, file2)).to be true
  end  

end