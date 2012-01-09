require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'fakeweb'
require 'ruby-debug'

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

def api_key_fixture
  'test_key'
end
def login_fixture
  'test_account'
end
def client_id_fixture
  'client_id'
end
def client_secret_fixture
  'client_secret'
end
def fixture_token
  'token'
end

class Test::Unit::TestCase
  def teardown
    FakeWeb.clean_registry
  end
end
