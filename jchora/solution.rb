#encoding: utf-8
require 'java'
require './classes/L2Norm.rb'
require './classes/ModelTrainer.rb'
require './classes/Model.rb'
require './classes/ReadFiles.rb'

# run with parameters : jruby  -J-Xmn512m -J-Xms512m -J-Xmx512m .\solution.rb

s1 = Time.new


# m_train = Model.load_model('normalized')
m_train = ModelTrainer.train 'normalized', "./dataset/train/*", 2
ModelTrainer.normalize m_train, L2Norm

f = Time.new
p "train time: #{f - s1}"
s = Time.new

# m_test = Model.load_model('test')
m_test  = ModelTrainer.train 'test', "./dataset/test/*" 
ModelTrainer.normalize m_test, L2Norm

f = Time.new
p "test time: #{f - s}"
s = Time.new

m_test.values.each do |k, v|
    cosines = m_train.distance(v)
    puts
    p "file: #{k}... "
    cosines[0..4].each { |f, v| p "%#{(v * 10000).ceil.to_i / 100.0}  #{f}" }
end

f = Time.new
p "find distance time: #{f - s}"
s = Time.new

# write plain values
# m_train.data_to_file     false
# m_train.metadata_to_file false

m_train.dump_to_file
m_test.dump_to_file

p "metadata: " + m_train.metadata.map { |e| e }.size.to_s
p "values: "   + m_train.values.map   { |e| e }.size.to_s

p "total time: #{f - s1}"
s = Time.new