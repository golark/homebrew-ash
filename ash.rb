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

    # Install shell integration file
    pkgshare.install "widget.zsh" => "ash.zsh"

    # Create installation script
    (bin/"ash-install").write <<~EOS
      #!/bin/bash
      set -e

      echo "🚀 Installing Ash shell integration..."

      ASH_DIR="$HOME/.ash"
      mkdir -p "$ASH_DIR"
      echo "✅ Created Ash directory: $ASH_DIR"

      cp "#{pkgshare}/ash.zsh" "$ASH_DIR/"
      echo "✅ Copied shell integration to $ASH_DIR"

      # Download the AI model if not already present
      MODEL_DIR="$ASH_DIR/models"
      MODEL_FILE="$MODEL_DIR/qwen2.5-coder-3b-instruct-q4_k_m.gguf"

      if [[ ! -f "$MODEL_FILE" ]]; then
        echo "📥 Downloading AI model (this may take a few minutes)..."
        mkdir -p "$MODEL_DIR"
        curl -L -o "$MODEL_FILE" "https://huggingface.co/Qwen/Qwen2.5-Coder-3B-Instruct-GGUF/resolve/main/qwen2.5-coder-3b-instruct-q4_k_m.gguf"
        echo "✅ Model downloaded successfully"
      else
        echo "✅ AI model already exists"
      fi

      # Ensure the Homebrew bin is in the user's PATH
      if ! grep -Fxq 'export PATH="#{HOMEBREW_PREFIX}/bin:$PATH"' "$HOME/.zshrc"; then
        echo 'export PATH="#{HOMEBREW_PREFIX}/bin:$PATH"' >> "$HOME/.zshrc"
        echo "✅ Added Ash to PATH"
      fi

      # Source integration if not present
      if ! grep -Fxq 'source $HOME/.ash/ash.zsh' "$HOME/.zshrc"; then
        echo 'source $HOME/.ash/ash.zsh' >> "$HOME/.zshrc"
        echo "✅ Added Ash shell integration"
      fi

      echo
      echo "✅ Ash installation complete!"
      echo "💡 Restart your terminal or run: source ~/.zshrc"
      echo "🎯 Enable Ash mode with Ctrl+G"
      echo "📖 For help, run: ash --help"
    EOS
    chmod 0755, bin/"ash-install"

    # Uninstall script
    (bin/"ash-uninstall").write <<~EOS
      #!/bin/bash
      set -e

      echo "🗑️  Uninstalling Ash shell integration..."

      # Remove Ash config lines from .zshrc
      if [[ -f "$HOME/.zshrc" ]]; then
        grep -vFx 'export PATH="#{HOMEBREW_PREFIX}/bin:$PATH"' "$HOME/.zshrc" | \\
        grep -vFx 'source $HOME/.ash/ash.zsh' > "$HOME/.zshrc.tmp" && \\
        mv "$HOME/.zshrc.tmp" "$HOME/.zshrc"
        echo "✅ Removed Ash configuration from ~/.zshrc"
      fi

      # Remove .ash directory
      if [[ -d "$HOME/.ash" ]]; then
        rm -rf "$HOME/.ash"
        echo "✅ Removed Ash directory: $HOME/.ash"
      fi

      echo "✅ Ash shell integration removed"
      echo "💡 Restart your terminal for changes to take effect"
    EOS
    chmod 0755, bin/"ash-uninstall"
  end

  test do
    # Test that ash can be invoked
    system "#{bin}/ash", "--help"
  end

  def caveats
    <<~EOS
      🎉 Ash has been installed!

      To complete the installation:
      1. Run: ash-install (this will create ~/.ash directory and configure your shell)
      2. Restart your terminal or run: source ~/.zshrc
      3. Enable Ash mode with Ctrl+G

      To uninstall shell integration:
      Run: ash-uninstall

      Note: When uninstalling with 'brew uninstall ash',
      you may need to manually remove ~/.ash directory:
        rm -rf ~/.ash

      For more information, visit: #{homepage}
    EOS
  end
end