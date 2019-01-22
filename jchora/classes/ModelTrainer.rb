class ModelTrainer
    require './classes/WordSieve.rb'
    require './classes/Model.rb'
    require './classes/FileReader.rb'
    require 'ruby-progressbar'    
    java_import 'java.util.concurrent.Semaphore'
    def self.train(model_name, pattern, thread_limit = 1, statu_bar_state = false)
        start_time = Time.new
        puts "#{model_name} training started!"
        thread_limit_semaphore = Semaphore.new(thread_limit)
        model_lock = Mutex.new
        model      = Model.new model_name
        ws         = WordSieve.new
        file_names = FileReader.get_file_names pattern
        
        if statu_bar_state
            progressbar = ProgressBar.create(:title => model_name, :starting_at => 0, :total => file_names.size, 
                    :format => '%t: %c/%C ||%B|| %%p', :remainder_mark => '-', :progress_mark => '#')
        end

        ts = []

        file_names.each_with_index do |file_name, i|
            thread_limit_semaphore.acquire
            ts<<Thread.new {
                text = FileReader.read_file file_name
                values = ws.pell_words(text)
                freq_hash = ws.freqhash values
    
                ws.clear_stopwords freq_hash
                
                model_lock.synchronize {
                    # add values to model
                    model.add_element file_name, freq_hash
                    progressbar.increment if statu_bar_state
                }
                thread_limit_semaphore.release
            }
        end
        ts.each(&:join)
        puts "#{model_name} training finished! #{Time.new - start_time} sn !"
        model
    end

    def self.normalize(model, normalizeClass)
        model.values.each { |k, v| normalizeClass.normalize! v }
    end
end