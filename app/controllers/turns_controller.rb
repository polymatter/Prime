class TurnsController < ApplicationController

  def index
    Battle.resolve_move_and_battles

    respond_to do |format|
      format.html { redirect_to map_path, notice: 'Turn update complete' }
      format.json { head :ok }
    end
  end

end