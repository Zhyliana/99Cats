class CatRentalRequest < ActiveRecord::Base
  belongs_to(
    :cat,
    class_name: 'Cat',
    primary_key: :id,
    foreign_key: :cat_id
  )

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :cat_id, presence: true
  validates :status, presence: true, inclusion: { in: %w(APPROVED DENIED PENDING) }
  validate :overlapping_approved_requests?

  private
  def overlapping_requests
    params = [self.start_date, self.end_date, self.start_date, self.end_date, self.cat_id]

    query = <<-SQL
        SELECT
          id
        FROM
          cat_rental_requests
        WHERE
          ((start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?))
          AND cat_id = ?
          AND status = "APPROVED"
        SQL

    CatRentalRequest.find_by_sql([query, *params])
  end

  def overlapping_approved_requests?
    unless overlapping_requests.empty?
      errors[:id] << "Overlapping request"
    end
  end
end

