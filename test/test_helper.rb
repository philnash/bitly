require 'minitest/autorun'
require 'shoulda'
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
  if filename.is_a?(Array)
    response = filename.map { |f| { :body => fixture_file(f), :content_type => 'text/json' } }
  else
    response = { :body => fixture_file(filename), :content_type => 'text/json' }
  end
  FakeWeb.register_uri(:get, path, response)
end

def stub_post(path, filename)
  response = { :body => fixture_file(filename), :content_type => 'text/json' }
  FakeWeb.register_uri(:post, path, response)
end

def api_key
  'test_key'
end
def login
  'test_account'
end

class Minitest::Test
  def teardown
    FakeWeb.clean_registry
  end
end
