class Subscription < ActiveRecord::Base
    belongs_to :user
    belongs_to :premium_plan
end
