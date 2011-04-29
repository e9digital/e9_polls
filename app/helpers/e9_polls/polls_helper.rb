module E9Polls::PollsHelper

  ##
  # Util
  #

  def html_concat(*chunks)
    ''.html_safe.tap do |html|
      chunks.each {|chunk| html.safe_concat("#{chunk}\n") }
    end
  end

  def e9_polls_resource_link(action, record, opts = {})
    opts.symbolize_keys!

    # NOTE cascading backend for i18n would accomplish the lookup without defaults

    action  = action.to_sym
    klass   = record.is_a?(Class) ? record : record.class
    scope   = "e9_polls.#{klass.model_name.collection}"

    # NOTE this assumes the definition of #parent, which is added by IR but only on controllers
    #      with polymorphic belongs_to relationships (by default).
    scopes  = [*(opts[:scope] || @route_scope), parent].compact
    path    = case action.to_sym
              when :new;  new_polymorphic_path(scopes << klass)
              when :edit; edit_polymorphic_path(scopes << record)
              else        polymorphic_path(scopes << record)
              end
    
    if action == :destroy
      opts[:method] = :delete
      opts.reverse_merge!({
        :confirm => t(:"#{scope}.confirm_destroy", 
                      :default => :"e9_polls.confirm_destroy")
      })
    end

    link_to t(:"#{scope}.#{action}", :default => :"e9_polls.#{action}"), path, opts
  end

  ##
  # Links
  #

  def records_table_links_for_record(record)
    if respond_to?(method_name = "records_table_links_for_#{record.class.name.underscore}")
      send(method_name, record)
    else
      html_concat(
      )
    end
  end

  def link_to_add_nested_attribute(association_name)
    link_to( t(:add_nested_attribute, :scope => :e9_polls), '#', :class => 'add-nested-association', 'data-association' => association_name)
  end

  def link_to_destroy_nested_attribute
    link_to( t(:destroy_nested_attribute, :scope => :e9_polls), '#', :class => 'destroy-nested-association')
  end

  def render_nested_attribute_association(association_name, form, options = {})
    options.symbolize_keys!

    association = resource.send(association_name)

    unless association.empty?
      form.fields_for(association_name) do |f|
        concat nested_attribute_template(association_name, f, options)
      end
    end
  end

  def nested_attribute_template_js(klass, association_name, options = {})
    options.symbolize_keys!
    options[:index] ||= 10000

    template = nil

    fields_for(klass.new) do |f|
      f.object.send(association_name).build
      f.fields_for(association_name, :child_index => options[:index]) do |ff|
        template = "#{escape_javascript(nested_attribute_template(association_name, ff))}"
      end
    end

    retv = <<-RETV
      TEMPLATES = window.TEMPLATES || {};
      TEMPLATES['#{association_name}'] = {
        index: #{options[:index]},
        template: "#{template}"
      };
    RETV
  end

  def nested_attribute_template(association_name, builder, options = {})
    options.symbolize_keys!
    partial = options[:partial] || File.join('e9_polls', builder.object.class.model_name.collection, 'nested_attribute_template')
    render(:partial => partial, :locals => { :f => builder })
  end

  def build_associated_resource(association_name)
    params_method = "#{association_name}_build_parameters"
    build_params = resource_class.send(params_method) if resource_class.respond_to?(params_method)
    resource.send(association_name).build(build_params || {})
  end
end
