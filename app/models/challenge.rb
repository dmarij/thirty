class Challenge < ActiveRecord::Base
	before_create :set_state
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

	private
		def set_state
			self.final_state = 'active'
		end
end
