require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  it "connects with a signed session cookie" do
    cookies.signed[:session_id] = sessions(:admin).id

    connect
    expect(connection.current_user).to eq(users(:admin))
  end

  it "rejects connections without a session" do
    expect { connect }.to have_rejected_connection
  end
end
