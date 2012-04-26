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

  # Given bid position in list and the bid value, calculate revenue
  #
  # params:
  #   bid_position: integer
  #   this_bid: integer
  #
  # returns:
  #   integer
  #
  def processBid (bid_position, this_bid)

    return bid_position * this_bid

  end

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
      max_revenue_thus_far = 0
      max_revenue_bid = 0
      max_revenue_bid_pos = 0

      # iterate through only as many bids as there are servers
      (0..(num_of_servers <= bids.length ? num_of_servers : bids.length)-1).each do |index|

        # use this index
        use_this_index = index + 1

        # get the bid price
        this_bid = bids[index]

        # calculate revenue given bid and position
        price = processBid(use_this_index, this_bid)

        # if revenue is greater than revenue generated from thus far from previous bids
        # then set the return values to current revenue, bid, and position
        if (price > max_revenue_thus_far)
          max_revenue_thus_far = price
          max_revenue_bid = this_bid
          max_revenue_bid_pos = use_this_index
        end
      end

      # return the map
      return {:revenue => max_revenue_thus_far, :revenue_bid => max_revenue_bid, :revenue_pos => max_revenue_bid_pos}

    # if error, display message and return the message in the map
    rescue Exception => e
      puts e.message
      return {:error_message => e.message}
    end

  end

end
