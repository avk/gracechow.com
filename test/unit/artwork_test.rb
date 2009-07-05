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
  
  def test_should_require_a_description
    assert_no_difference "Artwork.count" do
      artwork = create_artwork(:description => "")
      assert artwork.errors.on(:description), "allowing new artwork without a description"
    end
  end
  
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

end
