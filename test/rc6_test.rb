require 'test/unit'
require 'crypt/rc6'
require 'fileutils'

class TestRC6 < Test::Unit::TestCase
  
  def test_block_size
    assert_equal(16, Crypt::RC6.new([0]*32).block_size(), "Wrong block size")
  end

  def test_initialize
    ["","1", "qwe"].each do |key|
      assert_raise(RuntimeError) {
        Crypt::RC6.new(key)
      }
    end
    
    ["1234567890123456","123456789012345678901234"].each do |key|
      assert_nothing_raised() {
        Crypt::RC6.new(key)
      }
    end
  end

  def test_vectors
    vectors = [
    [[ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
      [0x00000000, 0x00000000, 0x00000000, 0x00000000],
      [0x36a5c38f, 0x78f7b156, 0x4edf29c1, 0x1ea44898] ],

    [[0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
        0x01, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78],
      [0x35241302, 0x79685746, 0xbdac9b8a, 0xf1e0dfce],
      [0x2f194e52, 0x23c61547, 0x36f6511f, 0x183fa47e]],

    [[ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
      [0x00000000, 0x00000000, 0x00000000, 0x00000000],
      [0xcb1bd66c, 0x38300b19, 0x163f8a4e, 0x82ae9086] ],

    [[0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
        0x01, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78,
        0x89, 0x9a, 0xab, 0xbc, 0xcd, 0xde, 0xef, 0xf0],
      [0x35241302, 0x79685746, 0xbdac9b8a, 0xf1e0dfce],
      [0xd0298368, 0x0405e519, 0x2ae9521e, 0xd49152f9]],

    [[ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
      [0x00000000, 0x00000000, 0x00000000, 0x00000000],
      [0x05bd5f8f, 0xa85fd110, 0xda3ffa93, 0xc27e856e] ],

    [[0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
        0x01, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78,
        0x89, 0x9a, 0xab, 0xbc, 0xcd, 0xde, 0xef, 0xf0,
        0x10, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe],
      [0x35241302, 0x79685746, 0xbdac9b8a, 0xf1e0dfce],
      [0x161824c8, 0x89e4d7f0, 0xa116ad20, 0x485d4e67]],
  ]

    vectors.each_with_index do |vector, i|
      rc6 = Crypt::RC6.new(vector[0])
      assert_equal(rc6.encrypt_block(vector[1].pack('N*')), vector[2].pack('N*'))
      assert_equal(rc6.decrypt_block(vector[2].pack('N*')), vector[1].pack('N*'))
    end

  end

end
