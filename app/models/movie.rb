class Movie < ActiveRecord::Base
    def self.get_all_ratings
        #P, PG, R, PG-13
        Movie.select(:rating).map(&:rating).uniq.each
    end
end
