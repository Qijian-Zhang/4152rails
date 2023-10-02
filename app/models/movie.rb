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

  def self.sort_by_name(ratings_list)
    if ratings_list.nil?
      movies=Movie.order(:title)
    else
      if ratings_list.empty?
        movies=Movie.order(:title)
      else
        movies = Movie.where(rating: ratings_list).order(:title)
      end
    end
    return movies
  end

  def self.sort_by_time(ratings_list)
    if ratings_list.nil?
      movies=Movie.order(:release_date)
    else
      if ratings_list.empty?
        movies=Movie.order(:release_date)
      else
        movies = Movie.where(rating: ratings_list).order(:release_date)
      end
    end

    return movies
  end
end
