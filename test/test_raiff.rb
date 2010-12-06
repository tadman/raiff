require File.expand_path('helper', File.dirname(__FILE__))

class TestRaiff < Test::Unit::TestCase
  def test_empty
    raiff = Raiff.new
    
    assert raiff
  end

  def test_open_short_sample
    raiff = Raiff.open(sample_file('example-24bit.aiff'))
    
    assert raiff
    
    assert_equal 23493, raiff.sample_frames
  end

  def test_failed_open
    raised = false

    raiff = Raiff.open('does.not.exist')

  rescue Errno::ENOENT
    raised = true
  ensure
    assert raised
  end
end
