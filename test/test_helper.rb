require 'minitest/autorun'
require 'shoulda'
require 'webmock/minitest'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bitly'

WebMock.disable_net_connect!

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(uri, filename)
  if filename.is_a?(Array)
    response = filename.map { |f| { :body => fixture_file(f), :headers => { "Content-Type" => 'text/json' } } }
  else
    response = { :body => fixture_file(filename), :headers => { "Content-Type" => 'text/json' } }
  end
  stub_request(:get, uri).to_return(response)
end

def stub_post(uri, filename)
  response = { :body => fixture_file(filename), :headers => { "Content-Type" => 'text/json' } }
  stub_request(:post, uri).to_return(response)
end

def api_key
  'test_key'
end
def login
  'test_account'
end

class Minitest::Test
  def teardown
    WebMock.reset!
  end
end
