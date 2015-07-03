ActiveAdmin.register_page "Report: Past Week" do
    content do
        page = (params[:page] || 1).to_i
        prev_page = page + 1
        next_page = page - 1

        last_day = Date.today - page.week
        first_day = last_day - 1.week

        subs = Subscription.where('start_date < ? AND end_date > ?', first_day, first_day)

        days = (first_day..last_day).map {|date| date.day}
        rev_apple = 0
        rev_stripe = 0
        subs.each do |sub|
            if days.include? sub.start_date.day
                if sub.premium_plan.title == 'Apple'
                    rev_apple += sub.premium_plan.price_per_month
                else
                    rev_stripe += sub.premium_plan.price_per_month
                end
            end
        end
        rev_total = rev_apple + rev_stripe

        para "#{first_day.month}/#{first_day.day}/#{first_day.year} -
            #{last_day.month}/#{last_day.day}/#{last_day.year}"

        para "Apple: #{rev_apple.round(2)}"
        para "Stripe: #{rev_stripe.round(2)}"
        para "Total revenue: #{rev_total.round(2)}"
        para ""

        a 'Previous', href: "/admin/report_past_week?page=#{prev_page}"
        if page > 1
            a 'Next', href: "/admin/report_past_week?page=#{next_page}"
        end
    end
end
