ActiveAdmin.register_page "Report: Calendar Month" do
    content do

        page = (params[:page] || 1).to_i
        prev_page = page.to_i + 1
        next_page = page.to_i - 1

        first_day = (Date.today - page.month).beginning_of_month
        last_day = first_day + 1.month - 1.day

        rev_apple = Subscription.joins(:premium_plan).\
            where('premium_plans.title' => 'Apple').\
            where('start_date < ? AND end_date > ?', first_day, first_day).\
            sum('price_per_month')

        rev_stripe = Subscription.joins(:premium_plan).\
            where('premium_plans.title' => 'Stripe').\
            where('start_date < ? AND end_date > ?', first_day, first_day).\
            sum('price_per_month')

        rev_total = rev_apple + rev_stripe

        para "#{first_day.strftime("%B")} #{first_day.year}"
        para "Apple: #{rev_apple.round(2)}"
        para "Stripe: #{rev_stripe.round(2)}"
        para "Total revenue: #{rev_total.round(2)}"

        a 'Previous', href: "/admin/report_calendar_month?page=#{prev_page}"
        if page > 1
            a 'Next', href: "/admin/report_calendar_month?page=#{next_page}"
        end

    end    
end
