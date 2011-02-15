class Raiff::Chunk::SoundData < Raiff::Chunk
  # == Properties ===========================================================
  
  attr_reader :offset, :block_size, :start_offset

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def initialize(file, common)
    super(file)
    
    @common = common

    @start_offset = file.offset
    @end_offset = file.offset + @size
    
    @offset, @block_size = file.unpack('NN')

    file.read(@offset)
    
    @sample_count = (@end_offset - file.offset) / @common.bytes_per_sample
    @bit_offset = @common.bytes_per_sample * 8 - @common.sample_size
    
    file.advance(@sample_count * @common.bytes_per_sample)
  end
  
  def read_sample
    self.decoder.call
  end
  
  def read_samples(count)
    if (count + @file.offset > @end_offset)
      count = (@end_offset - @file.offset) / @common.bytes_per_sample
    end
    
    samples = [ ]
    _decoder = self.decoder

    count.times do
      samples << _decoder.call
    end
    
    samples
  end
  
  def decoder
    sample_size = @common.bytes_per_sample
    channels = (1..@common.channels).to_a
    negative = 1 << (@common.sample_size - 1)

    @decoder =
      case (@bit_offset)
      when 0
        lambda {
          channels.collect {
            v = @file.read(sample_size).bytes.inject(0) do |a, b|
              a << 8 | b
            end
            
            (v & negative) ? ((v ^ negative) - negative) : v
          }
        }
      else
        lambda {
          channels.collect {
            v = @file.read(sample_size).bytes.inject(0) do |a, b|
              a << 8 | b
            end >> @bit_offset - @value_offset

            (v & negative) ? ((v ^ negative) - negative) : v
          }
        }
      end
    end
end
