# Gems
require 'rubygems'
require 'dotenv/load'
require 'sinatra/base'
require 'sinatra/cors'
require 'thin'

# Native modules
require 'json'
require 'logger'

# Project files
require 'lib/raspberry_pi'
require 'lib/mock_pi'
require 'lib/camera'
