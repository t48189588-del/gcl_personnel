{ pkgs, ... }: {
  channel = "stable";
  packages = [ pkgs.flutter pkgs.jdk17 ];
  idx.extensions = [ "Dart-Code.flutter" ];
  idx.workspace.onCreate = {
    pub-get = "flutter pub get";
  };
}