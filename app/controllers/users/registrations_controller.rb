class Users::RegistrationsController < Devise::RegistrationsController
  PERIOD = 10.days
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    today = ServerTime.now.strftime "%Y-%m-%d"
    ten_days_ago = (ServerTime.now - 10.days).strftime "%Y-%m-%d"
    @total_hits = current_user.total_hits.to_i
    @total_hits_today = current_user.total_hits_today.to_i
    day_keys = (10.days.ago.to_date..ServerTime.now.to_date)
      .map{|d| d.strftime("%Y-%m-%d")}
    stats_for_ten_days = AnalyticData::UserHits.new(current_user.id)
      .stats_for_period ten_days_ago, today
    logger.debug "hhhhhhhhhhhh========>#{stats_for_ten_days}"
    @hits_with_date = Hash[day_keys.zip(stats_for_ten_days)]
    super
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
