# for multi language create class on run time
class WordSieve
    require 'turkish_support'
    require './classes/StopWord'
    require './jars/zemberek-cekirdek-2.1.1.jar'
    require './jars/zemberek-tr-2.1.1.jar'
    
    java_import 'net.zemberek.erisim.Zemberek'
    java_import 'net.zemberek.tr.yapi.TurkiyeTurkcesi'
  
    using TurkishSupport
  
    attr_reader :stopwords
    # XXX: normalizer setter can be pretty dangerous!
    attr_writer :normalizer
    
    def initialize(stopword_pattern = false)
      @values     = []
      @zemberek   = Zemberek.new(TurkiyeTurkcesi.new)
      read_stopwords(stopword_pattern)
      @normalizer = L2Norm # set default normalizer 
    end
    
    # remove unalpha characters to space character
    def clear_unalphabetics(text)
      text.gsub(/[^[:alpha:]]/, ' ') 
    end
    
    # array to frequency hash
    def freqhash(values)
      freq_hash = values.inject(Hash.new(0)) { |hsh, val| hsh[val] += 1; hsh }
      freq_hash.default = 0 # set default hash value to 0
      freq_hash
    end
    
    # pell words to values
    def pell_words(text)
      values = []
  
      clear_unalphabetics(text.downcase!).split.each do |word|
        if word
          values << self.solve_word(word)
        else
          p word
        end
      end
  
      values
    end

    # read stopwords
    def read_stopwords(pattern = false)
        @stopwords = StopWord.read_stopwords pattern  
    end

    # delete stop words from frequency hash
    def clear_stopwords(freq_hash)
      @stopwords.each { |word| freq_hash.delete(word) }
    end
    
    # return norm of freq_hash
    def normalize(freq_hash, normalizer = @normalizer)
      normalizer.normalize freq_hash.values
    end

    protected

    # kelimeyi çözümleyerek kökünü bulur
    # denetlenemeyecekkelimeler için kelimeyi doğrudan döndürür
    def solve_word(word)
      if @zemberek.kelimeDenetle word
          @zemberek.kelimeCozumle(word)[0].kok().icerik()
      else
        word
      end
    rescue => e
      Dir.mkdir './stopwords' unless File.exists? './stopwords'
      File.open('./stopwords/stopwords_catced.txt', 'w+') do |f|
        f.puts word
      end
    end
end