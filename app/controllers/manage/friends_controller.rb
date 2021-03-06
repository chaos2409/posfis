class Manage::FriendsController <  ManageController
  before_action :set_manage_friend, only: [:show, :edit, :update, :destroy]

  # GET /manage/friends
  # GET /manage/friends.json
  def index
    friends = Manage::Friend.select("to_user_id").where(:from_user_id => current_user.id)
    @friends_blogs = Manage::Blog.where(:user_id => friends)
    @users = User.where.not( id: [current_user.id], user_type: [3, 4], :id => friends)
    @manage_friends = Manage::Friend.where(:to_user_id => friends)
  end

  # GET /manage/friends/1
  # GET /manage/friends/1.json
  def show
  end

  # GET /manage/friends/new
  def new
    @manage_friend = Manage::Friend.new
  end

  # GET /manage/friends/1/edit
  def edit
  end

  # POST /manage/friends
  # POST /manage/friends.json
  def create
    @manage_friend = Manage::Friend.new(manage_friend_params)

    respond_to do |format|
      if @manage_friend.save
        format.html { redirect_to @manage_friend, notice: 'Friend was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_friend }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/friends/1
  # PATCH/PUT /manage/friends/1.json
  def update
    respond_to do |format|
      if @manage_friend.update(manage_friend_params)
        format.html { redirect_to @manage_friend, notice: 'Friend was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/friends/1
  # DELETE /manage/friends/1.json
  def destroy
    @manage_friend.destroy
    respond_to do |format|
      format.html { redirect_to manage_friends_url }
      format.json { head :no_content }
    end
  end


  # 友達追加
  def add_friend
    to_friend_user_id = params[:id]
    @friend = Manage::Friend.new
    @friend.from_user_id = current_user.id
    @friend.to_user_id = to_friend_user_id
    @friend.save
    @friend.create_activity(:add_friend,
      :owner => proc {|controller, model| controller.current_user},
      :params => {
        :to_user => @friend.to_user_id
      }
    )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_friend
      @manage_friend = Manage::Friend.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_friend_params
      params.require(:manage_friend).permit(:from_user_id, :to_user_id)
    end
end
