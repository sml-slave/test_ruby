class PremiumPlan < ActiveRecord::Base
    has_many :subscription
end
