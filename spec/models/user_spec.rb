describe User do
  context 'validation' do
  it 'password should be more than 3 in length' do
    product = User.new(email: 'test@test.com', password:'p', password_confirmation:'p')
    product.valid?
    expect(product.errors[:password]).to be_include("is too short (minimum is 3 characters)")
  end

  it 'password_confirmation should be the same with password' do
    product = User.new(email: 'test@test.com', password:'password', password_confirmation:'')
    product.valid?
    expect(product.errors[:password_confirmation]).to be_include("doesn't match Password")
  end

  it 'email should be unique' do
    product1 = User.new(email: 'test@test.com', password:'password', password_confirmation:'password')
    product1.save
    product2 = User.new(email: 'test@test.com', password:'password', password_confirmation:'password')
    product2.valid?
    expect(product2.errors[:email]).to be_include("has already been taken")
  end
  end
end