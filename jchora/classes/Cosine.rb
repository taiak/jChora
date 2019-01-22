class Cosine
    def self.similarity(freq1, freq2, values)     
        similarity = values.inject(0.0) { |sum, v| sum + freq1[v] * freq2[v] }
        
        freq1_size = freq1.values.inject(0.0) { |sum, v| sum + v * v }
        freq1_size = Math.sqrt freq1_size
        
        freq2_size = freq2.values.inject(0.0) { |sum, v| sum + v * v }
        freq2_size = Math.sqrt freq2_size

        freqs = (freq1_size * freq2_size)
        freqs = (freqs.nan? || freqs == 0)? 1: freqs

        similarity = similarity / freqs
        similarity
    end
end
