class AbilitiesController < ApplicationController
  BASE_PATH = "#{Rails.root}/documents/%s.txt"
  def index
  end

  def search
    if params[:search].present?
      @document_paths = Document::Search.new.search params[:search]
    else
      @document_paths = Settings.docs.map{|f| "#{Rails.root}#{f}"}
    end
  end

  def read_file
    path = BASE_PATH % params[:id]
    file = File.open path
    @text = file.read
    respond_to do |format|
      format.js
    end
  end
end
