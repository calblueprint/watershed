class SessionSerializer < BaseSessionSerializer
  has_one :user, serializer: UserListSerializer

  def user
    object
  end

end
