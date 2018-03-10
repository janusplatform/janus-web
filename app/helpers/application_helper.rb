module ApplicationHelper

  def active?(clazz, action = nil)
    if clazz == params[:controller] && (action.nil? or action == params[:action])
      raw "class='active'"
    end
  end

  def controller?(controller)
    params[:controller].to_sym == controller.to_sym
  end

  def active_action?(*action)
    raw "class='active'" if (action.member?(params[:action]) || action.member?(params[:action].to_sym))
  end

  def active_controller?(*action)
    raw "class='active'" if (action.member?(params[:controller]) || action.member?(params[:controller].to_sym))
  end

  def active_if(conditions)
    "active" if (conditions[:controller].blank? or (conditions[:controller]) == params[:controller].to_sym) and
        (conditions[:controllers].blank? or conditions[:controllers].member?(params[:controller].to_sym)) and
        (conditions[:action].blank? or (conditions[:action] == params[:action].to_sym)) and
        (conditions[:actions].blank? or conditions[:actions].member?(params[:action].to_sym)) and
        (conditions[:unless_action].blank? or not conditions[:unless_action] == params[:action].to_sym) and
        (conditions[:unless_actions].blank? or not conditions[:unless_actions].member?(params[:action].to_sym))
  end

  def hide_unless(*args)
    'hide' unless args.member? params[:controller].to_sym
  end

  def hide_if val
    raw "hide" if val
  end

  def clean_params
    new = params.dup
    new.delete(:controller)
    new.delete(:action)
    new.to_query
  end

  def resource_name
    params[:controller].singularize.capitalize
  end

  def ic_form_for(record, options = {}, &block)
    simple_form_for(record, options, &block)
  end

  def ic_link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      ic_link_to(capture(&block), options, html_options)
    else
      name         = args[0]
      options      = args[1] || {}
      html_options = args[2]

      html_options = convert_options_to_data_attributes(options, html_options)
      url = url_for(options)

      href = html_options['href']
      tag_options = tag_options(html_options)

      href_attr = "ic-get-from=\"#{ERB::Util.html_escape(url)}\"" unless href
      "<a #{href_attr}#{tag_options}>#{ERB::Util.html_escape(name || url)}</a>".html_safe
    end
  end

  def ic_action_for(record, override_url = nil)
    if override_url
      url_to_target = override_url + (record.persisted? ? "/#{record.id}" : "")
    else
      url_to_target = url_for(record)
    end
    if record.persisted?
      raw("ic-put-to='#{url_to_target}'")
    else
      raw("ic-post-to='#{url_to_target}'")
    end
  end

  def ic_html_for(record, override_url = nil, more_vals = {})
    if override_url
      url_to_target = override_url + (record.persisted? ? "/" + record.id : "")
    else
      url_to_target = url_for(record)
    end
    map = {record.persisted? ? "ic-put-to" : "ic-post-to" => url_to_target}
    map.merge!(more_vals)
  end


  def aura_error_span(record, field)
    raw('<span class="text-danger">' +  record.errors[field].join(", ")  + '</span>') unless record.errors[field].blank?
  end

  def show_action(record)
    record.persisted? ? :show : :index
  end

  def nav_state
    @nav = compute_nav
    {'nav' => @nav}.to_json
  end

  def nav_changed?
    @nav != params[:nav]
  end

  def nav_is?(str)
    @nav == str
  end

  def compute_nav
    if ['tools'].member?(params[:controller])
      'tools'
    elsif ['subscriptions'].member?(params[:controller])
      'tools'
    else
      'dashboard'
    end
  end

  def include_nav?
    false && user_signed_in?
  end

  def ic_order_by(name, col)

    params_copy = params.permit!.clone
    params_copy.delete(:action)
    params_copy.delete(:controller)
    params_copy.delete_if { |k, v| k.to_s.start_with? 'ic-' }
    params_copy.delete(:_method)
    params_copy[:o] = col

    if col == params[:o]
      if params[:oa]
        params_copy[:o] = col
        params_copy.delete(:oa)
        name = raw "#{name} <strong><i class='sort-icon fa fa-sort-up'></i></strong>"
      else
        params_copy[:oa] = true
        name = raw "#{name} <strong><i class='sort-icon fa fa-sort-down'></i></strong>"
      end
    else
      name = raw "#{name} <i class='sort-icon text-very-muted fa fa-sort'></i>"
    end

    url = url_for(params_copy)

    raw("<span ic-get-from=\"#{ERB::Util.html_escape(url)}\">#{ERB::Util.html_escape(name || url)} " +
            "<i class='ic-indicator fa fa-spinner fa-spin' style='display:none'></i></span>")
  end

  def ic_filter_by(name, filter)

    params_copy = params.permit!.clone
    params_copy.delete(:action)
    params_copy.delete(:controller)
    params_copy.delete_if { |k, v| k.to_s.start_with? 'ic-' }
    params_copy.delete(:_method)
    params_copy[:f] = filter

    if filter == params[:f]
      html_class = 'active'
    else
      html_class = ''
    end

    url = url_for(params_copy)

    raw("<a class=\"#{html_class}\" ic-get-from=\"#{ERB::Util.html_escape(url)}\">#{ERB::Util.html_escape(name || url)} " +
            "<i class='ic-indicator fa fa-spinner fa-spin' style='display:none'></i></a>")
  end

end
