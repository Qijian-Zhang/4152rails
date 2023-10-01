class Movie < ActiveRecord::Base

  def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies

    if ratings_list.empty?
      return Movie.all
    else 
      movies = []
      ratings_list.each {|rating|
      movies.concat(Movie.where(rating: rating))}
      return movies

    end
    end

  def self.all_ratings
    return Movie.group('rating').count.keys()
  end



end
