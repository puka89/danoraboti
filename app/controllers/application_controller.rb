require 'csv'
require 'linear-regression'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_sessions
  skip_before_action :verify_authenticity_token
  def sums
    CSV.foreach do |row|
    sum=0
    sum += row[0]
    sum=sum.ceil
    render plain: ('%.2f'%sum)  
  end  
  def filters
    file=CSV.parse(params[:file].read)
    sum=0
    file.each do |row|
      if row[2].to_i % 2!=0 
        sum+=row[1].to_i
      end
    end 
    sum=sum.ceil
    render plain: ('%.2f'%sum)
  end 
  def intervals
    sum=0
    red=1
    bestDay=0
    file=CSV.parse(params[:file].read)
    while red < file.length-30 do
      i=0
      while i<30
        sum+=file[red+i][0].to_i
        i+=1
      end
      if sum > bestDay
        bestDay=sum
      end
      sum=0
      red+=1
    end
   bestDay=bestDay.ceil
    render plain: ('%.2f' % bestDay)
  end

  def lin_regressions
    file=CSV.parse(params[:file].read)
    ind=(1..file.length).to_a;
    values=file.map{|n| n[0].to_i}
    p values.length
    p ind.length
    linear = Regression::Linear.new(ind, values)
    b = linear.intercept
    a = linear.slope
    render plain: "#{'%.6f' % a},#{'%.6f' % b}"
  end  
end
