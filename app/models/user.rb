class User < ApplicationRecord
  enum role: {admin: 0, teacher: 1, student: 2}
  ransacker :role, formatter: proc {|v| roles[v]} do |parent|
    parent.table[:role]
  end

  belongs_to :class_user

  attr_accessor :reset_token

  before_save :downcase_Tk, :check_email_unique

  validates :name, presence: true, length: { maximum: 40 }
  validates :Tk, presence: true, length: {minium: 10, maximum: 100}, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password

  scope :asc_name, ->{order name: :asc}
  scope :student_with, ->id {where("class_user_id = ?", id)}

  delegate :name, to: :class_user, prefix: :class_user, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token)
    update reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  def password_reset_expired?
    reset_sent_at < 1.hours.ago
  end

  def check_email_unique
    return if email.blank?
    user = User.find_by email: email
    return false if user.present?
  end

  def downcase_Tk
    self.Tk.downcase!
  end
end
