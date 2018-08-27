module Admin
  class MembersController < BaseController
    load_and_authorize_resource
    skip_before_action :verify_authenticity_token, only: :profile
    def index
      @search_field = params[:search_field]
      @search_term = params[:search_term]
      @members = Member.search(field: @search_field, term: @search_term).page params[:page]
    end

    def show
      @account_versions = AccountVersion.where(account_id: @member.account_ids).order(:id).reverse_order.page params[:page]
      @members = Member.all
    end

    def toggle
      if params[:api]
        @member.api_disabled = !@member.api_disabled?
      else
        @member.disabled = !@member.disabled?
      end
      @member.save
    end

    def active
      @member.update_attribute(:activated, true)
      @member.save
      redirect_to admin_member_path(@member)
    end

    def profile
      @member = Member.find_by_email(params[:email])
      @member.id_document.update_attributes(:name =>params[:name], :address => params[:address], :country => params[:country], :aasm_state => params[:state], :city => params[:city], :zipcode=>params[:pincode])
      @member.update_attribute(:email=> params[:email, :phone_number => params[:phone], :reference_id => params[:uplink], :state => params[:status])
      redirect_to '/admin/members/'+@member[:id].to_s
    end

  end
end
