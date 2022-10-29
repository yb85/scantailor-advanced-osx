class Scantailor < Formula
  desc "Scantailor (Advanced) : bookscan images processor"
  homepage "https://github.com/vigri/scantailor-advanced"
  
  url "https://github.com/vigri/scantailor-advanced/archive/refs/tags/v1.0.18.tar.gz"
  sha256 "1daa21e8455bcf3c6f8807c1a025fd9c43c073a4a32193892b36e9c9610d4729"
  version "1.0.18"

  head "https://github.com/vigri/scantailor-advanced.git"
  
  depends_on "boost"
  depends_on "qt6"
  depends_on "libtiff" 
  depends_on "libpng" 
  depends_on "jpeg" 
  depends_on "zlib"
  depends_on "cmake" => :build
  
  def install
    vtag="#release@#{version} (build #{Time.now.utc.strftime("%Y%m%d")})"
    if build.head?
      vtag = "#master@#{version} (build #{Time.now.utc.strftime("%Y%m%d")})"
    end
    if File.file?("version.h.in")
      ohai "Setting versioning tag to #{vtag}"
      inreplace "version.h.in", /#define VERSION "([^"]*)"/, "#define VERSION \"\\1#{vtag}\""
    elsif File.file?("version.h") 
      ohai "Setting versioning tag to #{vtag}"
      inreplace "version.h", /#define VERSION "([^"]*)"/, "#define VERSION \"\\1#{vtag}\""
    end
    
    inreplace "src/foundation/Proximity.h", "#include <limits>", "#include <limits>\n#include <algorithm>"
    
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end
