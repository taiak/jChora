require './classes/PNorm.rb'
# p norm with p=2
class L2Norm < PNorm
    # return Euclidean norm
    # ∥x∥ = √[∑(xi^2)]
    def self.norm(arr, squared = false)
        super(arr, 2, squared)
    end

    def self.normalize(freq)
        super(freq, 2)
    end

    def self.normalize!(freq)
        super(freq, 2)
    end
end