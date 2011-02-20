require 'spork'
require 'steak'
require 'capybara/rspec'
require 'faker'
require 'sinatra'
require 'sequel'
require 'spawn'

Spork.prefork do

  SINATRA_ROOT = File.dirname(__FILE__)+'/..' 
  $LOAD_PATH << SINATRA_ROOT
  DB = Sequel.amalgalite
  set :environment, :test
  set :root, SINATRA_ROOT
  Capybara.app = Sinatra::Application
end

Spork.each_run do
  require 'notes'

  RSpec.configure do |config|
    config.include TextHelper
  end

  Note.extend Spawn
  Note.spawner do |user|
    user.title = generate_description
    user.body  = generate_content
  end
end

def generate_description
  Faker::Lorem.sentence
end

def generate_content
  Faker::Lorem.paragraph
end