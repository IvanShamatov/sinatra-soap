# Sinatra::Soap — Under construction

[![Build Status](https://travis-ci.org/IvanShamatov/sinatra-soap.png?branch=master)](https://travis-ci.org/IvanShamatov/sinatra-soap)[![Code Climate](https://codeclimate.com/github/IvanShamatov/sinatra-soap.png)](https://codeclimate.com/github/IvanShamatov/sinatra-soap)

## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-soap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sinatra-soap

## Overview

In case of simplicity and quick first working release:
 
 - WSDL would not be generated
 - WSDL would not be checked
 - Response would be ```"#{soap_action}Response"``` and types would guessed.


## Usage

A classic application would work like that: 

```ruby
require 'sinatra'
require 'sinatra/soap'

set :wsdl_path, "/path/to/file"

soap "SomeAction" do 
  params # hash to be returned
end
```

A modular application would look like that:

```ruby
require 'sinatra/base'
require 'sinatra/soap'

class SoapAPI < Sinatra::Base

  #remember to register extenstion if you are using modular style
  register Sinatra::Soap 

  set :wsdl_path, "/path/to/file"

  soap "SomeAction" do 
    params # hash to be returned
  end
end
```






