# Copyright (c) 2025-2026 Greg Ames/Ames & Associates. Licensed under the MIT License — see LICENSE.
# Project: Terminal Switcher | Filename: terminal-switcher.rb
class TerminalSwitcher < Formula
  desc "Menu-bar switcher for Apple Terminal windows, labeled by project"
  homepage "https://github.com/searayca/terminal-switcher"
  url "https://github.com/searayca/terminal-switcher/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "701be719349b5d0bb850219552492dda86bc4769083b7f782fe96b8f0deebccd"
  license "MIT"

  depends_on macos: :ventura

  def install
    # --disable-sandbox is required because Homebrew's build sandbox
    # conflicts with SwiftPM's own sandbox.
    system "swift", "build", "--disable-sandbox", "-c", "release"

    app = prefix/"Terminal Switcher.app"
    (app/"Contents/MacOS").install ".build/release/TerminalSwitcher"
    (app/"Contents").install "Info.plist"

    # Ad-hoc sign so the macOS Automation permission can attach to a
    # stable code identity.
    system "codesign", "--force", "--sign", "-", app
  end

  def caveats
    <<~EOS
      Terminal Switcher is a menu-bar app bundle. Copy it into ~/Applications
      and launch it:

        mkdir -p ~/Applications
        cp -R "#{prefix}/Terminal Switcher.app" ~/Applications/
        open "$HOME/Applications/Terminal Switcher.app"

      On first use, macOS will prompt:
        "Terminal Switcher" wants access to control "Terminal"
      Approving this Automation permission is required for the app to work.
      If declined, re-enable it in System Settings -> Privacy & Security ->
      Automation -> Terminal Switcher -> Terminal.
    EOS
  end

  test do
    assert_predicate prefix/"Terminal Switcher.app/Contents/MacOS/TerminalSwitcher", :exist?
    assert_predicate prefix/"Terminal Switcher.app/Contents/Info.plist", :exist?
  end
end
