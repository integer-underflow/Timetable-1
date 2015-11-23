class FinaltablesController < ApplicationController
    def index
        @count = 0
        @count_exam = 0
        require 'rubygems'
        require 'nokogiri'
        require 'open-uri'
        require 'set'

        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @classes = @table.classtables.all
        @regular = Regularexam.all

        year = @table.year.to_s
        semester = @table.semester.to_s
        link = semester + year

        @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{link}/exam/index.php?type=FINAL&term=#{link}"))   

        @day_selected = @page.css("td[width='19%']")
        @time_selected = @page.css("div[align='center']")
        @exam_selected = @page.css("td[width='27%']")

        @days = []

        @day_selected.each do |day|
            @days.push(day.text)
        end

        @exams = []
        
        @exam_selected.each do |exam|
            @exams.push(exam.text.gsub(/[\r\n\t]/, '').split(','))
        end

        @myexam = []
        day_len = @days.count
        exam_len = @exams.count
        i = j = 0

        while i < day_len do
            while j < exam_len do 
                @myexam.push([@days[i], @exams[j]])
                j += 1
                i += 1 if j % 3 == 0
            end
        end
        @is_shown = Set.new
    end

    def new
        @regularexam = Regularexam.new
    end
end
