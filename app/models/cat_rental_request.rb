class CatRentalRequest < ActiveRecord::Base
  STATUSES = %w(APPROVED DENIED PENDING)
  
  belongs_to(
    :cat,
    class_name: 'Cat',
    primary_key: :id,
    foreign_key: :cat_id
  )

  validates(
    :start_date,
    :end_date,
    :cat_id,
    :status,
    presence: true
  ) 
  
  validates :status, presence: true, inclusion: STATUSES 
  validate :overlapping_approved_requests?
  
  def approve!
    unless self.status == 'PENDING'
      errors[:status] << "This request is not pending"
    end
     transaction do
       self.update(:status => 'APPROVED')
       overlapping_pending_requests.each { |request| request.deny! }
     end
  end
  
  def deny!
     transaction do
       status = 'DENIED'
     end
  end

  private
  
  def overlapping_requests
    req_start = self.start_date
    req_end = self.end_date
    req_cat = cat_id
    
    params = [req_start, req_end, req_start, req_end, req_start, req_end, req_cat]
    
    query = <<-SQL
        SELECT
          *
        FROM
          cat_rental_requests
        WHERE
          (
            (start_date BETWEEN ? AND ?)
            OR (end_date BETWEEN ? AND ?)
          )
          OR 
          (
            (? BETWEEN start_date AND end_date)
            OR (? BETWEEN start_date AND end_date)
          )
          AND cat_id = ?
        SQL

    CatRentalRequest.find_by_sql([query, *params])
  end

  def overlapping_approved_requests?    
    unless overlapping_requests.where("status = 'APPROVED'").empty?
      errors[:id] << "Overlaps with approved request"
    end
  end
  
  def overlapping_pending_requests?    
    unless overlapping_requests.where("status = 'PENDING'").empty?
      errors[:id] << "Overlapping pending request"
    end
  end
end

