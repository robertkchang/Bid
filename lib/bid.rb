#
# BidCalc.rb
#
# Given:
#  - Number of servers
#  - List of bids in descending order
#
# Determine which bid will generate maximum revenue
#
# Rule: Upon accepting a bid, all previous bids > said bid will be set to the accepted bid amount
#
# Example: If there are 5 servers, and the bids (in descending order) are: 20, 15, 10, 9, 1
# If 20 is accepted, then revenue = 20
# If 15 is accepted, then 20 15 -> 15 15 = 30
# If 10 is accepted, then 20 15 10 -> 10 10 10 = 30
# If 9 is accepted, then 20 15 10 9 -> 9 9 9 9 = 36
# If 1 is accepted, then 20 15 10 9 1 -> 1 1 1 1 1 = 5
#
# Thus, the max revenue is attained if 9 is accepted
#
# In the case when an accepted bid generates same amount of revenue as one of the previous bids, the previous bid is preferred.
# The idea being the bid that allocates the lesser number of servers is better because that unallocated servers can be auctioned
# off for more at a later time.
# Example: If there are 3 servers, and the bids are: 10, 5, 1
# If 10 is accepted, then revenue = 10
# If 5 is accepted, then 10 5 -> 5 5 = 10
# If 1 is accepted, then 10 5 1 -> 1 1 1 = 3
#
# Both bids 10 and 5 generate same revenue. But the 10 bid uses one less server, thus 10 is the bid that should be accepted
#
class BidCalc

  # Given number of servers and a list of bids in descending order,
  # return a map containing maximum revenue, the bid that generates the max revenue, and the position of that bid in the list
  #
  # params:
  #   num_of_servers: integer
  #   *bids: one or more arguments
  #
  # returns:
  #   map containing the following key pair values:
  #     :revenue
  #     :revenue_bid
  #     :revenue_pos
  #
  def calculate (num_of_servers, *bids)

    begin

      # validate number of servers
      if (num_of_servers < 1)
        raise 'Invalid num_of_servers parameter'
      end

      # Note - it is valid not to have any bids

      # initialize return values
      result_map = {:revenue => 0, :revenue_bid => 0, :revenue_pos => 0}

      # iterate through only as many bids as there are servers
      (1..(num_of_servers <= bids.length ? num_of_servers : bids.length)).each do |index|

        # get the bid price
        this_bid = bids[index-1]

        # calculate revenue given bid and position
        price = index * this_bid

        # if revenue is greater than revenue generated from thus far from previous bids
        # then set the return values to current revenue, bid, and position
        if (price > result_map[:revenue])
          result_map = {:revenue => price, :revenue_bid => this_bid, :revenue_pos => index}
        end
      end

      # return the map
      return result_map

    # if error, display message and return the message in the map
    rescue Exception => e
      return {:error_message => e.message}
    end

  end

  ########
  # Main #
  ########

  # instantiate calculator
  calc = BidCalc.new

  if (ARGV.length == 0)
    puts ("USAGE: ruby bid.rb <num of servers> <bid>+")
    puts ("EXAMPLE: ruby bid.rb 5 20 15 10 9 1 (5 servers, bids: 20,15,10,9,1")
  else

    # first parameter is num_of_servers
    servers = ARGV[0].to_i()

    # rest of parameters are bids - convert to integer before calculating
    bid_list =  ARGV[1,(ARGV.length-1)].collect{|i| i.to_i}

    # calculate
    result_map = calc.calculate(servers, *bid_list)

    puts ('Max revenue $' + result_map[:revenue].to_s + ' @ bid = $' + result_map[:revenue_bid].to_s + ', with ' + result_map[:revenue_pos].to_s + ' server(s) auctioned.')
  end

end
