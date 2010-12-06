class Raiff::Chunk::Data < Raiff::Chunk
  # == Properties ===========================================================
  
  attr_reader :data

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def initialize(file)
    super(file)
    
    @data = file.read(@size)
    
    if (@size % 2 == 1)
      file.read(1)
    end
  end
end
