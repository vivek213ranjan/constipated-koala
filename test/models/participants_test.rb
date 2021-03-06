require "test_helper"

class ParticipantsTest < ActionDispatch::IntegrationTest
  def assert_counts(activity, expected_counts)
    # Assert that an activity's participant counts match the given values.
    activity.reload

    assert expected_counts[0] == expected_counts[1] + expected_counts[2],
           "unbalanced number of attendees and reservists."

    [[0, 'participants'], [1, 'attendees'], [2, 'reservists']].each do |pos, type|
      assert_equal expected_counts[pos], activity.participant_counts[pos], "#{ type } count doesn't match"
    end
  end

  test "enrolling reservist through deleting previous participant" do
    a = activities(:test_activities_1)
    assert_counts(a, [1, 1, 0])

    p1 = participants(:underpant_first)

    Participant.create!(
      member: members(:dannypanny),
      activity: a,
      reservist: true
    )

    assert_counts(a, [2, 1, 1])

    p1.destroy!
    a.enroll_reservists!

    assert_counts(a, [1, 1, 0])
  end

  test "enrolling reservists will not exceed limits" do
    a = activities(:test_activities_3)
    assert_counts(a, [1, 1, 0])
  end

  test "enrolling reservist through increasing participant limit" do
    a = activities(:test_activities_2)
    assert_counts(a, [1, 1, 0])

    m = members(:dannypanny)
    Participant.create!(
      member: m,
      activity: a,
      reservist: true
    )

    a.reload

    assert_counts(a, [2, 1, 1])

    a.participant_limit = 2
    a.save!

    assert_counts(a, [2, 2, 0])
  end

  test "luckypeople selection for master's activities not broken" do
    a = activities(:test_luckypeople_masters)
    a.enroll_reservists!

    assert_counts(a, [3, 1, 2])
    assert_equal a.attendees.first.member, members(:masterboy030man)
  end

  test "luckypeople selection for freshman's activities not broken" do
    a = activities(:test_luckypeople_freshmen)
    a.enroll_reservists!

    assert_counts(a, [3, 1, 2])
    assert_equal a.attendees.first.member, members(:feutemeteut)
  end
end
