class Ash < Formula
  desc "AI-powered shell assistant that translates natural language to commands"
  homepage "https://github.com/golark/ash"
  version "1.0.0"
  license "Apache-2.0"

  url "https://github.com/golark/ash/releases/download/v1.0.0/ash-v1.0.0-dirty-darwin-arm64.tar.gz"
  sha256 "9ec8123c161fcde8d7d57979c0dcd94f2df5f11a23c380fba76b13fd83624edf"

  depends_on :macos

  def install
    # Install binary
    bin.install "ash"

    # Install shell widget
    prefix.install "widget.zsh"
  end

  test do
    # Test that ash can be invoked (it will show usage on empty input)
    output = shell_output("#{bin}/ash 2>&1", 1)
    assert_match(/Usage:/, output)
  end

  def caveats
    <<~EOS
      🎉 Ash has been installed!

      To enable the shell widget, add this to your ~/.zshrc:
        source #{prefix}/widget.zsh

      For more information, visit: #{homepage}
    EOS
  end
end