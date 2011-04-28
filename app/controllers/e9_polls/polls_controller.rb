class E9Polls::PollsController < AdminController
  include E9Rails::Helpers::Translation
  include E9Rails::Helpers::Title
  include E9Rails::Helpers::ResourceErrorMessages
  include E9Rails::Helpers::Pagination
  include E9Rails::Controllers::Orderable

  inherit_resources
  defaults :route_prefix => nil, :resource_class => Poll

  skip_before_filter :authenticate_user!, :filter_access_filter, :only => :show

  add_resource_breadcrumbs

  def create
    create! { collection_path }
  end

  def update
    update! { collection_path }
  end

  def show
    show! do |format|
      format.html do 
        render(:layout => request.xhr? ? false : E9Polls.fallback_html_layout)
      end
    end
  end

  protected

  def parent; end
  helper_method :parent

  def add_index_breadcrumb
    # NOTE need to override this because AdminController paths admin_ prefix
    add_breadcrumb! e9_t(:index_title), polymorphic_path([parent, resource_class].compact)
  end

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(pagination_parameters))
  end

  def default_ordered_on
    'name'
  end

  def default_ordered_dir
    'ASC'
  end
end
