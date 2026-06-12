# Copyright (c) 2025-2026 Greg Ames/Ames & Associates. Licensed under the Coffee Right License — see LICENSE.
# Project: ClaudeScreenShot | Filename: claudescreenshot.rb
class Claudescreenshot < Formula
  desc "Menu-bar app that puts each new screenshot's path on the clipboard"
  homepage "https://github.com/searayca/claudescreenshot"
  url "https://github.com/searayca/claudescreenshot/releases/download/v1.0.0/ClaudeScreenShot-1.0.0.zip"
  sha256 "4c183b7628f4f431ee90483cda7e7b71bf6a6f9ab77f2de866a5b923e886b229"
  license :cannot_represent

  depends_on macos: :ventura

  def install
    # The release zip contains a prebuilt universal (arm64 + x86_64)
    # "ClaudeScreenShot.app" bundle. Homebrew strips a lone top-level
    # directory when unpacking, so the working dir is usually the bundle's
    # own contents — reassemble the .app in that case.
    if File.exist?("ClaudeScreenShot.app")
      prefix.install "ClaudeScreenShot.app"
    else
      (prefix/"ClaudeScreenShot.app").install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      ClaudeScreenShot is a menu-bar app bundle. Copy it into ~/Applications
      and launch it:

        mkdir -p ~/Applications
        cp -R "#{prefix}/ClaudeScreenShot.app" ~/Applications/
        open "$HOME/Applications/ClaudeScreenShot.app"

      When the first screenshot lands, macOS will prompt:
        "ClaudeScreenShot" would like to access files in your
        chosen screenshots folder
      Approving this folder-access permission is required for the app to work.
      If declined, re-enable it in System Settings -> Privacy & Security ->
      Files and Folders -> ClaudeScreenShot.
    EOS
  end

  test do
    bin_path = prefix/"ClaudeScreenShot.app/Contents/MacOS/ClaudeScreenShot"
    assert_path_exists bin_path
    assert_predicate bin_path, :executable?
    assert_path_exists prefix/"ClaudeScreenShot.app/Contents/Info.plist"
  end
end
