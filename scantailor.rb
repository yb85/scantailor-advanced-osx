class Scantailor < Formula
  desc "Scantailor (Advanced) : bookscan images processor"
  homepage "https://github.com/4lex4/scantailor-advanced"
  
  url "https://github.com/4lex4/scantailor-advanced/archive/v1.0.16.tar.gz"
  sha256 "84629d2edba4c36c62bdb75eedb145262b894d950bcb95cec0dab43e21bdb909"

  head "https://github.com/4lex4/scantailor-advanced.git", :branch => "master"
  
	devel do
		url "https://github.com/4lex4/scantailor-advanced.git", :branch => "develop"
		version "DEVEL"
	end
  depends_on "boost"
  depends_on "qt5"
  depends_on "libtiff" 
  depends_on "libpng" 
  depends_on "jpeg" 
  depends_on "zlib"
  depends_on "cmake" => :build
  
  def install
    vtag="#release (build #{Time.now.utc.strftime("%Y%m%d")})"
    if build.devel?
      vtag = "#develop@HEAD (build #{Time.now.utc.strftime("%Y%m%d")})"
    elsif build.head?
      vtag = "#master@#{version} (build #{Time.now.utc.strftime("%Y%m%d")})"
    end
    if File.file?("version.h.in")
      ohai "Setting versioning tag to #{vtag}"
      inreplace "version.h.in", /#define VERSION "([^"]*)"/, "#define VERSION \"\\1#{vtag}\""
    elsif File.file?("version.h") 
      ohai "Setting versioning tag to #{vtag}"
      inreplace "version.h", /#define VERSION "([^"]*)"/, "#define VERSION \"\\1#{vtag}\""
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end
