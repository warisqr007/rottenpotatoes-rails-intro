class Movie < ActiveRecord::Base
    def self.ratings
       ["G","PG","R","PG-13"] 
    end
end
