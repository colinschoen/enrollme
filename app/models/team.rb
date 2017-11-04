class Team < ActiveRecord::Base
    has_many :users
    has_one :submission
    validates :passcode, uniqueness: true

    def self.generate_hash(length=36)
        return SecureRandom.urlsafe_base64(length, false)
    end

    def team_skills
      result = ''
      self.users.each do |user|
        user.talents.each do |talent|
          skill_name = Skill.find(talent.skill_id).name
          result += skill_name + ', '
        end
      end
      if result != ''
        return result[0..(result.length - 3)]
      end
    end

    def self.approved_teams
        return Team.where(:approved => true)
    end

    def withdraw_submission
        self.submitted = false
        self.save!
    end

    def disapprove
        self.approved = false
        self.submitted = false
        self.save!
    end

    def withdraw_approval
        self.approved = false
        self.save!
    end

    def approve_with_discussion(id)
        self.approved = true
        self.discussion_id = id
        self.save!
    end

    def send_submission_reminder_email
        self.users.each do |user|
            #EmailStudents.submit_email(user).deliver_later
        end
    end

    def eligible?
        users.count.between?(Option.minimum_team_size, Option.maximum_team_size)
    end

    def self.filter_by(status)
        if status.nil? or status == "Pending | Approved"
            return Team.where(approved: true) + Team.where(approved: false, submitted: true)
        elsif status == "Approved"
            return Team.where(approved: true)
        elsif status == "Pending"
            return Team.where(approved: false, submitted: true)
        elsif status == "Forming"
            return Team.where(approved: false, submitted: false)
        end
        return Team.all.each
    end

    def add_submission(id)
        self.update(submitted: true)
        self.submission_id = id
        self.save!
    end

    def can_join?
      ! passcode.nil?  &&
        ! approved     &&
        users.size < Option.maximum_team_size
    end
end
