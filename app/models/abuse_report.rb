class AbuseReport < ApplicationRecord
  belongs_to :abuseable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: {scope: [:abuseable_id, :abuseable_type]}
  validates :details, presence: true

  after_save :check_should_abusable_be_unpublished

  private def check_should_abusable_be_unpublished
    if abuseable.abuse_reports.size > ENV["abuse_reports_unpublish_no"].to_i
      abuseable.mark_unpublished!
    end
  end
end
