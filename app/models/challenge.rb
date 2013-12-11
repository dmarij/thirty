class Challenge < ActiveRecord::Base
	before_create :set_state
	def days_from_start
		(Time.now - self.created_at).to_i / 1.day
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

	private
		def set_state
			self.final_state = 'active'
		end
end
