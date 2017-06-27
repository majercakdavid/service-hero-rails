require 'test_helper'

class TimeSlotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @time_slot = time_slots(:one)
  end
=begin
  test "should create time_slot" do
    assert_difference('TimeSlot.count') do
      post business_service_time_slot_url, params: {
          time_slot: {
              business_service_id: business_services(:one).id,
              datetime_from: @time_slot.datetime_from,
              datetime_to: @time_slot.datetime_to
          }
      }
    end

    assert_redirected_to time_slot_url(TimeSlot.last)
  end

  test "should show time_slot" do
    get business_service_time_slot(@time_slot)
    assert_response :success
  end

  #test "should get edit" do
  #  get edit_time_slot_url(@time_slot)
  #  assert_response :success
  #end
  test "should update time_slot" do
    put business_service_time_slot_url, params: {
        time_slot: {
            business_service_id: @time_slot.business_service_id,
            datetime_from: @time_slot.datetime_from,
            datetime_to: @time_slot.datetime_to,
            id: @time_slot.id
        }
    }
    assert_redirected_to root_url
  end

  test "should destroy time_slot" do
    assert_difference('TimeSlot.count', -1) do
      delete business_service_time_slot_url, params: {
          time_slot: {
              id: @time_slot.id
          }
      }
    end

    assert_redirected_to time_slots_url
  end
=end
end
