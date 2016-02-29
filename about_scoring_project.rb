require File.expand_path(File.dirname(__FILE__) + '/neo')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

def score1(dice)
  points = 0
  all_numbers = dice.uniq
  number_counts = Hash[all_numbers.map { |number| [number, dice.count(number)] } ]
  number_counts.each do |number, count|

    if number == 1
      if count >= 3
        points += 1000
        count -= 3
      end
      points += count * 100

    elsif number == 5
      if count >= 3
        points += number * 100
        count -=3
      end
      points += count * 50

    elsif count >= 3
      points += number * 100
    end

  end
  points
end


def score2(dice)
  points = 0
  all_numbers = dice.uniq
  number_counts = Hash[all_numbers.map { |number| [number, dice.count(number)] } ]
  at_least_three = number_counts.select { |number, count| count >= 3 }

  at_least_three.each do |number, count|
    remaining = count - 3
    if number == 1
      points += 1000
      points += remaining * 100
    else
      points += number * 100
      if number == 5
        points += remaining * 50
      end
    end
  end

  remaining_ones = number_counts.select { |number, count| count < 3 and number == 1}
  unless remaining_ones.empty?
    points += remaining_ones.values.first * 100
  end

  remaining_fives = number_counts.select { |number, count| count < 3 and number == 5}
  unless remaining_fives.empty?
    points += remaining_fives.values.first * 50
  end

  points
end


def score3(dice)
  points = 0
  all_numbers = dice.uniq
  number_counts = Hash[all_numbers.map { |number| [number, dice.count(number)] } ]
  at_least_three = number_counts.select { |number, count| count >= 3 }

  at_least_three.each do |number, count|
    remaining = count - 3
    if number == 1
      points += 1000
      points += remaining * 100
    else
      points += number * 100
      if number == 5
        points += remaining * 50
      end
    end
  end

  remaining_ones = number_counts.select { |number, count| count < 3 and number == 1}
  points += remaining_ones.values.first * 100 unless remaining_ones.empty?

  remaining_fives = number_counts.select { |number, count| count < 3 and number == 5}
  points += remaining_fives.values.first * 50 unless remaining_fives.empty?

  points
end


def score4(dice)
  points = 0
  all_numbers = dice.uniq
  number_counts = Hash[all_numbers.map { |number| [number, dice.count(number)] } ]

  number_counts.each do |number, count|
    if count >= 3
      points += (number == 1) ? 1000 : (number * 100)
      count = count - 3
    end
    points += count * 100 if number == 1
    points += count * 50 if number == 5
  end

  points
end


# http://stackoverflow.com/a/7943386/720077
def score(dice)
  score = [0, 100, 200, 1000, 1100, 1200][dice.count(1)]
  score += [0, 50, 100, 500, 550, 600][dice.count(5)]
  [2,3,4,6].each do |num|
    score += num * 100 if dice.count(num) >= 3
  end
  score
end



class AboutScoringProject < Neo::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
    assert_equal 1100, score([1,1,1,1])
    assert_equal 1200, score([1,1,1,1,1])
    assert_equal 1150, score([1,1,1,5,1])
  end

end
