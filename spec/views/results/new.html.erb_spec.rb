require 'rails_helper'

RSpec.describe "results/new", type: :view do
  before(:each) do
    assign(:result, Result.new())
  end

  it "renders new result form" do
    render

    assert_select "form[action=?][method=?]", results_path, "post" do
    end
  end
end
