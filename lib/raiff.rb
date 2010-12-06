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
      
      @samples = [ ]

      if (@chunks['SSND'])
        @chunks['SSND'].each do |sound_data|
          @samples += sound_data.samples
        end
      end
    end
  end
  
  def inspect
    "<Raiff\##{object_id} channels=#{channels} sample_frames=#{sample_frames} sample_size=#{sample_size} sample_rate=#{sample_rate}>"
  end
  
  def each_sample(&block)
    @chunks['SSND'].each do |sound_data|
      sound_data.samples.each(&:block)
    end
  end
end
