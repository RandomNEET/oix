{ lib }:
{
  display = {
    getPrimary = displayList: lib.findFirst (d: d.orientation == "landscape") { } displayList;
  };
}
