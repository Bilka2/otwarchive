class Admin::ActionUsersController < Admin::BaseController
  # TODO Bilka
  def mass_setup
    authorize AdminActionUsers
  end

  def mass_action
    authorize AdminActionUsers

    @urls = params[:urls].split

    # TODO Bilka get users from works, those can be sorted by whatever pac doesn't know yet

    users = User.where(login: params[:users].split.map(&:strip)).order(:id) # TODO Bilka then add these users at the end, this sorting by id is fine # TODO Bilka ordering???
    @user_managers = users.map { |user| UserManager.new(current_admin, user, {}) }
  end

  def mass_create
    authorize AdminActionUsers

    @urls = [] # TODO Bilka

    @user_managers = []  # TODO Bilka ordering???


    if params[:take_action_button] # TODO Bilka this shouldn't use a param but instead different actions
      params[:user].each do |id, action|
        user = User.find_by(id: id) # TODO Bilka what if no user?
        @user_managers.push(UserManager.new(current_admin, user, action))
      end
      errors = @user_managers.map do |user_manager|
        user_manager.error_message unless user_manager.valid?
      end.compact

      if errors.empty?
        @user_managers.each(&:save) # TODO Bilka should check return value here, should skip validation
        flash[:notice] = t(".success")
        redirect_to mass_setup_admin_action_users_path
      else
        # TODO Bilka this is a hack
        output = @user_managers.map do |user_manager|
          helpers.tag.p(helpers.link_to("#{user_manager.user.login} (#{user_manager.user.id})", anchor: user_manager.user.id) + ": " + user_manager.error_message) if user_manager.error_message
        end.compact
        flash.now[:error] = output.join("") # TODO Bilka is it correct that we abort saving all if any errors?, i18n? Showing which message means which user?
        render :mass_action
      end
    end

  end

  # TODO Bilka email preview
end
