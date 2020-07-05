#:nodoc:
class Admin::HomeController < ApplicationController
  def index
    @members = Education.where('status = 0').distinct.count(:member_id) + Tag.joins(:member, member: :educations).where('status != 0').distinct.count(:member_id)
    @studies = Education.where('status = 0').joins(:study).group('studies.code').count

    @activities = Activity.where("start_date >= ?", Date.to_date(Date.today.study_year)).count

    @transactions = CheckoutTransaction.count(:all)

    @recent = CheckoutTransaction.where("created_at >= ?", Time.zone.now.beginning_of_day).order(created_at: :desc).take(12)
    @recentparticipants = ParticipantTransaction.where("created_at >= ?", Time.zone.now.beginning_of_day).order(created_at: :desc).take(12)

    @unpayed = Participant.where(:reservist => false, :paid => false).joins(:activity).where('activities.start_date < NOW()').sum(:price) + Participant.where(:reservist => false, :paid => false, :price => nil).joins(:activity).where('activities.start_date < NOW() AND activities.price IS NOT NULL').sum('activities.price')

    @defaulters = Participant.where(:reservist => false, :paid => false).joins(:activity, :member).where('activities.start_date < NOW()').group(:member_id).sum(:price).merge( \
      Participant.where(:reservist => false, :paid => false, :price => nil).joins(:activity, :member).where('activities.start_date < NOW()').group(:member_id).sum('activities.price ')
    ) { |_, sum_a, sum_b| sum_a + sum_b }.sort_by { |_, sum| -sum }.map { |k, v| [Member.where(:id => k).select(:id, :first_name, :infix, :last_name).first, v] }.take(12).delete_if { |_, v| v == 0 }
  end
end
