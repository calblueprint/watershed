# == Schema Information
#
# Table name: photos
#
#  id                :integer          not null, primary key
#  parent_id         :integer
#  parent_type       :string(255)
#  image             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  original_filename :string(255)
#  image_tmp         :string(255)
#  hidden            :boolean          default(FALSE)
#

require 'spec_helper'

describe Photo do
  pending "add some examples to (or delete) #{__FILE__}"
end
