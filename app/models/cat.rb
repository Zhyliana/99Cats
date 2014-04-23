
COLORS =  %w(orange grey black white brown purple blue)
class Cat < ActiveRecord::Base
  validates :age, numericality: true, presence: true
  validates :birth_date, presence: true
  validates :color, presence: true, inclusion: { in: %w(orange grey black white brown purple blue) }
  validates :name, presence: true
  validates :sex, presence: true, inclusion: { in: %w(M F) }
end
