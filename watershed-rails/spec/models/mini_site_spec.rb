# == Schema Information
#
# Table name: mini_sites
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  street      :text
#  city        :string(255)
#  state       :string(255)
#  zipcode     :integer
#  latitude    :decimal(, )
#  longitude   :decimal(, )
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe MiniSite do
  pending "add some examples to (or delete) #{__FILE__}"
end
