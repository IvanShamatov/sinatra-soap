# Sinatra::Soap — Under construction

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

**:wsdl_route** — url for getting wsdl, either static or dynamically generated file


**:endpoint** — url for sending SOAP Requests


**:wsdl_file** — app will send static file, if this setting specified
```ruby
set :wsdl_file, "wsdl.xml"
```
If wsdl_file is set, app will try to read wsdl file from ```:public_folder``` (by default ./public directory). If file does not exist, app will raise an error. You also don't need to specify ```:namespace``` or ```:service``` if you want to serve static wsdl.


**:namespace** — wsdl setting, required for generating wsdl
namespace is taking its place in ```xmlns:tns``` and ```targetNamespace``` definitions of SOAP Envelope

**:service** — wsdl setting, required for generating wsdl





