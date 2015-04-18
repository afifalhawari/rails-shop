describe Product do
  context 'validation' do
  it 'name should be presence' do
    product = Product.new(name: '', image: 'test.jpg', price: '10000', description: 'sample')
    product.valid?
    expect(product.errors[:name]).to be_include("can't be blank")
  end

  it 'price should be presence' do
    product = Product.new(name: '', image: 'test.jpg', price: '', description: 'sample')
    product.valid?
    expect(product.errors[:price]).to be_include("can't be blank")
  end

  it 'price should be a number' do
    product = Product.new(name: '', image: 'test.jpg', price: 'aaa', description: 'sample')
    product.valid?
    expect(product.errors[:price]).to be_include("is not a number")
  end

  end
end