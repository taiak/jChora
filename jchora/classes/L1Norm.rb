require './classes/PNorm.rb'
# manhattan distance
class L1Norm < PNorm
    # p norm with p=1
    # ∥x∥ = ∑|xi|
    def self.norm(arr)
        super(arr, 1, false)
    end

    def self.normalize(freq)
        super(freq, 1, false)
    end

    def self.normalize!(freq)
        super(freq, 1, false)
    end
end
