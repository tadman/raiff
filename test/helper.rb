require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'raiff'

class Test::Unit::TestCase
  def sample_file(name)
    File.expand_path(File.join('..', 'sample', name), File.dirname(__FILE__))
  end
end
