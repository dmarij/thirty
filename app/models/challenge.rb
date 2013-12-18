class Challenge < ActiveRecord::Base
	validates :title, presence: true
	validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0}

	def days_from_start
		(Time.now - self.created_at).to_i / 1.day
	end
	
	def percent_complete
		(self.days_from_start.to_f / self.duration) * 100
	end
	
	def in_progress?
		(((Time.now - self.created_at).to_i / 1.day) < self.duration) and (self.final_state == 'active')
	end
	
	def expired?
		(((Time.now - self.created_at).to_i / 1.day) >= self.duration) and (self.final_state == 'active')
	end
	
	def state
		return 'In progress' if in_progress?
		return 'Expired' if expired?
		return 'Done' if self.final_state == 'done'
		return 'Failed' if self.final_state == 'failed'
	end

	def self.active_count
		Challenge.where(final_state: 'active').count
	end

	def self.done_count
		Challenge.where(final_state: 'done').count
	end

	def self.failed_count
		Challenge.where(final_state: 'failed').count
	end

end
