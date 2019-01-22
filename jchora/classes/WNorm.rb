# weighted norm
class WNorm
    def self.norm(arr)
        sum = arr.inject(0) { |sum, value| sum + value  }
        sum / arr.size
    end

    def self.normalize(freq)
        norm = self.norm freq.values
        freq_hash = freq.dup
        freq_hash.keys.map { |k| freq_hash[k] /= norm }
        freq_hash
    end

    def self.normalize!(freq)
        norm = self.norm freq.values
        freq.keys.map { |k| freq[k] /= norm }
        freq
    end
end