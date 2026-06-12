# Copyright (c) 2025-2026 Greg Ames/Ames & Associates. Licensed under the Coffee Right License — see LICENSE.
# Project: Terminal Switcher | Filename: terminal-switcher.rb
class TerminalSwitcher < Formula
  desc "Menu-bar switcher for Apple Terminal windows, labeled by project"
  homepage "https://github.com/searayca/terminal-switcher"
  url "https://github.com/searayca/terminal-switcher/releases/download/v1.0.0/Terminal-Switcher-v1.0.0-universal.zip"
  sha256 "e4d93c8c1a592d2d2e6e476ff44303d800779e959b04692e7c29c9ec70d3b46e"
  license :cannot_represent

  depends_on macos: :ventura

  def install
    # The release zip contains a prebuilt universal (arm64 + x86_64)
    # "Terminal Switcher.app" bundle. Homebrew strips a lone top-level
    # directory when unpacking, so the working dir is usually the bundle's
    # own contents — reassemble the .app in that case.
    if File.exist?("Terminal Switcher.app")
      prefix.install "Terminal Switcher.app"
    else
      (prefix/"Terminal Switcher.app").install Dir["*"]
    end
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
    bin_path = prefix/"Terminal Switcher.app/Contents/MacOS/TerminalSwitcher"
    assert_path_exists bin_path
    assert_predicate bin_path, :executable?
    assert_path_exists prefix/"Terminal Switcher.app/Contents/Info.plist"
  end
end
