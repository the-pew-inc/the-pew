# == Schema Information
#
# Table name: subcription_transactions
#
#  id               :uuid             not null, primary key
#  transaction_err  :string
#  transaction_txt  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  subscriptions_id :uuid             not null
#  transaction_id   :string
#
# Indexes
#
#  index_subcription_transactions_on_subscriptions_id  (subscriptions_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscriptions_id => subscriptions.id)
#
require "test_helper"

class SubcriptionTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
