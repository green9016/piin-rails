# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

module V1
  module AdminControllers
    class DashboardController < ::AdminController # :nodoc:
      def stats
        stats_data = stats_count
                     .merge(stats_revenue)
                     .merge(stats_transaction)

        stats_json = { type: 'dashboard', id: '', attributes: stats_data }
        render json: stats_json
      end

      private

      def stats_count
        pins = Pin.all
        posts = Post.all

        @service = StatsDataService.new

        {
          users_count: User.count, businesses_count: Firm.count,
          pins_count: pins.count, active_pins_count: pins.active.count,
          active_posts_count: posts.active.count,
          posts_count: posts.count,
          diff_users_count: @service.diff_results_count(User),
          diff_businesses_count: @service.diff_results_count(Firm),
          diff_active_pins_count: @service.diff_active_results_count(Pin),
          diff_pins_count: @service.diff_results_count(Pin),
          diff_offers_count: @service.diff_results_count(Offer),
          diff_active_posts_count: @service.diff_active_results_count(Post),
          diff_posts_count: @service.diff_results_count(Post)
        }
      end

      def stats_revenue
        # TODO: calculate value for revenue current year
        revenue_current_year = @service.total_revenue_current_year
        # TODO: cal value for revenue last year
        revenue_last_year = @service.total_revenue_last_year
        # TODO: calculate value for revenue yearly to date
        revenue_yearly_to_date = @service.total_revenue_yearly
        # TODO: calculate value for revenue current month
        revenue_current_month = @service.total_revenue_current_month
        # TODO: cal value for today revenue
        revenue_today = @service.total_revenue_current_day

        {
          revenue_current_year: revenue_current_year,
          revenue_last_year: revenue_last_year,
          revenue_yearly_to_date: revenue_yearly_to_date,
          revenue_current_month: revenue_current_month,
          revenue_today: revenue_today,
          revenue_detail: revenue_detail
        }
      end

      def stats_transaction
        # TODO: calculate actual value for avg_transaction
        avg_transaction = 0
        # TODO: diff between transaction current month - transaction per month
        diff_avg_transaction = 0

        {
          avg_transaction: avg_transaction,
          diff_avg_transaction: diff_avg_transaction
        }
      end

      def revenue_detail
        {
          month_1: @service.revenue_details_month(1),
          month_2: @service.revenue_details_month(2),
          month_3: @service.revenue_details_month(3),
          month_4: @service.revenue_details_month(4),
          month_6: @service.revenue_details_month(5),
          month_5: @service.revenue_details_month(6),
          month_7: @service.revenue_details_month(7),
          month_8: @service.revenue_details_month(8),
          month_9: @service.revenue_details_month(9),
          month_10: @service.revenue_details_month(10),
          month_11: @service.revenue_details_month(11),
          month_12: @service.revenue_details_month(12)
        }
      end
    end
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
