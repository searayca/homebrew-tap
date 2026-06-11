# Copyright (c) 2025-2026 Greg Ames/Ames & Associates. Licensed under the MIT License — see LICENSE.
# Project: Terminal Switcher | Filename: terminal-switcher.rb
class TerminalSwitcher < Formula
  desc "Menu-bar switcher for Apple Terminal windows, labeled by project"
  homepage "https://github.com/searayca/terminal-switcher"
  url "https://github.com/searayca/terminal-switcher/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ae9626dd27e2a7ba81a894801ccb0be2f90d52f23b5d28ed1b52eb78660a4d0e"
  license :cannot_represent

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
    assert_path_exists prefix/"Terminal Switcher.app/Contents/MacOS/TerminalSwitcher"
    assert_path_exists prefix/"Terminal Switcher.app/Contents/Info.plist"
  end
end
