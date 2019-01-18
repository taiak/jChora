class Cosine
    def self.similarity(freq1, freq2, values)
        similarity = 0.0 
        freq1_size, freq2_size = 0, 0

        similarity = values.inject(0.0) { |sum, v| sum + freq1[v] * freq2[v] }
        
        freq1_size = freq1.values.inject(0.0) { |sum, v| sum + v * v }
        freq1_size = Math.sqrt freq1_size
        
        freq2_size = freq2.values.inject(0.0) { |sum, v| sum + v * v }
        freq2_size = Math.sqrt freq2_size

        
        similarity = similarity / (freq1_size * freq2_size)

        if similarity > 1
            1
        elsif similarity < 0
            0
        else
            similarity
        end
    end

end