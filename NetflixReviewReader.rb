#
# Ruby program to analyze Netflix reviews.
# U. of Illinois, Chicago
# CS 341, Fall 2014
# Final Project
#

class Movie
	# Creates getters and setters for each of the instance variables
	# You never have access to instance variables outside of the instance
	# You can also use attr_reader and attr_writer to restrict access
	attr_accessor :name
	attr_accessor :ratings
	attr_accessor :sum_of_reviews
	attr_accessor :average_rating
	attr_accessor :total_review_count

	# Class constructor
	def initialize(movie_name)
		# Instance Variables
		@name = movie_name
		@ratings = [0,0,0,0,0,0]
		@sum_of_reviews = 0.0
		@average_rating = 0
		@total_review_count = 0
	end

	def calculate_average_rating
		@average_rating = @sum_of_reviews / @total_review_count
	end

	def print_ratings_breakdown
		puts '5: ' + @ratings[5].to_s
		puts '4: ' + @ratings[4].to_s
		puts '3: ' + @ratings[3].to_s
		puts '2: ' + @ratings[2].to_s
		puts '1: ' + @ratings[1].to_s
	end
end

def read_in_movies
	file = File.open("movies.txt", "r")
	movies = Hash.new []

	file.each_line do |line|
		info = line.split(',')
		movie = Movie.new(info[1])	# Store the movie name
		movies[info[0]] = movie 	# Use movie id as key in hash
	end

	file.close
	movies
end

def read_in_reviews(movies)
	file = File.open("reviews1.txt", "r")
	users = Hash.new []

	file.each_line do |line|
		info = line.split(',')
		id = info[0]
		userid = info[1]
		rating = info[2]

		# Update the movie profile
		if movies[id] != nil
			movies[id].total_review_count += 1
			movies[id].sum_of_reviews += rating.to_i
			movies[id].ratings[rating.to_i] += 1
		end

		# Update the user user data
		if users.has_key?(userid) == false
			users[userid] = 1
		else
			users[userid] += 1
		end
	end

	file.close
	users
end

def display_top_average_ratings(movies)
	average_scores = Hash.new []

	movies.each do |movieid, movie|
		movie.calculate_average_rating
		average_scores[movieid] = movie.average_rating 	# Store all averages into hash
	end

	average_scores = average_scores.sort_by {|key, value| value}.reverse!

	count = 1
	puts "Top 10 rated movies:\nMovie ID:\t#Reviews:\tAve. Rating:\tName:"
	average_scores.each do |movieid, rating|
		puts movieid + "\t\t" +
			 movies[movieid].total_review_count.to_s + "\t\t" +
			 rating.round(4).to_s + "\t\t" +
			 movies[movieid].name

		break if count == 10
		count += 1
	end
	puts
end

def display_top_users(users)
	users = users.sort_by {|key, value| value}.reverse!

	count = 1
	puts "Top 10 users:\nUser ID:\tNumber of Reviews:"
	users.each do |id, number_of_reviews|
		puts id + "\t\t" + number_of_reviews.to_s
		break if count == 10
		count += 1
	end
	puts
end

movies = read_in_movies
users = read_in_reviews(movies)
display_top_average_ratings(movies)
display_top_users(users)

input = ""
loop do
	print "Enter movie id -> "
	input = gets.chomp
	break if input == "q"

	if movies.has_key?(input) == false
		puts "Movie id #{input} not found"; puts
		next
	end

	puts "Movie Name: \t\t" + movies[input].name
	puts "Average Rating: \t" + movies[input].average_rating.round(4).to_s
	puts "Number of Reviews: \t" + movies[input].total_review_count.to_s
	puts
	movies[input].print_ratings_breakdown
	puts
end

puts "\nEnding program..."
puts

