class Raiff::File
  # == Constants ============================================================

  # == Properties ===========================================================

  attr_reader :offset

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def initialize(file)
    case (file)
    when IO
      @handle = file
    else
      @handle = File.open(file.to_s, 'r:BINARY')
    end

    @data = @handle.read
    @offset = 0
  end
  
  def eof?
    @offset >= @data.length
  end
  
  def advance(count = 1)
    @offset += count
  end
  
  def seek(offset)
    @offset = offset
  end
  
  def peek(bytes)
    @data[@offset, bytes]
  end
  
  def read(bytes)
    data = @data[@offset, bytes]
    
    @offset += bytes
    
    data
  end

  def unpack_extended_float
    extended = read(10).unpack('B80')[0]

    sign = extended[0, 1]
    exponent = extended[1, 15].to_i(2) - ((1 << 14) - 1)
    fraction = extended[16, 64].to_i(2)
    
    ((sign == '1') ? -1.0 : 1.0) * (fraction.to_f / ((1 << 63) - 1)) * (2 ** exponent)
  end

  def unpack(format)
    return if (@offset >= @data.length)

    part = @data[@offset, @data.length].unpack(format)
    advance(part.pack(format).length)
    part

  rescue TypeError
    [ ]
  end
end
