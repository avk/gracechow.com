require 'test_helper'

class ArtworkTest < ActiveSupport::TestCase

  def test_should_be_able_to_create_artwork
    assert_difference "Artwork.count", 1 do
      artwork = create_artwork
      assert !artwork.new_record?, "#{artwork.errors.full_messages.to_sentence}"
    end
  end
  
  def test_should_require_a_title
    assert_no_difference "Artwork.count" do
      artwork = create_artwork(:title => "")
      assert artwork.errors.on(:title), "allowing new artwork without a title"
    end
  end
  
  def test_should_require_a_unique_title
    title = "Starry Night"
    assert_difference "Artwork.count", 1 do
      artwork = create_artwork(:title => title)
      assert !artwork.new_record?, "#{artwork.errors.full_messages.to_sentence}"
      
      artwork2 = create_artwork(:title => title)
      assert artwork2.errors.on(:title), "allowing new artwork with a duplicate title"
    end
  end
  
  # def test_should_require_a_description
  #   assert_no_difference "Artwork.count" do
  #     artwork = create_artwork(:description => "")
  #     assert artwork.errors.on(:description), "allowing new artwork without a description"
  #   end
  # end
  
  def test_should_belong_to_a_category
    assert_no_difference "Artwork.count" do
      artwork = create_artwork(:category_id => nil)
      assert artwork.errors.on(:category_id), "allowing new artwork without a category"
    end
  end
  
  def test_should_be_associated_with_a_valid_category
    assert_no_difference "Artwork.count" do
      category = Category.create(invalid_options_for_category)
      artwork = create_artwork(:category => category)
      assert artwork.errors.on(:category), "allowing new artwork with an invalid category"
    end
  end
  
  def test_should_set_sequence_automatically
    category = Category.last
    last_sequence_number = category.artworks.size
    assert_difference "Artwork.count", 1 do
      artwork = create_artwork(:category_id => category.id)
      assert !artwork.new_record?, "#{artwork.errors.full_messages.to_sentence}"
      assert artwork.sequence == last_sequence_number + 1
    end
  end
  
  def test_should_not_allow_sequence_to_be_set_via_mass_assignment
    ["random", 908709870987].each do |sequence|
      assert_difference "Artwork.count", 1 do
        random_title = Time.now.to_s + rand().to_s
        artwork = create_artwork(:sequence => sequence, :title => random_title)
        assert artwork.sequence != sequence, "allowing a new artwork with arbitrary sequence: #{sequence}"
      end
    end
  end
  
  def test_should_not_set_the_sequence_on_updates
    artwork = Artwork.first
    original_sequence = artwork.sequence

    artwork.title = "something else that's very unique"
    artwork.save
    artwork.reload
    
    assert original_sequence == artwork.sequence, "setting a new sequence on artwork updates"
  end
  
  def test_should_update_sequence_when_updating_category
    old_category = categories(:paintings)
    new_category = categories(:sepia)
    artwork = old_category.artworks.ordered.last
    expected_sequence = new_category.artworks.size + 1
    
    artwork.category = new_category
    artwork.save
    artwork.reload
    
    assert artwork.sequence == expected_sequence, "not setting a new sequence when updating artwork category"
  end
  
  def test_should_be_able_to_fetch_previous_artwork_within_its_category
    artwork = artworks(:two)
    assert Artwork.before(artwork) == artworks(:one)
  end
  
  def test_should_return_nil_for_previous_artwork_if_first_within_its_category
    artwork = artworks(:one)
    assert Artwork.before(artwork) == nil
  end
  
  def test_should_be_able_to_fetch_next_artwork_within_its_category
    artwork = artworks(:two)
    assert Artwork.after(artwork) == artworks(:three)
  end
  
  def test_should_return_nil_for_next_artwork_if_last_within_its_category
    artwork = artworks(:three)
    assert Artwork.after(artwork) == nil
  end
  
  

end
