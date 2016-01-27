require 'sinatra/base'
require 'sinatra/contrib'
require 'slim'
require 'yaml'

class TmNCTNewsWeb < Sinatra::Base
  register Sinatra::Contrib

  before do
    @config = YAML.load_file('./config/config.yml')
  end

  get '/' do
    @title = "苫小牧高専News"
    slim :index
  end

  post '/register/?' do
    yaml = YAML.load_file(@config["addresses_file_path"])

    if /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i === params[:email]
      if yaml["to_addresses"].include?(params[:email])
        @error = "すでに登録されているメールアドレスです。"
        slim :index
      else
        @error = false
        @title = "登録完了 苫小牧高専News"
        yaml["to_addresses"] << params[:email]
        open(@config["addresses_file_path"], "w") do |f|
          YAML.dump(yaml, f)
        end
        slim :registered
      end
    else
      @error = "不正なメールアドレスです。"
      slim :index
    end
  end

  helpers do
    def page_title(title = nil)
      @title = title if title
      @title ? "#{@title} - mktakuya.net" : "mktakuya.net"
    end
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
end
