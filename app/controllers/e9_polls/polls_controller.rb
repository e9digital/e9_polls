class E9Polls::PollsController < AdminController
  inherit_resources

  include E9Rails::Helpers::Translation
  include E9Rails::Helpers::Title
  include E9Rails::Helpers::ResourceErrorMessages
  include E9Rails::Helpers::Pagination
  include E9Rails::Controllers::Orderable
  include E9::DestroyRestricted::Controller

  respond_to :json, :only => [:answer, :show]

  defaults :route_prefix => :admin, :resource_class => Poll
  before_filter :except => [:show, :answer, :results] {|c| @route_scope = :admin }
  skip_before_filter :authenticate_user!, :filter_access_filter, :only => [:show, :answer, :results]

  add_resource_breadcrumbs

  def create
    create! { collection_path }
  end

  def update
    update! do |format|
      format.html { redirect_to collection_path }
      format.js { resource.reload; render }
    end
  end

  def answer
    object = resource
    
    if vote = params[resource_instance_name] && params[resource_instance_name][:vote]
      if cookie[object.id].present?
        # already voted error
        object.errors.add(:vote, :already_voted)
      else
        # new vote OK!
        object.vote = cookie[object.id] = vote
        store_cookie
      end
    else
      object.errors.add(:vote, :no_argument)
    end

    respond_with(object) do |format|
      format.html { redirect_to poll_url(object) }

      format.json do
        if object.errors[:vote].present?
          flash[:alert] = object.errors[:vote]
          head 400
        else
          flash[:notice] = I18n.t(:success_message, :scope => :e9_polls)
          render(:json => { :poll => object, :html => render_html_for_action('results') })
        end
      end
    end
  end

  def results
    show! do |format|
      format.json do
        render(:json => { :poll => resource, :html => render_html_for_action })
      end
    end
  end

  def show
    show! do |format|
      format.json do
        render(:json => { :poll => resource, :html => render_html_for_action })
      end
    end
  end

  def destroy
    destroy! do |format|
      format.js
    end
  end

  protected

  def render_html_for_action(action = nil)
    action ||= params[:action]

    html = nil

    lookup_context.update_details(:formats => [Mime::HTML.to_sym]) do
      html = render_to_string(action, :layout => false)
    end

    html
  end

  def cookie
    @_e9_polls_cookie ||= Marshal.load(cookies[E9Polls.cookie_name]) rescue {}
  end

  def store_cookie
    cookies.permanent[E9Polls.cookie_name] = {
      :value => Marshal.dump(cookie),
      :expires => 1.year.from_now
    }
  end

  def parent; end
  helper_method :parent

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(pagination_parameters))
  end

  def default_ordered_on
    'name'
  end

  def default_ordered_dir
    'ASC'
  end

  def determine_layout
    if request.xhr?
      false
    elsif %w(show results answer).member? params[:action]
      E9Polls.fallback_html_layout
    else
      super
    end
  end
end
