require "spec_helper"

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    kevin = Fabricate(:user)
    sign_in(kevin)

    invite_a_friend
    friend_accepts_invitation
    friend_should_follow(kevin)
    inviter_should_follow_friend(kevin)
    
    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Ellie Lai"
    fill_in "Friend's Email Address", with: "ellie@example.com"
    fill_in "Message", with: "Hello please join this site."
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "ellie@example.com"
    current_email.click_link "Accept this invitation"

    fill_in "Password", with: "ellie@example.com"
    fill_in "Full Name", with: "Ellie Lai"
    click_button "Sign Up"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "Ellie Lai"
  end
end