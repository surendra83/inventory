# part.rb
require 'sequel'
require_relative '../db/migrate'
class Part < Sequel::Model
  plugin :timestamps, update_on_create: true
end
