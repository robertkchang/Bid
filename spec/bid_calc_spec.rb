require "spec_helper"
require '../lib/bid'

describe "Test" do
  it "should process bid with the values given" do
    bid_pos_param = 1
    bid_price_param = 10
    calc = BidCalc.new
    calc.should_receive(:processBid).with(bid_pos_param, bid_price_param).and_return(10)
    calc.processBid(bid_pos_param, bid_price_param)
  end

  it "should calculate with the values given" do
    num_servers_param = 5
    bids_param = [20,15,10,9,1]
    calc = BidCalc.new
    calc.should_receive(:calculate).with(num_servers_param, bids_param).and_return(36)
    calc.calculate(num_servers_param, bids_param)
  end

  it "should return a value from process bid" do
    price_param = 10
    calc = BidCalc.new
    calc.stub(:processBid => price_param)
    calc.processBid(1,10).should eql price_param
  end

  it "should return a value from calculate" do
    result_map = {:revenue => 40, :revenue_bid => 10, :revenue_pos => 4}
    calc = BidCalc.new
    calc.stub(:calculate => result_map)
    calc.calculate(4,20,10,15,5).should eql result_map
  end

  it "should process bid correctly" do
    bid_pos_param = 4
    bid_price_param = 10
    calc = BidCalc.new
    calc.processBid(bid_pos_param, bid_price_param).should eql 40
  end

  it "should calculate revenue correctly" do
    calc = BidCalc.new
    result_map = calc.calculate(5,20,15,10,9,1)
    result_map[:revenue].should eql 36
    result_map[:revenue_bid].should eql 9
    result_map[:revenue_pos].should eql 4
  end

  it "should choose bid that utilize lesser number of servers if a bid generate same revenue as one of the previous bids" do
    calc = BidCalc.new
    result_map = calc.calculate(3,10,5,1)
    result_map[:revenue].should eql 10
    result_map[:revenue_bid].should eql 10
    result_map[:revenue_pos].should eql 1
  end

  it "should calculate revenue correctly if number of servers is greater than number of bids" do
    calc = BidCalc.new
    result_map = calc.calculate(5,20,15,10,9)
    result_map[:revenue].should eql 36
    result_map[:revenue_bid].should eql 9
    result_map[:revenue_pos].should eql 4
  end

  it "should calculate revenue correctly if number of servers is less than number of bids" do
    calc = BidCalc.new
    result_map = calc.calculate(3,20,15,10,9)
    result_map[:revenue].should eql 30
    result_map[:revenue_bid].should eql 15
    result_map[:revenue_pos].should eql 2
  end

  it "should return an error message if num_of_servers parameter is less than 0" do
    calc = BidCalc.new
    result_map = calc.calculate(0,20,15,10,9)
    result_map[:revenue].should eql nil
    result_map[:revenue_bid].should eql nil
    result_map[:revenue_pos].should eql nil
    result_map[:error_message].should eql 'Invalid num_of_servers parameter'
  end

  it "should return all values equal to 0 with no error message if no bids are passed as parameters" do
    calc = BidCalc.new
    result_map = calc.calculate(1)
    result_map[:revenue].should eql 0
    result_map[:revenue_bid].should eql 0
    result_map[:revenue_pos].should eql 0
    result_map[:error_message].should eql nil
  end

end