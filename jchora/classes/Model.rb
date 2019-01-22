require './classes/Cosine.rb'

# a class for saving model values
class Model
    require 'fileutils'
    java_import 'java.util.concurrent.Semaphore'

    attr_reader :metadata, :values, :name

    def initialize(model_name, writable = false)
      @name         = model_name
      @metadata     = [] 
      @values       = [] # hash of { order => hash }
      @model_folder = './dataset/model/' + @name 
      @prefix       = {
        metadata: '/meta_data_',
        filename: '/file_name_',
        data:     '/data_'
      }
    end

    def add_element(name, freq_hash)
      freq_hash.each do |value|
          @metadata << value.first unless @metadata.include? value.first  
      end
      @values<<[name.to_s, freq_hash]
    end

    def index(value)
      @metadata.index value
    end

    # write metadata into file
    # for human readable mode set marshalable false
    def metadata_to_file(marshalable = true)
      create_model_dir
      file_suffix = suffix_str marshalable

      write_file = @model_folder + @prefix[:metadata] + @name + file_suffix
      
      if marshalable
        marshalize_to_file(write_file, @metadata)
      else
        print_array_to_file(write_file, @metadata)
      end

    end

    def file_to_metadata
      @metadata = marshal.load(File.read(@model_folder + @prefix[:metadata] + @name + '.marshal_dump'))
    end

    def self.load_model(name)
      Marshal.load(File.read("./dataset/model/#{name}/#{name}.model_dump"))
    end

    def data_to_file(marshalable = true)
      create_model_dir
      file_suffix = suffix_str marshalable
      data_file_name = @model_folder + @prefix[:data] + @name + file_suffix
      
      if marshalable
        marshalize_to_file(data_file_name, @values)
      else
        filename_file_name = @model_folder + @prefix[:filename] + @name + file_suffix
        file_names = write_data_to_file(data_file_name)
        print_array_to_file(filename_file_name, file_names, "\n")
      end

    end

    def to_dump
      create_model_dir
      filename = @model_folder + '/' + @name + '.model_dump'
      File.open(filename, 'w') do |f|
        f.write(Marshal.dump self)
      end
    end

    def distance(freq, thread_limit = 4)
      thread_num = Semaphore.new(thread_limit)

      lock = Mutex.new
      result, ts = [], []
      
      @values.each do |file_name, frequency|
        thread_num.acquire
        ts<<Thread.new {
          arr = [file_name, Cosine.similarity(freq, frequency, @metadata)]
          lock.synchronize {
            result<<arr
          }
          thread_num.release
        }
      end

      ts.each(&:join)
      result.sort_by { |_, similarity| similarity}.reverse!
    end

    private

    # set suffix for file writing
    def suffix_str(marshalable = false)
      marshalable ? '.marshal_dump' : '.txt'
    end
    
    # convert values to marshal dump and write into file_name
    def marshalize_to_file(file_name, values, file_mode = 'w')
      File.open(file_name, file_mode) do |f|
        f.write(Marshal.dump(values.to_a))
      end
    end

    def write_data_to_file(file_name, file_mode = 'w')
      file_names = []

      File.open(file_name, file_mode) do |f|
        @values.each do |file_name, value|
          file_names << file_name 
          @metadata.each { |word, freq| f.print "#{value[word] } "}
          f.puts
        end
      end
      return file_names
    end

    def print_array_to_file(file_name, arr, seperator = ' ', file_mode = 'w')
      File.open(file_name, file_mode) do |f|
        arr.each { |file| f.write(file.to_s + seperator) }
        f.puts
      end
    end

    def create_model_dir
      FileUtils.mkdir_p @model_folder
    end
end