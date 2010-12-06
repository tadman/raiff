class Raiff::Chunk::SoundData < Raiff::Chunk
  # == Properties ===========================================================
  
  attr_reader :offset, :block_size
  attr_reader :samples

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def initialize(file, common)
    super(file)
    
    end_offset = file.offset + @size
    
    @offset, @block_size = file.unpack('NN')

    file.read(@offset)
    
    sample_count = (end_offset - file.offset) / common.bytes_per_sample
    bit_offset = common.bytes_per_sample * 8 - common.sample_size
    
    @samples = [ ]
    
    case (common.bytes_per_sample)
    when 3
      format = 'B24' * common.channels
      
      sample_count.times do
        if (sample = file.unpack(format))
          @samples << sample.collect { |s| s.to_i(2) >> bit_offset }
        end
      end
    else
      format = %w[ C n x N ][common.bytes_per_sample] * common.channels
      
      sample_count.times do
        @samples << file.unpack(format).collect { |i| i >> bit_offset }
      end
    end
  end
end
