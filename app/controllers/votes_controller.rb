class VotesController < InheritedResources::Base

  private

    def vote_params
      params.require(:vote).permit()
    end
end

