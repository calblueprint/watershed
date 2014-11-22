# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  site_id     :integer
#  assigner_id :integer
#  assignee_id :integer
#  complete    :boolean
#  due_date    :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  urgent      :boolean          default(FALSE)
#

require 'spec_helper'

describe Task do
  pending "add some examples to (or delete) #{__FILE__}"
end
