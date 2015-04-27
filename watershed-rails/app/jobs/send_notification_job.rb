class SendNotificationJob
  include SuckerPunch::Job

  def perform(users, type, object)
    android_devices, ios_devices = get_devices(users)
    message = get_message(type, object)
    ActiveRecord::Base.connection_pool.with_connection do
      send_android_notification(android_devices, message)
      send_ios_notificataion(ios_devices, message)
    end
    Rpush.push
  end

  def get_message(type, object)
    case type
    when ::Task::NEW_TASK
      message = "You've been assigned a task!"
    when ::Task::NEW_UNASSIGNED_TASK
      message = "There's a new task assigned to #{object.site.name}"
    else
      message = "There's been something new - check it out!"
    end
    return {
             message: message,
             type: type,
             object: object.as_json
           }
  end

  def get_devices(users)
    [users.to_a.select { |u| u.device_type == "android" },
     users.to_a.select { |u| u.device_type == "ios" }]
  end

  def send_android_notification(users, message)
    registration_ids = get_registration_ids(users)
    return if registration_ids.blank?

    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name("watershed_android")
    n.registration_ids = registration_ids
    n.data = message
    n.save!
  end

  def send_ios_notificataion(users, message)
    registration_ids = get_registration_ids(users)
    return if registration_ids.blank?

    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name("watershed_ios")
    n.device_token = registration_ids
    n.alert = "Watershed Notification"
    n.data = message
    n.save!
  end

  def get_registration_ids(users)
    users.map(&:registration_id).delete_if(&:blank?)
  end
end
