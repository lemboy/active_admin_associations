class AutocompleteController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render :json => autocomplete_results
      }
    end
  end
  
  private
  
  def autocomplete_results
    return [] unless query_term.present?
    if filter_param.present?
      model.autocomplete_results(query_term, filter_param)
    else
      model.autocomplete_results(query_term)
    end
  end
  
  def model
    params[:model].split('::').map(&:classify).join('::').constantize
  end
  
  def query_param_name
    if activeadmin_associations_config.autocomplete_query_term_param_names.present?
      activeadmin_associations_config.autocomplete_query_term_param_names.detect do |param_name|
        params.keys.map(&:to_sym).include?(param_name.to_sym)
      end
    else
      :q
    end
  end
  
  def query_term
    params[query_param_name]
  end
  
  def filter_param
    params[:filter]
  end

  def activeadmin_associations_config
    Rails.application.config.activeadmin_associations
  end
end
