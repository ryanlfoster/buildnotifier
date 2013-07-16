class IosReleasesController < ReleasesController
  def index
    redirect_to root_url
  end

  def destroy
    @product = @release.product
    @release.destroy
    redirect_to @product, notice: t(:removed_release) 
  end
end
