class ApplicationController < ActionController::Base
	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

	def current_user
		User.first
	end

	private

	def record_not_found
		render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found
	end
end
