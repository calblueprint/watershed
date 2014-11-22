# == Schema Information
#
# Table name: field_reports
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  mini_site_id  :integer
#  description   :text
#  health_rating :integer
#  urgent        :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  task_id       :integer
#

require 'spec_helper'

describe FieldReport do
  pending "add some examples to (or delete) #{__FILE__}"
end
