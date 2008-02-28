require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :events, :machines, :participants, :users, :event_datetimes
  
  def test_name
   evento = events(:event_00038 )
    assert evento.valid?
    #assert_equal "should expecify a name", evento.errors.on(:name)
  end
  def test_if_a_machines_is_in_an_event_simple
    evento = events(:event_00038 )    
    trapo = machines(:machine_00005).id    
    assert evento.uses_participant(trapo)
  end
  def test_if_a_machines_is_in_an_event_complejo
    evento = events(:event_00040 )    
    trapo = machines(:machine_00005).id 
    golpe = machines(:machine_00008).id
    traste = machines(:machine_00009).id
    assert evento.uses_participant(trapo)
    assert evento.uses_participant(golpe)
    assert evento.uses_participant(traste)
  end
  
  def test_if_many_machines_are_in_an_event
    evento = events(:event_00040 )  
    trapo = machines(:machine_00005).id
    golpe = machines(:machine_00008).id
    traste = machines(:machine_00009).id
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
    evento = events(:event_00038 )  
    trapo = machines(:machine_00005).name
    participants = evento.get_participants
    assert_not_nil participants
    assert_equal trapo,participants
    
  end
  
  def test_get_participants_complejo
   evento = events(:event_00040 )  
    trapo = machines(:machine_00005).name
    golpe = machines(:machine_00008).name
    traste = machines(:machine_00009).name
    participants = evento.get_participants
    assert_not_nil participants
    assert_equal trapo +" "+ golpe +" "+ traste,participants
  end
  
  def test_get_url_simple
    evento = events(:event_00038 )  
    trapo = machines(:machine_00005).nickname
    url = []
    url[0]= "isabel://"+ trapo
    urls = evento.get_urls
     assert_not_nil urls
    assert_equal url, urls
  end
  
    def test_get_url_complejo
      evento = events(:event_00040 )  
    trapo = machines(:machine_00005).nickname
     golpe = machines(:machine_00008).nickname
    traste = machines(:machine_00009).nickname
    url = []
    url[0]= "isabel://"+ trapo
     url[1]= "isabel://"+ golpe
      url[2]= "isabel://"+ traste
       urls = evento.get_urls
       assert_not_nil urls
    assert_equal url, urls
  end
  
  def test_overlaps_with_event
    evento = events(:event_00040 ) 
    evento2 = events(:event_00042 ) 
    evento3 = events(:event_00041 )
    even = []
    even[0]= evento2
    even[1]= evento3
    even2 = []
    even2[0] = evento3
    
    assert evento.overlaps_with_event_in_array(even)
    #assert evento.overlaps_with_event_in_array(even2)
    
  end
  
  def test_has_any_session_in_the_past
    evento = events(:event_00040 ) 
    assert evento.has_any_session_in_the_past
  end
  
  
end
