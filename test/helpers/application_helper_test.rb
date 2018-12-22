require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "勤怠管理システム"
    assert_equal full_title("すべてのユーザー"), "すべてのユーザー | 勤怠管理システム"
    end
end