require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'flexmock/test_unit'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bitly'

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(path, filename)
  FakeWeb.register_uri(:get, path, :body => fixture_file(filename), :content_type => 'text/json')
end

def api_key
  'test_key'
end
def login
  'test_account'
end

class Test::Unit::TestCase
  def teardown
    FakeWeb.clean_registry
  end
end
