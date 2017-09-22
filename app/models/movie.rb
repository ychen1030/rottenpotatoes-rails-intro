class Movie < ActiveRecord::Base
    def self.get_all_ratings
        Movie.select(:rating).map(&:rating).uniq.each
    end
end
