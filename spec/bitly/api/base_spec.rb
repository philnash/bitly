# frozen_string_literal: true

RSpec.describe Bitly::API::Base do
  let(:klass) do
    Class.new do
      include Bitly::API::Base
      attr_reader :name, :created_at
      def self.attributes ; [:name] ; end
      def self.time_attributes ; [:created_at] ; end
      def initialize(opts)
        assign_attributes(opts)
      end
    end
  end

  it "assigns named attributes on initialization" do
    obj = klass.new("name" => "Bob")
    expect(obj.name).to eq("Bob")
  end

  it "doesn't assign attributes that don't exist" do
    obj = klass.new("name" => "Phil", "mood" => "happy")
    expect(obj.name).to eq("Phil")
    expect { obj.mood }.to raise_error(NoMethodError)
    expect(obj.instance_variable_get("@mood")).to be nil
  end

  it "makes time objects out of time attributes" do
    obj = klass.new("created_at" => "2016-10-21T10:33:49+0000")
    expect(obj.created_at).to eq(Time.parse("2016-10-21T10:33:49+0000"))
  end

  it "sets up an attr_reader for response" do
    obj = klass.new({})
    expect(obj.respond_to?(:response)).to be true
  end
end