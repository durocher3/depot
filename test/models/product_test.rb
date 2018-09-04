require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "title", description: "description", image_url: "image.gif", price: -1.50)
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    product.price = 0
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "any title", description: "any description", image_url: image_url, price: 1)
  end

  test "image url" do
    ok = %w{ image.gif image.png image.jpg IMAGE.JPG IMAGE.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ image.doc image image.gif/more image.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product must have unique title" do
    product = Product.new(title: products(:one).title, description: "asdf", image_url: "asdf.jpg", price: 5)
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "title must be at least 3 characters" do
    product = Product.new(title: "hi", description: "asdf", image_url: "asdf.png", price: 1)
    assert product.invalid?
    assert_equal ["is too short (minimum is 3 characters)"], product.errors[:title]
  end
end
