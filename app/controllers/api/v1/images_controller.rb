require "google/cloud/storage"
require "mini_magick"
require 'base64'

class Api::V1::ImagesController < ApplicationController
    def show
        image = Image.find(params[:id])
        render json: user
    end

    def create
        # convert from base64 to image file - paperclip?
        uploaded_io = params["image_io"]["base64"]
        metadata = uploaded_io.split(',/')[0] + ","
        filetype = metadata.split("/")[1].split("base64")[0][0...-1]
        base64_string = uploaded_io[metadata.size..-1]
        blob = Base64.decode64(base64_string)
        image = MiniMagick::Image.read(blob)
        filename = "#{Time.new.to_i}.#{filetype}"
        image.write filename
        
        storage = Google::Cloud::Storage.new(
            project_id: ENV['GOOGLE_CLOUD_PROJECT'],
            
            # credentials: ENV['GOOGLE_CLOUD_KEYFILE_JSON']
            #### NEED TO MAKE THIS REFERENCE AN ENV VAR; WON'T WORK ON HEROKU
            #### watch youtube video; use carrierwave?
            credentials: JSON.parse(File.read('config/google_cloud_credentials.json'))
        )
        
        bucket = storage.bucket "auto-stock-189103.appspot.com"
        byebug 
        bucket.create_file image, "test/#{filename}" #*** TypeError Exception: no implicit conversion of MiniMagick::Image into String
        

        # image = Image.new
        # image.url = (upload to google cloud)
        # labels = (send to google vision for labels)
        # labels.each do |label|
            # new_label = Label.find_or_create
            # image.labels << new_label
            # end
        # image.save
        # user = User.find(params["userId"])
        # user.images << image
        # user.save
        # render json: image
    end
end
