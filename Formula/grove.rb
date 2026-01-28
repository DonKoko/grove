class Grove < Formula
  desc "Git worktree workflow tool - manage multiple worktrees with ease"
  homepage "https://github.com/donkoko/grove"
  url "https://github.com/donkoko/grove/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256_AFTER_RELEASE"
  license "MIT"
  head "https://github.com/donkoko/grove.git", branch: "main"

  def install
    bin.install "bin/gwt"
    
    # Install completions
    bash_completion.install "completions/gwt.bash" => "gwt"
    zsh_completion.install "completions/_gwt"
    
    # Install shell integrations
    (share/"grove/integrations").install "integrations/grove.bash"
    (share/"grove/integrations").install "integrations/grove.zsh"
  end

  def caveats
    <<~EOS
      To enable auto-cd into worktrees after creation, run:

      For zsh:
        echo 'source #{HOMEBREW_PREFIX}/share/grove/integrations/grove.zsh' >> ~/.zshrc && source ~/.zshrc

      For bash:
        echo 'source #{HOMEBREW_PREFIX}/share/grove/integrations/grove.bash' >> ~/.bashrc && source ~/.bashrc
    EOS
  end

  test do
    system "#{bin}/gwt", "--version"
  end
end
