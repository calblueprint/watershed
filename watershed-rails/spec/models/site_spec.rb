# == Schema Information
#
# Table name: sites
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  street      :text
#  city        :string(255)
#  state       :string(255)
#  zip_code    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Site do
  pending "add some examples to (or delete) #{__FILE__}"
end
