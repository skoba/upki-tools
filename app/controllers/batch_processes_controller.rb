# coding: utf-8
class BatchProcessesController < ApplicationController
  def show
    @certificates =Certificate.where id: batch_processes_params[:ids]
  end

  def edit
  end

  def update
    tsv_file = params[:tsv_file]
    if tsv_file.blank?
      flash[:error] = 'ファイルを指定してください。'
      redirect_to edit_batch_processes_path
      return
    else
      Certificate.destroy_all
      Certificate.read_tsv(tsv_file)
      redirect_to root_path
    end
  end

  def destroy
  end

  private
  def batch_processes_params
    params.permit(:tsv_file, ids: [])
  end

  def certificate_params
    params.require(:certificate).permit(ids: [])
  end
end
