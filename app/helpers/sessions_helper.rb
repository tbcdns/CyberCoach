module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remembered_user] = user.username
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= cookies[:remembered_user]
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remembered_user)
  end
end
