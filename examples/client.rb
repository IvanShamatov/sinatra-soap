require "savon"

client = Savon.client do
  endpoint "http://127.0.0.1:4567/action"
  namespace "http://schemas.xmlsoap.org/wsdl/"
end

puts client.call(:test, message: { :hello => :world })

#client = Savon.client(
#  :wsdl => "http://www.webservicex.net/stockquote.asmx?WSDL",
#  :open_timeout => 10,
#  :read_timeout => 10,
#  :log => true
#)

 
