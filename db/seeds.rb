# Seeding coupon codes in a random fashion since selecting a random row from SQL is expensive. Not using the in-built
# secure algorithms as nothing provide base-36 encoding in ruby, and moreover, randomness is all we need. This will
# also be faster. And, since we are not generating coupon codes in real-time, and we will already seed them,
# coupon codes will never be easy to guess.

possible_chars = [('a'..'z'), (0..9)].map { |rng| rng.to_a }.flatten
number_of_possible_chars = possible_chars.length
number_of_letters_in_coupon_code = 6
number_of_coupon_codes_to_generate = number_of_letters_in_coupon_code ** number_of_possible_chars

while Coupon.count < number_of_coupon_codes_to_generate
  random_alphanumeric_code = (0..5).map { possible_chars[rand(number_of_possible_chars)] }.join
  Coupon.find_or_create_by!(code: random_alphanumeric_code)
end
