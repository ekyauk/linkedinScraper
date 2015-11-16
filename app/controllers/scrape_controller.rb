class ScrapeController < ApplicationController
    # before_filter :check_login, :only => :index

    def index
    end

    def login
        if session[:request_token] != nil
            redirect_to :action => :index
            return
        end
        client = LinkedIn::Client.new(ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_SECRET'])
        request_token = client.request_token({:oauth_callback => ENV['CALLBACK_URL']}, :scope => "r_basicprofile r_emailaddress")
        session[:request_token] = request_token.token
        session[:request_secret] = request_token.secret
        redirect_to request_token.authorize_url
    end

    def callback
        client = LinkedIn::Client.new(ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_SECRET'])
        puts 'CALLBACK'
        if session[:oauth_token].nil?
            pin = params[:oauth_verifier]
            oauth_token, oauth_secret = client.authorize_from_request(session[:request_token], session[:request_secret], pin)
            session[:oauth_token] = oauth_token
            session[:oauth_secret] = oauth_secret
        end
        redirect_to :action => :index
    end

    def view
        url = params[:url]
        @profile_table = []
        user = linkedin_client.profile(:url => url)
        puts user
        puts 'hiii'
        # if profile == nil
        #     render :inline => "<tr>Cannot find #{url}. Try again later.</tr>"
        # end
        # name = profile.name.empty? == nil ? profile.first_name + ' ' + profile.last_name : profile.name
        # if !profile.education.empty?
        #     for education_info in profile.education
        #         @profile_table << education_line(name, education_info)
        #     end
        # end
        positions = linkedin_client.profile(:url => url, :fields => %w(positions))
        education = linkedin_client.profile(:url => url, :fields => %w(education))
        puts "EDUCAMATA #{education}"
        if positions != nil
            puts positions
            for positon in positions
                start_date = "#{position[:start_date][:month]/positon[:start_date][:year]}"
                end_date = positon[:is_current] ? "" : "#{position[:end_date][:month]/positon[:end_date][:year]}"
                @profile_table << company_line(position[:title], positon[:company], start_date, end_date)
            end
        end
        if !profile.past_companies.empty?
            company_line(title, company_info, start_date, end_date)
            for company_info in profile.past_companies
                @profile_table << company_line(name, company_info)
            end
        end
        puts 'hi~'
        puts @profile_table
        render partial: 'profile_table'
    end

private
    def linkedin_client
        client = LinkedIn::Client.new(ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_SECRET'])
        client.authorize_from_access(session[:oauth_token], session[:oauth_secret])
        return client
    end

    def check_login
        if session[:oauth_token] == nil || session[:oauth_verifier] == nil
            redirect_to :login
        end
    end

    def education_line(name, education_info)
        return [name, 'Degree', education_info[:degree], education_info[:major], education_info[:name]]
    end

    def company_line(title, company_info, start_date, end_date)
        return [company_info[:name], 'Employment', nil, nil, nil, company_info[:company], title, company_info[:type], company_info[:linkedin_company_url], company_info[:size], start_date, end_date]
    end

end
