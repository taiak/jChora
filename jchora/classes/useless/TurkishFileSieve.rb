class TurkishFileSieve
  require 'turkish_support'
  require './jars/zemberek-cekirdek-2.1.1.jar'
  require './jars/zemberek-tr-2.1.1.jar'
  
  java_import 'net.zemberek.erisim.Zemberek'
  java_import 'net.zemberek.tr.yapi.TurkiyeTurkcesi'

  using TurkishSupport

  attr_reader :name, :freq, :values, :norm
  
  def initialize(name)
    @name         = name
    @text         = ReadFiles.read_file(name)
    @freq         = {}
    @freq.default = 0
    @values       = []
  end
  
  # remove unalpha characters to space character
  def clear_unalphabetics(text = @text)
    text.gsub!(/[^[:alpha:]]/, ' ')
  end
  
  def freqhash
    arr2freqHash(@values)
  end

  def freqhash!
    @freq = arr2freqHash(@values)
  end
  
  # pell words to values
  def pell_words(text = @text, values = @values)
    @zemberek ||= Zemberek.new(TurkiyeTurkcesi.new)
    values    ||= []

    clear_unalphabetics(text.downcase!).split.each do |word|
      values << solve_word(word)
    end

    values
  end
  
  # delete stop words from @freq
  def clear_stop_words(file_name = false)
    text = control_default_stop_words(file_name)
    stop_words = pell_words(text, false).sort.uniq

    stop_words.each { |word| @freq.delete(word) }
  end
  
  def normalize(obj)
    @norm = obj.normalize @freq.values
  end

  private
  
  def default_stopword_files
    [
      './stopwords.txt',
      './stopwords/*.txt'
    ]
  end

  # control default stop words in patterns
  def control_default_stop_words(file_name = ' ')
    stop_word_patterns = default_stopword_files + file_name.to_s.split

    stop_word_files = pattern2file stop_word_patterns
  
    return readFiles(stop_word_files)
  end

  # control patterns in pattern_array
  def pattern2file(pattern_array)
    pattern_array.inject([]) do |arr, pattern|
      arr + Dir.glob(pattern)
    end
  end

  # read files in giving array
  def readFiles(arr)
    text = " "
    unless arr.empty?
      arr.each do |f|
        text += ReadFiles.read_file(f)
      end
    end
    return text
  end

  # make array element to hash, hash = { values => value_count }
  def arr2freqHash(arr)
    arr.inject(Hash.new(0)) { |hsh,val| hsh[val] += 1; hsh }
  end

  # kelimeyi çözümleyerek kökünü bulur
  # denetlenemeyecekkelimeler için kelimeyi doğrudan döndürür
  def solve_word(word)
    if @zemberek.kelimeDenetle word
      @zemberek.kelimeCozumle(word)[0].kok().icerik()
    else
      word
    end
  end
end