# ∥x∥ = [∑i(|xi|^p]^1/p
class PNorm
    def self.norm(arr, p, evaluation = true)
        sum = arr.inject(0) { |sum, value| sum + (value.abs) ** p }
        evaluation ? sum ** (1.0/p) : sum
    end

    def self.normalize(freq, p, evaluation = true)
        norm = self.norm freq.values, p
        freq_hash = freq.dup
        freq_hash.keys.map { |k| freq_hash[k] /= norm }
        freq_hash
    end

    def self.normalize!(freq, p, evaluation = true)
        norm = self.norm freq.values, p
        freq.keys.map { |k| freq[k] /= norm }
        freq
    end
end