class User < ActiveRecord::Base
  belongs_to :team
  has_many :talents
  has_many :skills, through: :talents

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 50 }, \
    format: VALID_EMAIL_REGEX, exclusion: { in: lambda { |u| u.all_admin_emails } }
  validates :major, presence: true
  validates :sid, presence: true, uniqueness: true, length: { maximum: 10 }
  before_save :downcase_email

  def get_skills
    # skills.inject("") {|str, skill| str += skill.name}
    if talents.nil? || talents.length == 0
      return ""
    end
    skills = ""
    talents.each do |talent|
      skill = Skill.find(talent.skill_id)
      skills += skill.name + ", "
    end
    skills
  end

  def skill?(skill)
    if talents.length.zero?
      return false
    end
    bool = false
    talents.each do |talent|
      bool = true if talent.skill_id == skill.id
    end
    bool
  end

  def downcase_email
    self.email.downcase!
  end

  def leave_team
    @team = self.team
    @team.users.delete(self)
    self.team = nil
    @team.withdraw_submission

    if User.where(:team_id => @team.id).length <= 0
      @team.destroy!
    end
  end

  def self.user_from_oauth(auth)
    return User.find_by(:email => auth[:info][:email].downcase)
    # query = "%#{" << auth[:info][:email] << "}%"
    # return User.where("email LIKE ?", query).first
  end

  def all_admin_emails
    return Admin.pluck(:email)
  end
end
