# user.rb
require 'sequel'
require_relative '../db/migrate'
class User < Sequel::Model
  plugin :timestamps, update_on_create: true
end
