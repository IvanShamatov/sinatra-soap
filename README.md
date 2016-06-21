# Sinatra::Soap — Not maintained. 

[![Build Status](https://travis-ci.org/IvanShamatov/sinatra-soap.png?branch=master)](https://travis-ci.org/IvanShamatov/sinatra-soap) [![Code Climate](https://codeclimate.com/github/IvanShamatov/sinatra-soap.png)](https://codeclimate.com/github/IvanShamatov/sinatra-soap) [![Gem Version](https://badge.fury.io/rb/sinatra-soap.png)](http://badge.fury.io/rb/sinatra-soap)

Sinatra-soap gem makes task to create SOAP API really simple. Inspired by WashOut gem for Rails. But remember, the only reason why you should use SOAP is legacy code.


## Overview

In case of simplicity and quick first working release: 

## Usage

A classic application would work like that: 

```ruby
require 'sinatra'
require 'sinatra/soap'

soap "SomeAction" do
  do_something_with_params # hash to be returned
end
```

A modular application would look like that:

```ruby
require 'sinatra/base'
require 'sinatra/soap'

class SoapAPI < Sinatra::Base

  #remember to register extenstion if you are using modular style
  register Sinatra::Soap 

  soap "SomeAction" do
    params # hash to be returned
  end
end
```


## Settings

* **:wsdl_route** — url for getting wsdl, either static or dynamically generated file
```ruby
set :wsdl_route, '/wsdl'
```
Defines route for app to response with wsdl. Default is '/wsdl'


* **:endpoint** — url for sending SOAP Requests
```ruby
set :endpoint, '/action'
```
Defines route for SOAP Requests. Default is '/action'


* **:wsdl_file** — app will send static file, if this setting specified
```ruby
set :wsdl_file, "wsdl.xml"
```
If wsdl_file is set, app will try to read wsdl file from ```:public_folder``` (by default ./public directory). If file does not exist, app will raise an error. You also don't need to specify ```:namespace``` or ```:service``` if you want to serve static wsdl.


* **:namespace** — wsdl setting, required for generating wsdl
```ruby
set :namespace, "http://schemas.xmlsoap.org/wsdl/"
```
Namespace is taking it's place in ```xmlns:tns``` and ```targetNamespace``` definitions of SOAP Envelope

* **:service** — wsdl setting, required for generating wsdl
```ruby
set :service, "sinatra"
```
Service involved in ```portType```, ```binding``` and ```service``` definitions as a prefix for name attribute.




## Soap Arguments

If you want to be able to generate wsdl on a fly, you need to specify incoming and outgoing nodes with their types. 

```ruby
soap :test, in: {circle: {center: {x: :integer, 
                                   y: :integer}, 
                          radius: :double}
                },
            out: nil do
  params #=> {circle: {center: {x: 3, y: 2}, radius: 12.0} }
  nil
end
```

The code above will respond to request like this:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsdl="anynamespacehere" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
  <env:Body>
    <wsdl:test>
      <circle>
        <center>
          <x>3</x>
          <y>2</y>
        </center>
        <radius>12.0</radius>
      </circle>
    </wsdl:test>
  </env:Body>
</env:Envelope>
``` 


