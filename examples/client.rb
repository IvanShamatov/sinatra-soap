require "savon"

#client = Savon.client do
#  endpoint "http://127.0.0.1:4567/action"
#  namespace "http://schemas.xmlsoap.org/wsdl/"
#end


client = Savon.client(wsdl: "http://127.0.0.1:4567/wsdl")

puts client.operations

puts client.call(:test, message: { :hello => :world })
puts client.call(:test, message: { :should => :fail })

 
