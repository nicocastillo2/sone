class AdminsController < ApplicationController

	def admin
		@users = User.all
	end

end

