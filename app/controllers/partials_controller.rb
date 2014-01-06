class PartialsController < ApplicationController
  layout false
  def navbar_stats
    render :json => {
      :cache_id => system_info.last_bot_run.id * system_info.last_bot_run.id,
      :data => render_to_string(:partial => 'shared/navbar_stats')
    }
  end

  def bot_run_actions
    render :json => {
      :cache_id => system_info.last_bot_run.id,
      :data => cache( [ :bot_run_actions, system_info.last_bot_run.id ] ) do
        render_to_string :partial => 'shared/bot_run_actions', :locals => {
          :bot_run_actions => data_provider.bot_run_actions
        }
      end
    }
  end
end
