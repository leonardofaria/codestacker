class CodesController < ApplicationController
  before_action :set_code, only: [:show, :embed, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :new, :create]

  # GET /codes
  # GET /codes.json
  def index
    user = params[:user] ||= nil
    tag = params[:tag] ||= nil

    @codes = Code.get_codes(current_user, user, tag).paginate(page: params[:page])
  end

  # GET /codes/1
  # GET /codes/1.json
  def show
  end

  def embed
    respond_to do |format|
      format.js
    end
  end

  # GET /codes/new
  def new
    @code = Code.new
  end

  # GET /codes/1/edit
  def edit
    admin_or_owner_required(@code.user_id)
  end

  # POST /codes
  # POST /codes.json
  def create
    @code = Code.new(code_params)
    @code.user_id = user_signed_in? ? current_user.id : 1

    respond_to do |format|
      if @code.save
        format.html { redirect_to @code, notice: 'Code was successfully created.' }
        format.json { render :show, status: :created, location: @code }
      else
        format.html { render :new }
        format.json { render json: @code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /codes/1
  # PATCH/PUT /codes/1.json
  def update
    admin_or_owner_required(@code.user_id)

    respond_to do |format|
      if @code.update(code_params)
        format.html { redirect_to @code, notice: 'Code was successfully updated.' }
        format.json { render :show, status: :ok, location: @code }
      else
        format.html { render :edit }
        format.json { render json: @code.errors, status: :unprocessable_entity }
      end
    end
  end

  def comment
    @code = Code.find(params[:code_id])

    begin
      @code.comments.create!(code_params[:comments_attributes])
      redirect_to @code, notice: 'Comment was successfully created.'
    rescue ActiveRecord::RecordInvalid => e
      redirect_to @code, alert: 'Check your comment'
    end
  end

  # DELETE /codes/1
  # DELETE /codes/1.json
  def destroy
    admin_or_owner_required(@code.user_id)

    @code.destroy
    respond_to do |format|
      format.html { redirect_to codes_url, notice: 'Code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_code
      @code = Code.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def code_params
      params.require(:code).permit(:title, :code, :language_id, :description, :tag_list, :privated, comments_attributes: [:name, :email, :body])
    end
end
