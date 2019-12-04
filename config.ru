# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require

require './orchestrate'
$stdout.sync = true
run Sinatra::Application
