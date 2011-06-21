class WorkingOn
  def update 
    10
  end
  
  def context
    {
      :activities => Activity.being_worked_on
    }
  end
end

class Calendar
  def initialize(url)
    @url = url
  end
  
  def update 
     120
  end
  
  def clean_up(e)
    e.gsub(/holiday/i,"").gsub(/not it/i,"").gsub(/not in/i,"").strip
  end
  
  def events_from(calendar)
     cals = Icalendar.parse(calendar)

     today = Date.today
     next_week = Date.today + 7

     cur_date = today
     expanded_events = []
     
     while(cur_date < next_week)
        events = cals.first.events.select do |e|
          e.dtstart <= cur_date && e.dtend >= cur_date
        end
        events.each do |e|
          expanded_events << [cur_date,clean_up(e.summary)]
        end
        cur_date += 1
     end
    
     events = expanded_events.group_by {|a| a[0]}.sort_by {|a| a[0]}
     return events.map {|k,v| [k.strftime("%a"),v.map {|v| v[1]}]}.reject {|e| e[0] == "Sat" || e[0] == "Sun"}
  end

  def context
    calendar = open(@url)
    {
       :events => events_from(calendar.read)
    }
  end
end
