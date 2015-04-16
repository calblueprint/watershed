class SendNotificationJob
  include SuckerPunch::Job

  def perform(users, type, object)
    android_devices = users.where(device_type: User.device_types["android"])
    ios_devices = users.where(device_type: User.device_types["ios"])
    message = get_message(type, object)
    ActiveRecord::Base.connection_pool.with_connection do
      send_android_notification(android_devices, message)
      send_ios_notificataion(ios_devices, message)
    end
    Rpush.push
  end

  def get_message(type, object)
    case type
    when Task::NEW_TASK
      message = "You've been assigned a task!"
    when Task::NEW_UNASSIGNED_TASK
      message = "There's a new task assigned to #{object.site.name}"
    else
      message = "There's been something new - check it out!"
    end
    return {
             message: message,
             type: type,
             object: object
           }
  end

  def send_android_notification(users, message)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name("watershed_android")
    n.registration_ids = get_registration_ids(users)
    n.data = message
    n.save!
  end

  def send_ios_notificataion(users, message)
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name("watershed_ios")
    n.device_token = get_registration_ids(users)
    n.alert = "Watershed Notification"
    n.data = message
    n.save!
  end

  def get_registration_ids(users)
    users.map(&:registration_id).delete_if(&:blank?)
  end
end
