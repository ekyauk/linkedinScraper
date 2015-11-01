class ScrapeController < ApplicationController

    def index
    end

    def view
        urls = params[:urls].split
        @profile_table = []
        for url in urls
            profile = Linkedin::Profile.get_profile(url)
            name = profile.name.empty? == nil ? profile.first_name + ' ' + profile.last_name : profile.name
            if !profile.education.empty?
                for education_info in profile.education
                    @profile_table << education_line(name, education_info[:name], education_info[:degree])
                end
            end

            if !profile.current_companies.empty?
                puts profile.current_companies
                for company_info in profile.current_companies
                    @profile_table << company_line(name, company_info)
                end
            end
            if !profile.past_companies.empty?
                for company_info in profile.past_companies
                    @profile_table << company_line(name, company_info)
                end
            end
        end
    end

private
    def education_line(name, school, degree)
        return [name, 'Degree', school, degree]
    end

    def company_line(name, company_info)
        return [name, 'Employment', nil, nil, company_info[:company], company_info[:title], company_info[:start_date].to_s, company_info[:end_date].to_s]
    end

end
