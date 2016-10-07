# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 
count = 0
Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    Movie.create!(:title => movie["title"], :rating => movie["rating"], :release_date => movie["release_date"])
  end
  count = movies_table.hashes.size
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
	Movie.all_ratings.to_a.each do |everyRating|
		uncheck "ratings[#{everyRating}]"
	end
	arg1.split(", ").each do |myRatings|
		check "ratings[#{myRatings}]"
	end
	click_button('Refresh')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
	arg1.split(", ").each do |yesRatings|
		if page.has_no_css?('td', :text => /\A#{yesRatings}\z/)			
			assert false, "Assert failed: #{yesRatings} is a rating you should see."
		end
 	end 
	arg2 = Movie.all_ratings.to_a - arg1.split(", ")
	arg2.each do |noRatings|
		if page.has_css?('td', :text => /\A#{noRatings}\z/)			
			assert false, "Assert failed: #{noRatings} is not a rating you should see."
		end
 	end 
end

Then /^I should see all of the movies$/ do
	rows = all('#movies tr > td:nth-child(2)').size
	rows.should == count
end

When /^I select to display movies in alphabetical order$/ do
	visit('/movies')
	click_on "Movie Title"
end


Then /^I should see movies in alphabetical order by title$/ do
	webpage = page.body
	result = true
	laststring = " "
	all('#movies tr > td:nth-child(1)').each do |title|
		if title.text < laststring
			result = false
		end
		laststring = title.text
end

	expect(result).to be_truthy
end

When /^I select to display movies by release date$/ do
	visit('/movies')
	click_on "Release Date"
end



Then /^I should see the movies in order of release date$/ do
	result = true
	laststring = " "
	all('#movies tr > td:nth-child(3)').each do |released|
		if released.text < laststring
			result = false
		end
		laststring = released.text
		
	end
end

