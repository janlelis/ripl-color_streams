# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/ripl/color_streams"
 
Gem::Specification.new do |s|
  s.name        = "ripl-color_streams"
  s.version     = Ripl::ColorStreams::VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "http://github.com/janlelis/ripl-color_streams"
  s.summary = "A ripl plugin to colorize stdout and stderr."
  s.description =  "This ripl plugin colorizes your stdout and stderr streams."
  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency 'ripl', '>= 0.2.7'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end
