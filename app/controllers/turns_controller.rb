class TurnsController < ApplicationController

  def index
    Unit.move_all_human
    Battle.resolve_battles
    
    Unit.move_all_computer
    Battle.resolve_battles

    respond_to do |format|
      format.html { redirect_to map_path, notice: 'Turn update complete' }
      format.json { head :ok }
    end
  end

end