def yield_tester
  if block_given?
    yield
  else
    :no_block
  end
end

# puts yield_tester
# result = yield_tester { :valami }
# print result


def simple
  if true
    :valami
  end
end

print simple
