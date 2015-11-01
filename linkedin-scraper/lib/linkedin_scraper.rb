require "rubygems"
require "mechanize"
require "cgi"
require "net/http"
require_relative "linkedin_scraper/profile.rb"
Dir[File.dirname(__FILE__) + "linkedin_scraper/*.rb"].each { |file| require file }
