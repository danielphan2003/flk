{
  lib,
  inputs,
}: let
  l = lib;

  cmdWithCategory = category: attrs: attrs // {inherit category;};

  pkgWithCategory = category: package: cmdWithCategory category {inherit package;};

  withCategory = category: attrs: let
    mapWith =
      if l.isDerivation attrs
      then pkgWithCategory
      else cmdWithCategory;
  in
    mapWith category attrs;

  mkCategories = categories: attrs:
    l.genAttrs categories withCategory // attrs;

  categories = [
    "cli-dev"
    "devos"
    "docs"
    "formatters"
    "legal"
    "utils"
  ];
in
  mkCategories categories {
    inherit cmdWithCategory pkgWithCategory withCategory categories;
  }
