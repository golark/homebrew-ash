# typed: false
# frozen_string_literal: true

class Ash < Formula
  desc "AI-powered shell assistant that translates natural language to shell commands"
  homepage "https://github.com/golark/ash"
  version "1.0.14"
  license "Apache-2.0"
  head "https://github.com/golark/ash.git", branch: "main"

  on_macos do
    url "https://github.com/golark/ash/releases/download/v#{version}/ash--darwin-arm64.tar.gz"
    sha256 "182a609342dbcecf91d8e8edd8b3105df341f3e5ac7e3875ec5905315171dca1"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/golark/ash/releases/download/v#{version}/ash--linux-amd64.tar.gz"
      sha256 "50ae1350397130e6712ea20f36b4262e7f6704fa737211ee285f5bc685fee045"
    end
  end

  def install
    bin.install "ash"
    prefix.install "widget.zsh"
    prefix.install "widget.bash"
  end

  def caveats
    <<~EOS
    To enable the shell assistant widget (Ctrl+G), add to your shell config:

    For Zsh (~/.zshrc):
      source #{opt_prefix}/widget.zsh

    For Bash (~/.bashrc or ~/.bash_profile):
      source #{opt_prefix}/widget.bash

    Then reload your terminal with: source ~/.zshrc (or source ~/.bashrc)

    Usage: Type a natural language command, press Ctrl+G to convert it.

    Note: On first use, ash will download a ~2GB model to ~/.ash/models/
    This ensures all processing runs locally on your device.

    To uninstall completely:
      brew uninstall ash
      rm -rf ~/.ash/models/  # Remove downloaded model
      # Remove the "source ..." line from your shell config
    EOS
  end

  test do
    output = shell_output("#{bin}/ash 2>&1", 1)
    assert_match(/Usage:/, output)
  end
end
