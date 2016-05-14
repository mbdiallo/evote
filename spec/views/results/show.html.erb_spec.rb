require 'rails_helper'

RSpec.describe "results/show", type: :view do
  before(:each) do
    @result = assign(:result, Result.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
