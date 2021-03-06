require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :events, :machines, :participants, :users, :event_datetimes
  
  def test_name
   evento = events(:event_simple )
    assert evento.valid?
    #assert_equal "should expecify a name", evento.errors.on(:name)
  end
  
  
  def test_if_a_machines_is_in_an_event_simple
    evento = events(:event_simple )    
    trapo = machines(:machine_trapo).id    
    assert evento.uses_participant(trapo)
  end
  
  
  def test_if_a_machines_is_in_an_event_complejo
    evento = events(:event_complejo )    
    trapo = machines(:machine_trapo).id 
    golpe = machines(:machine_golpe).id
    traste = machines(:machine_traste).id
    assert evento.uses_participant(trapo)
    assert evento.uses_participant(golpe)
    assert evento.uses_participant(traste)
  end
  
  
  def test_if_many_machines_are_in_an_event
    evento = events(:event_complejo )  
    trapo = machines(:machine_trapo).id
    golpe = machines(:machine_golpe).id
    traste = machines(:machine_traste).id
    array_participants_this_event = []
    array_participants_this_event << trapo
    array_participants_this_event << golpe
    array_participants_this_event << traste
    array_participants_this_event << "54"
    array_participants_this_event << "56"
    coincidences = evento.contains_participants(array_participants_this_event)
    assert_kind_of(Array, coincidences)
    #assert_include(trapo, coincidences)
    #assert_include golpe, coincidences
    #assert_include traste, coincidences
    assert_not_nil coincidences
    assert_equal 5, coincidences[0]
     assert_equal 8, coincidences[1]
      assert_equal 9, coincidences[2]
      assert coincidences.include?(5)
      assert coincidences.include?(8)
      assert coincidences.include?(9)
  end
  
  
  def test_get_participants_simple
    evento = events(:event_simple )  
    trapo = machines(:machine_trapo).name
    participants = evento.get_participants
    assert_not_nil participants
    assert_equal trapo,participants
    
  end
  
  
  def test_get_participants_complejo
   evento = events(:event_complejo )  
    trapo = machines(:machine_trapo).name
    golpe = machines(:machine_golpe).name
    traste = machines(:machine_traste).name
    participants = evento.get_participants
    assert_not_nil participants
    assert_equal trapo +" "+ golpe +" "+ traste,participants
  end
  
  
  def test_get_url_simple
    evento = events(:event_simple )  
    trapo = machines(:machine_trapo).nickname
    url = []
    url[0]= "isabel://"+ trapo
    urls = evento.get_urls
     assert_not_nil urls
    assert_equal url, urls
  end
  
  
    def test_get_url_complejo
      evento = events(:event_complejo )  
    trapo = machines(:machine_trapo).nickname
     golpe = machines(:machine_golpe).nickname
    traste = machines(:machine_traste).nickname
    url = []
    url[0]= "isabel://"+ trapo
     url[1]= "isabel://"+ golpe
      url[2]= "isabel://"+ traste
       urls = evento.get_urls
       assert_not_nil urls
    assert_equal url, urls
  end
  
  
  def test_overlaps_with_event
    evento = events(:event_complejo ) 
    evento2 = events(:event_SolapadorFebrero ) 
    evento3 = events(:event_solapador )
    even = []
    even[0]= evento2
    even[1]= evento3
    even2 = []
    even2[0] = evento3
    
    assert evento.overlaps_with_event_in_array(even)
    #assert evento.overlaps_with_event_in_array(even2)
    
  end
  
  
  def test_has_any_session_in_the_past
    evento = events(:event_complejo ) 
    assert evento.has_any_session_in_the_past
  end
  
  
  def test_get_participant_desc
    evento = events(:event_complejo )  
    desc = evento.get_participants_description
    assert_not_nil desc
    
  end
  
  
  def test_get_machine_name
    evento = events(:event_complejo )  
    trapo = machines(:machine_trapo).name
     golpe = machines(:machine_golpe).name
    traste = machines(:machine_traste).name
    machines = evento.get_machine_names
    assert_not_nil machines
    mach = []
    mach[0] = trapo
    mach[1] = golpe
    mach[2] = traste
    assert_equal machines, mach
  end
  
  
  def test_get_xedl_filename
    evento = events(:event_complejo ) 
    xedl = evento.get_xedl_filename
    assert_equal "xedls/Evento Complejo-27-2-2008-at-11-0.xedl", xedl 
  end
  
  
  def test_get_at_jobs
    evento = events(:event_complejo )  
    at_jobs = evento.get_at_jobs
    at = []
    at[0] = 208
    at[1] = 212
    assert_not_nil at_jobs
    assert_equal at_jobs, at
  end
  
  
  def create_at_jobs
    eve = Event.new(:name=> 'Evento1', :service => 'conference.act', :quality => '1M')
     assert_valid eve
      eve.create_at_jobs
      at_jobs=eve.get_at_jobs
      assert_not_nil at_jobs
     
      eve.destroy
      
     
   
 end
 def test_service_qualities
   eve = Event.new(:name=> 'Evento1', :service => 'conference.act', :quality => '1M')
qualities = Event.service_qualities
assert_not_nil qualities
end

 
  def test_uses_participant
     evento = events(:event_complejo ) 
     assert evento.uses_participant(5)
  
     assert evento.uses_participant(0)
      assert evento.uses_participant(8)
       assert evento.uses_participant(9)
        assert !evento.uses_participant(3)
  end
    def test_get_submenu
       evento = events(:event_complejo ) 
       submenu = evento.get_submenu
       assert_not_nil submenu
      
    end
    
   def test_should_parse_atom
    data = prepare_atom("dos", "desc", "Fri Oct 31 16:50:00 +0100 2008", "Fri Oct 31 20:50:00 +0100 2008",
    "password", {:tag1 => "t1", :tag2 => "t2", :tag3 => "t3"})
    params = Event.atom_parser(data)
    assert params.include?(:event)
    assert_equal "dos", params[:event][:name]
    assert_equal "desc", params[:event][:description]
    assert_equal "Fri, 31 Oct 2008 16:50:00 +0000".to_datetime, params[:start_date0]
    assert_equal "Fri Oct 31 20:50:00 +0100 2008".to_datetime, params[:end_date0]
    assert_equal "password", params[:event][:password]
    assert_equal "t1,t2,t3", params[:tags]
  end
  
   def test_should_parse_atom2
    data = prepare_atom2("dos", "desc", "Fri Oct 31 16:50:00 +0100 2008", "Fri Oct 31 20:50:00 +0100 2008",
    "password", {:tag1 => "t1", :tag2 => "t2", :tag3 => "t3"})
    params = Event.atom_parser(data)
    assert params.include?(:event)
    assert_equal "dos", params[:event][:name]
    assert_equal "desc", params[:event][:description]
    assert_equal "Fri, 31 Oct 2008 16:50:00 +0000".to_datetime, params[:start_date0]
    assert_equal "Fri Oct 31 20:50:00 +0100 2008".to_datetime, params[:end_date0]
    assert_equal "Sun, 2 Nov 2008 16:50:00 +0000".to_datetime, params[:start_date1]
    assert_equal "Sun Nov 2 20:50:00 +0100 2008".to_datetime, params[:end_date1]
    assert_equal "password", params[:event][:password]
    assert_equal "t1,t2,t3", params[:tags]
  end
    
    
    
    protected
    
  def prepare_atom(title, description, start, fin, password, options = {})
    d = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <entry xmlns:sir=\"http://sir.dit.upm.es/schema\" 
    xmlns:gd=\"http://schemas.google.com/g/2005\" 
    xml:lang=\"en-US\" xmlns=\"http://www.w3.org/2005/Atom\">  
    <id>tag:flexsir.dit.upm.es,2005:Event/1</id>  
    <link rel=\"alternate\" type=\"text/html\" href=\"/spaces/el%20espacio%20de%20javi/events/1\"/>  
    <link rel=\"self\" type=\"application/atom+xml\" href=\"/spaces/el%20espacio%20de%20javi/events/1.atom\"/>  
    <title>#{ title }</title>  
    <summary>#{ description }</summary>   
    <gd:when startTime=\"#{ start }\" endTime=\"#{ fin }\" valueString=\"0\"/>
    <category term=\"#{ options[:tag1] }\"/>
    <category term=\"#{ options[:tag2] }\"/>
    <category term=\"#{ options[:tag3] }\"/>
    <sir:password>#{ password }</sir:password>
    <sir:service>meeting.act</sir:service>
    <sir:all_participant_sites>10</sir:all_participant_sites>
    <sir:quality>1M</sir:quality>
    </entry>"
  end
  
  def prepare_atom2(title, description, start, fin, password, options = {})
    d = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <entry xmlns:sir=\"http://sir.dit.upm.es/schema\" 
    xmlns:gd=\"http://schemas.google.com/g/2005\" 
    xml:lang=\"en-US\" xmlns=\"http://www.w3.org/2005/Atom\">  
    <id>tag:flexsir.dit.upm.es,2005:Event/1</id>  
    <link rel=\"alternate\" type=\"text/html\" href=\"/spaces/el%20espacio%20de%20javi/events/1\"/>  
    <link rel=\"self\" type=\"application/atom+xml\" href=\"/spaces/el%20espacio%20de%20javi/events/1.atom\"/>  
    <title>#{ title }</title>  
    <summary>#{ description }</summary>   
    <gd:when startTime=\"#{ start }\" endTime=\"#{ fin }\" valueString=\"0\"/>
    <gd:when startTime=\"Sun Nov 2 16:50:00 +0100 2008\" endTime=\"Sun Nov 2 20:50:00 +0100 2008\" valueString=\"1\"/>
    <category term=\"#{ options[:tag1] }\"/>
    <category term=\"#{ options[:tag2] }\"/>
    <category term=\"#{ options[:tag3] }\"/>
    <sir:password>#{ password }</sir:password>
    <sir:service>meeting.act</sir:service>
    <sir:all_participant_sites>10</sir:all_participant_sites>
    <sir:quality>1M</sir:quality>
    </entry>"
  end


    
    
    
  end
