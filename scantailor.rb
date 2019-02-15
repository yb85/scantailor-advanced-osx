class Scantailor < Formula
  desc "Scantailor (Advanced) : bookscan images processor"
  homepage "https://github.com/4lex4/scantailor-advanced"
  
  url "https://github.com/4lex4/scantailor-advanced/archive/v1.0.16.tar.gz"
  sha256 "84629d2edba4c36c62bdb75eedb145262b894d950bcb95cec0dab43e21bdb909"

  head "https://github.com/4lex4/scantailor-advanced.git"
  
  depends_on "boost"
  depends_on "qt5"
  depends_on "libtiff" 
  depends_on "libpng" 
  depends_on "jpeg" 
  depends_on "zlib"
  depends_on "cmake" => :build
  
  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end