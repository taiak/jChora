#encoding: utf-8
require 'java'
require './classes/l2Norm.rb'

require './classes/ModelTrainer.rb'

# run with parameters : jruby  -J-Xmn512m -J-Xms512m -J-Xmx512m .\solution.rb

s1 = Time.new

# m_train = Model.load_model('normalized')
m_train = ModelTrainer.train 'normalized', "./dataset/train/*", 20, true
ModelTrainer.normalize m_train, L2Norm

# m_test = Model.load_model('test')
m_test  = ModelTrainer.train 'test', "./dataset/test/*", 5, true
ModelTrainer.normalize m_test, L2Norm

s = Time.new

m_test.values.each do |k, v1|
    puts
    p "file: #{k}... "
    cosines = m_train.distance(v1)
    cosines [0..4].each { |f, v| p "%#{(v * 10000).ceil.to_i / 100.0} #{f} " }
end
f = Time.new
p "find distance time: #{f - s} sec"

# write plain values
# m_train.data_to_file     false
# m_train.metadata_to_file false

m_train.to_dump
m_test.to_dump

puts "model total word count: " + m_train.metadata.map { |e| e }.size.to_s
puts "model file count: "       + m_train.values.map   { |e| e }.size.to_s
f = Time.new
puts "total time: #{f - s1} sec"