{ lib }:
rec {
  display = {
    getPrimary = displayList: lib.findFirst (d: (d.orientation or "") == "landscape") { } displayList;
  };
}
