class Raiff::Chunk::Common < Raiff::Chunk
  # == Properties ===========================================================
  
  attr_reader :channels, :sample_frames, :sample_size, :sample_rate
  attr_reader :bytes_per_sample

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def initialize(file)
    super(file)
    
    chunk_end = file.offset + @size
    
    @channels, @sample_frames, @sample_size = file.unpack('nNn')

    @sample_rate = file.unpack_extended_float
    
    @bytes_per_sample = (@sample_size - 1) / 8 + 1
  end

  def inspect
    "<#{self.class}\##{object_id} #{@id} #{@size} channels=#{channels} sample_frames=#{sample_frames} sample_size=#{sample_size} sample_rate=#{'%.2f' % sample_rate}>"
  end
end
