require 'sinatra'
require 'datamapper'

enable :sessions

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/#{ENV['RACK_ENV']}.db")

require './models.rb'

DataMapper.finalize
DataMapper.auto_upgrade!

require './handlers.rb'
