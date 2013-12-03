require 'spec_helper'


describe "WSDL" do

  def wsdl 
    Sinatra::Soap::Wsdl
  end

  it "should hold registered actions with arguments and blocks" do
    [:test, :add_circle].each do |action|
      wsdl.actions.should include(action)
    end
  end 

  it "should hold blocks for registered actions" do
    [:test, :add_circle].each do |action|
      wsdl.actions[action].should include(:block)
    end
  end

  it "should hould arguments types" do
    wsdl.actions[:add_circle].should include(:in)
    wsdl.actions[:add_circle].should include(:out)
  end
end