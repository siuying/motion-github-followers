describe LoginValidator do
  before do
    @validator = LoginValidator.new
  end

  it "should be valid for proper parameters" do
    @validator.valid?({:username => "siuying", :password => "1234"}).should == true
    @validator.error_message.should == ""
  end

  it "should be invalid if username is nil or empty or invalid" do
    @validator.valid?({:username => nil, :password => "1"}).should.not == true
    @validator.error_message.should.not == ""

    @validator.valid?({:username => "", :password => "1"}).should.not == true
    @validator.error_message.should.not == ""
  end
  
  it "should be invalid if password is nil or empty" do
    @validator.valid?({:username => "tester", :password => ""}).should.not == true
    @validator.error_message.should.not == ""

    @validator.valid?({:username => "tester", :password => nil}).should.not == true
    @validator.error_message.should.not == ""
  end
end