class InvitationsController < ApplicationController
  before_action :require_user
  def new
    @invitation = Invitation.new
  end

  def create
    invitation = Invitation.create(invite_params.merge!(inviter_id: current_user.id))
    AppMailer.send_invitation_email(invitation).deliver
    redirect_to new_invitation_path
  end

  private

  def invite_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end