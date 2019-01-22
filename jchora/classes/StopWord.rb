class StopWord
    require './classes/FileReader'
    def self.read_stopwords(pattern = false)
        text = self.control_default_stopwords(pattern)
        self.pell_words(text).uniq  
    end

    private

    def self.default_stopword_files
        [
          './stopwords.txt',
          './stopwords/*.txt'
        ]
    end

    def self.pell_words(text)
        values = []
  
        clear_unalphabetics(text.downcase!).split.each do |word|
          values << word
        end
    
        values
    end

    def self.clear_unalphabetics(text)
      if text
        text.gsub(/[^[:alpha:]]/, ' ')
      else
        ' '
      end 
    end

    # control default stop words in patterns
    def self.control_default_stopwords(file_name = ' ')
      stopword_patterns = default_stopword_files + file_name.to_s.split
      stopword_files = pattern2file stopword_patterns

      return readFiles stopword_files
    end
   
    # control patterns in pattern_array
    def self.pattern2file(pattern_array)
      pattern_array.inject([]) do |arr, pattern|
        arr + Dir.glob(pattern)
      end
    end
   
    # read files in giving array
    def self.readFiles(arr)
      text = " "
      unless arr.empty?
        arr.each do |f|
          text += FileReader.read_file(f)
        end
      end
      return text
    end
end