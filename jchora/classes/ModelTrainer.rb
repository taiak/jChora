require './classes/WordSieve.rb'
require './classes/Model.rb'
class ModelTrainer
    java_import 'java.util.concurrent.Semaphore'

    def self.train(model_name, pattern, thread_limit = 5)
        thread_limit_semaphore = Semaphore.new(thread_limit)
        model_lock = Mutex.new
        model = Model.new model_name
        ws  = WordSieve.new

        file_names = ReadFiles.get_file_names pattern
        ts = []
        file_names.each_with_index do |file_name, i|
            thread_limit_semaphore.acquire
            ts<<Thread.new {
                # p "#{i}. #{file_name} başladı"
                text = ReadFiles.read_file file_name
                values = ws.pell_words(text)
                freq_hash = ws.freqhash values
    
                ws.clear_stopwords freq_hash
                
                model_lock.synchronize {
                    # add values to model
                    model.add_element file_name, freq_hash
                }
                # p "#{i}. #{file_name} bitti"
                thread_limit_semaphore.release
            }
        end
        ts.each(&:join)
        model
    end

    def self.normalize(model, normalizeClass)
        model.values.each { |k, v| normalizeClass.normalize! v }
    end
end