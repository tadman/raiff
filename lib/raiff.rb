class Raiff
  # == Submodules ===========================================================
  
  autoload(:Chunk, 'raiff/chunk')
  autoload(:File, 'raiff/file')

  # == Properties ===========================================================
  
  attr_reader :channels, :sample_frames, :sample_size, :sample_rate
  attr_reader :samples

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  
  def self.open(file)
    raiff = new(file)
    
    yield(raiff) if (block_given?)
    
    raiff
  end

  # == Instance Methods =====================================================

  def initialize(file = nil)
    @offset = 0
    
    if (file)
      @file = Raiff::File.new(file)
    
      @form = Raiff::Chunk::Form.new(@file)
      @chunks = @form.chunks
      
      common_chunk = (@chunks['COMM'] and @chunks['COMM'][0])
      
      if (common_chunk)
        @channels = common_chunk.channels
        @sample_frames = common_chunk.sample_frames
        @sample_size = common_chunk.sample_size
        @sample_rate = common_chunk.sample_rate
      end
    end
  end
  
  def inspect
    "<Raiff\##{object_id} channels=#{channels} sample_frames=#{sample_frames} sample_size=#{sample_size} sample_rate=#{sample_rate}>"
  end
  
  def each_sample
    @chunks['SSND'].each do |sound_data|
      @file.seek(sound_data.start_offset)

      sound_data.sample_count.times do
        sample = sound_data.read_sample

        yield(sample)
      end
    end
  end

  def each_sample_block(size)
    @chunks['SSND'].each do |sound_data|
      @file.seek(sound_data.start_offset)

      block_count = (@sample_frames - 1) / size + 1
      
      block_count.times do
        yield(sound_data.read_samples(size))
      end
    end
  end
end
