# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  CatRentalRequest.new(:cat_id => 1, :start_date => '2014-04-27', :end_date => '2014-05-08', :status => 'APPROVED').save
  CatRentalRequest.new(:cat_id => 1, :start_date => '2014-09-05', :end_date => '2014-09-15').save

  #overlaps w req1 by the start_date
  CatRentalRequest.new(:cat_id => 1, :start_date => '2014-04-22', :end_date => '2014-04-30').save

  #overlaps w req1 by end date
  CatRentalRequest.new(:cat_id => 1, :start_date => '2014-04-30', :end_date => '2014-05-07').save
end