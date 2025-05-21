class Admin::ActionUsersController < Admin::BaseController
  # TODO Bilka
  def mass_setup
    authorize AdminActionUsers
  end

  def mass_action
    authorize AdminActionUsers

    @urls = params[:urls].split

    # TODO Bilka get users from works, those can be sorted by whatever pac doesn't know yet

    @users = User.where(login: params[:users].split.map(&:strip)) # TODO Bilka then add these users at the end, this sorting by id is fine
  end

  def mass_create
    authorize AdminActionUsers

  end

  # TODO Bilka email preview
end