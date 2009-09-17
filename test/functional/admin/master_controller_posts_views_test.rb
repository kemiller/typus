require 'test/helper'

class Admin::PostsControllerTest < ActionController::TestCase

  ##
  # get :index
  ##

  def test_should_render_index_and_verify_presence_of_custom_partials
    get :index
    partials = %w( _index.html.erb _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

  def test_should_render_index_and_verify_page_title
    get :index
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} - Posts"
  end

  def test_should_render_index_and_show_add_entry_link

    get :index

    assert_select "#sidebar ul" do
      assert_select "li", "Add entry"
    end

  end

  def test_should_render_index_and_not_show_add_entry_link

    typus_user = typus_users(:designer)
    @request.session[:typus_user_id] = typus_user.id

    get :index
    assert_response :success

    assert_no_match /Add entry/, @response.body

  end

  def test_should_render_index_and_show_trash_item_image
    get :index
    assert_response :success
    assert_select '.trash', 'Trash'
  end

  def test_should_render_index_and_not_show_trash_image

    typus_user = typus_users(:designer)
    @request.session[:typus_user_id] = typus_user.id

    get :index
    assert_response :success
    assert_select '.trash', false

  end

  def test_should_get_index_and_render_edit_or_show_links

    %w( edit show ).each do |action|

      options = Typus::Configuration.options.merge(:default_action_on_item => action)
      Typus::Configuration.stubs(:options).returns(options)

      get :index

      Post.find(:all).each do |post|
        assert_match "/posts/#{action}/#{post.id}", @response.body
      end

    end

  end

  def test_should_get_index_and_render_edit_or_show_links_on_owned_records

    typus_user = typus_users(:editor)
    @request.session[:typus_user_id] = typus_user.id

    get :index

    Post.find(:all).each do |post|
      action = post.owned_by?(typus_user) ? 'edit' : 'show'
      assert_match "/posts/#{action}/#{post.id}", @response.body
    end

  end

  ##
  # get :new
  ##

  def test_should_render_posts_partials_on_new
    get :new
    partials = %w( _new.html.erb _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

  def test_should_render_new_and_verify_page_title
    get :new
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} - Posts &rsaquo; New"
  end

  ##
  # get :edit
  ##

  def test_should_render_edit_and_verify_presence_of_custom_partials
    get :edit, { :id => posts(:published).id }
    partials = %w( _edit.html.erb _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

  def test_should_render_edit_and_verify_page_title
    get :edit, { :id => posts(:published).id }
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} - Posts &rsaquo; Edit"
  end

  ##
  # get :show
  ##

  def test_should_render_show_and_verify_presence_of_custom_partials
    get :show, { :id => posts(:published).id }
    partials = %w( _show.html.erb _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

  def test_should_render_show_and_verify_page_title
    get :show, { :id => posts(:published).id }
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} - Posts &rsaquo; Show"
  end

=begin

  # FIXME

  def test_should_verify_new_comment_contains_a_link_to_add_a_new_post
    get :new
    match = '/admin/posts/new?back_to=%2Fadmin%2Fcomments%2Fnew&amp;selected=post_id'
    assert_match match, @response.body
  end

  def test_should_verify_edit_comment_contains_a_link_to_add_a_new_post
    comment = comments(:first)
    get :edit, { :id => comment.id }
    match = "/admin/posts/new?back_to=%2Fadmin%2Fcomments%2Fedit%2F#{comment.id}&amp;selected=post_id"
    assert_match match, @response.body
  end

=end

end