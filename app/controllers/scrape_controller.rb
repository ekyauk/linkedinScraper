class ScrapeController < ApplicationController
    skip_before_filter :check_login, :except => [:index]


    def index
    end

    def login
        linkedinClient = LinkedIn::Client.new(ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_SECRET'])

        request_token = linkedinClient.request_token({}, :scope => "r_basicprofile r_emailaddress")
        session[:request_token] = request_token.token
        session[:request_secret] = request_token.secret
        redirect_to request_token.authorize_url
    end

    def callback
        linkedinClient = LinkedIn::Client.new(ENV['LINKEDIN_CLIENT_ID'], ENV['LINKEDIN_SECRET'])
        if session[:oauth_token].nil?
            pin = params[:oauth_verifier]
            oauth_token, oauth_secret = client.authorize_from_request(session[:request_token], session[:request_secret], pin)
            session[:oauth_token] = oauth_token
            session[:oauth_secret] = oauth_secret
        end
        redirect_to :index
    end

    # def view
    #     url = params[:url]
    #     @profile_table = []
    #     profile = Linkedin::Profile.get_profile(url)
    #     puts profile
    #     if profile == nil
    #         render :inline => "<tr>Cannot find #{url}. Try again later.</tr>"
    #     end
    #     name = profile.name.empty? == nil ? profile.first_name + ' ' + profile.last_name : profile.name
    #     if !profile.education.empty?
    #         for education_info in profile.education
    #             @profile_table << education_line(name, education_info)
    #         end
    #     end

    #     if !profile.current_companies.empty?
    #         puts profile.current_companies
    #         for company_info in profile.current_companies
    #             @profile_table << company_line(name, company_info)
    #         end
    #     end
    #     if !profile.past_companies.empty?
    #         for company_info in profile.past_companies
    #             @profile_table << company_line(name, company_info)
    #         end
    #     end
    #     puts 'hi~'
    #     puts @profile_table
    #     render partial: 'profile_table'
    # end

private
    def education_line(name, education_info)
        return [name, 'Degree', education_info[:degree], education_info[:major], education_info[:name]]
    end

    def company_line(name, company_info)
        return [name, 'Employment', nil, nil, nil, company_info[:company], company_info[:title], company_info[:industry], company_info[:linkedin_company_url], company_info[:company_size], company_info[:start_date].to_s, company_info[:end_date].to_s]
    end

end
