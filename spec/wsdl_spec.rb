require 'spec_helper'


describe "WSDL" do

  def wsdl
    Sinatra::Soap::Wsdl
  end

  it "should hold registered actions with arguments and blocks" do
    [:test, :add_circle].each do |action|
      expect(wsdl.actions).to include(action)
    end
  end

  it "should hold blocks for registered actions" do
    [:test, :add_circle].each do |action|
      expect(wsdl.actions[action]).to include(:block)
    end
  end

  it "should hould arguments types" do
    expect(wsdl.actions[:add_circle]).to include(:in)
    expect(wsdl.actions[:add_circle]).to include(:out)
  end
end
